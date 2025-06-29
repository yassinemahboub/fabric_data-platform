-- retail.categories
CREATE TABLE retail.dim_categories (
  CategoryID INT,
  CategoryName VARCHAR(255),
  Description VARCHAR(255)
);

-- retail.orders
CREATE TABLE retail.facts_orders (
  OrderID INT,
  CustomerID VARCHAR(255),
  EmployeeID INT,
  OrderDate DATE,
  RequiredDate DATETIME2(3),
  ShippedDate DATETIME2(3),
  ShipVia INT,
  FreightCosts FLOAT,
  ShipName VARCHAR(255),
  ShipAddress VARCHAR(255),
  ShipCity VARCHAR(255),
  ShipRegion VARCHAR(255),
  ShipPostalCode VARCHAR(255),
  ShipCountry VARCHAR(255),
  Year INT,
  Month INT,
  Day INT
);

-- retail.orderdetails
CREATE TABLE retail.facts_orderdetails (
    OrderID     INT,
    ProductID   INT,
    UnitPrice   FLOAT,
    Quantity    SMALLINT,
    Discount    FLOAT
);


-- retail.products
CREATE TABLE retail.dim_products (
  ProductID INT,
  ProductName VARCHAR(255),
  SupplierID INT,
  CategoryID INT,
  QuantityPerUnit VARCHAR(255),
  UnitPrice FLOAT,
  UnitsInStock SMALLINT,
  UnitsOnOrder SMALLINT,
  ReorderLevel SMALLINT,
  Discontinued BIT
);

-- retail.customers
CREATE TABLE  retail.dim_customers (
  CustomerID VARCHAR(255),
  CompanyName VARCHAR(255),
  ContactName VARCHAR(255),
  ContactTitle VARCHAR(255),
  Address VARCHAR(255),
  City VARCHAR(255),
  Region VARCHAR(255),
  PostalCode VARCHAR(255),
  Country VARCHAR(255),
  Phone VARCHAR(255),
  Fax VARCHAR(255)
);

-- retail.employees
CREATE TABLE retail.dim_employees (
  EmployeeID INT,
  LastName VARCHAR(255),
  FirstName VARCHAR(255),
  Title VARCHAR(255),
  TitleOfCourtesy VARCHAR(255),
  BirthDate DATETIME2(3),
  HireDate DATETIME2(3),
  Address VARCHAR(255),
  City VARCHAR(255),
  Region VARCHAR(255),
  PostalCode VARCHAR(255),
  Country VARCHAR(255),
  HomePhone VARCHAR(255),
  Extension VARCHAR(255),
  Notes VARCHAR(MAX),
  Manager INT
);

-- retail.employeeterritories
CREATE TABLE retail.bridge_employeeterritories (
  EmployeeID INT,
  TerritoryID BIGINT
);

-- retail.region
CREATE TABLE retail.dim_region (
  RegionID INT,
  RegionDescription VARCHAR(255)
);

-- retail.shippers
CREATE TABLE retail.dim_shippers (
  ShipperID INT,
  CompanyName VARCHAR(255),
  Phone VARCHAR(255)
);

-- retail.suppliers
CREATE TABLE retail.dim_suppliers (
  SupplierID INT,
  CompanyName VARCHAR(255),
  ContactName VARCHAR(255),
  ContactTitle VARCHAR(255),
  Address VARCHAR(255),
  City VARCHAR(255),
  Region VARCHAR(255),
  PostalCode VARCHAR(255),
  Country VARCHAR(255),
  Phone VARCHAR(255),
  Fax VARCHAR(255)
);

-- retail.territories
CREATE TABLE retail.dim_territories (
  TerritoryID BIGINT,
  TerritoryDescription VARCHAR(255),
  RegionID INT
);