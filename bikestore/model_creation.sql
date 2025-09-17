CREATE DATABASE BikeStore
USE BikeStore

--Customers
CREATE TABLE Customers (
	customer_id int,
	first_name varchar(50),
	last_name varchar(50),
	phone varchar(50),
	email varchar(50),
	street varchar(50),
	city varchar(50),
	state varchar(10),
	zip_code int,
	constraint PK_customer_id primary key (customer_id)
) 
BULK INSERT Customers
FROM 'C:\Users\HP\Desktop\BikeStore\data\customers.csv'
WITH
(
first_row = 2,
FIELDTERMINATOR = ',' ,
ROWTERMINATOR = '\n' 
)

--Brands
CREATE TABLE Brands (
	brand_id int,
	brand_name varchar(20)
	constraint PK_brand_id primary key (brand_id)
)
BULK INSERT Brands
FROM 'C:\Users\HP\Desktop\BikeStore\data\brands.csv' 
WITH
(
first_row = 2,
FIELDTERMINATOR = ',' ,
ROWTERMINATOR = '\n' 
)

--Categories
CREATE TABLE Categories (
	category_id int,
	category_name varchar(25)
	constraint PK_category_id primary key (category_id)
)
BULK INSERT Categories
FROM 'C:\Users\HP\Desktop\BikeStore\data\categories.csv' 
WITH
(
first_row = 2,
FIELDTERMINATOR = ',' ,
ROWTERMINATOR = '\n' 
)

--Products
CREATE TABLE Products (
	product_id int,
	product_name varchar(100),
	brand_id int,
	category_id int,
	model_year int,
	list_price decimal(8, 2),
	constraint PK_product_id primary key (product_id),
	constraint FK_brand_id foreign key (brand_id) references Brands(brand_id),
	constraint FK_category_id foreign key (category_id) references Categories(category_id)
)
BULK INSERT Products
FROM 'C:\Users\HP\Desktop\BikeStore\data\products.csv' 
WITH
(
first_row = 2,
FIELDTERMINATOR = ',' ,
ROWTERMINATOR = '\n' 
)

--Stores
CREATE TABLE Stores (
	store_id int,
	store_name varchar(30),
	phone varchar(30),
	email varchar(30),
	street varchar(30),
	city varchar(30),
	[state] varchar(10),
	zip_code int
	constraint PK_store_id primary key (store_id)
)
BULK INSERT Stores
FROM 'C:\Users\HP\Desktop\BikeStore\data\stores.csv' 
WITH
(
first_row = 2,
FIELDTERMINATOR = ',' ,
ROWTERMINATOR = '\n' 
)
drop table staffs
--Staffs
CREATE TABLE Staffs (
	staff_id varchar(20),
	first_name varchar(30),
	last_name varchar(30),
	email varchar(50),
	phone varchar(30),
	active int,
	store_id int,
	manager_id varchar(20),
	constraint PK_staff_id primary key (staff_id),
	constraint FK_manager_id foreign key (manager_id) references Staffs(staff_id)
)
BULK INSERT Staffs
FROM 'C:\Users\HP\Desktop\BikeStore\data\staffs.csv' 
WITH
(
first_row = 2,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
KEEPNULLS
)

--Orders
CREATE TABLE Orders (
	order_id int,
	customer_id int,
	order_status int,
	order_date date,
	required_date date,
	shipped_date varchar(30),
	store_id int,
	staff_id varchar(20),
	constraint PK_order_id primary key (order_id),
	constraint FK_customer_id foreign key (customer_id) references Customers(customer_id),
	constraint FK_staff_id foreign key (staff_id) references Staffs(staff_id),
	constraint FK_store_id foreign key (store_id) references Stores(store_id)
)
BULK INSERT Orders
FROM 'C:\Users\HP\Desktop\BikeStore\data\orders.csv' 
WITH
(
first_row = 2,
FIELDTERMINATOR = ',' ,
ROWTERMINATOR = '\n',
KEEPNULLS
)

--Order-items
CREATE TABLE Order_items (
	order_id int,
	item_id int,
	product_id int,
	quantity int,
	list_price decimal(8, 2),
	discount decimal(8, 3),
	constraint PK_item_order_id primary key (item_id, order_id),
	constraint FK_order_id foreign key (order_id) references Orders(order_id),
	constraint FK_product_id foreign key (product_id) references Products(product_id)
)
BULK INSERT Order_items
FROM 'C:\Users\HP\Desktop\BikeStore\data\order_items.csv' 
WITH
(
first_row = 2,
FIELDTERMINATOR = ',' ,
ROWTERMINATOR = '\n',
KEEPNULLS
)

--Stocks
CREATE TABLE Stocks (
	store_id int,
	product_id int,
	quantity int,
	constraint PK_store_product_id primary key (store_id, product_id),
	constraint FK_each_store_id foreign key (store_id) references Stores(store_id),
	constraint FK_each_product_id foreign key (product_id) references Products(product_id)
)
BULK INSERT Stocks
FROM 'C:\Users\HP\Desktop\BikeStore\data\stocks.csv' 
WITH
(
first_row = 2,
FIELDTERMINATOR = ',' ,
ROWTERMINATOR = '\n',
KEEPNULLS
)
