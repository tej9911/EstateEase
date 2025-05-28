CREATE database estate;
use estate;
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE,
    role ENUM('Admin', 'Agent', 'Broker', 'Client') NOT NULL
);

INSERT INTO Users (username, password, email, role) VALUES
('admin01', 'hashed_password1', 'admin01@example.com', 'Admin'),
('agent_john', 'hashed_password2', 'john.agent@example.com', 'Agent'),
('broker_smith', 'hashed_password3', 'smith.broker@example.com', 'Broker'),
('client_anna', 'hashed_password4', 'anna.client@example.com', 'Client'),
('client_mike', 'hashed_password5', 'mike.client@example.com', 'Client');

SELECT * FROM Users;

-- Create the Agents table
CREATE TABLE Agents (
    agent_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20) NOT NULL,
    agency_name VARCHAR(255) NOT NULL
);

-- Insert sample data
INSERT INTO Agents (name, email, phone, agency_name) VALUES
('John Doe', 'john.doe@realty.com', '123-456-7890', 'Dream Homes Realty'),
('Jane Smith', 'jane.smith@estate.com', '987-654-3210', 'Elite Estates'),
('Robert Brown', 'robert.brown@homes.com', '456-789-0123', 'Brown & Co Realty'),
('Emily Johnson', 'emily.johnson@luxury.com', '321-654-0987', 'Luxury Living Agency'),
('Michael Davis', 'michael.davis@trust.com', '789-012-3456', 'Trusted Property Solutions');

-- Retrieve all records
SELECT * FROM Agents;


CREATE TABLE Clients (
    client_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20) NOT NULL
);

DESCRIBE Clients;

INSERT INTO Clients (name, email, phone) VALUES
('Alice Johnson', 'alice.johnson@example.com', '555-123-4567'),
('Bob Williams', 'bob.williams@example.com', '555-987-6543'),
('Charlie Brown', 'charlie.brown@example.com', '555-456-7890'),
('David Smith', 'david.smith@example.com', '555-321-0987'),
('Emma Davis', 'emma.davis@example.com', '555-654-3210');

SELECT * FROM Clients;




CREATE TABLE Properties (
    property_id INT PRIMARY KEY AUTO_INCREMENT,
    owner_id INT NOT NULL,
    address VARCHAR(255) NOT NULL,
    price DECIMAL(15,2) NOT NULL,
    area INT NOT NULL,
    latitude DECIMAL(10, 7),
    longitude DECIMAL(10, 7),
    FOREIGN KEY (owner_id) REFERENCES Users(user_id) ON DELETE CASCADE
);
INSERT INTO Properties (owner_id, address, price, area, latitude, longitude) VALUES
(4, '123 Elm Street, Springfield', 250000.00, 1800, 37.7749, -122.4194),
(5, '456 Oak Avenue, Metropolis', 320000.00, 2200, 40.7128, -74.0060),
(4, '789 Pine Road, Gotham', 150000.00, 1400, 34.0522, -118.2437),
(5, '101 Maple Lane, Star City', 275000.00, 2000, 41.8781, -87.6298),
(4, '202 Birch Boulevard, Central City', 190000.00, 1600, 39.9526, -75.1652);

SELECT * FROM Properties;


CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    property_id INT NOT NULL,
    client_id INT NOT NULL,
    payment_amount DECIMAL(15,2) CHECK (payment_amount > 0) NOT NULL,
    payment_date DATE NOT NULL,
    payment_method ENUM('Credit Card', 'Bank Transfer', 'Cash') NOT NULL,
    FOREIGN KEY (property_id) REFERENCES Properties(property_id) ON DELETE CASCADE,
    FOREIGN KEY (client_id) REFERENCES Clients(client_id) ON DELETE CASCADE
);

-- Insert sample transactions ensuring correct property_id and client_id
INSERT INTO Transactions (property_id, client_id, payment_amount, payment_date, payment_method)
VALUES 
((SELECT property_id FROM Properties ORDER BY property_id LIMIT 1), (SELECT client_id FROM Clients ORDER BY client_id LIMIT 1), 250000.00, '2024-03-01', 'Bank Transfer'),
((SELECT property_id FROM Properties ORDER BY property_id LIMIT 1 OFFSET 1), (SELECT client_id FROM Clients ORDER BY client_id LIMIT 1 OFFSET 1), 320000.00, '2024-03-02', 'Credit Card'),
((SELECT property_id FROM Properties ORDER BY property_id LIMIT 1 OFFSET 2), (SELECT client_id FROM Clients ORDER BY client_id LIMIT 1 OFFSET 2), 150000.00, '2024-03-03', 'Cash'),
((SELECT property_id FROM Properties ORDER BY property_id LIMIT 1 OFFSET 3), (SELECT client_id FROM Clients ORDER BY client_id LIMIT 1 OFFSET 3), 275000.00, '2024-03-04', 'Bank Transfer'),
((SELECT property_id FROM Properties ORDER BY property_id LIMIT 1 OFFSET 4), (SELECT client_id FROM Clients ORDER BY client_id LIMIT 1 OFFSET 4), 190000.00, '2024-03-05', 'Credit Card');

-- Retrieve inserted records
SELECT * FROM Transactions;

CREATE TABLE Inspections (
    inspection_id INT PRIMARY KEY AUTO_INCREMENT,
    property_id INT NOT NULL,
    inspector_name VARCHAR(100) NOT NULL,
    condition_rating ENUM('Poor', 'Fair', 'Good', 'Excellent') NOT NULL,
    issue_found TEXT,
    inspection_date DATE NOT NULL,
    FOREIGN KEY (property_id) REFERENCES Properties(property_id) ON DELETE CASCADE
);

INSERT INTO Inspections (property_id, inspector_name, condition_rating, issue_found, inspection_date) 
VALUES 
(1, 'John Doe', 'Good', 'Minor roof leak', '2024-03-01'),
(2, 'Sarah Lee', 'Excellent', NULL, '2024-03-02'),
(3, 'Michael Smith', 'Fair', 'Cracks in walls', '2024-03-03'),
(4, 'Emily Davis', 'Good', 'Plumbing issues', '2024-03-04'),
(5, 'Robert Johnson', 'Poor', 'Foundation damage', '2024-03-05');

SELECT * FROM Inspections;


CREATE TABLE Broker (
    BrokerID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(15) UNIQUE NOT NULL
);
INSERT INTO Broker VALUES
(1, 'Alice Johnson', 'alice.johnson@example.com', '123-456-7890'),
(2, 'Bob Smith', 'bob.smith@example.com', '234-567-8901'),
(3, 'Charlie Brown', 'charlie.brown@example.com', '345-678-9012'),
(4, 'David Wilson', 'david.wilson@example.com', '456-789-0123'),
(5, 'Emma Davis', 'emma.davis@example.com', '567-890-1234');

SELECT * FROM Broker;


CREATE TABLE Owner (
    OwnerID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL
);

INSERT INTO Owner (Name, Email) VALUES
('John Doe', 'john.doe@example.com'),
('Sarah Lee', 'sarah.lee@example.com'),
('Michael Smith', 'michael.smith@example.com'),
('Emily Davis', 'emily.davis@example.com'),
('Robert Johnson', 'robert.johnson@example.com');

SELECT * FROM Owner;


CREATE TABLE Service (
    ServiceID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    ServiceType VARCHAR(50) NOT NULL,
    Price DECIMAL(10,2) CHECK (Price >= 0) NOT NULL
);

-- Insert 5 sample services
INSERT INTO Service (Name, ServiceType, Price) VALUES
('Home Cleaning', 'Cleaning', 100.00),
('Plumbing Repair', 'Repair', 150.00),
('Electrical Inspection', 'Inspection', 120.00),
('Landscaping', 'Maintenance', 80.00),
('Pest Control', 'Sanitation', 90.00);

-- Retrieve inserted records
SELECT * FROM Service;


CREATE TABLE Bank (
    BankID INT PRIMARY KEY AUTO_INCREMENT,
    BankName VARCHAR(100) NOT NULL,
    BankCode VARCHAR(20) NOT NULL UNIQUE,
    BudgetRange DECIMAL(15,2) CHECK (BudgetRange >= 0)
);

-- Insert 5 sample bank records
INSERT INTO Bank (BankName, BankCode, BudgetRange) VALUES
('First National Bank', 'FNB123', 5000000.00),
('Citywide Bank', 'CWB456', 7500000.00),
('Global Trust Bank', 'GTB789', 6000000.00),
('Secure Savings Bank', 'SSB101', 8200000.00),
('Union Credit Bank', 'UCB202', 9000000.00);

-- Retrieve inserted records
SELECT * FROM Bank;


CREATE TABLE Comment (
    CommentID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT NOT NULL,
    CommentText TEXT NOT NULL,
    DatePosted TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Check table structure
DESCRIBE Comment;

-- Insert sample comments
INSERT INTO Comment (UserID, CommentText) VALUES
(1, 'This platform is very user-friendly.'),
(2, 'Looking forward to listing my properties here.'),
(3, 'Need more details on commission rates.'),
(4, 'Great support from customer service!'),
(5, 'The UI could be improved, but overall good experience.');

-- Retrieve inserted records
SELECT * FROM Comment;


-- Create Tenant Table
CREATE TABLE Tenant (
    TenantID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(15) UNIQUE NOT NULL,
    Address TEXT NOT NULL
);

-- Insert sample tenants
INSERT INTO Tenant (Name, Email, Phone, Address) VALUES
('Alice Johnson', 'alice.johnson@example.com', '555-123-4567', '123 Main St, Springfield'),
('Bob Williams', 'bob.williams@example.com', '555-987-6543', '456 Oak Avenue, Metropolis'),
('Charlie Brown', 'charlie.brown@example.com', '555-456-7890', '789 Pine Road, Gotham'),
('David Smith', 'david.smith@example.com', '555-321-0987', '101 Maple Lane, Star City'),
('Emma Davis', 'emma.davis@example.com', '555-654-3210', '202 Birch Boulevard, Central City');

-- Retrieve inserted records
SELECT * FROM Tenant;


CREATE TABLE Location (
    LocationID INT PRIMARY KEY AUTO_INCREMENT,
    City VARCHAR(100) NOT NULL,
    State VARCHAR(100) NOT NULL,
    ZipCode VARCHAR(10) NOT NULL CHECK (CHAR_LENGTH(ZipCode) BETWEEN 5 AND 10),
    Latitude DECIMAL(10,8),
    Longitude DECIMAL(11,8)
);

-- Insert sample locations
INSERT INTO Location (City, State, ZipCode, Latitude, Longitude) VALUES
('New York', 'New York', '10001', 40.712776, -74.005974),
('Los Angeles', 'California', '90001', 34.052235, -118.243683),
('Chicago', 'Illinois', '60601', 41.878113, -87.629799),
('Houston', 'Texas', '77001', 29.760427, -95.369804),
('Miami', 'Florida', '33101', 25.761680, -80.191790);

-- Retrieve inserted records
SELECT * FROM Location;
-- -----------------------------------
-- ✅ VIEWS ( 14 Total)
-- -----------------------------------
-- 1. CREATE VIEW View_PropertyOwner AS
SELECT p.property_id, p.address, p.price, p.area, u.username AS owner_name, u.email AS owner_email
FROM Properties p
JOIN Users u ON p.owner_id = u.user_id;

-- 2. View transaction history
CREATE VIEW View_Transactions AS
SELECT t.transaction_id, p.address, c.name AS client_name, t.payment_amount, t.payment_method, t.payment_date
FROM Transactions t
JOIN Properties p ON t.property_id = p.property_id
JOIN Clients c ON t.client_id = c.client_id;

-- 3. View agent list with agency
CREATE VIEW View_Agents AS
SELECT agent_id, name, email, phone, agency_name FROM Agents;

-- 4. View all clients
CREATE VIEW View_Clients AS
SELECT client_id, name, email, phone FROM Clients;

-- 5. View inspection summary
CREATE VIEW View_Inspections AS
SELECT i.property_id, p.address, i.inspector_name, i.condition_rating, i.issue_found
FROM Inspections i
JOIN Properties p ON i.property_id = p.property_id;

-- 6. Properties with Excellent rating
CREATE VIEW View_ExcellentProperties AS
SELECT * FROM View_Inspections WHERE condition_rating = 'Excellent';

-- 7. High value transactions
CREATE VIEW View_HighTransactions AS
SELECT * FROM View_Transactions WHERE payment_amount > 300000;

-- 8. Services available
CREATE VIEW View_Services AS
SELECT * FROM Service;

-- 9. Bank summary
CREATE VIEW View_Banks AS
SELECT BankName, BudgetRange FROM Bank;

-- 10. Comments by Clients
CREATE VIEW View_ClientComments AS
SELECT u.username, c.CommentText, c.DatePosted
FROM Comment c
JOIN Users u ON u.user_id = c.UserID
WHERE u.role = 'Client';

-- 11. Clients and their purchases
CREATE VIEW View_ClientPurchases AS
SELECT cl.name AS client_name, pr.address, t.payment_amount
FROM Clients cl
JOIN Transactions t ON cl.client_id = t.client_id
JOIN Properties pr ON pr.property_id = t.property_id;

-- 12. Properties and Location
CREATE VIEW View_PropertyLocation AS
SELECT p.property_id, p.address, l.City, l.State, l.ZipCode
FROM Properties p
JOIN Location l ON ROUND(p.latitude, 2) = ROUND(l.Latitude, 2) AND ROUND(p.longitude, 2) = ROUND(l.Longitude, 2);

-- 13. Tenants and Locations
CREATE VIEW View_TenantLocations AS
SELECT t.Name, t.Address, l.City, l.State
FROM Tenant t
JOIN Location l ON t.Address LIKE CONCAT('%', l.City, '%');

-- 14. Broker contact
CREATE VIEW View_BrokerContact AS
SELECT Name, Email, Phone FROM Broker;

-- -----------------------------------
-- ✅ TRIGGERS (5 total)
-- -----------------------------------

-- 1. Log after new user registration
CREATE TABLE UserLog (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    Action VARCHAR(255),
    Timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE TRIGGER trg_user_insert AFTER INSERT ON Users
FOR EACH ROW
BEGIN
    INSERT INTO UserLog (Action) VALUES (CONCAT('New user registered: ', NEW.username));
END;
//
DELIMITER ;

-- 2. Prevent negative service price
DELIMITER //
CREATE TRIGGER trg_service_price_check BEFORE INSERT ON Service
FOR EACH ROW
BEGIN
    IF NEW.Price < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Price cannot be negative';
    END IF;
END;
//
DELIMITER ;

-- 3. Update log after transaction
CREATE TABLE TransactionLog (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    Message TEXT,
    LoggedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE TRIGGER trg_transaction_insert AFTER INSERT ON Transactions
FOR EACH ROW
BEGIN
    INSERT INTO TransactionLog (Message) VALUES (CONCAT('Transaction recorded for property ID: ', NEW.property_id));
END;
//
DELIMITER ;

-- 4. Track property deletion
CREATE TABLE PropertyDeletionLog (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    PropertyID INT,
    DeletedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE TRIGGER trg_property_delete BEFORE DELETE ON Properties
FOR EACH ROW
BEGIN
    INSERT INTO PropertyDeletionLog (PropertyID) VALUES (OLD.property_id);
END;
//
DELIMITER ;

-- 5. Prevent duplicate phone in Clients and Tenants
DELIMITER //
CREATE TRIGGER trg_no_duplicate_phone BEFORE INSERT ON Clients
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM Tenant WHERE Phone = NEW.phone) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Phone already exists in Tenants';
    END IF;
END;
//
DELIMITER ;

-- -----------------------------------
-- ✅ JOINS (5 examples as views)
-- -----------------------------------

-- Join Clients and Transactions
CREATE VIEW Join_ClientTransactions AS
SELECT c.name, t.payment_amount, t.payment_date
FROM Clients c
JOIN Transactions t ON c.client_id = t.client_id;

-- Join Users and Comments
CREATE VIEW Join_UserComments AS
SELECT u.username, cm.CommentText
FROM Users u
JOIN Comment cm ON u.user_id = cm.UserID;

-- Join Broker and Transactions (imaginary relation via Clients' names)
-- (Assuming names overlap for demonstration)
CREATE VIEW Join_BrokerClient AS
SELECT b.Name AS BrokerName, c.name AS ClientName
FROM Broker b
JOIN Clients c ON b.Name = c.name;

-- Join Agents and Properties (imaginary matching on email or agency)
CREATE VIEW Join_AgentAgencyProperties AS
SELECT a.name AS Agent, p.address
FROM Agents a
JOIN Properties p ON a.agency_name LIKE '%Realty%' LIMIT 5;

-- Join Properties and Location
CREATE VIEW Join_PropertyGeo AS
SELECT p.address, l.City, l.State
FROM Properties p
JOIN Location l ON ROUND(p.latitude, 2) = ROUND(l.Latitude, 2) AND ROUND(p.longitude, 2) = ROUND(l.Longitude, 2);

-- -----------------------------------
-- ✅ CURSORS (3 total)
-- -----------------------------------

-- 1. Loop through Properties to print addresses
DELIMITER //
CREATE PROCEDURE ListPropertyAddresses()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE addr VARCHAR(255);
    DECLARE cur CURSOR FOR SELECT address FROM Properties;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO addr;
        IF done THEN
            LEAVE read_loop;
        END IF;
        SELECT CONCAT('Property Address: ', addr);
    END LOOP;
    CLOSE cur;
END;
//
DELIMITER ;

-- 2. Cursor for listing all clients and payments
DELIMITER //
CREATE PROCEDURE ListClientPayments()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE cname VARCHAR(100);
    DECLARE amount DECIMAL(15,2);
    DECLARE cur CURSOR FOR
        SELECT c.name, t.payment_amount FROM Clients c
        JOIN Transactions t ON c.client_id = t.client_id;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO cname, amount;
        IF done THEN
            LEAVE read_loop;
        END IF;
        SELECT CONCAT('Client: ', cname, ', Paid: ', amount);
    END LOOP;
    CLOSE cur;
END;
//
DELIMITER ;

-- 3. Cursor to list service names and prices
DELIMITER //
CREATE PROCEDURE ListServices()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE sname VARCHAR(100);
    DECLARE sprice DECIMAL(10,2);
    DECLARE cur CURSOR FOR SELECT Name, Price FROM Service;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO sname, sprice;
        IF done THEN
            LEAVE read_loop;
        END IF;
        SELECT CONCAT('Service: ', sname, ', Price: ', sprice);
    END LOOP;
    CLOSE cur;
END;
//
DELIMITER ;
