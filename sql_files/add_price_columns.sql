-- SQL Queries to add price columns to packages and sub_packages tables
-- Run these queries in your SQL Server Management Studio

-- =============================================
-- ADD PRICE COLUMN TO PACKAGES TABLE
-- =============================================

-- Check if price column already exists in packages table
IF EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'packages' AND COLUMN_NAME = 'price'
)
BEGIN
    PRINT 'price column already exists in packages table';
END
ELSE
BEGIN
    -- Add price column to packages table
    ALTER TABLE packages
    ADD price DECIMAL(10,2) DEFAULT 0.00;
    
    PRINT 'price column added successfully to packages table';
END

-- Update existing packages with sample prices
UPDATE packages
SET price = CASE
    WHEN id = 1 THEN 1200.00
    WHEN id = 2 THEN 1500.00
    WHEN id = 3 THEN 1800.00
    WHEN id = 4 THEN 2000.00
    WHEN id = 5 THEN 2200.00
    WHEN id = 6 THEN 2500.00
    WHEN id = 7 THEN 2800.00
    WHEN id = 8 THEN 3000.00
    WHEN id = 9 THEN 1200.00
    WHEN id = 10 THEN 1600.00
    WHEN id = 11 THEN 1900.00
    WHEN id = 12 THEN 2300.00
    ELSE 1000.00
END
WHERE price IS NULL OR price = 0;

-- Show updated packages data
SELECT id, package_name, category, duration, price 
FROM packages 
ORDER BY id;

-- =============================================
-- ADD PRICE COLUMN TO SUB_PACKAGES TABLE
-- =============================================

-- Check if price column already exists in sub_packages table
IF EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'sub_packages' AND COLUMN_NAME = 'price'
)
BEGIN
    PRINT 'price column already exists in sub_packages table';
END
ELSE
BEGIN
    -- Add price column to sub_packages table
    ALTER TABLE sub_packages
    ADD price DECIMAL(10,2) DEFAULT 0.00;
    
    PRINT 'price column added successfully to sub_packages table';
END

-- Update existing sub_packages with sample prices
UPDATE sub_packages
SET price = CASE
    WHEN id = 1 THEN 800.00
    WHEN id = 2 THEN 1000.00
    WHEN id = 3 THEN 1200.00
    WHEN id = 4 THEN 1500.00
    WHEN id = 5 THEN 1800.00
    WHEN id = 6 THEN 2000.00
    WHEN id = 7 THEN 2200.00
    WHEN id = 8 THEN 2500.00
    WHEN id = 9 THEN 2800.00
    WHEN id = 10 THEN 3000.00
    WHEN id = 11 THEN 900.00
    WHEN id = 12 THEN 1100.00
    WHEN id = 13 THEN 1300.00
    WHEN id = 14 THEN 1600.00
    WHEN id = 15 THEN 1900.00
    WHEN id = 16 THEN 2100.00
    WHEN id = 17 THEN 2400.00
    WHEN id = 18 THEN 2700.00
    WHEN id = 19 THEN 3200.00
    WHEN id = 20 THEN 3500.00
    ELSE 500.00
END
WHERE price IS NULL OR price = 0;

-- Show updated sub_packages data
SELECT id, package_id, sub_package_name, price 
FROM sub_packages 
ORDER BY id;

-- =============================================
-- VERIFICATION
-- =============================================

-- Check packages table structure
SELECT 'PACKAGES TABLE STRUCTURE:' as TableInfo;
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'packages'
ORDER BY ORDINAL_POSITION;

-- Check sub_packages table structure
SELECT 'SUB_PACKAGES TABLE STRUCTURE:' as TableInfo;
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'sub_packages'
ORDER BY ORDINAL_POSITION;

-- Summary
SELECT 'SUMMARY:' as Info;
SELECT 
    (SELECT COUNT(*) FROM packages WHERE price > 0) as packages_with_price,
    (SELECT COUNT(*) FROM sub_packages WHERE price > 0) as sub_packages_with_price;

PRINT 'Price columns added successfully to both tables!';
