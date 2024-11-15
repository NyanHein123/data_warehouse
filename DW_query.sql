/* 
Queries to find the insights about the profit

Query 1 for profit analysis
*/
use SPAIDW2A0102;
SELECT 
    Year,
    Quarter,
    SUM(Profit) AS TotalProfit,
    RANK() OVER (PARTITION BY Year ORDER BY SUM(Profit) DESC) AS QuarterRank
FROM 
    ProfitFact
JOIN 
    TimeDim ON ProfitFact.TimeKey = TimeDim.TimeKey
GROUP BY 
    Year, Quarter;


/* 
Query 2 to find the insights about the profit 


Queries to find the insights about the relation between the profit and the model type
to understand which model type give the most profit
*/
SELECT 
    mt.ModelType,
    SUM(pf.Profit) AS TotalProfit,
    SUM(CASE WHEN td.Year = 2021 THEN pf.Profit ELSE 0 END) AS Profit2021,
    SUM(CASE WHEN td.Year = 2022 THEN pf.Profit ELSE 0 END) AS Profit2022,
    SUM(CASE WHEN td.Year = 2023 THEN pf.Profit ELSE 0 END) AS Profit2023,
    COUNT(DISTINCT od.OrderKey) AS NumberOfOrders
FROM 
    ProfitFact pf
JOIN 
    ModelDim md ON pf.ModelKey = md.ModelKey
JOIN 
    ModelTypeDim mt ON pf.MTypeKey = mt.MTypeKey
JOIN 
    TimeDim td ON pf.TimeKey = td.TimeKey
LEFT JOIN 
    OrderDim od ON pf.OrderKey = od.OrderKey
GROUP BY 
    mt.ModelType
ORDER BY 
    TotalProfit DESC;
/*
Query 3 
The following query is to analyze the insights about the customer
The following query will show the profit obtained from the companies 
in each quarter 
*/


SELECT 
    CompanyName,
    Q1_2023_Profit,
    Q2_2023_Profit,
    Q3_2023_Profit,
    Q4_2023_Profit,
    (Q1_2023_Profit + Q2_2023_Profit + Q3_2023_Profit + Q4_2023_Profit) AS TotalProfit
FROM (
    SELECT 
        cd.CompanyName,
        SUM(CASE WHEN td.Year = 2023 AND td.Quarter = 1 THEN pf.Profit ELSE 0 END) AS Q1_2023_Profit,
        SUM(CASE WHEN td.Year = 2023 AND td.Quarter = 2 THEN pf.Profit ELSE 0 END) AS Q2_2023_Profit,
        SUM(CASE WHEN td.Year = 2023 AND td.Quarter = 3 THEN pf.Profit ELSE 0 END) AS Q3_2023_Profit,
        SUM(CASE WHEN td.Year = 2023 AND td.Quarter = 4 THEN pf.Profit ELSE 0 END) AS Q4_2023_Profit
    FROM 
        ProfitFact pf
    JOIN 
        CustomerDim cd ON pf.CustomerKey = cd.CustomerKey
    JOIN 
        TimeDim td ON pf.TimeKey = td.TimeKey
    GROUP BY 
        cd.CompanyName
) AS QuarterlyProfits
ORDER BY 
    TotalProfit desc;


/*
Query 4. 
The following query is to analyze the performace of employee
*/

SELECT 
    ed.EmployeeID,
    CONCAT(ed.FirstName, ' ', ed.LastName) AS FullName,
    COUNT(pf.OrderKey) AS TotalOrders,
    SUM(CASE WHEN td.Year = 2021 THEN 1 ELSE 0 END) AS Orders2021,
    SUM(CASE WHEN td.Year = 2022 THEN 1 ELSE 0 END) AS Orders2022,
	SUM(CASE WHEN td.Year = 2022 THEN 1 ELSE 0 END) - SUM(CASE WHEN td.Year = 2021 THEN 1 ELSE 0 END) AS PerformanceFrom2021To2022,
    SUM(CASE WHEN td.Year = 2023 THEN 1 ELSE 0 END) AS Orders2023,
	SUM(CASE WHEN td.Year = 2023 THEN 1 ELSE 0 END) - SUM(CASE WHEN td.Year = 2022 THEN 1 ELSE 0 END) AS PerformanceFrom2022To2023
FROM 
    ProfitFact pf
JOIN 
    EmployeeDim ed ON pf.EmployeeKey = ed.EmployeeKey
JOIN 
    OrderDim od ON pf.OrderKey = od.OrderKey
JOIN 
    TimeDim td ON pf.TimeKey = td.TimeKey
GROUP BY 
    ed.EmployeeID, ed.FirstName, ed.LastName
ORDER BY 
    TotalOrders DESC;


