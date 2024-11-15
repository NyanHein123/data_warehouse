use SPAIDW2A0102;
/* 
inserting data into customerdim table
from customer table of OLTP database(SPAI2A0102)
*/
INSERT INTO CustomerDIM (CustomerID, FirstName, LastName, CompanyName, Contact)
SELECT CustomerID, FirstName, LastName, CompanyName, Contact
FROM SPAI2A0102.dbo.Customer;


/* 
insert into employeedim table from employee table of OLTP database(SPAI2A0102)
*/
INSERT INTO EmployeeDim (EmployeeID, FirstName, LastName, Gender, Contact)
SELECT EmployeeID, FirstName, LastName, Gender, Contact
FROM SPAI2A0102.dbo.Employee;



/* 
insert data into modeltype table from modeltype table of OLTP database(SPAI2A0102)
*/
INSERT INTO ModelTypeDim (ModelCode, ModelType)
SELECT ModelCode, ModelType
FROM SPAI2A0102.dbo.ModelType;



/* 
insert data into datasetDim table from Dataset table of OLTP database(SPAI2A0102)
*/
INSERT INTO DatasetDim (DatasetID, Datasetname)
SELECT DatasetID, Datasetname
FROM SPAI2A0102.dbo.Dataset;


/* 
insert data into modelDim table from Model table of OLTP database(SPAI2A0102)
*/
INSERT INTO ModelDim (ModelID, TrainingDate,Accuracy)
SELECT ModelID, TrainingDate,Accuracy
FROM SPAI2A0102.dbo.Model;



/*
insert data into orderDim table from order table of OLTP database(SPAI2A0102)

*/

INSERT INTO OrderDim (OrderID, OrderDate,RequiredAcc)
SELECT OrderID, OrderDate,RequiredAcc
FROM SPAI2A0102.dbo.Orders;


/*
inserting data into TimeDim table
(the date of time dimension table are from the completion date of the order table, 
because in our ProfitFact table, the interest is in the profit and the completion date is 
when we get the profit. 
The start date of Completion Date in our order table is from 2021/01/16 to the end date 2023/12/31. 
So, there should be 1080 dates and so, the row number will be 1080.
*/
DECLARE @StartDate DATE = '2021-01-16';
DECLARE @EndDate DATE = '2023-12-31';

-- Temporary variables
DECLARE @CurrentDate DATE = @StartDate;
DECLARE @DayName VARCHAR(20);
DECLARE @DayOfMonth INT;
DECLARE @DayOfWeek INT;
DECLARE @Month INT;
DECLARE @Month_Year VARCHAR(20);
DECLARE @MonthName VARCHAR(20);
DECLARE @Quarter INT;
DECLARE @QuarterName VARCHAR(20);
DECLARE @WeekOfYear INT;
DECLARE @Year INT;

WHILE @CurrentDate <= @EndDate
BEGIN
    SET @DayName = DATENAME(WEEKDAY, @CurrentDate);
    SET @DayOfMonth = DATEPART(DAY, @CurrentDate);
    SET @DayOfWeek = DATEPART(WEEKDAY, @CurrentDate);
    SET @Month = DATEPART(MONTH, @CurrentDate);
    SET @Month_Year = FORMAT(@CurrentDate, 'MMM-yyyy');
    SET @MonthName = DATENAME(MONTH, @CurrentDate);
    SET @Quarter = DATEPART(QUARTER, @CurrentDate);
    SET @QuarterName = 'Q' + CAST(@Quarter AS VARCHAR(1));
    SET @WeekOfYear = DATEPART(WEEK, @CurrentDate);
    SET @Year = DATEPART(YEAR, @CurrentDate);

    INSERT INTO TimeDim (DateOfProfit, DayName, DayOfMonth, DayOfWeek, Month, Month_Year, MonthName, Quarter, QuarterName, WeekOfYear, Year)
    VALUES (@CurrentDate, @DayName, @DayOfMonth, @DayOfWeek, @Month, @Month_Year, @MonthName, @Quarter, @QuarterName, @WeekOfYear, @Year);

    -- Moving to the next date
    SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate);
END;



/* 
inserting data into ProfitFact Table

*/
use SPAIDW2A0102;

Insert INTO ProfitFact(
CustomerKey,
EmployeeKey,
ModelKey,
TimeKey,
OrderKey,
DatasetKey,
MTypeKey,
Profit)
Select 

cd.CustomerKey,
ed.EmployeeKey,
md.ModelKey,
td.TimeKey,
od.OrderKey,
dd.DatasetKey,
mtd.MTypeKey,
o.Price
from SPAI2A0102.dbo.Orders o 
inner join SPAIDW2A0102.dbo.orderdim od on o.OrderID = od.orderid
inner join SPAIDW2A0102.dbo.modeldim md on o.Modelid = md.modelid
inner join SPAIDW2A0102.dbo.modeltypedim mtd on o.ModelCode = mtd.modelcode
inner join SPAIDW2A0102.dbo.CustomerDim cd on o.CustomerID = cd.CustomerID
inner join SPAIDW2A0102.dbo.EmployeeDim ed on o.EmployeeID = ed.employeeId
inner join SPAIDW2A0102.dbo.TimeDim td on o.CompletionDate = td.dateofprofit
INNER JOIN (
    SELECT d.DatasetKey, m.ModelID 
    FROM SPAIDW2A0102.dbo.DatasetDim d
    INNER JOIN SPAI2A0102.dbo.Model m ON d.DatasetID = m.DatasetID
) dd ON o.ModelID = dd.ModelID;

