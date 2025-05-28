-- ##############################################
-- ## RealEstateDB Database with Complete Normalization
-- ## Includes 1NF, 2NF, 3NF, BCNF, 4NF, and 5NF
-- ##############################################

-- 1. DROP AND CREATE DATABASE
DROP DATABASE IF EXISTS realestatedb;
CREATE DATABASE realestatedb;
USE realestatedb;

-- ##############################################
-- ## 1NF (First Normal Form) Implementation
-- ## - All tables have primary keys
-- ## - All attributes are atomic
-- ## - No repeating groups
-- ##############################################

-- Users Table (1NF)
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE,
    role ENUM('Admin', 'Agent', 'Broker', 'Client') NOT NULL
);

-- Agents Table (1NF)
CREATE TABLE Agents (
    agent_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20) NOT NULL,
    agency_name VARCHAR(255) NOT NULL
);

-- ##############################################
-- ## 2NF (Second Normal Form) Verification
-- ## - Already in 1NF
-- ## - No partial dependencies (all non-key attributes depend on whole PK)
-- ##############################################

-- Clients Table (2NF)
CREATE TABLE Clients (
    client_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20) NOT NULL
);

-- Owners Table (2NF)
CREATE TABLE Owners (
    owner_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

-- ##############################################
-- ## 3NF (Third Normal Form) Implementation
-- ## - Already in 2NF
-- ## - No transitive dependencies
-- ##############################################

-- Location Table (3NF - ZipCode info separated)
CREATE TABLE Location (
    location_id INT PRIMARY KEY AUTO_INCREMENT,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    zip_code VARCHAR(10) NOT NULL UNIQUE,
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8)
);

-- Properties Table (3NF - Proper foreign key relationships)
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

-- Add validation that price must be positive
ALTER TABLE Properties ADD CONSTRAINT chk_positive_price 
CHECK (price > 0);
-- ##############################################
-- ## BCNF (Boyce-Codd Normal Form) Verification
-- ## - Already in 3NF
-- ## - Every determinant is a candidate key
-- ##############################################

-- First create the Brokers table that will be referenced
CREATE TABLE IF NOT EXISTS Brokers (
    broker_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    commission_rate DECIMAL(5,2) NOT NULL
);

-- Now create PropertyBrokers with the foreign key
CREATE TABLE PropertyBrokers (
    property_id INT NOT NULL,
    broker_id INT NOT NULL,
    PRIMARY KEY (property_id, broker_id),
    FOREIGN KEY (property_id) REFERENCES Properties(property_id),
    FOREIGN KEY (broker_id) REFERENCES Brokers(broker_id)
);
-- ##############################################
-- ## 4NF (Fourth Normal Form) Implementation
-- ## - Already in BCNF
-- ## - No multi-valued dependencies
-- ## - Separated property features and photos
-- ##############################################

-- PropertyPhotos Table (4NF)
CREATE TABLE PropertyPhotos (
    photo_id INT PRIMARY KEY AUTO_INCREMENT,
    property_id INT NOT NULL,
    photo_url TEXT NOT NULL,
    FOREIGN KEY (property_id) REFERENCES Properties(property_id) ON DELETE CASCADE
);

-- PropertyFeatures Table (4NF)
CREATE TABLE PropertyFeatures (
    feature_id INT PRIMARY KEY AUTO_INCREMENT,
    property_id INT NOT NULL,
    feature VARCHAR(255) NOT NULL,
    FOREIGN KEY (property_id) REFERENCES Properties(property_id) ON DELETE CASCADE
);

-- ##############################################
-- ## 5NF (Fifth Normal Form) Verification
-- ## - Already in 4NF
-- ## - No join dependencies
-- ##############################################

-- Our schema has no join dependencies that can be decomposed further
-- No changes needed as schema already meets 5NF requirements

-- ##############################################
-- ## Additional Tables (All Normal Forms)
-- ##############################################

-- Transactions Table (1NF)
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

-- Banks Table (1NF)
CREATE TABLE Banks (
    bank_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    bank_code VARCHAR(20) UNIQUE NOT NULL,
    budget_range DECIMAL(15,2) CHECK (budget_range >= 0)
);

-- Payments Table (1NF)
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

-- Inspections Table (1NF)
CREATE TABLE Inspections (
    inspection_id INT PRIMARY KEY AUTO_INCREMENT,
    property_id INT NOT NULL,
    inspector_name VARCHAR(100) NOT NULL,
    condition_rating ENUM('Poor', 'Fair', 'Good', 'Excellent') NOT NULL,
    issue_found TEXT,
    inspection_date DATE NOT NULL,
    FOREIGN KEY (property_id) REFERENCES Properties(property_id)
);

-- Comments Table (1NF)
CREATE TABLE Comments (
    comment_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    comment_text TEXT NOT NULL,
    date_posted TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Tenants Table (1NF)
CREATE TABLE Tenants (
    tenant_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    address TEXT NOT NULL
);

-- Services Table (1NF)
CREATE TABLE Services (
    service_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    service_type VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) CHECK (price >= 0) NOT NULL
);

-- ##############################################
-- ## INDEXES FOR OPTIMIZATION
-- ##############################################
CREATE INDEX idx_property_price ON Properties(price);
CREATE INDEX idx_property_location ON Properties(location_id);
CREATE INDEX idx_transaction_date ON Transactions(payment_date);
CREATE INDEX idx_inspection_rating ON Inspections(condition_rating);
CREATE INDEX idx_service_type ON Services(service_type);

-- ##############################################
-- ## SAMPLE DATA INSERTION
-- ##############################################

-- Users
INSERT INTO Users (username, password, email, role) VALUES
('admin01', 'adminpass123', 'admin@example.com', 'Admin'),
('agent_john', 'johnpass456', 'john.agent@example.com', 'Agent'),
('broker_smith', 'smithsecure789', 'smith.broker@example.com', 'Broker'),
('client_lisa', 'lisapass001', 'lisa.client@example.com', 'Client'),
('agent_alice', 'alicepass789', 'alice.agent@example.com', 'Agent'),
('client_mark', 'markpass123', 'mark.client@example.com', 'Client'),
('broker_karen', 'karenpass456', 'karen.broker@example.com', 'Broker'),
('admin02', 'adminpass456', 'admin2@example.com', 'Admin'),
('client_sarah', 'sarahpass789', 'sarah.client@example.com', 'Client'),
('agent_mike', 'mikepass123', 'mike.agent@example.com', 'Agent');

-- Agents
INSERT INTO Agents (name, email, phone, agency_name) VALUES
('John Agent', 'john.agent@example.com', '9876543210', 'Dream Homes Realty'),
('Alice Realtor', 'alice.realtor@example.com', '9876543211', 'Star Properties'),
('Mike Broker', 'mike.broker@example.com', '9876543212', 'Elite Real Estate'),
('Sarah Agent', 'sarah.agent@example.com', '9876543213', 'Prime Properties'),
('David Realtor', 'david.realtor@example.com', '9876543214', 'City Homes'),
('Emily Agent', 'emily.agent@example.com', '9876543215', 'Urban Living'),
('Robert Broker', 'robert.broker@example.com', '9876543216', 'Metro Realty'),
('Jennifer Agent', 'jennifer.agent@example.com', '9876543217', 'Sunshine Properties'),
('Thomas Realtor', 'thomas.realtor@example.com', '9876543218', 'Horizon Real Estate'),
('Lisa Agent', 'lisa.agent@example.com', '9876543219', 'Coastal Homes');

-- Clients
INSERT INTO Clients (name, email, phone) VALUES
('Lisa Ray', 'lisa.client@example.com', '9123456780'),
('Mark Johnson', 'mark.johnson@example.com', '9123456781'),
('Sarah Williams', 'sarah.williams@example.com', '9123456782'),
('David Brown', 'david.brown@example.com', '9123456783'),
('Emily Davis', 'emily.davis@example.com', '9123456784'),
('Robert Wilson', 'robert.wilson@example.com', '9123456785'),
('Jennifer Taylor', 'jennifer.taylor@example.com', '9123456786'),
('Thomas Moore', 'thomas.moore@example.com', '9123456787'),
('Lisa Martinez', 'lisa.martinez@example.com', '9123456788'),
('Michael Anderson', 'michael.anderson@example.com', '9123456789');

-- Owners
INSERT INTO Owners (name, email) VALUES
('David Miller', 'david.owner@example.com'),
('Susan White', 'susan.owner@example.com'),
('Richard Johnson', 'richard.owner@example.com'),
('Patricia Smith', 'patricia.owner@example.com'),
('William Brown', 'william.owner@example.com'),
('Jennifer Davis', 'jennifer.owner@example.com'),
('Charles Wilson', 'charles.owner@example.com'),
('Elizabeth Taylor', 'elizabeth.owner@example.com'),
('Joseph Moore', 'joseph.owner@example.com'),
('Margaret Anderson', 'margaret.owner@example.com');

-- Location
INSERT INTO Location (city, state, zip_code, latitude, longitude) VALUES
('Chennai', 'Tamil Nadu', '600001', 13.0827, 80.2707),
('Bangalore', 'Karnataka', '560001', 12.9716, 77.5946),
('Mumbai', 'Maharashtra', '400001', 19.0760, 72.8777),
('Delhi', 'Delhi', '110001', 28.7041, 77.1025),
('Hyderabad', 'Telangana', '500001', 17.3850, 78.4867),
('Kolkata', 'West Bengal', '700001', 22.5726, 88.3639),
('Pune', 'Maharashtra', '411001', 18.5204, 73.8567),
('Jaipur', 'Rajasthan', '302001', 26.9124, 75.7873),
('Ahmedabad', 'Gujarat', '380001', 23.0225, 72.5714),
('Lucknow', 'Uttar Pradesh', '226001', 26.8467, 80.9462);

-- Properties
INSERT INTO Properties (owner_id, address, price, area, location_id) VALUES
(1, '123 Beach Road, Chennai', 7500000.00, 1200, 1),
(2, '456 MG Road, Bangalore', 9800000.00, 1500, 2),
(3, '789 Marine Drive, Mumbai', 12000000.00, 1800, 3),
(4, '101 Connaught Place, Delhi', 8500000.00, 1300, 4),
(5, '234 Jubilee Hills, Hyderabad', 6800000.00, 1100, 5),
(6, '567 Park Street, Kolkata', 7200000.00, 1150, 6),
(7, '890 FC Road, Pune', 6500000.00, 1050, 7),
(8, '112 MI Road, Jaipur', 5500000.00, 950, 8),
(9, '334 CG Road, Ahmedabad', 4800000.00, 850, 9),
(10, '556 Hazratganj, Lucknow', 5200000.00, 900, 10);

-- Property Photos
INSERT INTO PropertyPhotos (property_id, photo_url) VALUES
(1, 'http://example.com/property1/photo1.jpg'),
(1, 'http://example.com/property1/photo2.jpg'),
(2, 'http://example.com/property2/photo1.jpg'),
(3, 'http://example.com/property3/photo1.jpg'),
(4, 'http://example.com/property4/photo1.jpg'),
(5, 'http://example.com/property5/photo1.jpg'),
(6, 'http://example.com/property6/photo1.jpg'),
(7, 'http://example.com/property7/photo1.jpg'),
(8, 'http://example.com/property8/photo1.jpg'),
(9, 'http://example.com/property9/photo1.jpg'),
(10, 'http://example.com/property10/photo1.jpg');

-- Property Features
INSERT INTO PropertyFeatures (property_id, feature) VALUES
(1, '3 BHK'),
(1, 'Sea View'),
(2, 'Swimming Pool'),
(2, 'Gym'),
(3, '4 BHK'),
(3, 'Beachfront'),
(4, '3 BHK'),
(4, 'Central Location'),
(5, '2 BHK'),
(5, 'Gated Community'),
(6, '3 BHK'),
(6, 'Heritage Building'),
(7, '2 BHK'),
(7, 'Balcony'),
(8, '3 BHK'),
(8, 'Historical Area'),
(9, '2 BHK'),
(9, 'Modern Design'),
(10, '3 BHK'),
(10, 'City Center');

-- Brokers
INSERT INTO Brokers (name, email, phone, commission_rate) VALUES
('Samuel Broker', 'samuel.broker@example.com', '9988776655', 2.50),
('Karen Deals', 'karen.deals@example.com', '9988776644', 3.00),
('Andrew Sales', 'andrew.sales@example.com', '9988776633', 2.75),
('Jessica Listings', 'jessica.listings@example.com', '9988776622', 2.25),
('Matthew Properties', 'matthew.properties@example.com', '9988776611', 3.50),
('Olivia Homes', 'olivia.homes@example.com', '9988776600', 2.00),
('Daniel Estates', 'daniel.estates@example.com', '9988776599', 2.80),
('Sophia Realty', 'sophia.realty@example.com', '9988776588', 3.25),
('James Associates', 'james.associates@example.com', '9988776577', 2.90),
('Emma Investments', 'emma.investments@example.com', '9988776566', 3.75);

-- Property-Broker Relation
INSERT INTO PropertyBrokers (property_id, broker_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);

-- Transactions
INSERT INTO Transactions (property_id, client_id, payment_amount, payment_date, payment_method) VALUES
(1, 1, 7600000.00, '2025-04-01', 'Bank Transfer'),
(2, 2, 9900000.00, '2025-04-05', 'Credit Card'),
(3, 3, 12100000.00, '2025-04-10', 'Bank Transfer'),
(4, 4, 8600000.00, '2025-04-15', 'Credit Card'),
(5, 5, 6900000.00, '2025-04-20', 'Cash'),
(6, 6, 7300000.00, '2025-04-25', 'Bank Transfer'),
(7, 7, 6600000.00, '2025-05-01', 'Credit Card'),
(8, 8, 5600000.00, '2025-05-05', 'Bank Transfer'),
(9, 9, 4900000.00, '2025-05-10', 'Credit Card'),
(10, 10, 5300000.00, '2025-05-15', 'Cash');

-- Banks
INSERT INTO Banks (name, bank_code, budget_range) VALUES
('HDFC Bank', 'HDFC123', 20000000.00),
('SBI Bank', 'SBI456', 15000000.00),
('ICICI Bank', 'ICICI789', 18000000.00),
('Axis Bank', 'AXIS012', 16000000.00),
('Kotak Bank', 'KOTAK345', 17000000.00),
('IndusInd Bank', 'INDUS678', 14000000.00),
('Yes Bank', 'YES901', 13000000.00),
('PNB Bank', 'PNB234', 12000000.00),
('BOB Bank', 'BOB567', 11000000.00),
('Canara Bank', 'CANARA890', 10000000.00);

-- Payments
INSERT INTO Payments (transaction_id, bank_id, payment_amount, payment_method, payment_date) VALUES
(1, 1, 7600000.00, 'Bank Transfer', '2025-04-01'),
(2, 2, 9900000.00, 'Credit Card', '2025-04-05'),
(3, 3, 12100000.00, 'Bank Transfer', '2025-04-10'),
(4, 4, 8600000.00, 'Credit Card', '2025-04-15'),
(5, 5, 6900000.00, 'Cash', '2025-04-20'),
(6, 6, 7300000.00, 'Bank Transfer', '2025-04-25'),
(7, 7, 6600000.00, 'Credit Card', '2025-05-01'),
(8, 8, 5600000.00, 'Bank Transfer', '2025-05-05'),
(9, 9, 4900000.00, 'Credit Card', '2025-05-10'),
(10, 10, 5300000.00, 'Cash', '2025-05-15');

-- Inspections
INSERT INTO Inspections (property_id, inspector_name, condition_rating, issue_found, inspection_date) VALUES
(1, 'Inspector Roy', 'Good', 'Minor plumbing issue', '2025-03-28'),
(2, 'Inspector Mia', 'Excellent', NULL, '2025-04-02'),
(3, 'Inspector Jay', 'Good', 'Small crack in bathroom tile', '2025-04-07'),
(4, 'Inspector Kim', 'Fair', 'Needs repainting', '2025-04-12'),
(5, 'Inspector Sam', 'Excellent', NULL, '2025-04-17'),
(6, 'Inspector Lee', 'Good', 'Window latch needs repair', '2025-04-22'),
(7, 'Inspector Pat', 'Fair', 'Kitchen cabinet door loose', '2025-04-27'),
(8, 'Inspector Alex', 'Good', 'Balcony railing needs tightening', '2025-05-02'),
(9, 'Inspector Taylor', 'Excellent', NULL, '2025-05-07'),
(10, 'Inspector Jordan', 'Good', 'Minor electrical outlet issue', '2025-05-12');

-- Comments
INSERT INTO Comments (user_id, comment_text) VALUES
(1, 'System setup completed successfully.'),
(4, 'Loved the location and ambiance of the property.'),
(2, 'Great property, excellent sea view.'),
(3, 'The transaction process was smooth.'),
(5, 'The property needs some maintenance work.'),
(6, 'Very happy with the purchase.'),
(7, 'The broker was very helpful throughout.'),
(8, 'The inspection report was detailed and accurate.'),
(9, 'Looking forward to moving in next month.'),
(10, 'The payment process was efficient.');

-- Tenants
INSERT INTO Tenants (name, email, phone, address) VALUES
('Ravi Kumar', 'ravi.kumar@example.com', '9123409876', '7, Lake View Street, Chennai'),
('Meera Singh', 'meera.singh@example.com', '9123498765', '22, Residency Layout, Bangalore'),
('Amit Patel', 'amit.patel@example.com', '9123487654', '15, Marine Apartments, Mumbai'),
('Priya Sharma', 'priya.sharma@example.com', '9123476543', '33, Connaught Place, Delhi'),
('Vijay Gupta', 'vijay.gupta@example.com', '9123465432', '12, Jubilee Hills, Hyderabad'),
('Ananya Reddy', 'ananya.reddy@example.com', '9123454321', '45, Park Street, Kolkata'),
('Sanjay Verma', 'sanjay.verma@example.com', '9123443210', '78, FC Road, Pune'),
('Neha Joshi', 'neha.joshi@example.com', '9123432109', '89, MI Road, Jaipur'),
('Arun Desai', 'arun.desai@example.com', '9123421098', '56, CG Road, Ahmedabad'),
('Divya Iyer', 'divya.iyer@example.com', '9123410987', '34, Hazratganj, Lucknow');

-- Services
INSERT INTO Services (name, service_type, price) VALUES
('House Cleaning', 'Maintenance', 2500.00),
('Pest Control', 'Maintenance', 1800.00),
('Electric Repairs', 'Repairs', 3000.00),
('Plumbing Services', 'Repairs', 2800.00),
('Painting', 'Renovation', 5000.00),
('Carpentry', 'Renovation', 4500.00),
('Appliance Repair', 'Repairs', 3500.00),
('Landscaping', 'Maintenance', 4000.00),
('Deep Cleaning', 'Maintenance', 3500.00),
('Security System Installation', 'Installation', 8000.00);

-- ##############################################
-- ## NORMALIZATION SUMMARY VIEW
-- ##############################################

CREATE VIEW Normalization_Summary AS
SELECT '1NF' AS form, 'All tables have primary keys, atomic values, no repeating groups' AS characteristics
UNION ALL
SELECT '2NF', 'No partial dependencies - all non-key attributes depend on whole PK'
UNION ALL
SELECT '3NF', 'No transitive dependencies - separated location data, proper foreign keys'
UNION ALL
SELECT 'BCNF', 'Every determinant is a candidate key - schema already meets requirements'
UNION ALL
SELECT '4NF', 'No multi-valued dependencies - separated property features and photos'
UNION ALL
SELECT '5NF', 'No join dependencies - no further decomposition possible';

-- ##############################################
-- ## NORMALIZATION DEMONSTRATION QUERIES
-- ##############################################

-- 1NF DEMONSTRATION: Show atomic values and primary keys
SELECT '=== 1NF DEMONSTRATION ===' AS explanation;
SELECT '1. Users table has atomic values and primary key:' AS feature;
SELECT user_id, username, email FROM Users LIMIT 3;

SELECT '2. No repeating groups - PropertyFeatures separates multi-valued attributes:' AS feature;
SELECT property_id, feature FROM PropertyFeatures WHERE property_id = 1;

-- 2NF DEMONSTRATION: Show no partial dependencies
SELECT '=== 2NF DEMONSTRATION ===' AS explanation;
SELECT 'Properties table - all attributes depend on full primary key (property_id):' AS feature;
SELECT property_id, address, price FROM Properties LIMIT 3;

SELECT 'Violation would be if we stored owner_name directly in Properties table (depends only on owner_id)' AS warning;

-- 3NF DEMONSTRATION: Show no transitive dependencies
SELECT '=== 3NF DEMONSTRATION ===' AS explanation;
SELECT 'Location data is properly separated from Properties:' AS feature;
SELECT p.property_id, p.address, l.city, l.state 
FROM Properties p JOIN Location l ON p.location_id = l.location_id
LIMIT 3;

-- BCNF DEMONSTRATION: Show every determinant is a candidate key
SELECT '=== BCNF DEMONSTRATION ===' AS explanation;
SELECT 'PropertyBrokers table - all determinants are candidate keys:' AS feature;
SELECT 'Composite primary key (property_id, broker_id) is minimal' AS note;
SELECT property_id, broker_id FROM PropertyBrokers LIMIT 3;

-- 4NF DEMONSTRATION: Show multi-valued dependency resolution
SELECT '=== 4NF DEMONSTRATION ===' AS explanation;
SELECT 'Original 1NF design would have comma-separated features in one column:' AS note;
SELECT property_id, '3 BHK, Sea View' AS features 
FROM Properties WHERE property_id = 1
UNION ALL
SELECT property_id, 'Swimming Pool, Gym' AS features 
FROM Properties WHERE property_id = 2
LIMIT 2;

SELECT 'Current 4NF design with separate table:' AS note;
SELECT 
    p.property_id,
    p.address,
    GROUP_CONCAT(pf.feature SEPARATOR ', ') AS features
FROM Properties p
JOIN PropertyFeatures pf ON p.property_id = pf.property_id
GROUP BY p.property_id
LIMIT 3;

-- 5NF DEMONSTRATION: Show no join dependencies
SELECT '=== 5NF DEMONSTRATION ===' AS explanation;
SELECT 'All tables are in their most decomposed form:' AS feature;
SHOW TABLES;

-- Verify all normalization forms through the summary view
SELECT '=== NORMALIZATION SUMMARY ===' AS title;
SELECT * FROM Normalization_Summary;

-- Count records in each table to confirm 10+ entries
SELECT '=== TABLE RECORD COUNTS ===' AS title;
SELECT 'Users' AS table_name, COUNT(*) AS record_count FROM Users
UNION ALL SELECT 'Agents', COUNT(*) FROM Agents
UNION ALL SELECT 'Clients', COUNT(*) FROM Clients
UNION ALL SELECT 'Owners', COUNT(*) FROM Owners
UNION ALL SELECT 'Location', COUNT(*) FROM Location
UNION ALL SELECT 'Properties', COUNT(*) FROM Properties
UNION ALL SELECT 'PropertyPhotos', COUNT(*) FROM PropertyPhotos
UNION ALL SELECT 'PropertyFeatures', COUNT(*) FROM PropertyFeatures
UNION ALL SELECT 'Brokers', COUNT(*) FROM Brokers
UNION ALL SELECT 'PropertyBrokers', COUNT(*) FROM PropertyBrokers
UNION ALL SELECT 'Transactions', COUNT(*) FROM Transactions
UNION ALL SELECT 'Banks', COUNT(*) FROM Banks
UNION ALL SELECT 'Payments', COUNT(*) FROM Payments
UNION ALL SELECT 'Inspections', COUNT(*) FROM Inspections
UNION ALL SELECT 'Comments', COUNT(*) FROM Comments
UNION ALL SELECT 'Tenants', COUNT(*) FROM Tenants
UNION ALL SELECT 'Services', COUNT(*) FROM Services;