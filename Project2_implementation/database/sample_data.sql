
USE project2;

-- ====================================================================
-- 1. Brands 데이터 입력 (15개)
-- ====================================================================
INSERT INTO Brands (brand_id, name) VALUES
('B01', 'Chevrolet'), ('B02', 'Cadillac'), ('B03', 'GMC'), ('B04', 'Audi'),
('B05', 'Volkswagen'), ('B06', 'Porsche'), ('B07', 'Bentley'), ('B08', 'Ford'),
('B09', 'Lincoln'), ('B10', 'Toyota'), ('B11', 'Lexus'), ('B12', 'BMW'),
('B13', 'Mercedes-Benz'), ('B14', 'Honda'), ('B15', 'Hyundai');

-- ====================================================================
-- 2. Models 데이터 입력 (15개)
-- ====================================================================
INSERT INTO Models (model_id, model_name, year, base_price, body_style, brand_id) VALUES
('M01', 'Malibu', 2024, 26000.00, '4-door sedan', 'B01'),
('M02', 'Tahoe', 2024, 58000.00, 'SUV', 'B01'),
('M03', 'Escalade', 2025, 82000.00, 'SUV', 'B02'),
('M04', 'CT5', 2024, 47000.00, '4-door sedan', 'B02'),
('M05', 'Yukon', 2024, 60000.00, 'SUV', 'B03'),
('M06', 'A4', 2024, 42000.00, '4-door sedan', 'B04'),
('M07', 'Q7', 2025, 68000.00, 'SUV', 'B04'),
('M08', 'R8 Spyder', 2024, 165000.00, 'convertible', 'B04'),
('M09', 'Golf', 2024, 28000.00, 'wagon', 'B05'),
('M10', '911 Carrera', 2024, 125000.00, 'convertible', 'B06'),
('M11', 'Cayenne', 2025, 93000.00, 'SUV', 'B06'),
('M12', 'Continental GT', 2025, 240000.00, 'convertible', 'B07'),
('M13', 'Mustang', 2024, 38000.00, 'convertible', 'B08'),
('M14', 'Camry', 2024, 27000.00, '4-door sedan', 'B10'),
('M15', 'RX350', 2025, 59000.00, 'SUV', 'B11');

-- ====================================================================
-- 3. Options 데이터 입력 (15개)
-- ====================================================================
INSERT INTO Options (option_id, color, engine_type, transmission_type) VALUES
('OPT01', 'Black', '2.0L Turbo I4', 'Automatic'),
('OPT02', 'White', '3.0L V6 Turbo', 'Automatic'),
('OPT03', 'Red', '4.0L V8 Twin-Turbo', 'Dual-Clutch'),
('OPT04', 'Blue', 'Electric Motor', 'Single-Speed'),
('OPT05', 'Silver', '2.5L Hybrid', 'CVT'),
('OPT06', 'Gray', '1.5L Turbo I4', 'CVT'),
('OPT07', 'Yellow', '3.8L Flat-6 Twin-Turbo', 'Manual'),
('OPT08', 'Green', '3.0L Flat-6 Turbo', 'Dual-Clutch'),
('OPT09', 'Charcoal', '5.3L V8 EcoTec', 'Automatic'),
('OPT10', 'Midnight Black', '2.9L V6 Twin-Turbo', 'Automatic'),
('OPT11', 'San Marino Blue', '4.4L V8 Twin-Turbo', 'Automatic'),
('OPT12', 'Chalk White', '2.0L Hybrid', 'Automatic'),
('OPT13', 'Guards Red', '4.0L Flat-6 NA', 'Manual'),
('OPT14', 'Liquid Silver', '3.5L V6 Twin-Turbo', 'Automatic'),
('OPT15', 'Matte Gray', 'Electric Dual-Motor', 'Single-Speed');

-- ====================================================================
-- 4. Model_Options 데이터 입력 (18개)
-- ====================================================================
INSERT INTO Model_Options (model_id, option_id) VALUES
('M01', 'OPT01'), ('M01', 'OPT06'), ('M02', 'OPT09'), ('M03', 'OPT09'), 
('M04', 'OPT01'), ('M05', 'OPT09'), ('M06', 'OPT02'), ('M07', 'OPT02'), 
('M08', 'OPT03'), ('M09', 'OPT06'), ('M10', 'OPT07'), ('M10', 'OPT08'), 
('M11', 'OPT02'), ('M11', 'OPT10'), ('M12', 'OPT03'), ('M13', 'OPT01'), 
('M14', 'OPT05'), ('M15', 'OPT14');

-- ====================================================================
-- 5. Suppliers 데이터 입력 (15개)
-- ====================================================================
INSERT INTO Suppliers (supplier_id, name, contact_info) VALUES
('SUP01', 'Getrag', 'getrag@german.de'),
('SUP02', 'Bosch', 'bosch@tech.com'),
('SUP03', 'Denso', 'denso@japan.co.jp'),
('SUP04', 'Michelin', 'michelin@france.com'),
('SUP05', 'Continental', 'conti@germany.com'),
('SUP06', 'ZF Friedrichshafen', 'zf@transmission.com'),
('SUP07', 'Aisin Seiki', 'aisin@japan.com'),
('SUP08', 'Brembo', 'brembo@italy.com'),
('SUP09', 'Hankook Tire', 'hankook@korea.com'),
('SUP10', 'BorgWarner', 'borg@warner.com'),
('SUP11', 'Magna International', 'magna@canada.com'),
('SUP12', 'Valeo', 'valeo@france.com'),
('SUP13', 'Faurecia', 'faurecia@global.com'),
('SUP14', 'Mobis', 'mobis@korea.com'),
('SUP15', 'Akebono', 'akebono@braking.jp');

-- ====================================================================
-- 6. Plants 데이터 입력 (15개)
-- ====================================================================
INSERT INTO Plants (plant_id, name, location, supplier_id) VALUES
('P_GET01', 'Getrag Munich Plant', 'Munich, Germany', 'SUP01'),   
('P_GET02', 'Getrag Stuttgart Plant', 'Stuttgart, Germany', 'SUP01'), 
('P_BOS01', 'Bosch Stuttgart Component', 'Stuttgart, Germany', 'SUP02'),
('P_DEN01', 'Denso Nagoya Plant', 'Nagoya, Japan', 'SUP03'),
('P_MIC01', 'Michelin Clermont', 'Clermont, France', 'SUP04'),
('P_ZF01', 'ZF Saarbrucken Transmission', 'Saarbrucken, Germany', 'SUP06'),
('P_AIS01', 'Aisin Anjo Powertrain', 'Anjo, Japan', 'SUP07'),
('P_BOR01', 'BorgWarner Auburn Hills', 'Michigan, USA', 'SUP10'),
('P_MAG01', 'Magna Graz Assembly', 'Graz, Austria', 'SUP11'),
('P_MOB01', 'Mobis Ulsan Module', 'Ulsan, South Korea', 'SUP14'),
('P_ASY01', 'GM Michigan Assembly Plant', 'Michigan, USA', NULL),    
('P_ASY02', 'Audi Ingolstadt Main Line', 'Ingolstadt, Germany', NULL), 
('P_ASY03', 'Porsche Stuttgart-Zuffenhausen', 'Stuttgart, Germany', NULL), 
('P_ASY04', 'Ford Flat Rock Assembly', 'Michigan, USA', NULL),
('P_ASY05', 'Toyota Tsutsumi Plant', 'Aichi, Japan', NULL);

-- ====================================================================
-- 7. Supply_Contracts 데이터 입력 (15개)
-- ====================================================================
INSERT INTO Supply_Contracts (supplier_id, model_id, plant_id, part_type, supply_date) VALUES
('SUP01', 'M08', 'P_ASY02', 'transmission', '2024-02-10'), -- [수정 반영] P_GET01 -> P_ASY02
('SUP01', 'M10', 'P_ASY03', 'transmission', '2024-02-25'), -- [수정 반영] P_GET01 -> P_ASY03
('SUP01', 'M12', 'P_ASY03', 'transmission', '2024-03-05'), -- [수정 반영] P_GET01 -> P_ASY03
('SUP01', 'M01', 'P_GET02', 'transmission', '2024-04-01'), 
('SUP02', 'M01', 'P_BOS01', 'ECU', '2024-01-15'),
('SUP02', 'M03', 'P_BOS01', 'Fuel Injector', '2025-01-10'),
('SUP03', 'M14', 'P_DEN01', 'Alternator', '2024-02-20'),
('SUP03', 'M15', 'P_DEN01', 'Starter Motor', '2025-02-15'),
('SUP04', 'M02', 'P_MIC01', 'Tires', '2024-05-05'),
('SUP06', 'M04', 'P_ZF01', 'transmission', '2024-06-10'),
('SUP06', 'M06', 'P_ZF01', 'transmission', '2024-07-20'),
('SUP07', 'M14', 'P_AIS01', 'transmission', '2024-03-12'),
('SUP10', 'M13', 'P_BOR01', 'Turbocharger', '2024-04-18'),
('SUP11', 'M05', 'P_MAG01', 'Chassis Module', '2024-05-22'),
('SUP14', 'M07', 'P_MOB01', 'Brake Module', '2025-03-14');

-- ====================================================================
-- 8. Vehicles 데이터 입력 (19개)
-- ====================================================================
INSERT INTO Vehicles (vin, manufacturing_date, current_status, model_id, plant_id, option_id) VALUES
('1G1RC6E40FU100001', '2024-03-01', 'sold', 'M08', 'P_ASY02', 'OPT03'), 
('1G1RC6E40FU100002', '2024-03-12', 'sold', 'M10', 'P_ASY03', 'OPT07'), 
('1G1RC6E40FU100003', '2024-03-25', 'sold', 'M12', 'P_ASY03', 'OPT03'), 
('1G1RC6E40FU100004', '2024-04-20', 'sold', 'M01', 'P_ASY01', 'OPT01'), 
('1G1RC6E40FU100005', '2024-05-15', 'sold', 'M02', 'P_ASY01', 'OPT09'),
('1G1RC6E40FU100006', '2024-06-02', 'sold', 'M04', 'P_ASY01', 'OPT01'),
('1G1RC6E40FU100007', '2024-08-11', 'sold', 'M13', 'P_ASY04', 'OPT01'),
('1G1RC6E40FU100008', '2024-11-05', 'sold', 'M14', 'P_ASY05', 'OPT05'),
('1G1RC6E40FU100009', '2025-02-14', 'sold', 'M03', 'P_ASY01', 'OPT09'),
('1G1RC6E40FU100010', '2025-05-22', 'sold', 'M05', 'P_ASY01', 'OPT09'),
('1G1RC6E40FU100011', '2025-06-18', 'sold', 'M06', 'P_ASY02', 'OPT02'),
('1G1RC6E40FU100012', '2025-07-29', 'in inventory', 'M07', 'P_ASY02', 'OPT02'), 
('1G1RC6E40FU100013', '2025-09-02', 'sold', 'M10', 'P_ASY03', 'OPT08'),
('1G1RC6E40FU100014', '2025-10-12', 'sold', 'M11', 'P_ASY03', 'OPT10'),
('1G1RC6E40FU100015', '2025-12-20', 'in inventory', 'M15', 'P_ASY05', 'OPT14'),
('1G1RC6E40FU100016', '2026-02-10', 'sold', 'M14', 'P_ASY05', 'OPT05'),
('1G1RC6E40FU100017', '2026-04-05', 'in production', 'M09', 'P_ASY02', 'OPT06'),
('1G1RC6E40FU100021', '2024-05-10', 'sold', 'M08', 'P_ASY02', 'OPT03'), 
('1G1RC6E40FU100022', '2024-05-12', 'sold', 'M12', 'P_ASY03', 'OPT03'); 

-- ====================================================================
-- 9. Dealers 데이터 입력 (15개)
-- ====================================================================
INSERT INTO Dealers (dealer_id, name, address) VALUES
('D01', 'Luxury Motors NY', 'New York, USA'),
('D02', 'EuroCars Berlin', 'Berlin, Germany'),
('D03', 'Pacific Auto LA', 'Los Angeles, USA'),
('D04', 'Midwest Ford Chicago', 'Chicago, USA'),
('D05', 'Texas Trucks Houston', 'Houston, USA'),
('D06', 'Bavarian Auto Munich', 'Munich, Germany'),
('D07', 'Tokyo Premium Cars', 'Tokyo, Japan'),
('D08', 'Seoul Central Dealer', 'Seoul, South Korea'),
('D09', 'London Heritage Motors', 'London, UK'),
('D10', 'Paris Elite Autos', 'Paris, France'),
('D11', 'Silicon Valley EV Center', 'San Jose, USA'),
('D12', 'Metro Toronto Dealership', 'Toronto, Canada'),
('D13', 'Sydney Prestige Premium', 'Sydney, Australia'),
('D14', 'Dubai Luxury Wheels', 'Dubai, UAE'),
('D15', 'Shanghai Golden Gallop', 'Shanghai, China');

-- ====================================================================
-- 10. Customers 데이터 입력 (15개)
-- ====================================================================
INSERT INTO Customers (customer_id, name, address, phone, gender, annual_income) VALUES
('C01', 'John Smith', 'New York, USA', '555-0101', 'Male', 125000.00),
('C02', 'Alice Cooper', 'Los Angeles, USA', '555-0102', 'Female', 88000.00),
('C03', 'Bob Mueller', 'Berlin, Germany', '49-1234-56', 'Male', 62000.00),
('C04', 'Emma Watson', 'London, UK', '44-20-7946', 'Female', 280000.00),
('C05', 'David Kim', 'Seoul, South Korea', '82-10-1234', 'Male', 48000.00),
('C06', 'Sophia Loren', 'Rome, Italy', '39-06-6982', 'Female', 140000.00),
('C07', 'Michael Jordan', 'Chicago, USA', '555-2323', 'Male', 750000.00),
('C08', 'Clara Schumann', 'Frankfurt, Germany', '49-69-9876', 'Female', 54000.00),
('C09', 'Takeshi Sato', 'Tokyo, Japan', '81-3-5555', 'Male', 98000.00),
('C10', 'Elena Rostova', 'Moscow, Russia', '7-495-111', 'Female', 32000.00),
('C11', 'Carlos Santana', 'San Francisco, USA', '555-7777', 'Male', 195000.00),
('C12', 'Jean Dupont', 'Paris, France', '33-1-4227', 'Male', 71000.00),
('C13', 'Amelie Poulain', 'Paris, France', '33-1-8888', 'Female', 42000.00),
('C14', 'Fatima Al-Mansoor', 'Dubai, UAE', '971-4-333', 'Female', 410000.00),
('C15', 'Li Wei', 'Beijing, China', '86-10-6275', 'Male', 115000.00);

-- ====================================================================
-- 11. Sales 데이터 입력 (16개)
-- ====================================================================
INSERT INTO Sales (sale_id, date, payment_method, sale_price, vin, dealer_id, customer_id) VALUES
('S01', '2024-04-12', 'Financing', 170000.00, '1G1RC6E40FU100001', 'D01', 'C01'), 
('S02', '2024-04-28', 'Cash', 130000.00, '1G1RC6E40FU100002', 'D02', 'C04'),     
('S03', '2024-05-02', 'Financing', 245000.00, '1G1RC6E40FU100003', 'D06', 'C14'), 
('S04', '2024-05-18', 'Credit Card', 27000.00, '1G1RC6E40FU100004', 'D03', 'C02'),
('S05', '2024-06-20', 'Financing', 60000.00, '1G1RC6E40FU100005', 'D04', 'C07'),
('S06', '2024-07-11', 'Financing', 49000.00, '1G1RC6E40FU100006', 'D01', 'C11'),
('S07', '2024-09-01', 'Cash', 40000.00, '1G1RC6E40FU100007', 'D04', 'C03'),
('S08', '2024-12-15', 'Credit Card', 28500.00, '1G1RC6E40FU100008', 'D07', 'C09'),
('S09', '2025-03-10', 'Financing', 85000.00, '1G1RC6E40FU100009', 'D05', 'C15'),
('S10', '2025-05-22', 'Cash', 63000.00, '1G1RC6E40FU100010', 'D05', 'C08'),
('S11', '2025-07-04', 'Credit Card', 44000.00, '1G1RC6E40FU100011', 'D02', 'C12'),
('S12', '2025-10-02', 'Financing', 128000.00, '1G1RC6E40FU100013', 'D09', 'C06'),
('S13', '2025-11-20', 'Financing', 96000.00, '1G1RC6E40FU100014', 'D03', 'C13'),
('S14', '2026-03-15', 'Cash', 28000.00, '1G1RC6E40FU100016', 'D07', 'C10'),
('S15', '2024-06-15', 'Credit Card', 132000.00, '1G1RC6E40FU100021', 'D01', 'C01'), 
('S16', '2025-06-22', 'Bank Transfer', 245000.00, '1G1RC6E40FU100022', 'D02', 'C04');