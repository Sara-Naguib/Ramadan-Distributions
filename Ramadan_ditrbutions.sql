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

CREATE TABLE Donations_Log (
    donation_id INT AUTO_INCREMENT PRIMARY KEY,
    donor_name VARCHAR(100),
    amount_value DECIMAL(10,2),
    donation_type ENUM('Cash','Food'),
    org_type ENUM('Individual','Company','NGO')
);

CREATE TABLE Users_Master (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    gender VARCHAR(10),
    age INT,
    phone VARCHAR(20),
    address VARCHAR(150),
    role ENUM('Admin','Volunteer','Driver','Beneficiary') NOT NULL
);

CREATE TABLE Beneficiary_Details (
    beneficiary_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNIQUE, 
    family_members_count INT,
    poverty_score INT CHECK (poverty_score BETWEEN 1 AND 10),
    last_received_date DATE,
    FOREIGN KEY (user_id) REFERENCES Users_Master(user_id)
);
CREATE TABLE Skills (
    skill_id INT AUTO_INCREMENT PRIMARY KEY,
    skill_type ENUM('Cooking','Driving','Data Entry') NOT NULL
);
CREATE TABLE Volunteer_Skills (
    volunteer_id INT,
    skill_id INT,
    years_of_experience INT,
    PRIMARY KEY (volunteer_id, skill_id),
    FOREIGN KEY (volunteer_id) REFERENCES Users_Master (user_id),
    FOREIGN KEY (skill_id) REFERENCES Skills (skill_id)
);
CREATE TABLE Training_Sessions (
    session_id INT AUTO_INCREMENT PRIMARY KEY,
    session_name VARCHAR(100),
    trainer_name VARCHAR(100),
    session_date DATE
);
CREATE TABLE Driver_Training (
    driver_id INT,
    session_id INT,
    PRIMARY KEY (driver_id, session_id),
    FOREIGN KEY (driver_id) REFERENCES Users_Master (user_id),
    FOREIGN KEY (session_id) REFERENCES Training_Sessions (session_id)
);

