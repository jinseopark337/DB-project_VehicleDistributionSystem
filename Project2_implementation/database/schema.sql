

DROP DATABASE IF EXISTS project2;
CREATE DATABASE project2;
USE project2;

SET FOREIGN_KEY_CHECKS = 0;
DROP TRIGGER IF EXISTS after_sales_insert;
DROP TABLE IF EXISTS Sales;
DROP TABLE IF EXISTS Vehicles;
DROP TABLE IF EXISTS Supply_Contracts;
DROP TABLE IF EXISTS Plants;
DROP TABLE IF EXISTS Model_Options;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Dealers;
DROP TABLE IF EXISTS Suppliers;
DROP TABLE IF EXISTS Options;
DROP TABLE IF EXISTS Models;
DROP TABLE IF EXISTS Brands;
SET FOREIGN_KEY_CHECKS = 1;

-- 1. Brands
CREATE TABLE Brands (
    brand_id VARCHAR(10) NOT NULL,
    name VARCHAR(50) NOT NULL,
    PRIMARY KEY (brand_id),
    UNIQUE KEY uq_brands_name (name)
) ENGINE=InnoDB;

-- 2. Models
CREATE TABLE Models (
    model_id VARCHAR(10) NOT NULL,
    model_name VARCHAR(50) NOT NULL,
    year INT NOT NULL,
    base_price DECIMAL(12, 2) NOT NULL,
    body_style VARCHAR(30) NOT NULL,
    brand_id VARCHAR(10) NOT NULL,
    PRIMARY KEY (model_id),
    KEY idx_models_brand (brand_id),
    KEY idx_models_body_style (body_style),
    CONSTRAINT fk_models_brand
        FOREIGN KEY (brand_id) REFERENCES Brands(brand_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_models_year CHECK (year BETWEEN 1900 AND 2100),
    CONSTRAINT chk_models_base_price CHECK (base_price > 0)
) ENGINE=InnoDB;

-- 3. Options
CREATE TABLE Options (
    option_id VARCHAR(10) NOT NULL,
    color VARCHAR(30) NOT NULL,
    engine_type VARCHAR(50) NOT NULL,
    transmission_type VARCHAR(50) NOT NULL,
    PRIMARY KEY (option_id)
) ENGINE=InnoDB;

-- 4. Model_Options: M:N relation between Models and Options
CREATE TABLE Model_Options (
    model_id VARCHAR(10) NOT NULL,
    option_id VARCHAR(10) NOT NULL,
    PRIMARY KEY (model_id, option_id),
    KEY idx_model_options_option (option_id),
    CONSTRAINT fk_model_options_model
        FOREIGN KEY (model_id) REFERENCES Models(model_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_model_options_option
        FOREIGN KEY (option_id) REFERENCES Options(option_id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 5. Suppliers
CREATE TABLE Suppliers (
    supplier_id VARCHAR(10) NOT NULL,
    name VARCHAR(50) NOT NULL,
    contact_info VARCHAR(100) NOT NULL,
    PRIMARY KEY (supplier_id),
    KEY idx_suppliers_name (name)
) ENGINE=InnoDB;

-- 6. Plants
CREATE TABLE Plants (
    plant_id VARCHAR(10) NOT NULL,
    name VARCHAR(50) NOT NULL,
    location VARCHAR(100) NOT NULL,
    supplier_id VARCHAR(10) NULL,
    PRIMARY KEY (plant_id),
    KEY idx_plants_supplier (supplier_id),
    CONSTRAINT fk_plants_supplier
        FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id)
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 7. Supply_Contracts
CREATE TABLE Supply_Contracts (
    supplier_id VARCHAR(10) NOT NULL,
    model_id VARCHAR(10) NOT NULL,
    plant_id VARCHAR(10) NOT NULL,
    part_type VARCHAR(50) NOT NULL,
    supply_date DATE NOT NULL,
    PRIMARY KEY (supplier_id, model_id, plant_id, part_type, supply_date),
    KEY idx_supply_model (model_id),
    KEY idx_supply_plant (plant_id),
    KEY idx_supply_lookup (supplier_id, part_type, supply_date, model_id, plant_id),
    CONSTRAINT fk_supply_supplier
        FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_supply_model
        FOREIGN KEY (model_id) REFERENCES Models(model_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_supply_plant
        FOREIGN KEY (plant_id) REFERENCES Plants(plant_id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 8. Vehicles
CREATE TABLE Vehicles (
    vin VARCHAR(17) NOT NULL,
    manufacturing_date DATE NOT NULL,
    current_status VARCHAR(20) NOT NULL,
    model_id VARCHAR(10) NOT NULL,
    plant_id VARCHAR(10) NOT NULL,
    option_id VARCHAR(10) NOT NULL,
    PRIMARY KEY (vin),
    KEY idx_vehicles_model_plant (model_id, plant_id),
    KEY idx_vehicles_plant (plant_id),
    KEY idx_vehicles_model_option (model_id, option_id),
    CONSTRAINT fk_vehicles_plant
        FOREIGN KEY (plant_id) REFERENCES Plants(plant_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_vehicles_model_option
        FOREIGN KEY (model_id, option_id) REFERENCES Model_Options(model_id, option_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_vehicles_status
        CHECK (current_status IN ('in production', 'in inventory', 'sold'))
) ENGINE=InnoDB;

-- 9. Dealers
CREATE TABLE Dealers (
    dealer_id VARCHAR(10) NOT NULL,
    name VARCHAR(50) NOT NULL,
    address VARCHAR(100) NOT NULL,
    PRIMARY KEY (dealer_id)
) ENGINE=InnoDB;

-- 10. Customers
CREATE TABLE Customers (
    customer_id VARCHAR(10) NOT NULL,
    name VARCHAR(50) NOT NULL,
    address VARCHAR(100) NOT NULL,
    phone VARCHAR(30) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    annual_income DECIMAL(12, 2) NOT NULL,
    PRIMARY KEY (customer_id),
    CONSTRAINT chk_customers_income CHECK (annual_income >= 0),
    CONSTRAINT chk_customers_gender CHECK (gender IN ('Male', 'Female', 'Other'))
) ENGINE=InnoDB;

-- 11. Sales
CREATE TABLE Sales (
    sale_id VARCHAR(10) NOT NULL,
    date DATE NOT NULL,
    payment_method VARCHAR(30) NOT NULL,
    sale_price DECIMAL(12, 2) NOT NULL,
    vin VARCHAR(17) NOT NULL,
    dealer_id VARCHAR(10) NOT NULL,
    customer_id VARCHAR(10) NOT NULL,
    PRIMARY KEY (sale_id),
    UNIQUE KEY uq_sales_vin (vin),
    KEY idx_sales_date (date),
    KEY idx_sales_dealer (dealer_id),
    KEY idx_sales_customer (customer_id),
    CONSTRAINT fk_sales_vehicle
        FOREIGN KEY (vin) REFERENCES Vehicles(vin)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_sales_dealer
        FOREIGN KEY (dealer_id) REFERENCES Dealers(dealer_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_sales_customer
        FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_sales_price CHECK (sale_price > 0)
) ENGINE=InnoDB;

DELIMITER $$
CREATE TRIGGER after_sales_insert
AFTER INSERT ON Sales
FOR EACH ROW
BEGIN
    UPDATE Vehicles
    SET current_status = 'sold'
    WHERE vin = NEW.vin;
END$$
DELIMITER ;


