--The musical instrument that was sold the most on the last day of sales data available
SELECT inst_id, SUM(sales_quantity) as total_sales
FROM Sales
WHERE sales_date = (SELECT MAX(sales_date) FROM Sales)
GROUP BY inst_id
ORDER BY total_sales DESC

--Email of the customer who bought a piano
SELECT cust_mail
FROM Customer c
INNER JOIN Sales p ON c.cust_id = p.cust_id
INNER JOIN Instruments i ON p.inst_id = i.inst_id
WHERE i.inst_name = 'Piano'

--Number of musical instruments sold by employees with university-level education
SELECT COUNT(*) as sales_quantity
FROM Sales s
INNER JOIN Employees e ON s.emp_id = e.emp_id
WHERE e.emp_education = 'University'

--The name and surname of the people who bought the instruments with a price greater than 20000 
SELECT c.cust_name, c.cust_surname
FROM Customer c
INNER JOIN Sales p ON c.cust_id = p.cust_id
INNER JOIN Instruments i ON p.inst_id = i.inst_id
WHERE i.inst_price > 20000

--Sales ids of products with a price greater than 50000
SELECT sales_id, sales_date
FROM Sales
WHERE EXISTS (SELECT inst_id FROM Instruments
WHERE Sales.inst_id = Instruments.inst_id AND inst_price >50000)

--Salaries of our employees who have received a university education
SELECT salary 
FROM Salaries 
JOIN Employees ON Salaries.emp_position=Employees.emp_position AND Employees.emp_education='University'

--Musical instruments that belong to category id 401 and 402	
SELECT  inst_name, category_name 
FROM Instruments
JOIN Category ON Category.category_id=Instruments.category_id
WHERE Category.category_id in ('401' , '402')

--Name of musical instruments that are sold more than 5 times
SELECT inst_name, inst_stock, Sales.sales_quantity
FROM Sales
LEFT JOIN Instruments ON Sales.inst_id=Instruments.inst_id
WHERE Sales.sales_quantity >=5
ORDER BY Sales.sales_quantity;

--Employees who have sold both trumpet and flute
SELECT emp_id, emp_name, emp_surname
FROM Employees
WHERE emp_id IN (SELECT S.emp_id FROM Sales S, Instruments I WHERE S.inst_id=I.inst_id AND I.inst_name = 'Trumpet')
INTERSECT 
SELECT emp_id, emp_name, emp_surname
FROM Employees
WHERE emp_id IN (SELECT S.emp_id FROM Sales S, Instruments I WHERE S.inst_id=I.inst_id AND I.inst_name = 'Flute')

--Name and surname of customers who bought at most one instrument in November
SELECT c.cust_name, c.cust_surname
FROM Customer c
JOIN Sales s ON c.cust_id = s.cust_id
JOIN Instruments i ON s.inst_id = i.inst_id
WHERE s.sales_date BETWEEN '2022-11-01' AND '2022-11-31'
GROUP BY s.cust_id
HAVING COUNT(i.inst_id) <= 1

--Number of sales of each salesman who have more than 3 sales
SELECT S.emp_id, COUNT(S.sales_id) AS 'total_sales'
FROM Sales S
INNER JOIN Employees E ON S.emp_id = E.emp_id
WHERE E.emp_position='Salesman'
GROUP BY S.emp_id
HAVING COUNT(S.sales_id) > 3
	
--Use of CASE Expression 
UPDATE Instruments
SET inst_price =
       CASE
         WHEN inst_name = 'Piano' THEN inst_price * 1.1
         WHEN inst_name = 'Trumpet' THEN inst_price * 1.2
         ELSE inst_price
       END

--Procedure which rates employee success according to their sales rate at a specific month
CREATE PROCEDURE EmployeeSuccess
	@emp_id INT, @month INT
AS 
	BEGIN 
		DECLARE @salesamount INTEGER
		DECLARE @successrate INTEGER
		SET @salesamount = (SELECT COUNT(*) FROM Sales S 
WHERE S.emp_id=@emp_id AND MONTH(sales_date)=@month)
		IF(@salesamount > 10)
			SET @successrate = 3
		ELSE IF (@salesamount > 5)
			SET @successrate = 2
		ELSE 
			SET @successrate = 1
		RETURN @successrate
	END
EXECUTE EmployeeSuccess @emp_id=115, @month=11

--Procedure for adding stock to a specific instrument
CREATE PROCEDURE addStock
	@inst_id int,
	@new_stock int
AS 
	BEGIN 
	DECLARE @stock int
		UPDATE Instruments
		SET inst_stock = inst_stock + @new_stock
		WHERE inst_id = @inst_id
		RETURN @stock
	END
EXECUTE addStock @inst_id = '309', @new_stock = 3

--Procedure for increasing employee salaries by position
CREATE PROCEDURE UpdateSalary
	@emp_position varchar(15),
	@increase int
AS 
	BEGIN
	DECLARE @new_salary int
		UPDATE Salaries
		SET salary = salary + @increase
		WHERE emp_position = @emp_position
		RETURN @new_salary
	END

EXECUTE UpdateSalary @emp_position= 'Manager', @increase =1000
