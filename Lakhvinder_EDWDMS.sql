CREATE DATABASE Online_Marketplace;
USE Online_Marketplace;

CREATE TABLE Vendors (
    VendorID INT AUTO_INCREMENT PRIMARY KEY,
    VendorName VARCHAR(100) NOT NULL,
    CommissionRate DECIMAL(5, 2) NOT NULL,
    ContactInfo VARCHAR(255) DEFAULT NULL
);

CREATE TABLE Products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(150) NOT NULL,
    VendorID INT NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (VendorID) REFERENCES Vendors(VendorID)
);

CREATE TABLE Shoppers (
    ShopperID INT AUTO_INCREMENT PRIMARY KEY,
    ShopperName VARCHAR(100) NOT NULL,
    IsMember BOOLEAN DEFAULT FALSE
);

CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    ShopperID INT NOT NULL,
    OrderStatus ENUM('Complete', 'Incomplete') NOT NULL,
    OrderDate DATE NOT NULL,
    FOREIGN KEY (ShopperID) REFERENCES Shoppers(ShopperID)
);

CREATE TABLE OrderDetails (
    OrderDetailID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE ShopperExperience (
    ExperienceID INT AUTO_INCREMENT PRIMARY KEY,
    ShopperID INT NOT NULL,
    ProductID INT NOT NULL,
    Review TEXT DEFAULT NULL,
    TimeSpentSeconds INT NOT NULL CHECK (TimeSpentSeconds >= 0),
    FOREIGN KEY (ShopperID) REFERENCES Shoppers(ShopperID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Costs (
    CostID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT NOT NULL,
    DeliveryFailureCost DECIMAL(10, 2) DEFAULT 0,
    ReturnFraudCost DECIMAL(10, 2) DEFAULT 0,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

CREATE TABLE Revenue (
    RevenueID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT NOT NULL,
    VendorID INT NOT NULL,
    CommissionAmount DECIMAL(10, 2) DEFAULT 0,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (VendorID) REFERENCES Vendors(VendorID)
);

INSERT INTO Vendors (VendorName, CommissionRate, ContactInfo)
SELECT CONCAT('Vendor_', FLOOR(RAND() * 1000)), 
       ROUND(RAND() * 10 + 5, 2), 
       CONCAT('Contact_', FLOOR(RAND() * 1000))
FROM (SELECT 1 UNION ALL SELECT 2) AS Temp
LIMIT 50;


INSERT INTO Products (ProductName, VendorID, Price)
SELECT CONCAT('Product_', FLOOR(RAND() * 1000)), 
       VendorID, 
       ROUND(RAND() * 500 + 50, 2)
FROM Vendors 
ORDER BY RAND()
LIMIT 1000;

INSERT INTO Shoppers (ShopperName, IsMember)
SELECT CONCAT('Shopper_', FLOOR(RAND() * 1000)), 
       (RAND() > 0.5)
FROM (SELECT 1 UNION ALL SELECT 2) AS Temp
LIMIT 1000;

INSERT INTO Orders (ShopperID, OrderStatus, OrderDate)
SELECT ShopperID, 
       IF(RAND() > 0.5, 'Complete', 'Incomplete') AS OrderStatus, 
       DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND() * 365) DAY) AS OrderDate
FROM Shoppers 
ORDER BY RAND()
LIMIT 10000;

INSERT INTO OrderDetails (OrderID, ProductID, Quantity)
SELECT 
    Orders.OrderID, 
    Products.ProductID, 
    FLOOR(RAND() * 10 + 1) AS Quantity
FROM 
    Orders
CROSS JOIN 
    Products
ORDER BY RAND()
LIMIT 20000;


INSERT INTO ShopperExperience (ShopperID, ProductID, Review, TimeSpentSeconds)
SELECT 
    Shoppers.ShopperID, 
    Products.ProductID, 
    CONCAT('Review_', FLOOR(RAND() * 1000)), 
    FLOOR(RAND() * 5000 + 1) AS TimeSpentSeconds
FROM 
    Shoppers
CROSS JOIN 
    Products
ORDER BY RAND()
LIMIT 1000;


INSERT INTO Costs (OrderID, DeliveryFailureCost, ReturnFraudCost)
SELECT 
    Orders.OrderID, 
    ROUND(RAND() * 50, 2) AS DeliveryFailureCost, 
    ROUND(RAND() * 30, 2) AS ReturnFraudCost
FROM 
    Orders
ORDER BY RAND()
LIMIT 500;

# Total Sales by Vendor (Monthly)
SELECT 
    V.VendorName,
    SUM(OD.Quantity * P.Price) AS TotalSales,
    MONTH(O.OrderDate) AS Month,
    YEAR(O.OrderDate) AS Year
FROM Orders O
JOIN OrderDetails OD ON O.OrderID = OD.OrderID
JOIN Products P ON OD.ProductID = P.ProductID
JOIN Vendors V ON P.VendorID = V.VendorID
WHERE O.OrderStatus = 'Complete'
GROUP BY V.VendorName, Year, Month
ORDER BY Year, Month;

# Top Products Based on Shopper Feedback
SELECT 
    P.ProductName, 
    AVG(SE.TimeSpentSeconds) AS AvgTimeSpent,
    COUNT(SE.ExperienceID) AS ReviewCount
FROM ShopperExperience SE
JOIN Products P ON SE.ProductID = P.ProductID
GROUP BY P.ProductName
ORDER BY ReviewCount DESC, AvgTimeSpent DESC;


#  Total Cost from Failed Deliveries and Return Frauds
SELECT 
    O.OrderID,
    SUM(C.DeliveryFailureCost + C.ReturnFraudCost) AS TotalCost
FROM Costs C
JOIN Orders O ON C.OrderID = O.OrderID
WHERE O.OrderStatus = 'Incomplete'
GROUP BY O.OrderID;

# Stored Procedure: Monthly Report
DELIMITER $$

CREATE PROCEDURE monthly_report(IN report_month VARCHAR(7))
BEGIN
    SELECT 
        SUM(OD.Quantity * P.Price) AS MonthlyRevenue,
        SUM(C.DeliveryFailureCost + C.ReturnFraudCost) AS TotalCosts
    FROM Orders O
    JOIN OrderDetails OD ON O.OrderID = OD.OrderID
    JOIN Products P ON OD.ProductID = P.ProductID
    JOIN Costs C ON O.OrderID = C.OrderID
    WHERE DATE_FORMAT(O.OrderDate, '%Y-%m') = report_month
    AND O.OrderStatus = 'Complete';
END $$

DELIMITER ;








