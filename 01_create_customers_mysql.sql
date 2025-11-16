-- ============================================
-- Azure MySQL Database Setup
-- Customer Dimension Source Data
-- ============================================

-- Create database
CREATE DATABASE IF NOT EXISTS ecommerce_source;
USE ecommerce_source;

-- Create customers table
DROP TABLE IF EXISTS customers;
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_code VARCHAR(20) UNIQUE NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    customer_segment VARCHAR(30),
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50),
    postal_code VARCHAR(20),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Insert initial customer data (20 customers)
INSERT INTO customers (customer_code, first_name, last_name, email, phone, customer_segment, city, state, country, postal_code, created_date) VALUES
('CUST001', 'John', 'Smith', 'john.smith@email.com', '555-0101', 'Premium', 'New York', 'NY', 'USA', '10001', '2024-01-01 08:00:00'),
('CUST002', 'Sarah', 'Johnson', 'sarah.j@email.com', '555-0102', 'Standard', 'Los Angeles', 'CA', 'USA', '90001', '2024-01-02 09:15:00'),
('CUST003', 'Michael', 'Williams', 'mwilliams@email.com', '555-0103', 'Premium', 'Chicago', 'IL', 'USA', '60601', '2024-01-03 10:30:00'),
('CUST004', 'Emily', 'Brown', 'ebrown@email.com', '555-0104', 'Standard', 'Houston', 'TX', 'USA', '77001', '2024-01-04 11:45:00'),
('CUST005', 'David', 'Jones', 'djones@email.com', '555-0105', 'VIP', 'Phoenix', 'AZ', 'USA', '85001', '2024-01-05 13:00:00'),
('CUST006', 'Jennifer', 'Garcia', 'jgarcia@email.com', '555-0106', 'Standard', 'Philadelphia', 'PA', 'USA', '19101', '2024-01-06 14:15:00'),
('CUST007', 'Robert', 'Martinez', 'rmartinez@email.com', '555-0107', 'Premium', 'San Antonio', 'TX', 'USA', '78201', '2024-01-07 15:30:00'),
('CUST008', 'Lisa', 'Rodriguez', 'lrodriguez@email.com', '555-0108', 'Standard', 'San Diego', 'CA', 'USA', '92101', '2024-01-08 16:45:00'),
('CUST009', 'James', 'Davis', 'jdavis@email.com', '555-0109', 'VIP', 'Dallas', 'TX', 'USA', '75201', '2024-01-09 08:00:00'),
('CUST010', 'Mary', 'Wilson', 'mwilson@email.com', '555-0110', 'Premium', 'San Jose', 'CA', 'USA', '95101', '2024-01-10 09:15:00'),
('CUST011', 'Christopher', 'Anderson', 'canderson@email.com', '555-0111', 'Standard', 'Austin', 'TX', 'USA', '73301', '2024-01-11 10:30:00'),
('CUST012', 'Patricia', 'Thomas', 'pthomas@email.com', '555-0112', 'Premium', 'Jacksonville', 'FL', 'USA', '32099', '2024-01-12 11:45:00'),
('CUST013', 'Daniel', 'Taylor', 'dtaylor@email.com', '555-0113', 'Standard', 'San Francisco', 'CA', 'USA', '94101', '2024-01-13 13:00:00'),
('CUST014', 'Nancy', 'Moore', 'nmoore@email.com', '555-0114', 'VIP', 'Columbus', 'OH', 'USA', '43004', '2024-01-14 14:15:00'),
('CUST015', 'Matthew', 'Jackson', 'mjackson@email.com', '555-0115', 'Premium', 'Indianapolis', 'IN', 'USA', '46201', '2024-01-15 15:30:00'),
('CUST016', 'Barbara', 'Martin', 'bmartin@email.com', '555-0116', 'Standard', 'Charlotte', 'NC', 'USA', '28201', '2024-01-16 16:45:00'),
('CUST017', 'Anthony', 'Lee', 'alee@email.com', '555-0117', 'Premium', 'Seattle', 'WA', 'USA', '98101', '2024-01-17 08:00:00'),
('CUST018', 'Karen', 'White', 'kwhite@email.com', '555-0118', 'Standard', 'Denver', 'CO', 'USA', '80201', '2024-01-18 09:15:00'),
('CUST019', 'Mark', 'Harris', 'mharris@email.com', '555-0119', 'VIP', 'Boston', 'MA', 'USA', '02101', '2024-01-19 10:30:00'),
('CUST020', 'Sandra', 'Clark', 'sclark@email.com', '555-0120', 'Premium', 'Nashville', 'TN', 'USA', '37201', '2024-01-20 11:45:00');

-- Create incremental load test data (5 new customers - to be added later)
-- These will be used to demonstrate incremental loading
INSERT INTO customers (customer_code, first_name, last_name, email, phone, customer_segment, city, state, country, postal_code, created_date) VALUES
('CUST021', 'Paul', 'Lewis', 'plewis@email.com', '555-0121', 'Standard', 'Detroit', 'MI', 'USA', '48201', '2024-02-01 08:00:00'),
('CUST022', 'Betty', 'Walker', 'bwalker@email.com', '555-0122', 'Premium', 'Memphis', 'TN', 'USA', '37501', '2024-02-02 09:15:00'),
('CUST023', 'George', 'Hall', 'ghall@email.com', '555-0123', 'VIP', 'Portland', 'OR', 'USA', '97201', '2024-02-03 10:30:00'),
('CUST024', 'Helen', 'Allen', 'hallen@email.com', '555-0124', 'Standard', 'Las Vegas', 'NV', 'USA', '89101', '2024-02-04 11:45:00'),
('CUST025', 'Steven', 'Young', 'syoung@email.com', '555-0125', 'Premium', 'Milwaukee', 'WI', 'USA', '53201', '2024-02-05 13:00:00');

-- Create index for efficient querying
CREATE INDEX idx_customer_code ON customers(customer_code);
CREATE INDEX idx_created_date ON customers(created_date);
CREATE INDEX idx_segment ON customers(customer_segment);

-- Verify data
SELECT COUNT(*) as total_customers FROM customers;
SELECT customer_segment, COUNT(*) as count FROM customers GROUP BY customer_segment;
