CREATE DATABASE Ramadan_Distributions;
USE Ramadan_Distributions;

CREATE TABLE Warehouses (
    warehouse_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    location VARCHAR(255) NOT NULL,
    max_capacity INT,
    current_status ENUM('Open','Full','Maintenance'),
    supervisor_id INT
);
INSERT INTO Warehouses (name, location, max_capacity, current_status, supervisor_id)
VALUES
('Zagazig Warehouse', 'Zagazig', 5000, 'Open', 101),
('Cairo Warehouse', 'Cairo', 4000, 'Full', 102),
('Mansoura Warehouse', 'Mansoura', 3000, 'Maintenance', 103);

CREATE TABLE Food_Categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    type VARCHAR(100) NOT NULL,
    required_storage_temperature DECIMAL(5, 2)
);

INSERT INTO Food_Categories (type, required_storage_temperature)
VALUES
('Dry', 25.0),
('Fresh', 5.0),
('Cooked', 10.0);

CREATE TABLE Inventory_Items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    quantity_kg DECIMAL(10, 2),
    expiry_date DATE,
    warehouse_id INT NOT NULL,
    category_id INT NOT NULL,
    FOREIGN KEY (warehouse_id) REFERENCES Warehouses (warehouse_id),
    FOREIGN KEY (category_id) REFERENCES Food_Categories (category_id)
);

ALTER TABLE Inventory_Items
ADD box_type ENUM('Dry Box','Fresh Box','Cooked Box');
INSERT INTO Inventory_Items (name, quantity_kg, expiry_date, warehouse_id, category_id, box_type)
VALUES
('Rice', 200, '2026-03-20', 1, 1, 'Dry Box'),
('Tomatoes', 100, '2026-03-09', 1, 2, 'Fresh Box'),
('Cooked Beans', 50, '2026-03-10', 2, 3, 'Cooked Box'),
('Pasta', 150, '2026-03-12', 2, 1, 'Dry Box');
CREATE TABLE Donations_Log (
    donation_id INT AUTO_INCREMENT PRIMARY KEY,
    donor_name VARCHAR(100),
    amount_value DECIMAL(10,2),
    donation_type ENUM('Cash','Food'),
    org_type ENUM('Individual','Company','NGO')
);
INSERT INTO Donations_Log (donor_name, amount_value, donation_type, org_type)
VALUES
('Ali Company', 5000, 'Cash', 'Company'),
('Fatma Individual', 200, 'Cash', 'Individual'),
('NGO Care', 1000, 'Food', 'NGO');
CREATE TABLE Users_Master (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    gender VARCHAR(10),
    age INT,
    phone VARCHAR(20),
    address VARCHAR(150),
    role ENUM('Admin','Volunteer','Driver','Beneficiary') NOT NULL
);
INSERT INTO Users_Master (full_name, gender, age, phone, address, role)
VALUES
('Ahmed Ali', 'Male', 35, '0101111111', 'Zagazig', 'Beneficiary'),
('Sara Naguib', 'Female', 28, '0102222222', 'Cairo', 'Volunteer'),
('Mohamed Hassan', 'Male', 40, '0103333333', 'Minya Al-Qamh', 'Driver'),
('Layla Mahmoud', 'Female', 30, '0104444444', 'Mansoura', 'Admin');

CREATE TABLE Beneficiary_Details (
    beneficiary_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNIQUE, 
    family_members_count INT,
    poverty_score INT CHECK (poverty_score BETWEEN 1 AND 10),
    last_received_date DATE,
    FOREIGN KEY (user_id) REFERENCES Users_Master(user_id)
);
INSERT INTO Beneficiary_Details (user_id, family_members_count, poverty_score, last_received_date)
VALUES
(1, 5, 9, '2026-02-20'); 
CREATE TABLE Skills (
    skill_id INT AUTO_INCREMENT PRIMARY KEY,
    skill_type ENUM('Cooking','Driving','Data Entry') NOT NULL
);
INSERT INTO Skills (skill_type)
VALUES
('Cooking'),
('Driving'),
('Data Entry');
CREATE TABLE Volunteer_Skills (
    volunteer_id INT,
    skill_id INT,
    years_of_experience INT,
    PRIMARY KEY (volunteer_id, skill_id),
    FOREIGN KEY (volunteer_id) REFERENCES Users_Master (user_id),
    FOREIGN KEY (skill_id) REFERENCES Skills (skill_id)
);
INSERT INTO Volunteer_Skills (volunteer_id, skill_id, years_of_experience)
VALUES
(2, 1, 3),  
(2, 3, 2);
CREATE TABLE Training_Sessions (
    session_id INT AUTO_INCREMENT PRIMARY KEY,
    session_name VARCHAR(100),
    trainer_name VARCHAR(100),
    session_date DATE
);
INSERT INTO Training_Sessions (session_name, trainer_name, session_date)
VALUES
('Safety First', 'Ahmed Trainer', '2026-03-05'),
('Food Handling', 'Mona Trainer', '2026-03-06');
CREATE TABLE Driver_Training (
    driver_id INT,
    session_id INT,
    PRIMARY KEY (driver_id, session_id),
    FOREIGN KEY (driver_id) REFERENCES Users_Master (user_id),
    FOREIGN KEY (session_id) REFERENCES Training_Sessions (session_id)
);
INSERT INTO Driver_Training (driver_id, session_id) VALUES (3, 1);

