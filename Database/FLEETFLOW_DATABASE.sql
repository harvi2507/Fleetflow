CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL,  -- e.g., admin, driver
    phone VARCHAR(15)
);

CREATE TABLE vehicles (
    vehicle_id SERIAL PRIMARY KEY,
    plate_number VARCHAR(20) UNIQUE NOT NULL,
    load_capacity NUMERIC(10,2) NOT NULL, -- in kg/ton
    availability BOOLEAN DEFAULT TRUE      -- TRUE = available, FALSE = unavailable
);

CREATE TABLE trips (
    trip_id SERIAL PRIMARY KEY,
    vehicle_id INT REFERENCES vehicles(vehicle_id) ON DELETE CASCADE,
    vehicle_type VARCHAR(50),
    origin VARCHAR(100) NOT NULL,
    destination VARCHAR(100) NOT NULL,
    weight NUMERIC(10,2),
    notes TEXT
);

CREATE TABLE drivers (
    driver_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    license_number VARCHAR(50) UNIQUE NOT NULL,
    license_date DATE,     -- License issue date or joining date
    trips_completed INT DEFAULT 0
);

CREATE TABLE maintenance (
    maintenance_id SERIAL PRIMARY KEY,
    vehicle_id INT REFERENCES vehicles(vehicle_id) ON DELETE CASCADE,
    maintenance_type VARCHAR(50),
    service_type VARCHAR(50),
    description TEXT,
    cost NUMERIC(10,2),
    maintenance_date DATE DEFAULT CURRENT_DATE
);

CREATE TABLE fuel (
    fuel_id SERIAL PRIMARY KEY,
    vehicle_id INT REFERENCES vehicles(vehicle_id) ON DELETE CASCADE,
    liters NUMERIC(10,2) NOT NULL,
    cost_per_liter NUMERIC(10,2) NOT NULL,
    fuel_date DATE DEFAULT CURRENT_DATE
);




INSERT INTO customers (name, username, password, role, phone) VALUES
('Alice', 'alice123', 'pass123', 'admin', '9876543210'),
('Bob', 'bob_driver', 'driverpass', 'driver', '9876543211'),
('Charlie', 'charlie_admin', 'admin123', 'admin', '9876543212'),
('David', 'david_driver', 'driver123', 'driver', '9876543213'),
('Eve', 'eve_manager', 'manager123', 'manager', '9876543214'),
('Frank', 'frank_driver', 'frankpass', 'driver', '9876543215');


INSERT INTO vehicles (plate_number, load_capacity, availability) VALUES
('MH12AB1234', 1000, TRUE),
('MH12AB1235', 2000, TRUE),
('MH12AB1236', 1500, TRUE),
('MH12AB1237', 1200, TRUE),
('MH12AB1238', 1800, TRUE),
('MH12AB1239', 2200, TRUE);

-- If you want manual customer_id
ALTER TABLE customers
ALTER COLUMN customer_id DROP DEFAULT;

ALTER TABLE customers
ALTER COLUMN customer_id
ADD GENERATED ALWAYS AS IDENTITY;

-- Drop SERIAL default
ALTER TABLE vehicles
ALTER COLUMN vehicle_id DROP DEFAULT;

INSERT INTO drivers (name, license_number, license_date, trips_completed) VALUES
('Bob', 'DL1234567', '2020-05-01', 10),
('David', 'DL2345678', '2019-03-15', 15),
('Frank', 'DL3456789', '2021-07-10', 5),
('George', 'DL4567890', '2020-11-20', 8),
('Harry', 'DL5678901', '2018-08-05', 20),
('Ian', 'DL6789012', '2019-12-25', 12);

-- Step 1: Drop the SERIAL default
ALTER TABLE vehicles
ALTER COLUMN vehicle_id DROP DEFAULT;

-- Step 2: Optional: set it as identity if you want auto-increment fallback
-- If you want pure manual input, skip this step.
-- ALTER TABLE vehicles ALTER COLUMN vehicle_id ADD GENERATED ALWAYS AS IDENTITY;

INSERT INTO vehicles (vehicle_id, plate_number, load_capacity, availability) VALUES
(1, 'GJ01ZZ1001', 1400, TRUE),
(2, 'GJ01ZZ1002', 1600, TRUE),
(3, 'GJ01ZZ1003', 1200, TRUE),
(4, 'GJ01ZZ1004', 1800, TRUE),
(5, 'GJ01ZZ1005', 2000, TRUE),
(6, 'GJ01ZZ1006', 1500, TRUE);

-- 1️⃣ Delete dependent tables first (trips, maintenance, fuel)
DELETE FROM trips;
DELETE FROM maintenance;
DELETE FROM fuel;

-- 2️⃣ Delete from drivers (no dependency on vehicles)
DELETE FROM drivers;

-- 3️⃣ Delete from vehicles
DELETE FROM vehicles;

-- 4️⃣ Delete from customers
DELETE FROM customers;

INSERT INTO customers (name, username, password, role, phone) VALUES
('Sophia', 'sophia_admin', 'passSophia1', 'admin', '9012345670'),
('Jackson', 'jackson_driver', 'passJackson1', 'driver', '9012345671'),
('Mia', 'mia_manager', 'passMia1', 'manager', '9012345672'),
('Lucas', 'lucas_driver', 'passLucas1', 'driver', '9012345673'),
('Amelia', 'amelia_admin', 'passAmelia1', 'admin', '9012345674'),
('Logan', 'logan_driver', 'passLogan1', 'driver', '9012345675');

SELECT * FROM customers;

ALTER SEQUENCE customers_customer_id_seq RESTART WITH 1;

SELECT * FROM customers;

INSERT INTO vehicles (vehicle_id, plate_number, load_capacity, availability) VALUES
(1, 'GJ01ZZ1001', 1400, TRUE),
(2, 'GJ01ZZ1002', 1600, TRUE),
(3, 'GJ01ZZ1003', 1200, FALSE),
(4, 'GJ01ZZ1004', 1800, TRUE),
(5, 'GJ01ZZ1005', 2000, FALSE),
(6, 'GJ01ZZ1006', 1500, TRUE);

SELECT * FROM vehicles;

INSERT INTO drivers (name, license_number, license_date, trips_completed) VALUES
('Sophia Driver', 'DL8765432', '2021-02-10', 6),
('Jackson Driver', 'DL8765433', '2020-07-15', 14),
('Lucas Driver', 'DL8765434', '2019-09-20', 8),
('Logan Driver', 'DL8765435', '2021-12-05', 3),
('Mia Driver', 'DL8765436', '2020-03-12', 10),
('Amelia Driver', 'DL8765437', '2018-11-30', 18);

INSERT INTO trips (vehicle_id, vehicle_type, driver_id, origin, destination, weight, notes) VALUES
(1, 'Truck', 1, 'Ahmedabad', 'Surat', 550, 'Fragile electronics'),
(2, 'Van', 2, 'Surat', 'Vadodara', 300, 'Perishable food'),
(3, 'Truck', 3, 'Vadodara', 'Rajkot', 700, 'Furniture shipment'),
(4, 'Van', 4, 'Rajkot', 'Bhavnagar', 250, 'Medical supplies'),
(5, 'Truck', 5, 'Bhavnagar', 'Junagadh', 650, 'Construction material'),
(6, 'Van', 6, 'Junagadh', 'Surendranagar', 400, 'Clothing goods');

INSERT INTO maintenance (vehicle_id, maintenance_type, service_type, description, cost) VALUES
(1, 'Engine', 'Full Service', 'Oil and filter change', 2700),
(2, 'Tyres', 'Replacement', 'Front tyres replaced', 8500),
(3, 'Brake', 'Repair', 'Brake pads replacement', 3200),
(4, 'Engine', 'Oil Change', 'Engine oil replaced', 1600),
(5, 'Transmission', 'Repair', 'Gearbox repaired', 12500),
(6, 'Tyres', 'Alignment', 'Wheel alignment performed', 1100);

INSERT INTO fuel (vehicle_id, liters, cost_per_liter, fuel_date) VALUES
(1, 60, 101, '2026-02-01'),
(2, 55, 103, '2026-02-02'),
(3, 45, 105, '2026-02-03'),
(4, 50, 102, '2026-02-04'),
(5, 70, 100, '2026-02-05'),
(6, 65, 104, '2026-02-06');

SELECT * FROM vehicles ORDER BY vehicle_id;

ALTER TABLE trips
ADD COLUMN distance NUMERIC(10,2);

DELETE FROM trips;
INSERT INTO trips (vehicle_id, vehicle_type, origin, destination, weight, notes, distance) VALUES
(1, 'Truck',  'Ahmedabad', 'Surat', 550, 'Fragile electronics', 270),
(2, 'Van',  'Surat', 'Vadodara', 300, 'Perishable food', 120),
(3, 'Truck',  'Vadodara', 'Rajkot', 700, 'Furniture shipment', 220),
(4, 'Van',  'Rajkot', 'Bhavnagar', 250, 'Medical supplies', 150),
(5, 'Truck',  'Bhavnagar', 'Junagadh', 650, 'Construction material', 320),
(6, 'Van',  'Junagadh', 'Surendranagar', 400, 'Clothing goods', 180);

select * from trips;

ALTER SEQUENCE customers_customer_id_seq RESTART WITH 1;
ALTER SEQUENCE vehicles_vehicle_id_seq RESTART WITH 1;
ALTER SEQUENCE drivers_driver_id_seq RESTART WITH 1;
ALTER SEQUENCE trips_trip_id_seq RESTART WITH 1;
ALTER SEQUENCE maintenance_maintenance_id_seq RESTART WITH 1;
ALTER SEQUENCE fuel_fuel_id_seq RESTART WITH 1;