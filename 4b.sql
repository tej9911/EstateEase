DROP DATABASE IF EXISTS realestatedb;
CREATE DATABASE realestatedb;
use realestatedb;
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE,
    role ENUM('Admin', 'Agent', 'Broker', 'Client') NOT NULL
);

-- AGENTS TABLE (2NF - Separate full dependencies)
CREATE TABLE Agents (
    agent_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20) NOT NULL,
    agency_name VARCHAR(255) NOT NULL
);

-- CLIENTS TABLE
CREATE TABLE Clients (
    client_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20) NOT NULL
);

-- OWNERS TABLE (3NF - No transitive dependencies)
CREATE TABLE Owners (
    owner_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

-- LOCATION TABLE (3NF - ZipCode info separated)
CREATE TABLE Location (
    location_id INT PRIMARY KEY AUTO_INCREMENT,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    zip_code VARCHAR(10) NOT NULL UNIQUE,
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8)
);

-- PROPERTIES TABLE (Refactored)
CREATE TABLE Properties (
    property_id INT PRIMARY KEY AUTO_INCREMENT,
    owner_id INT NOT NULL,
    address VARCHAR(255) NOT NULL,
    price DECIMAL(15,2) NOT NULL,
    area INT NOT NULL,
    location_id INT NOT NULL,
    FOREIGN KEY (owner_id) REFERENCES Owners(owner_id),
    FOREIGN KEY (location_id) REFERENCES Location(location_id)
);

-- PROPERTY PHOTOS TABLE (4NF)
CREATE TABLE PropertyPhotos (
    photo_id INT PRIMARY KEY AUTO_INCREMENT,
    property_id INT NOT NULL,
    photo_url TEXT NOT NULL,
    FOREIGN KEY (property_id) REFERENCES Properties(property_id) ON DELETE CASCADE
);

-- PROPERTY FEATURES TABLE (4NF)
CREATE TABLE PropertyFeatures (
    feature_id INT PRIMARY KEY AUTO_INCREMENT,
    property_id INT NOT NULL,
    feature VARCHAR(255) NOT NULL,
    FOREIGN KEY (property_id) REFERENCES Properties(property_id) ON DELETE CASCADE
);

-- BROKERS TABLE
CREATE TABLE Brokers (
    broker_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    commission_rate DECIMAL(5,2) NOT NULL
);

-- PROPERTY-BROKER RELATION (BCNF)
CREATE TABLE PropertyBrokers (
    property_id INT NOT NULL,
    broker_id INT NOT NULL,
    PRIMARY KEY (property_id, broker_id),
    FOREIGN KEY (property_id) REFERENCES Properties(property_id),
    FOREIGN KEY (broker_id) REFERENCES Brokers(broker_id)
);

-- TRANSACTIONS TABLE
CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    property_id INT NOT NULL,
    client_id INT NOT NULL,
    payment_amount DECIMAL(15,2) CHECK (payment_amount > 0),
    payment_date DATE NOT NULL,
    payment_method ENUM('Credit Card', 'Bank Transfer', 'Cash') NOT NULL,
    FOREIGN KEY (property_id) REFERENCES Properties(property_id),
    FOREIGN KEY (client_id) REFERENCES Clients(client_id)
);

-- PAYMENTS TABLE
CREATE TABLE Banks (
    bank_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    bank_code VARCHAR(20) UNIQUE NOT NULL,
    budget_range DECIMAL(15,2) CHECK (budget_range >= 0)
);

CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    transaction_id INT NOT NULL,
    bank_id INT NOT NULL,
    payment_amount DECIMAL(15,2) CHECK (payment_amount > 0),
    payment_method ENUM('Credit Card', 'Bank Transfer', 'Cash') NOT NULL,
    payment_date DATE NOT NULL,
    FOREIGN KEY (transaction_id) REFERENCES Transactions(transaction_id),
    FOREIGN KEY (bank_id) REFERENCES Banks(bank_id)
);

-- INSPECTIONS TABLE
CREATE TABLE Inspections (
    inspection_id INT PRIMARY KEY AUTO_INCREMENT,
    property_id INT NOT NULL,
    inspector_name VARCHAR(100) NOT NULL,
    condition_rating ENUM('Poor', 'Fair', 'Good', 'Excellent') NOT NULL,
    issue_found TEXT,
    inspection_date DATE NOT NULL,
    FOREIGN KEY (property_id) REFERENCES Properties(property_id)
);

-- COMMENTS TABLE
CREATE TABLE Comments (
    comment_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    comment_text TEXT NOT NULL,
    date_posted TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- TENANTS TABLE
CREATE TABLE Tenants (
    tenant_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    address TEXT NOT NULL
);

-- SERVICES TABLE
CREATE TABLE Services (
    service_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    service_type VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) CHECK (price >= 0) NOT NULL
);

-- USERS
INSERT INTO Users (username, password, email, role) VALUES
('admin01', 'adminpass123', 'admin@example.com', 'Admin'),
('agent_john', 'johnpass456', 'john.agent@example.com', 'Agent'),
('broker_smith', 'smithsecure789', 'smith.broker@example.com', 'Broker'),
('client_lisa', 'lisapass001', 'lisa.client@example.com', 'Client');

-- AGENTS
INSERT INTO Agents (name, email, phone, agency_name) VALUES
('John Agent', 'john.agent@example.com', '9876543210', 'Dream Homes Realty'),
('Alice Realtor', 'alice.realtor@example.com', '9876543211', 'Star Properties');

-- CLIENTS
INSERT INTO Clients (name, email, phone) VALUES
('Lisa Ray', 'lisa.client@example.com', '9123456780'),
('Mark Johnson', 'mark.johnson@example.com', '9123456781');

-- OWNERS
INSERT INTO Owners (name, email) VALUES
('David Miller', 'david.owner@example.com'),
('Susan White', 'susan.owner@example.com');

-- LOCATION
INSERT INTO Location (city, state, zip_code, latitude, longitude) VALUES
('Chennai', 'Tamil Nadu', '600001', 13.0827, 80.2707),
('Bangalore', 'Karnataka', '560001', 12.9716, 77.5946);

-- PROPERTIES
INSERT INTO Properties (owner_id, address, price, area, location_id) VALUES
(1, '123 Beach Road, Chennai', 7500000.00, 1200, 1),
(2, '456 MG Road, Bangalore', 9800000.00, 1500, 2);

-- PROPERTY PHOTOS
INSERT INTO PropertyPhotos (property_id, photo_url) VALUES
(1, 'http://example.com/property1/photo1.jpg'),
(1, 'http://example.com/property1/photo2.jpg'),
(2, 'http://example.com/property2/photo1.jpg');

-- PROPERTY FEATURES
INSERT INTO PropertyFeatures (property_id, feature) VALUES
(1, '3 BHK'),
(1, 'Sea View'),
(2, 'Swimming Pool'),
(2, 'Gym');

-- BROKERS
INSERT INTO Brokers (name, email, phone, commission_rate) VALUES
('Samuel Broker', 'samuel.broker@example.com', '9988776655', 2.50),
('Karen Deals', 'karen.deals@example.com', '9988776644', 3.00);

-- PROPERTY-BROKER RELATION
INSERT INTO PropertyBrokers (property_id, broker_id) VALUES
(1, 1),
(2, 2);

-- TRANSACTIONS
INSERT INTO Transactions (property_id, client_id, payment_amount, payment_date, payment_method) VALUES
(1, 1, 7600000.00, '2025-04-01', 'Bank Transfer'),
(2, 2, 9900000.00, '2025-04-05', 'Credit Card');

-- BANKS
INSERT INTO Banks (name, bank_code, budget_range) VALUES
('HDFC Bank', 'HDFC123', 20000000.00),
('SBI Bank', 'SBI456', 15000000.00);

-- PAYMENTS
INSERT INTO Payments (transaction_id, bank_id, payment_amount, payment_method, payment_date) VALUES
(1, 1, 7600000.00, 'Bank Transfer', '2025-04-01'),
(2, 2, 9900000.00, 'Credit Card', '2025-04-05');

-- INSPECTIONS
INSERT INTO Inspections (property_id, inspector_name, condition_rating, issue_found, inspection_date) VALUES
(1, 'Inspector Roy', 'Good', 'Minor plumbing issue', '2025-03-28'),
(2, 'Inspector Mia', 'Excellent', NULL, '2025-04-02');

-- COMMENTS
INSERT INTO Comments (user_id, comment_text) VALUES
(1, 'System setup completed successfully.'),
(4, 'Loved the location and ambiance of the property.');

-- TENANTS
INSERT INTO Tenants (name, email, phone, address) VALUES
('Ravi Kumar', 'ravi.kumar@example.com', '9123409876', '7, Lake View Street, Chennai'),
('Meera Singh', 'meera.singh@example.com', '9123498765', '22, Residency Layout, Bangalore');

-- SERVICES
INSERT INTO Services (name, service_type, price) VALUES
('House Cleaning', 'Maintenance', 2500.00),
('Pest Control', 'Maintenance', 1800.00),
('Electric Repairs', 'Repairs', 3000.00);

SELECT * FROM users;
SELECT * FROM agents;
SELECT * FROM clients;
SELECT * FROM owners;
SELECT * FROM location;
SELECT * FROM properties;
SELECT * FROM propertyphotos;
SELECT * FROM propertyfeatures;
SELECT * FROM brokers;
SELECT * FROM propertybrokers;
SELECT * FROM transactions;
SELECT * FROM banks;
SELECT * FROM payments;
SELECT * FROM inspections;
SELECT * FROM comments;
SELECT * FROM tenants;
SELECT * FROM services;