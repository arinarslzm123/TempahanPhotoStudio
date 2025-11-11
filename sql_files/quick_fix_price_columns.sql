-- Quick fix for "Invalid column name price" error
-- Run these commands one by one

-- 1. Add price column to packages table
ALTER TABLE packages ADD price DECIMAL(10,2) DEFAULT 0.00;

-- 2. Add price column to sub_packages table
ALTER TABLE sub_packages ADD price DECIMAL(10,2) DEFAULT 0.00;

-- 3. Update packages with sample prices
UPDATE packages SET price = 1200.00 WHERE id = 1;
UPDATE packages SET price = 1500.00 WHERE id = 2;
UPDATE packages SET price = 1800.00 WHERE id = 3;
UPDATE packages SET price = 2000.00 WHERE id = 4;
UPDATE packages SET price = 2200.00 WHERE id = 5;
UPDATE packages SET price = 2500.00 WHERE id = 6;
UPDATE packages SET price = 2800.00 WHERE id = 7;
UPDATE packages SET price = 3000.00 WHERE id = 8;
UPDATE packages SET price = 1200.00 WHERE id = 9;
UPDATE packages SET price = 1600.00 WHERE id = 10;

-- 4. Update sub_packages with sample prices
UPDATE sub_packages SET price = 800.00 WHERE id = 1;
UPDATE sub_packages SET price = 1000.00 WHERE id = 2;
UPDATE sub_packages SET price = 1200.00 WHERE id = 3;
UPDATE sub_packages SET price = 1500.00 WHERE id = 4;
UPDATE sub_packages SET price = 1800.00 WHERE id = 5;
UPDATE sub_packages SET price = 2000.00 WHERE id = 6;
UPDATE sub_packages SET price = 2200.00 WHERE id = 7;
UPDATE sub_packages SET price = 2500.00 WHERE id = 8;
UPDATE sub_packages SET price = 2800.00 WHERE id = 9;
UPDATE sub_packages SET price = 3000.00 WHERE id = 10;

-- 5. Add Photography packages
INSERT INTO packages (package_name, category, duration, price, description) VALUES
('Basic Photography Package', 'Photography', '2 hours', 800.00, 'Basic photography session with 50 edited photos'),
('Standard Photography Package', 'Photography', '3 hours', 1200.00, 'Standard photography session with 100 edited photos'),
('Premium Photography Package', 'Photography', '4 hours', 1800.00, 'Premium photography session with 150 edited photos'),
('Wedding Photography Package', 'Photography', '8 hours', 3000.00, 'Full wedding photography coverage with 300+ edited photos'),
('Event Photography Package', 'Photography', '6 hours', 2200.00, 'Event photography coverage with 200+ edited photos'),
('Portrait Photography Package', 'Photography', '1 hour', 500.00, 'Professional portrait session with 20 edited photos'),
('Family Photography Package', 'Photography', '2 hours', 1000.00, 'Family photography session with 80 edited photos'),
('Corporate Photography Package', 'Photography', '4 hours', 1500.00, 'Corporate event photography with 120 edited photos');

-- 6. Verify the fix
SELECT 'PACKAGES WITH PRICE:' as Info;
SELECT id, package_name, category, price FROM packages ORDER BY id;

SELECT 'SUB_PACKAGES WITH PRICE:' as Info;
SELECT id, sub_package_name, price FROM sub_packages ORDER BY id;

SELECT 'PHOTOGRAPHY PACKAGES:' as Info;
SELECT id, package_name, category, price FROM packages WHERE category = 'Photography' ORDER BY id;
