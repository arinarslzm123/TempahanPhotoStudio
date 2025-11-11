-- Add price columns to packages and sub_packages tables
-- This script will fix the "Invalid column name price" error

PRINT '=== ADDING PRICE COLUMNS TO DATABASE ===';

-- =============================================
-- ADD PRICE COLUMN TO PACKAGES TABLE
-- =============================================
PRINT '--- Adding price column to packages table ---';

-- Check if price column already exists in packages table
IF EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'packages' AND COLUMN_NAME = 'price'
)
BEGIN
    PRINT '✅ price column already exists in packages table';
END
ELSE
BEGIN
    -- Add price column to packages table
    ALTER TABLE packages
    ADD price DECIMAL(10,2) DEFAULT 0.00;
    
    PRINT '✅ price column added to packages table';
END

-- =============================================
-- ADD PRICE COLUMN TO SUB_PACKAGES TABLE
-- =============================================
PRINT '--- Adding price column to sub_packages table ---';

-- Check if price column already exists in sub_packages table
IF EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'sub_packages' AND COLUMN_NAME = 'price'
)
BEGIN
    PRINT '✅ price column already exists in sub_packages table';
END
ELSE
BEGIN
    -- Add price column to sub_packages table
    ALTER TABLE sub_packages
    ADD price DECIMAL(10,2) DEFAULT 0.00;
    
    PRINT '✅ price column added to sub_packages table';
END

-- =============================================
-- UPDATE EXISTING DATA WITH SAMPLE PRICES
-- =============================================
PRINT '--- Updating existing data with sample prices ---';

-- Update packages with sample prices
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
    WHEN id = 13 THEN 2600.00
    WHEN id = 14 THEN 2900.00
    WHEN id = 15 THEN 3200.00
    ELSE 1000.00
END
WHERE price IS NULL OR price = 0;

-- Update sub_packages with sample prices
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

-- =============================================
-- ADD PHOTOGRAPHY PACKAGES IF MISSING
-- =============================================
PRINT '--- Adding Photography packages if missing ---';

-- Check if Photography packages exist
IF NOT EXISTS (SELECT 1 FROM packages WHERE category = 'Photography')
BEGIN
    PRINT 'Adding Photography packages...';
    
    INSERT INTO packages (package_name, category, duration, price, description) VALUES
    ('Basic Photography Package', 'Photography', '2 hours', 800.00, 'Basic photography session with 50 edited photos'),
    ('Standard Photography Package', 'Photography', '3 hours', 1200.00, 'Standard photography session with 100 edited photos'),
    ('Premium Photography Package', 'Photography', '4 hours', 1800.00, 'Premium photography session with 150 edited photos'),
    ('Wedding Photography Package', 'Photography', '8 hours', 3000.00, 'Full wedding photography coverage with 300+ edited photos'),
    ('Event Photography Package', 'Photography', '6 hours', 2200.00, 'Event photography coverage with 200+ edited photos'),
    ('Portrait Photography Package', 'Photography', '1 hour', 500.00, 'Professional portrait session with 20 edited photos'),
    ('Family Photography Package', 'Photography', '2 hours', 1000.00, 'Family photography session with 80 edited photos'),
    ('Corporate Photography Package', 'Photography', '4 hours', 1500.00, 'Corporate event photography with 120 edited photos');
    
    PRINT '✅ Photography packages added successfully!';
END
ELSE
BEGIN
    PRINT '✅ Photography packages already exist';
END

-- =============================================
-- VERIFICATION
-- =============================================
PRINT '--- Final verification ---';

-- Check packages table structure
SELECT 'PACKAGES TABLE STRUCTURE:' as Info;
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'packages'
ORDER BY ORDINAL_POSITION;

-- Check sub_packages table structure
SELECT 'SUB_PACKAGES TABLE STRUCTURE:' as Info;
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'sub_packages'
ORDER BY ORDINAL_POSITION;

-- Show sample data
SELECT 'SAMPLE PACKAGES DATA:' as Info;
SELECT TOP 10 id, package_name, category, duration, price 
FROM packages 
ORDER BY id;

SELECT 'SAMPLE SUB_PACKAGES DATA:' as Info;
SELECT TOP 10 id, package_id, sub_package_name, price 
FROM sub_packages 
ORDER BY id;

-- Show Photography packages
SELECT 'PHOTOGRAPHY PACKAGES:' as Info;
SELECT id, package_name, category, duration, price 
FROM packages 
WHERE category = 'Photography'
ORDER BY id;

-- Summary
SELECT 'SUMMARY:' as Info;
SELECT 
    (SELECT COUNT(*) FROM packages WHERE price > 0) as packages_with_price,
    (SELECT COUNT(*) FROM sub_packages WHERE price > 0) as sub_packages_with_price,
    (SELECT COUNT(*) FROM packages WHERE category = 'Photography') as photography_packages;

PRINT '=== PRICE COLUMNS ADDED SUCCESSFULLY ===';
