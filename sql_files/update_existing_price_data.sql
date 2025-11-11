-- Update existing price data in packages and sub_packages tables
-- Run this if you need to update the price values

-- Update packages with sample prices
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

-- Update sub_packages with sample prices
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

-- Verify the updates
SELECT 'PACKAGES:' as TableName;
SELECT id, package_name, price FROM packages ORDER BY id;

SELECT 'SUB_PACKAGES:' as TableName;
SELECT id, sub_package_name, price FROM sub_packages ORDER BY id;
