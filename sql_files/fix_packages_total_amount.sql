-- Fix packages table to add total_amount column and populate data
-- This script specifically targets the packages table

PRINT '=== FIXING PACKAGES TABLE ===';

-- Check current structure of packages table
PRINT '--- Current packages table structure ---';
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'packages'
ORDER BY ORDINAL_POSITION;

-- Check if total_amount column exists
IF EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'packages' AND COLUMN_NAME = 'total_amount'
)
BEGIN
    PRINT '✅ total_amount column already exists in packages table';
    
    -- Check current data
    SELECT COUNT(*) as total_records, 
           COUNT(CASE WHEN total_amount > 0 THEN 1 END) as records_with_amount
    FROM packages;
    
    -- Show current data
    SELECT id, package_name, category, duration, total_amount 
    FROM packages 
    ORDER BY id;
END
ELSE
BEGIN
    PRINT '❌ total_amount column does NOT exist in packages table';
    
    -- Add total_amount column
    ALTER TABLE packages
    ADD total_amount DECIMAL(10,2) DEFAULT 0.00;
    
    PRINT '✅ total_amount column added to packages table';
    
    -- Check if price column exists to copy data
    IF EXISTS (
        SELECT * FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = 'packages' AND COLUMN_NAME = 'price'
    )
    BEGIN
        PRINT '📋 Copying data from price column to total_amount column';
        UPDATE packages
        SET total_amount = price
        WHERE price IS NOT NULL AND price > 0;
        
        PRINT '✅ Data copied from price to total_amount';
    END
    ELSE
    BEGIN
        PRINT '⚠️  No price column found, setting sample values';
        
        -- Set sample values based on package category and name
        UPDATE packages
        SET total_amount = CASE
            WHEN category LIKE '%Wedding%' THEN 3000.00
            WHEN category LIKE '%Event%' THEN 2000.00
            WHEN category LIKE '%Portrait%' THEN 800.00
            WHEN category LIKE '%Family%' THEN 1200.00
            WHEN category LIKE '%Corporate%' THEN 1800.00
            WHEN category LIKE '%Photography%' THEN 1500.00
            WHEN category LIKE '%Videography%' THEN 2500.00
            WHEN package_name LIKE '%Basic%' THEN 1000.00
            WHEN package_name LIKE '%Premium%' THEN 2000.00
            WHEN package_name LIKE '%Deluxe%' THEN 3000.00
            ELSE 1500.00
        END
        WHERE total_amount IS NULL OR total_amount = 0;
        
        PRINT '✅ Sample values set for total_amount';
    END
    
    -- Show updated data
    SELECT id, package_name, category, duration, total_amount 
    FROM packages 
    ORDER BY id;
END

-- Final verification
PRINT '--- Final verification ---';
SELECT COUNT(*) as total_records, 
       COUNT(CASE WHEN total_amount > 0 THEN 1 END) as records_with_amount,
       MIN(total_amount) as min_amount,
       MAX(total_amount) as max_amount,
       AVG(total_amount) as avg_amount
FROM packages;

-- Show sample data
SELECT TOP 10 id, package_name, category, duration, total_amount 
FROM packages 
ORDER BY id;

PRINT '=== PACKAGES TABLE FIX COMPLETE ===';
