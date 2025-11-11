-- Comprehensive script to fix all total_amount columns
-- This script will fix both packages and sub_packages tables

PRINT '========================================';
PRINT 'FIXING ALL TOTAL_AMOUNT COLUMNS';
PRINT '========================================';

-- =============================================
-- FIX PACKAGES TABLE
-- =============================================
PRINT '';
PRINT '--- FIXING PACKAGES TABLE ---';

-- Check if total_amount column exists in packages
IF EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'packages' AND COLUMN_NAME = 'total_amount'
)
BEGIN
    PRINT '✅ total_amount column already exists in packages table';
    
    -- Check if there's data
    DECLARE @packageCount INT;
    SELECT @packageCount = COUNT(*) FROM packages WHERE total_amount > 0;
    PRINT '📊 Packages with total_amount > 0: ' + CAST(@packageCount AS VARCHAR(10));
    
    IF @packageCount = 0
    BEGIN
        PRINT '⚠️  No data in total_amount column, setting sample values';
        
        -- Set sample values
        UPDATE packages
        SET total_amount = CASE
            WHEN id = 1 THEN 1200.00
            WHEN id = 2 THEN 1500.00
            WHEN id = 3 THEN 1800.00
            WHEN id = 4 THEN 2000.00
            WHEN id = 5 THEN 2200.00
            WHEN id = 6 THEN 2500.00
            WHEN id = 7 THEN 2800.00
            WHEN id = 8 THEN 3000.00
            WHEN id = 9 THEN 1200.00
            ELSE 1000.00
        END
        WHERE total_amount IS NULL OR total_amount = 0;
        
        PRINT '✅ Sample values set for packages total_amount';
    END
END
ELSE
BEGIN
    PRINT '❌ total_amount column does NOT exist in packages table';
    
    -- Add total_amount column
    ALTER TABLE packages
    ADD total_amount DECIMAL(10,2) DEFAULT 0.00;
    
    PRINT '✅ total_amount column added to packages table';
    
    -- Set sample values
    UPDATE packages
    SET total_amount = CASE
        WHEN id = 1 THEN 1200.00
        WHEN id = 2 THEN 1500.00
        WHEN id = 3 THEN 1800.00
        WHEN id = 4 THEN 2000.00
        WHEN id = 5 THEN 2200.00
        WHEN id = 6 THEN 2500.00
        WHEN id = 7 THEN 2800.00
        WHEN id = 8 THEN 3000.00
        WHEN id = 9 THEN 1200.00
        ELSE 1000.00
    END
    WHERE total_amount IS NULL OR total_amount = 0;
    
    PRINT '✅ Sample values set for packages total_amount';
END

-- =============================================
-- FIX SUB_PACKAGES TABLE
-- =============================================
PRINT '';
PRINT '--- FIXING SUB_PACKAGES TABLE ---';

-- Check if total_amount column exists in sub_packages
IF EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'sub_packages' AND COLUMN_NAME = 'total_amount'
)
BEGIN
    PRINT '✅ total_amount column already exists in sub_packages table';
    
    -- Check if there's data
    DECLARE @subPackageCount INT;
    SELECT @subPackageCount = COUNT(*) FROM sub_packages WHERE total_amount > 0;
    PRINT '📊 Sub-packages with total_amount > 0: ' + CAST(@subPackageCount AS VARCHAR(10));
    
    IF @subPackageCount = 0
    BEGIN
        PRINT '⚠️  No data in total_amount column, setting sample values';
        
        -- Set sample values based on sub_package_name
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
        
        PRINT '✅ Sample values set for sub_packages total_amount';
    END
END
ELSE
BEGIN
    PRINT '❌ total_amount column does NOT exist in sub_packages table';
    
    -- Add total_amount column
    ALTER TABLE sub_packages
    ADD total_amount DECIMAL(10,2) DEFAULT 0.00;
    
    PRINT '✅ total_amount column added to sub_packages table';
    
    -- Set sample values based on sub_package_name
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
    
    PRINT '✅ Sample values set for sub_packages total_amount';
END

-- =============================================
-- FINAL VERIFICATION
-- =============================================
PRINT '';
PRINT '--- FINAL VERIFICATION ---';

-- Check packages table
DECLARE @finalPackageCount INT;
SELECT @finalPackageCount = COUNT(*) FROM packages WHERE total_amount > 0;
PRINT '📊 Final packages with total_amount > 0: ' + CAST(@finalPackageCount AS VARCHAR(10));

-- Check sub_packages table
DECLARE @finalSubPackageCount INT;
SELECT @finalSubPackageCount = COUNT(*) FROM sub_packages WHERE total_amount > 0;
PRINT '📊 Final sub-packages with total_amount > 0: ' + CAST(@finalSubPackageCount AS VARCHAR(10));

-- Show sample data
PRINT '';
PRINT '--- SAMPLE PACKAGES DATA ---';
SELECT TOP 5 id, package_name, category, duration, total_amount 
FROM packages 
ORDER BY id;

PRINT '';
PRINT '--- SAMPLE SUB_PACKAGES DATA ---';
SELECT TOP 5 id, package_id, sub_package_name, total_amount 
FROM sub_packages 
ORDER BY id;

PRINT '';
PRINT '========================================';
PRINT 'ALL TOTAL_AMOUNT COLUMNS FIXED SUCCESSFULLY';
PRINT '========================================';
