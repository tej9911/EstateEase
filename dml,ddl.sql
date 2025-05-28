DROP DATABASE IF EXISTS estateesse;
CREATE DATABASE estateesse;
USE estateesse;

-- Users Table
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

-- Agents Table
CREATE TABLE Agents (
    agent_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20) NOT NULL,
    agency_name VARCHAR(255) NOT NULL
);

INSERT INTO Agents (name, email, phone, agency_name) VALUES
('John Doe', 'john.doe@realty.com', '123-456-7890', 'Dream Homes Realty'),
('Jane Smith', 'jane.smith@estate.com', '987-654-3210', 'Elite Estates');

SELECT * FROM Agents;

-- Clients Table
CREATE TABLE Clients (
    client_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20) NOT NULL
);

INSERT INTO Clients (name, email, phone) VALUES
('Alice Johnson', 'alice.johnson@example.com', '555-123-4567'),
('Bob Williams', 'bob.williams@example.com', '555-987-6543');

SELECT * FROM Clients;

-- Properties Table
CREATE TABLE Properties (
    property_id INT PRIMARY KEY AUTO_INCREMENT,
    owner_id INT NOT NULL,
    address VARCHAR(255) NOT NULL,
    price DECIMAL(15,2) NOT NULL,
    area INT NOT NULL,
    latitude DECIMAL(10,7),
    longitude DECIMAL(10,7),
    FOREIGN KEY (owner_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

INSERT INTO Properties (owner_id, address, price, area, latitude, longitude) VALUES
(4, '123 Elm Street', 250000.00, 1800, 37.7749, -122.4194),
(5, '456 Oak Avenue', 320000.00, 2200, 40.7128, -74.0060);

SELECT * FROM Properties;

-- Transactions Table
CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    property_id INT NOT NULL,
    client_id INT NOT NULL,
    payment_amount DECIMAL(15,2) CHECK (payment_amount > 0),
    payment_date DATE NOT NULL,
    payment_method ENUM('Credit Card', 'Bank Transfer', 'Cash') NOT NULL,
    FOREIGN KEY (property_id) REFERENCES Properties(property_id) ON DELETE CASCADE,
    FOREIGN KEY (client_id) REFERENCES Clients(client_id) ON DELETE CASCADE
);

INSERT INTO Transactions (property_id, client_id, payment_amount, payment_date, payment_method) VALUES
(1, 1, 250000.00, '2025-03-01', 'Bank Transfer'),
(2, 2, 320000.00, '2025-03-02', 'Credit Card');

SELECT * FROM Transactions;

-- Inspections Table
CREATE TABLE Inspections (
    inspection_id INT PRIMARY KEY AUTO_INCREMENT,
    property_id INT NOT NULL,
    inspector_name VARCHAR(100) NOT NULL,
    condition_rating ENUM('Poor', 'Fair', 'Good', 'Excellent') NOT NULL,
    issue_found TEXT,
    inspection_date DATE NOT NULL,
    FOREIGN KEY (property_id) REFERENCES Properties(property_id) ON DELETE CASCADE
);

INSERT INTO Inspections (property_id, inspector_name, condition_rating, issue_found, inspection_date) VALUES
(1, 'John Carter', 'Good', 'Minor paint scratches', '2025-03-01'),
(2, 'Sarah Lee', 'Excellent', 'No issues found', '2025-03-02');

SELECT * FROM Inspections;

-- Broker Table
CREATE TABLE Broker (
    BrokerID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(15) UNIQUE NOT NULL
);

INSERT INTO Broker VALUES
(1, 'Alice Johnson', 'alice.johnson@example.com', '123-456-7890'),
(2, 'Bob Smith', 'bob.smith@example.com', '234-567-8901');

SELECT * FROM Broker;

-- Owner Table
CREATE TABLE Owner (
    OwnerID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL
);

INSERT INTO Owner (Name, Email) VALUES
('John Doe', 'john.doe@example.com'),
('Sarah Lee', 'sarah.lee@example.com');

SELECT * FROM Owner;

-- Service Table
CREATE TABLE Service (
    ServiceID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    ServiceType VARCHAR(50) NOT NULL,
    Price DECIMAL(10,2) CHECK (Price >= 0) NOT NULL
);

INSERT INTO Service (Name, ServiceType, Price) VALUES
('Home Cleaning', 'Cleaning', 100.00),
('Plumbing Repair', 'Repair', 150.00);

SELECT * FROM Service;

-- Bank Table
CREATE TABLE Bank (
    BankID INT PRIMARY KEY AUTO_INCREMENT,
    BankName VARCHAR(100) NOT NULL,
    BankCode VARCHAR(20) NOT NULL UNIQUE,
    BudgetRange DECIMAL(15,2) CHECK (BudgetRange >= 0)
);

INSERT INTO Bank (BankName, BankCode, BudgetRange) VALUES
('First National Bank', 'FNB123', 5000000.00),
('Citywide Bank', 'CWB456', 7500000.00);

SELECT * FROM Bank;

-- Comment Table
CREATE TABLE Comment (
    CommentID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT NOT NULL,
    CommentText TEXT NOT NULL,
    DatePosted TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users(user_id) ON DELETE CASCADE
);

INSERT INTO Comment (UserID, CommentText) VALUES
(1, 'This platform is very user-friendly.'),
(2, 'Looking forward to listing my properties here.');

SELECT * FROM Comment;

-- Tenant Table
CREATE TABLE Tenant (
    TenantID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(15) UNIQUE NOT NULL,
    Address TEXT NOT NULL
);

INSERT INTO Tenant (Name, Email, Phone, Address) VALUES
('Alice Johnson', 'alice.johnson@example.com', '555-123-4567', '123 Main St'),
('Bob Williams', 'bob.williams@example.com', '555-987-6543', '456 Oak Avenue');

SELECT * FROM Tenant;

-- Location Table
CREATE TABLE Location (
    LocationID INT PRIMARY KEY AUTO_INCREMENT,
    City VARCHAR(100) NOT NULL,
    State VARCHAR(100) NOT NULL,
    ZipCode VARCHAR(10) NOT NULL CHECK (CHAR_LENGTH(ZipCode) BETWEEN 5 AND 10),
    Latitude DECIMAL(10,8),
    Longitude DECIMAL(11,8)
);

INSERT INTO Location (City, State, ZipCode, Latitude, Longitude) VALUES
('New York', 'New York', '10001', 40.712776, -74.005974),
('Los Angeles', 'California', '90001', 34.052235, -118.243683);

SELECT * FROM Location;

-- Payment Table
CREATE TABLE Payment (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    transaction_id INT NOT NULL,
    BankID INT NOT NULL, -- References the primary key of Bank table
    payment_amount DECIMAL(15,2) CHECK (payment_amount > 0),
    payment_method ENUM('Credit Card', 'Bank Transfer', 'Cash') NOT NULL,
    payment_date DATE NOT NULL,
    FOREIGN KEY (transaction_id) REFERENCES Transactions(transaction_id) ON DELETE CASCADE,
    FOREIGN KEY (BankID) REFERENCES Bank(BankID) ON DELETE CASCADE
);
INSERT INTO Payment (transaction_id, BankID, payment_amount, payment_method, payment_date) VALUES  
(1, 1, 250000.00, 'Bank Transfer', '2025-03-01'),  
(2, 2, 320000.00, 'Credit Card', '2025-03-02');
 SELECT * FROM Payment;

-- Modify columns (example: increase VARCHAR size)
ALTER TABLE Users MODIFY email VARCHAR(150);
ALTER TABLE Agents MODIFY phone VARCHAR(25);
ALTER TABLE Clients MODIFY phone VARCHAR(25);
ALTER TABLE Broker MODIFY Phone VARCHAR(20);
ALTER TABLE Bank MODIFY BankCode VARCHAR(30);

-- Add new columns
ALTER TABLE Properties ADD COLUMN property_type ENUM('Apartment', 'House', 'Land') NOT NULL DEFAULT 'House';
ALTER TABLE Transactions ADD COLUMN transaction_status ENUM('Pending', 'Completed', 'Failed') NOT NULL DEFAULT 'Pending';
ALTER TABLE Inspections ADD COLUMN inspector_id INT NOT NULL;

-- More Users
INSERT INTO Users (username, password, email, role) VALUES
('agent_emily', 'hashed_password6', 'emily.agent@gmail.com', 'Agent'),
('broker_william', 'hashed_password7', 'william.broker@gmail.com', 'Broker'),
('client_sophia', 'hashed_password8', 'sophia.client@gmail.com', 'Client'),
('client_david', 'hashed_password9', 'david.client@gmail.com', 'Client');

-- More Agents
INSERT INTO Agents (name, email, phone, agency_name) VALUES
('Emily Clark', 'emily.clark@gmail.com', '111-222-3333', 'Luxury Estates'),
('Michael Scott', 'michael.scott@gmail.com', '444-555-6666', 'Modern Realty');

-- More Clients
INSERT INTO Clients (name, email, phone) VALUES
('Sophia Martinez', 'sophia.martinez@gmail.com', '555-333-7890'),
('David Brown', 'david.brown@gmail.com', '555-222-4444');

-- More Properties
INSERT INTO Properties (owner_id, address, price, area, latitude, longitude, property_type) VALUES
(6, '789 Maple Street', 400000.00, 2500, 34.0522, -118.2437, 'Apartment'),
(7, '101 Pine Lane', 500000.00, 3000, 41.8781, -87.6298, 'House');

-- More Transactions
INSERT INTO Transactions (property_id, client_id, payment_amount, payment_date, payment_method, transaction_status) VALUES
(3, 3, 400000.00, '2025-03-05', 'Cash', 'Completed'),
(4, 4, 500000.00, '2025-03-06', 'Bank Transfer', 'Pending');

-- More Inspections
INSERT INTO Inspections (property_id, inspector_name, condition_rating, issue_found, inspection_date, inspector_id) VALUES
(3, 'Henry Adams', 'Fair', 'Leaking faucet', '2025-03-04', 1),
(4, 'Laura White', 'Excellent', 'No issues found', '2025-03-05', 2);

-- More Brokers
INSERT INTO Broker VALUES
(5, 'Will Johnson', 'will.johnson@gmail.com', '345-678-9002'),
(9, 'Emi Carter', 'emi.carter@gmail.com', '456-789-0023');

-- More Owners
INSERT INTO Owner (Name, Email) VALUES
('Michael Roberts', 'michael.roberts@gmail.com'),
('Olivia Green', 'olivia.green@gmail.com');

-- More Services
INSERT INTO Service (Name, ServiceType, Price) VALUES
('Electrical Repair', 'Repair', 200.00),
('Landscaping', 'Maintenance', 300.00);

-- More Banks
INSERT INTO Bank (BankName, BankCode, BudgetRange) VALUES
('Global Bank', 'GB789', 10000000.00),
('Federal Trust', 'FT012', 12000000.00);

-- More Comments
INSERT INTO Comment (UserID, CommentText) VALUES
(3, 'Great platform for property search.'),
(4, 'Easy to connect with agents.');

-- More Tenants
INSERT INTO Tenant (Name, Email, Phone, Address) VALUES
('Ethan Harris', 'ethan.harris@gmail.com', '666-777-8888', '789 Birch Road'),
('Emma Wilson', 'emma.wilson@gmail.com', '999-000-1111', '102 Cedar Street');

-- More Locations
INSERT INTO Location (City, State, ZipCode, Latitude, Longitude) VALUES
('Chicago', 'Illinois', '60601', 41.878113, -87.629799),
('San Francisco', 'California', '94103', 37.774929, -122.419416);

-- More Payments
INSERT INTO Payment (transaction_id, BankID, payment_amount, payment_method, payment_date) VALUES  
(3, 3, 400000.00, 'Cash', '2025-03-05'),  
(4, 4, 500000.00, 'Bank Transfer', '2025-03-06');
/*INSERT INTO Transactions (transaction_id, property_id, client_id, payment_amount, payment_date, payment_method, transaction_status) VALUES
(3, 3, 3, 400000.00, '2025-03-05', 'Cash', 'Completed'),
(4, 4, 4, 500000.00, '2025-03-06', 'Bank Transfer', 'Pending');
*/
ALTER TABLE Payment MODIFY COLUMN transaction_id INT NULL;
INSERT INTO Payment (transaction_id, BankID, payment_amount, payment_method, payment_date) VALUES  
(NULL, 3, 400000.00, 'Cash', '2025-03-05'),  
(NULL, 4, 500000.00, 'Bank Transfer', '2025-03-06');
SELECT * FROM Users;
SELECT * FROM Agents;
SELECT * FROM Clients;

-- Start a transaction
START TRANSACTION;

-- Insert a sample record (example for rollback)
INSERT INTO Users (username, password, email, role) 
VALUES ('test_user', 'hashed_password_test', 'test.user@example.com', 'Client');

-- Commit the transaction (save changes)
COMMIT;

-- Rollback the transaction (undo changes)
ROLLBACK;

SELECT * FROM Users;
SELECT * FROM Agents;
SELECT * FROM Clients;
SELECT * FROM Properties;
SELECT * FROM Transactions;
SELECT * FROM Inspections;
SELECT * FROM Broker;
SELECT * FROM Owner;
SELECT * FROM Service;
SELECT * FROM Bank;
SELECT * FROM Comment;
SELECT * FROM Tenant;
SELECT * FROM Location;
SELECT * FROM Payment;




-- Show all tables in the current database
SHOW TABLES;

-- Show columns of a specific table
SHOW COLUMNS FROM Users;
SHOW COLUMNS FROM Properties;
SHOW COLUMNS FROM Transactions;

-- Show table structure
DESCRIBE Users;
DESCRIBE Agents;
DESCRIBE Clients;
DESCRIBE Properties;
DESCRIBE Transactions;
DESCRIBE Inspections;
DESCRIBE Broker;
DESCRIBE Owner;
DESCRIBE Service;
DESCRIBE Bank;
DESCRIBE Comment;
DESCRIBE Tenant;
DESCRIBE Location;
DESCRIBE Payment;

SELECT t.Name AS TenantName, p.address AS PropertyAddress  
FROM Tenant t  
JOIN Properties p ON t.TenantID = p.owner_id  
LIMIT 1000;

SELECT p.address AS PropertyAddress, o.Name AS OwnerName, o.Email  
FROM Properties p  
JOIN Owner o ON p.owner_id = o.OwnerID  -- Joining the Owner table to get owner details  
ORDER BY p.price DESC;  -- Sorting properties by price from highest to lowest

-- retrieve agents and associative properties
SELECT a.name AS AgentName, a.email, a.phone,  
       p.address AS PropertyAddress, p.price, p.property_type  
FROM Agents a  
JOIN Properties p ON a.agent_id = p.owner_id  -- Assuming agent is the property owner  
ORDER BY a.name ASC;  -- Sorting by agent name









INSERT INTO Users (username, password, email, role) VALUES
('john_doe', 'hashed_password21', 'john.doe@example.com', 'Client'),
('susan_adams', 'hashed_password22', 'susan.adams@example.com', 'Agent'),
('david_miller', 'hashed_password23', 'david.miller@example.com', 'Broker');
INSERT INTO Agents (name, email, phone, agency_name) VALUES
('Michael Brown', 'michael.brown@elitehomes.com', '888-999-7777', 'Elite Homes'),
('Sophia Wilson', 'sophia.wilson@dreamproperties.com', '777-888-6666', 'Dream Properties');
INSERT INTO Clients (name, email, phone) VALUES
('Rachel Green', 'rachel.green@example.com', '666-555-4444'),
('Ryan Adams', 'ryan.adams@example.com', '555-444-3333');
INSERT INTO Properties (owner_id, address, price, area, latitude, longitude, property_type) VALUES
(4, '789 Maple Drive', 450000.00, 2500, 34.0522, -118.2437, 'House'),
(5, '321 Pine Road', 600000.00, 3000, 37.3382, -121.8863, 'Apartment');
INSERT INTO Transactions (property_id, client_id, payment_amount, payment_date, payment_method, transaction_status) VALUES
(1, 1, 450000.00, '2025-03-03', 'Cash', 'Completed'),
(2, 2, 600000.00, '2025-03-04', 'Bank Transfer', 'Pending');
 -- Extra Payments (Must Match Transactions)

INSERT INTO Payment (transaction_id, BankID, payment_amount, payment_method, payment_date) VALUES  
(3, 1, 450000.00, 'Cash', '2025-03-03'),  
(4, 2, 600000.00, 'Bank Transfer', '2025-03-04');

INSERT INTO Inspections (property_id, inspector_name, condition_rating, issue_found, inspection_date, inspector_id) VALUES
(1, 'Mike Holmes', 'Excellent', 'No major issues', '2025-03-05', 1),
(2, 'Emma Watson', 'Good', 'Minor plumbing repairs needed', '2025-03-06', 2);

INSERT INTO Broker (BrokerID, Name, Email, Phone) VALUES
(8, 'Michael White', 'michael.white@brokers.com', '333-222-1111'),
(7, 'Samantha Black', 'samantha.black@realty.com', '222-111-0000');

INSERT INTO Owner (Name, Email) VALUES
('Eleanor Rigby', 'eleanor.rigby@example.com'),
('Robert Downey', 'robert.downey@example.com');

INSERT INTO Service (Name, ServiceType, Price) VALUES
('Roof Inspection', 'Inspection', 250.00),
('Home Deep Cleaning', 'Maintenance', 150.00);

INSERT INTO Bank (BankName, BankCode, BudgetRange) VALUES
('Union Savings Bank', 'USB123', 7500000.00),
('Premier National Bank', 'PNB456', 9000000.00);
INSERT INTO Comment (UserID, CommentText) VALUES
(5, 'Amazing customer support and fast responses!'),
(6, 'Great experience using this platform.');
INSERT INTO Tenant (Name, Email, Phone, Address) VALUES
('Clark Kent', 'clark.kent@example.com', '999-888-7777', 'Metropolis Towers, NY'),
('Steve Rogers', 'steve.rogers@example.com', '888-777-6666', 'Brooklyn Heights, NY');
INSERT INTO Location (City, State, ZipCode, Latitude, Longitude) VALUES
('Seattle', 'Washington', '98101', 47.6062, -122.3321),
('Austin', 'Texas', '73301', 30.2672, -97.7431);
SET SQL_SAFE_UPDATES = 0;


-- Delete Payments (must be done before deleting transactions)
DELETE FROM Payment WHERE payment_date IN ('2025-03-03', '2025-03-04');
DELETE FROM Payment WHERE transaction_id IN (3, 4);


-- Delete Transactions

DELETE FROM Transactions WHERE transaction_id IN (1, 2);








-- review 3b
-- necessary extra constraints
ALTER TABLE Properties 
ADD CONSTRAINT chk_price CHECK (price >= 0);


-- Joins
-- Retrieve a list of transactions along with client names and property addresses:
SELECT 
    t.transaction_id,
    c.name AS client_name,
    p.address AS property_address,
    t.payment_amount,
    t.payment_date
FROM 
    Transactions t
JOIN 
    Clients c ON t.client_id = c.client_id
JOIN 
    Properties p ON t.property_id = p.property_id;
    
    
    -- sets
    SELECT address FROM Properties
UNION
SELECT email FROM Clients;

SELECT p.address
FROM Properties p
LEFT JOIN Clients c ON p.owner_id = c.client_id  -- Assuming you're filtering based on owner_id
WHERE c.client_id IS NULL;  -- This filters out properties that have clients associated with them

SELECT p.address
FROM Properties p
LEFT JOIN Transactions t ON p.property_id = t.property_id
WHERE t.transaction_id IS NULL;  -- This shows properties that have no associated transactions

-- Create a temporary table to store unique property addresses involved in Transactions
CREATE TEMPORARY TABLE TempPropertyAddresses AS
SELECT DISTINCT p.address
FROM Properties p
JOIN Transactions t ON p.property_id = t.property_id;

-- Now find properties that exist in both the Properties table and the temporary table
SELECT address
FROM Properties
WHERE address IN (SELECT address FROM TempPropertyAddresses);

DROP TEMPORARY TABLE TempPropertyAddresses;  -- Clean up the temporary table after use


-- VIEWS
-- Create a view to show all properties along with their owner and transaction details:
CREATE VIEW PropertyDetails AS
SELECT 
    p.property_id,
    p.address,
    p.price,
    u.username AS owner_name,  -- Changed to u.username since the name is not in Users
    u.email AS owner_email,
    t.payment_amount,
    t.payment_date
FROM 
    Properties p
JOIN 
    Users u ON p.owner_id = u.user_id  -- Use the correct alias 'u'
LEFT JOIN 
    Transactions t ON p.property_id = t.property_id;
    
    select * from PropertyDetails;

DROP VIEW IF EXISTS AllPropertyDetails;

-- View for Client Transactions This view lists all transactions associated with each client, including property details.
CREATE VIEW ClientTransactions AS
SELECT 
    c.client_id,
    c.name AS client_name,
    c.email AS client_email,
    p.address AS property_address,
    t.payment_amount,
    t.payment_date,
    t.transaction_status
FROM 
    Clients c
JOIN 
    Transactions t ON c.client_id = t.client_id
JOIN 
    Properties p ON t.property_id = p.property_id;
select * from ClientTransactions;

-- View for Agent Listings This view shows the properties associated with each agent, including property details and their current status.
CREATE VIEW AgentPropertyListings AS
SELECT 
    a.agent_id,
    a.name AS agent_name,
    a.email AS agent_email,
    p.address AS property_address,
    p.price,
    p.property_type,
    t.transaction_status
FROM 
    Agents a
JOIN 
    Properties p ON a.agent_id = p.owner_id  -- Assuming agent is the owner
LEFT JOIN 
    Transactions t ON p.property_id = t.property_id;

select * from AgentPropertyListings;
-- View for Payment History This view summarizes payment transactions, including the payment method and corresponding transaction details.
CREATE VIEW PaymentHistory AS
SELECT 
    p.payment_id,
    t.transaction_id,
    p.payment_amount,
    p.payment_method,
    p.payment_date,
    b.BankName AS bank_name
FROM 
    Payment p
JOIN 
    Transactions t ON p.transaction_id = t.transaction_id
JOIN 
    Bank b ON p.BankID = b.BankID;
select * from PaymentHistory;


-- View for User Comments This view displays comments made by users about the platform or specific properties.
CREATE VIEW UserComments AS
SELECT 
    c.CommentID,
    u.username AS user_name,
    c.CommentText,
    c.DatePosted
FROM 
    Comment c
JOIN 
    Users u ON c.UserID = u.user_id;
select * from UserComments;

-- trigger
-- Create a trigger that automatically updates the transaction status when a payment is made:
DELIMITER //

CREATE TRIGGER UpdateTransactionStatus 
AFTER INSERT ON Payment
FOR EACH ROW
BEGIN
    UPDATE Transactions 
    SET transaction_status = 'Completed' 
    WHERE transaction_id = NEW.transaction_id;
END; //

DELIMITER ;
-- if it works
INSERT INTO Payment (transaction_id, BankID, payment_amount, payment_method, payment_date)
VALUES (1, 1, 500.00, 'Credit Card', '2025-03-31');  -- Assuming transaction_id 1 exists
SELECT transaction_id, transaction_status 
FROM Transactions 
WHERE transaction_id = 1;  -- Change to the relevant transaction_id you inserted,
-- If the trigger is working correctly, the result should show that the transaction_status for the transaction_id you inserted is now 'Completed'.
INSERT INTO Transactions (property_id, client_id, payment_amount, payment_date, payment_method, transaction_status)
VALUES 
(1, 1, 250000.00, '2025-03-01', 'Bank Transfer', 'Pending'),
(2, 2, 320000.00, '2025-03-02', 'Credit Card', 'Pending');
INSERT INTO Payment (transaction_id, BankID, payment_amount, payment_method, payment_date)
VALUES (2, 2, 250000.00, 'Bank Transfer', '2025-03-01');  -- This payment corresponds to transaction_id 1


SELECT transaction_id, transaction_status 
FROM Transactions 
WHERE transaction_id = 2;  -- Check the status for transaction_id 2


-- trigger 2
-- Trigger to Prevent Negative Property Prices
-- This trigger ensures that when a property is updated, the price cannot be set to a negative value. It raises an error if someone tries to do so.
DELIMITER //

CREATE TRIGGER PreventNegativePrice 
BEFORE UPDATE ON Properties
FOR EACH ROW
BEGIN
    IF NEW.price < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Price cannot be negative.';
    END IF;
END; //

DELIMITER ;
UPDATE Properties
SET price = -50000.00
WHERE property_id = 1;  -- Change this to the correct property_id if necessary
-- now it gave error so the trigger works

SELECT * FROM Properties WHERE property_id = 1;  -- Check the specific property, price didnt change because neg price was given to update if it was positive it would have changed

-- triger 3 to set type to house if nothing is given
DELIMITER //

CREATE TRIGGER SetDefaultPropertyType 
BEFORE INSERT ON Properties
FOR EACH ROW
BEGIN
    IF NEW.property_type IS NULL THEN
        SET NEW.property_type = 'House';
    END IF;
END; //

DELIMITER ;

-- to check
INSERT INTO Properties (owner_id, address, price, area, latitude, longitude)
VALUES (1, '789 Maple Drive', 450000.00, 2500, 34.0522, -118.2437); -- here property type not given

SELECT * FROM Properties WHERE address = '789 Maple Drive';-- in output house came because of trigger





-- cursor
-- Using a cursor to iterate through each property and print out its address and owner:


DROP PROCEDURE IF EXISTS ListProperties;  -- Drop the procedure if it already exists
DELIMITER //
CREATE PROCEDURE ListProperties()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE prop_address VARCHAR(255);
    DECLARE owner_name VARCHAR(50);  -- Match the length to the username

    -- Correct the column name to 'username'
    DECLARE property_cursor CURSOR FOR 
    SELECT p.address, o.username  -- Changed 'o.Name' to 'o.username'
    FROM Properties p
    JOIN Users o ON p.owner_id = o.user_id;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN property_cursor;

    read_loop: LOOP
        FETCH property_cursor INTO prop_address, owner_name;
        IF done THEN
            LEAVE read_loop;
        END IF;
        SELECT CONCAT('Property Address: ', prop_address, ' | Owner: ', owner_name);
    END LOOP;

    CLOSE property_cursor;
END; //

DELIMITER ;
call ListProperties;

-- subqueries
-- Retrieve the clients who have made payments greater than the average payment amount:
SELECT 
    c.name, 
    SUM(t.payment_amount) AS total_spent
FROM 
    Clients c
JOIN 
    Transactions t ON c.client_id = t.client_id
GROUP BY 
    c.client_id
HAVING 
    total_spent > (SELECT AVG(payment_amount) FROM Transactions);