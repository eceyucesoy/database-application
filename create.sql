CREATE TABLE Salaries(
emp_position varchar(15) NOT NULL PRIMARY KEY,
salary int)

CREATE TABLE Employees(
emp_id int NOT NULL PRIMARY KEY,
emp_name char(20),
emp_surname char(20),
emp_marriage char(1),
emp_dob date,
emp_gender char(1),
emp_education varchar(15),
emp_position varchar(15) NOT NULL,
emp_phone char(10),
emp_address varchar(25),
emp_mail varchar(20),
FOREIGN KEY (emp_position) REFERENCES Salaries(emp_position))

CREATE TABLE Suppliers(
sup_id int NOT NULL PRIMARY KEY,
sup_name varchar(25),
sup_phone char(10),
sup_mail varchar(20),
sup_address varchar(25))

CREATE TABLE Customer(
cust_id int NOT NULL PRIMARY KEY,
cust_name varchar(15),
cust_surname varchar(10),
cust_phone char(10),
cust_address varchar(25),
cust_city char(10),
cust_mail varchar(25))

CREATE TABLE Category(
category_id int NOT NULL PRIMARY KEY,
category_name varchar(20))

CREATE TABLE Instruments(
inst_id int NOT NULL PRIMARY KEY,
category_id int,
inst_name varchar(25),
inst_price int,
inst_stock int,
inst_sold int,
FOREIGN KEY (category_id) REFERENCES Category(category_id))

CREATE TABLE Sales(
sales_id int NOT NULL PRIMARY KEY,
inst_id int NOT NULL,
emp_id int NOT NULL,
cust_id int NOT NULL,
sales_date date,
sales_quantity int,
FOREIGN KEY (inst_id) REFERENCES Instruments(inst_id),
FOREIGN KEY (cust_id) REFERENCES Customer(cust_id),
FOREIGN KEY (emp_id) REFERENCES Employees(emp_id))

CREATE TABLE Supplies(
inst_id int, 
sup_id int,
supply_date date,
PRIMARY KEY (inst_id, sup_id),
FOREIGN KEY (inst_id) REFERENCES Instruments(inst_id),
FOREIGN KEY (sup_id) REFERENCES Suppliers(sup_id)
)
