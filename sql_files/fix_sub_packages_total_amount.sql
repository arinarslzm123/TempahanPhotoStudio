-- Fix sub_packages table to add total_amount column and populate data
-- This script specifically targets the sub_packages table

PRINT '=== FIXING SUB_PACKAGES TABLE ===';

-- Check current structure of sub_packages table
PRINT '--- Current sub_packages table structure ---';
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'sub_packages'
ORDER BY ORDINAL_POSITION;

-- Check if total_amount column exists
IF EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'sub_packages' AND COLUMN_NAME = 'total_amount'
)
BEGIN
    PRINT '✅ total_amount column already exists in sub_packages table';
    
    -- Check current data
    SELECT COUNT(*) as total_records, 
           COUNT(CASE WHEN total_amount > 0 THEN 1 END) as records_with_amount
    FROM sub_packages;
    
    -- Show current data
    SELECT id, package_id, sub_package_name, total_amount 
    FROM sub_packages 
    ORDER BY id;
END
ELSE
BEGIN
    PRINT '❌ total_amount column does NOT exist in sub_packages table';
    
    -- Add total_amount column
    ALTER TABLE sub_packages
    ADD total_amount DECIMAL(10,2) DEFAULT 0.00;
    
    PRINT '✅ total_amount column added to sub_packages table';
    
    -- Check if price column exists to copy data
    IF EXISTS (
        SELECT * FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = 'sub_packages' AND COLUMN_NAME = 'price'
    )
    BEGIN
        PRINT '📋 Copying data from price column to total_amount column';
        UPDATE sub_packages
        SET total_amount = price
        WHERE price IS NOT NULL AND price > 0;
        
        PRINT '✅ Data copied from price to total_amount';
    END
    ELSE
    BEGIN
        PRINT '⚠️  No price column found, setting sample values';
        
        -- Set sample values based on sub_package_name patterns
        UPDATE sub_packages
        SET total_amount = CASE
            WHEN sub_package_name LIKE '%Basic%' OR sub_package_name LIKE '%Regular%' THEN 800.00
            WHEN sub_package_name LIKE '%Premium%' OR sub_package_name LIKE '%Standard%' THEN 1200.00
            WHEN sub_package_name LIKE '%Exclusive%' OR sub_package_name LIKE '%Deluxe%' THEN 1800.00
            WHEN sub_package_name LIKE '%Luxury%' OR sub_package_name LIKE '%VIP%' THEN 2500.00
            WHEN sub_package_name LIKE '%Wedding%' THEN 3000.00
            WHEN sub_package_name LIKE '%Event%' THEN 2000.00
            WHEN sub_package_name LIKE '%Portrait%' THEN 500.00
            WHEN sub_package_name LIKE '%Family%' THEN 1000.00
            WHEN sub_package_name LIKE '%Corporate%' THEN 1500.00
            ELSE 1000.00
        END
        WHERE total_amount IS NULL OR total_amount = 0;
        
        PRINT '✅ Sample values set for total_amount';
    END
    
    -- Show updated data
    SELECT id, package_id, sub_package_name, total_amount 
    FROM sub_packages 
    ORDER BY id;
END

-- Final verification
PRINT '--- Final verification ---';
SELECT COUNT(*) as total_records, 
       COUNT(CASE WHEN total_amount > 0 THEN 1 END) as records_with_amount,
       MIN(total_amount) as min_amount,
       MAX(total_amount) as max_amount,
       AVG(total_amount) as avg_amount
FROM sub_packages;

-- Show sample data
SELECT TOP 10 id, package_id, sub_package_name, total_amount 
FROM sub_packages 
ORDER BY id;

PRINT '=== SUB_PACKAGES TABLE FIX COMPLETE ===';
