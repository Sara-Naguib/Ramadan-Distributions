CREATE DATABASE Ramadan_Distributions;
USE Ramadan_Distributions;

-- Tables 
-- ------------------------------
CREATE TABLE users_master (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    gender ENUM('Male','Female','Other') NOT NULL,
    age TINYINT UNSIGNED NOT NULL CHECK (age >= 0),
    phone VARCHAR(20) UNIQUE,
    address VARCHAR(255),
    role ENUM('Admin','Volunteer','Driver','Beneficiary') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


<<<<<<< HEAD
CREATE TABLE Warehouses (
=======
CREATE TABLE warehouses (
>>>>>>> 65f5c68ae01d5a899533ce74a938325a704a09c1
    warehouse_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(255) NOT NULL,
    max_capacity DECIMAL(10,2) NOT NULL COMMENT 'Capacity in kg',
    current_status ENUM('Open','Full','Maintenance') NOT NULL DEFAULT 'Open',
    supervisor_id INT,
    CONSTRAINT fk_warehouse_supervisor
        FOREIGN KEY (supervisor_id) REFERENCES users_master(user_id)
        ON DELETE SET NULL ON UPDATE CASCADE
);

<<<<<<< HEAD


CREATE TABLE Food_Categories (
=======
CREATE TABLE food_categories (
>>>>>>> 65f5c68ae01d5a899533ce74a938325a704a09c1
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE,
    storage_type ENUM('Dry','Fresh','Cooked') NOT NULL,
    required_storage_temperature DECIMAL(5,2) NOT NULL
);

<<<<<<< HEAD

=======
>>>>>>> 65f5c68ae01d5a899533ce74a938325a704a09c1

CREATE TABLE inventory_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    quantity_kg DECIMAL(10,2) NOT NULL CHECK (quantity_kg >= 0),
    warehouse_id INT NOT NULL,
    category_id INT,
    expiry_date DATE NOT NULL,
    CONSTRAINT fk_item_warehouse
        FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_item_category
        FOREIGN KEY (category_id) REFERENCES food_categories(category_id)
        ON DELETE SET NULL ON UPDATE CASCADE
);
<<<<<<< HEAD
SELECT*FROM Inventory_Items;

CREATE TABLE Donations_Log (
=======


CREATE TABLE donations_log (
>>>>>>> 65f5c68ae01d5a899533ce74a938325a704a09c1
    donation_id INT AUTO_INCREMENT PRIMARY KEY,
    donor_name VARCHAR(100) NOT NULL,
    amount_value DECIMAL(12,2)  NOT NULL CHECK (amount_value > 0),
    donation_type ENUM('Cash','Food') NOT NULL,
    org_type ENUM('Individual','Company','NGO') NOT NULL,
    donated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE beneficiary_details (
    beneficiary_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    family_members_count TINYINT UNSIGNED NOT NULL DEFAULT 1,
    poverty_score TINYINT UNSIGNED NOT NULL CHECK (poverty_score BETWEEN 1 AND 10),
    last_received_date DATE,
    CONSTRAINT fk_beneficiary_user
        FOREIGN KEY (user_id) REFERENCES users_master(user_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

<<<<<<< HEAD


CREATE TABLE Skills (
    skill_id INT AUTO_INCREMENT PRIMARY KEY,
    skill_type ENUM('Cooking','Driving','Data Entry') NOT NULL
);



CREATE TABLE Volunteer_Skills (
    volunteer_skill_id INT AUTO_INCREMENT PRIMARY KEY,
    volunteer_id INT NOT NULL,
    skill_id INT NOT NULL,
    years_of_experience TINYINT UNSIGNED NOT NULL DEFAULT 0,
    UNIQUE KEY uq_volunteer_skill (volunteer_id, skill_id),
    CONSTRAINT fk_skill_volunteer FOREIGN KEY (volunteer_id) REFERENCES Users_Master (user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_skill_id FOREIGN KEY (skill_id) REFERENCES Skills (skill_id) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE Training_Sessions (
=======
CREATE TABLE training_sessions (
>>>>>>> 65f5c68ae01d5a899533ce74a938325a704a09c1
    session_id INT AUTO_INCREMENT PRIMARY KEY,
    session_name VARCHAR(100) NOT NULL,
    trainer_name VARCHAR(100) NOT NULL,
    session_date DATE  NOT NULL
);

<<<<<<< HEAD


CREATE TABLE Driver_Training (
    driver_id INT NOT NULL,
=======
CREATE TABLE driver_training (
    driver_id  INT NOT NULL,
>>>>>>> 65f5c68ae01d5a899533ce74a938325a704a09c1
    session_id INT NOT NULL,
    PRIMARY KEY (driver_id, session_id),
    CONSTRAINT fk_dt_driver
        FOREIGN KEY (driver_id) REFERENCES users_master(user_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_dt_session
        FOREIGN KEY (session_id) REFERENCES training_sessions(session_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

<<<<<<< HEAD
INSERT INTO Driver_Training (driver_id, session_id)
VALUES
(3, 1); 

INSERT INTO Users_Master (full_name, gender, age, phone, address, role)
VALUES
('Ahmed Ali', 'Male', 35, '0101111111', 'Zagazig', 'Beneficiary'),
('Sara Naguib', 'Female', 28, '0102222222', 'Sharkia', 'Volunteer'),
('Mohamed Hassan', 'Male', 40, '0103333333', 'Minya Al-Qamh', 'Driver'),
('Layla Mahmoud', 'Female', 30, '0104444444', 'Mansoura', 'Admin'),
('Supervisor 1', 'Male', 45, '0105555555', 'Zagazig', 'Admin'),
('Supervisor 2', 'Female', 42, '0106666666', 'Cairo', 'Admin'),
('Supervisor 3', 'Male', 50, '0107777777', 'Mansoura', 'Admin');

INSERT INTO Warehouses (name, location, max_capacity, current_status, supervisor_id)
VALUES
('Zagazig Warehouse', 'Zagazig', 5000, 'Open', 5),
('Cairo Warehouse', 'Cairo', 4000, 'Full', 6),
('Mansoura Warehouse', 'Mansoura', 3000, 'Maintenance', 7);


INSERT INTO Food_Categories (category_name, storage_type, required_storage_temperature)
VALUES
('Rice', 'Dry', 25.00),
('Vegetables', 'Fresh', 4.00),
('Cooked Meals', 'Cooked', 60.00),
('Fruits', 'Fresh', 5.00),
('Pasta', 'Dry', 23.50);

INSERT INTO Donations_Log (donor_name, amount_value, donation_type, org_type)
VALUES
('Ahmed Ali', 500.00, 'Cash', 'Individual'),
('Al-Masry Company', 2000.50, 'Food', 'Company'),
('Hope NGO', 1500.00, 'Cash', 'NGO'),
('Fatma Hassan', 300.00, 'Food', 'Individual');


INSERT INTO Skills (skill_type)
VALUES
('Cooking'),
('Driving'),
('Data Entry');


INSERT INTO Training_Sessions (session_name, trainer_name, session_date)
VALUES
('Safety First', 'Ahmed Trainer', '2026-03-05'),
('Food Handling', 'Mona Trainer', '2026-03-06');


INSERT INTO Beneficiary_Details (user_id, family_members_count, poverty_score, last_received_date)
VALUES
(1, 5, 8, '2026-02-15');


INSERT INTO Inventory_Items (name, quantity_kg, expiry_date, warehouse_id, category_id, box_type)
VALUES
('Rice 5kg Bag', 500.00, '2026-12-31', 1, 1, 'Dry Box'),
('Fresh Tomatoes', 200.50, '2026-03-15', 1, 2, 'Fresh Box'),
('Cooked Chicken Meal', 50.75, '2026-03-10', 2, 3, 'Cooked Box'),
('Fresh Apples', 100.00, '2026-03-16', 3, 4, 'Fresh Box'),
('Pasta 1kg Pack', 300.00, '2026-12-31', 2, 5, 'Dry Box');

INSERT INTO Volunteer_Skills (volunteer_id, skill_id, years_of_experience)
VALUES
(2, 1, 3),
(2, 3, 2);


-- Queries
SELECT ii.name AS item_name,
       ii.quantity_kg,
       ii.expiry_date,
       w.name AS warehouse_name,
       fc.category_name
FROM Inventory_Items ii
JOIN Warehouses w ON ii.warehouse_id = w.warehouse_id
JOIN Food_Categories fc ON ii.category_id = fc.category_id
WHERE fc.storage_type = 'Fresh'
  AND w.name = 'Zagazig Warehouse'
  AND ii.expiry_date BETWEEN NOW() AND NOW() + INTERVAL 2 DAY;
=======


CREATE TABLE volunteer_skills (
    skill_id INT AUTO_INCREMENT PRIMARY KEY,
    volunteer_id INT  NOT NULL,
    skill_type ENUM('Cooking','Driving','Data Entry') NOT NULL,
    years_of_experience TINYINT UNSIGNED NOT NULL DEFAULT 0,
    UNIQUE KEY uq_volunteer_skill (volunteer_id, skill_type),
    CONSTRAINT fk_skill_volunteer
        FOREIGN KEY (volunteer_id) REFERENCES users_master(user_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);


-- Sampel
-- -----------------------------

INSERT INTO users_master (full_name, gender, age, phone, address, role) VALUES
('Ahmed Hassan',      'Male',   45, '01001234567', 'Zagazig, Sharkia',      'Admin'),
('Mohamed Ali',       'Male',   30, '01112345678', 'Zagazig, Sharkia',      'Driver'),
('Sara Naguib',      'Female', 28, '01223456789', 'Minya Al-Qamh, Sharkia','Volunteer'),
('Jana Tamer',     'Female', 35, '01334567890', 'Minya Al-Qamh, Sharkia','Beneficiary'),
('Omar Sayed',        'Male',   50, '01445678901', 'Belbeis, Sharkia',      'Beneficiary'),
('Khalid Youssef',    'Male',   33, '01556789012', 'Zagazig, Sharkia',      'Driver'),
('Nour El-Din',       'Male',   27, '01667890123', 'Minya Al-Qamh, Sharkia','Volunteer'),
('Hana Adel',         'Female', 40, '01778901234', 'Minya Al-Qamh, Sharkia','Beneficiary'),
('Tarek Fawzy',       'Male',   55, '01889012345', 'Zagazig, Sharkia',      'Beneficiary'),
('Layla Nasser',      'Female', 29, '01990123456', 'Belbeis, Sharkia',      'Volunteer');

INSERT INTO warehouses (name, location, max_capacity, current_status, supervisor_id) VALUES
('Zagazig Warehouse',     'Zagazig, Sharkia',       50000.00, 'Open',        1),
('Minya Al-Qamh Store',   'Minya Al-Qamh, Sharkia', 30000.00, 'Open',        1),
('Belbeis Cold Storage',  'Belbeis, Sharkia',        20000.00, 'Maintenance', 1);

INSERT INTO food_categories (category_name, storage_type, required_storage_temperature) VALUES
('Dry Goods',      'Dry',    25.00),
('Fresh Produce',  'Fresh',   4.00),
('Cooked Meals',   'Cooked',  6.00);

INSERT INTO inventory_items (name, quantity_kg, warehouse_id, category_id, expiry_date) VALUES
('Rice',           5000.00, 1, 1, DATE_ADD(CURDATE(), INTERVAL 180 DAY)),
('Lentils',        3000.00, 1, 1, DATE_ADD(CURDATE(), INTERVAL 365 DAY)),
('Fresh Tomatoes', 800.00,  1, 2, DATE_ADD(CURDATE(), INTERVAL 1  DAY)),  
('Fresh Cucumbers',600.00,  1, 2, DATE_ADD(CURDATE(), INTERVAL 2  DAY)),  
('Chicken (Fresh)',1200.00, 2, 2, DATE_ADD(CURDATE(), INTERVAL 30 DAY)),
('Cooked Foul',    400.00,  2, 3, DATE_ADD(CURDATE(), INTERVAL 2  DAY)),
('Sugar',          2000.00, 1, 1, DATE_ADD(CURDATE(), INTERVAL 730 DAY)),
('Cooking Oil',    1500.00, 2, 1, DATE_ADD(CURDATE(), INTERVAL 365 DAY));

INSERT INTO donations_log (donor_name, amount_value, donation_type, org_type) VALUES
('Al-Nour Company',   50000.00, 'Cash', 'Company'),
('Ahmed Hassan',       2000.00, 'Cash', 'Individual'),
('Relief NGO',        30000.00, 'Cash', 'NGO'),
('Delta Corp',        75000.00, 'Cash', 'Company'),
('Mohamed Ali',        1500.00, 'Cash', 'Individual'),
('Sara Ibrahim',        500.00, 'Cash', 'Individual'),
('Sharkia Charity',   20000.00, 'Cash', 'NGO');

INSERT INTO beneficiary_details (user_id, family_members_count, poverty_score, last_received_date) VALUES
(4, 5, 9,  DATE_SUB(CURDATE(), INTERVAL 20 DAY)),   
(5, 3, 7,  DATE_SUB(CURDATE(), INTERVAL 10 DAY)),   
(8, 6, 9,  DATE_SUB(CURDATE(), INTERVAL 16 DAY)),   
(9, 4, 8,  DATE_SUB(CURDATE(), INTERVAL 5  DAY));  

INSERT INTO volunteer_skills (volunteer_id, skill_type, years_of_experience) VALUES
(3, 'Cooking',    3),
(3, 'Data Entry', 1),
(7, 'Driving',    5),
(10,'Cooking',    2);

INSERT INTO training_sessions (session_name, trainer_name, session_date) VALUES
('Safety First',       'Eng. Kamal Reda',  DATE_SUB(CURDATE(), INTERVAL 10 DAY)),
('Food Handling',      'Dr. Heba Mostafa', DATE_SUB(CURDATE(), INTERVAL 5  DAY)),
('Customer Service',   'Ms. Rana Tawfik',  CURDATE());


INSERT INTO driver_training (driver_id, session_id) VALUES
(2, 1),  
(2, 2),   
(6, 2);   

-- INDEXING FOR PERFORMANCE
-- -----------------------------------

CREATE INDEX idx_beneficiary_address
    ON users_master(address(50));


CREATE INDEX idx_poverty_score
    ON beneficiary_details(poverty_score);

CREATE INDEX idx_last_received
    ON beneficiary_details(last_received_date);

CREATE INDEX idx_item_expiry
    ON inventory_items(expiry_date);

CREATE INDEX idx_item_warehouse_cat
    ON inventory_items(warehouse_id, category_id);

CREATE INDEX idx_driver_training_session
    ON driver_training(session_id);
>>>>>>> 65f5c68ae01d5a899533ce74a938325a704a09c1
