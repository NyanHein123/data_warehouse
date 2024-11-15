create database SPAIDW2A0102;
/* 
creating customer dimension table 

*/
use SPAIDW2A0102;
Create Table CustomerDim(
CustomerKey int IDENTITY not null primary key, 
CustomerID varchar(10) not null,
FirstName varchar(20) not null,
LastName varchar(20) not null,
CompanyName varchar(50) not null,
Contact VARCHAR (10));
/* 
creating employee dimension table 

*/
Create Table EmployeeDim(
EmployeeKey int IDENTITY not null primary key,
EmployeeID varchar(10) not null,
FirstName varchar(20) not null,
LastName varchar(20) not null,
Gender char(1) not null,
Contact varchar(10)
);

/*
creating dataset dimension table 
*/
Create Table DatasetDim(
DatasetKey int IDENTITY not null primary key, 
DatasetID varchar(10) not null,
DatasetName varchar(50) not null
);

/* 
creating model type dimension

*/

Create Table ModelTypeDim(
MTypeKey int IDENTITY not null primary key, 
ModelCode varchar(10) not null,
ModelType varchar(50) not null);
/*
creating table model dimension
*/
Create Table ModelDim(
ModelKey int IDENTITY not null primary key,
ModelID varchar(10) not null,
Accuracy decimal(6,2) not null,
TrainingDate date not null
);

/*
creating table for order dimension

*/

Create Table OrderDim
(
OrderKey int IDENTITY NOT NULL PRIMARY KEY,
OrderID varchar(10) not null,
OrderDate date not null,
RequiredAcc decimal(6,2) not null);

/* 
creating table for time dimension 

*/
Create Table TimeDim(
TimeKey int IDentity not null primary key,
DateOfProfit Date not null,
DayName varchar(20) not null,
DayOfMonth int not null,
DayOfWeek int not null,
Month int not null,
Month_Year varchar(20) not null,
MonthName varchar(20) not null,
Quarter int not null,
QuarterName varchar(20) not null,
WeekOfYear int not null,
Year int not null
);

/* 
Creating table for Profit fact
*/
Create Table ProfitFact(
ProfitFactKey int Identity not null primary key,
Profit int not null,
CustomerKey int not null foreign key references CustomerDim(customerKey),
DatasetKey int not null foreign key references DatasetDim(DatasetKey),
EmployeeKey int not null foreign key references EmployeeDim(EmployeeKey),
ModelKey int not null foreign key references ModelDim(ModelKey),
MTypeKey int not null foreign key references ModelTypeDim(MTypeKey),
OrderKey int not null foreign key references OrderDim(OrderKey),
TimeKey int not null foreign key references TimeDim(TimeKey)
);


