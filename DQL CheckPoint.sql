---CREATION OF ALL TABLES

CREATE TABLE Products(
ProductID INT PRIMARY KEY, 
ProductName VARCHAR(50),
ProductType VARCHAR(50), 
Price DECIMAL (6,2)
);

CREATE TABLE Customers(
CustomerID 	INT PRIMARY KEY, 
CustomerName VARCHAR(50), 
Email VARCHAR(50),
Phone VARCHAR(50)
);

CREATE TABLE Orders(
OrderID INT PRIMARY KEY, 
CustomerID INT, 
OrderDate DATE,
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE
);

CREATE TABLE OrderDetailS(
OrderDetailID INT PRIMARY KEY,
OrderID INT,
ProductID INT,
Quantity INT,
FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE,
FOREIGN KEY (ProductID) REFERENCES Products(ProductID) ON DELETE CASCADE
);

CREATE TABLE ProductTypes(
ProductTypeID INT PRIMARY KEY, 
ProductTypeName VARCHAR(50)
);

---INSERTING VALUES FOR ALL TABLES

INSERT INTO Products VALUES
( 1, 'Widget A', 'Widget', 10.00),
( 2, 'Widget B', 'Widget', 15.00),
( 3, 'Gadget X', 'Gadget', 20.00),
( 4, 'Gadget Y', 'Gadget', 25.00),
( 5, 'Doohickey Z', 'Doohickey', 30.00);

INSERT INTO Customers VALUES
(1, 'John Smith', 'john@example.com', '123-456-7890'),
(2, 'Jane Doe', 'jane.doe@example.com', '987-654-3210'),
(3, 'Alice Brown', 'alice.brown@example.com', '456-789-0123');

INSERT INTO Orders VALUES
(101, 1, '2024-05-01'),
 (102, 2, '2024-05-02'),
(103, 3, '2024-05-01');

INSERT INTO OrderDetailS VALUES
(1, 101, 1, 2),
(2, 101, 3, 1),
(3, 102, 2, 3),
(4, 102, 4, 2),
(5, 103, 5, 1);

INSERT INTO ProductTypes VALUES
(1, 'Widget'),
(2, 'Gadget'),
(3, 'Doohickey');


---Retrieve all products.
SELECT * FROM Products

---Retrieve all customers.
SELECT * FROM Customers

---Retrieve all orders.
SELECT * FROM Orders

---Retrieve all order details.
SELECT * FROM OrderDetails

---Retrieve all product types.
SELECT * FROM ProductTypes

---Retrieve the names of the products that have been ordered by at least one customer, 
---along with the total quantity of each product ordered.

SELECT p.productName, 
	SUM(od.quantity) AS total_quantity
FROM orders o
	INNER JOIN OrderDetailS od ON o.OrderID = od.OrderID
	INNER JOIN Products p ON od.productID = p.productID
GROUP BY p.productName
HAVING 
	SUM(od.quantity) > 0;


-- 7. Retrieve the names of the
--customers who have placed an order on every day of the week, along with the total number of orders placed by each customer.

SELECT CustomerName, 
	COUNT(*) AS totaOrders
FROM Customers c
	JOIN orders o ON c.customerID = o.customerID
GROUP BY c.customerName
HAVING 
	COUNT(DISTINCT EXTRACT(DOW FROM o.orderDate)) = 7;

-- 8. Retrieve the names of the customers who have placed the most orders, along with the total number of orders placed by each customer.
SELECT c.customerName, 
	COUNT(*) AS totalOrders, 
	MAX(od.Quantity) AS maxQuantity
FROM Customers c 
	JOIN Orders o ON c.customerID = o.customerID
	JOIN orderDetails od ON o.orderID = od.orderID
GROUP BY c.customerName;

-- 9. Retrieve the names of the products that have been ordered the most, along with the total quantity of each product ordered.
SELECT p.productName,
    COUNT(*) AS total_quantity,
	MAX(Quantity) AS max_quantity
FROM Products p
	JOIN orderDetails od ON p.productID = od.productID
GROUP BY p.productName;

-- 10. Retrieve the names of customers who have placed an order for at least one widget.
SELECT DISTINCT c.customerName
FROM Customers c 
	JOIN orders o ON c.CustomerID = o.customerID
	JOIN orderDetails od ON o.orderID = od.orderID
	JOIN products p ON od.productID = p.productID
WHERE p.productID IN (3, 4)
	AND od.quantity > 0;
  
-- 11. Retrieve the names of the customers who have placed an order for at least one widget and at least one gadget, along with the total cost of the widgets and gadgets ordered by each customer.
SELECT c.customerName,
	SUM(od.quantity * p.price) AS totalPrice
FROM customers c 
	JOIN orders o ON c.customerID = o.CustomerID
	JOIN orderDetails od ON o.orderID = od.orderID
	JOIN products p ON od.productID = p.productID
WHERE p.productID IN (1, 2)
	AND p.productID IN (3, 4)
	AND od.quantity > 0
GROUP BY c.customerName;

-- 12. Retrieve the names of the customers who have placed an order for at least one gadget, along with the total cost of the gadgets ordered by each customer.
SELECT c.customerName, 
	SUM(od.quantity * p.price) AS total_price
FROM customers c 
	JOIN orders o ON c.customerID = o.customerID
	JOIN orderDetails od ON o.orderID = od.orderID
	JOIN products p ON od.productID = p.productID
WHERE p.productID IN (3, 4) 
	AND od.quantity > 0
GROUP BY c.customerName;

-- 13. Retrieve the names of the customers who have placed an order for at least one doohickey, along with the total cost of the doohickeys ordered by each customer.
SELECT c.customerName,
	SUM(od.quantity * p.price) AS total_price
FROM customers c
	JOIN orders o ON c.customerID = o.customerID
	JOIN orderDetails od ON o.orderID = od.orderID
	JOIN products p ON od.productID = p.productID
WHERE p.productID = 5
    AND od.quantity > 0
GROUP BY c.customerName;

-- 14. Retrieve the names of the customers who have placed an order every day of the week, along with the total number of orders placed by each customer.
SELECT CustomerName, 
  COUNT(*) AS totalOrders
FROM customers c
  JOIN orders o ON c.customerID = o.customerID
GROUP BY c.customerName
HAVING 
  COUNT(DISTINCT EXTRACT(DOW FROM o.orderDate)) = 7;
  
-- 15. Retrieve the total number of widgets and gadgets ordered by each customer, along with the total cost of the orders.
SELECT p.productID, p.productName,
	SUM(od.quantity * p.price) AS totalCost
	FROM products p 
	JOIN orderDetails od ON p.productID = od.productID
WHERE p.productID IN (1, 2, 3, 4)
GROUP BY p.productID, p.productName;