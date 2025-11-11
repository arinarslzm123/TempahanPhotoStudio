-- Test script to verify database columns and data
-- Run this to check if total_amount columns exist and have data

PRINT '=== TESTING DATABASE COLUMNS ===';

-- Test packages table
PRINT '--- PACKAGES TABLE ---';
IF EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'packages' AND COLUMN_NAME = 'total_amount'
)
BEGIN
    PRINT '✅ total_amount column EXISTS in packages table';
    
    -- Check if there's data
    DECLARE @packageCount INT;
    SELECT @packageCount = COUNT(*) FROM packages WHERE total_amount > 0;
    PRINT '📊 Packages with total_amount > 0: ' + CAST(@packageCount AS VARCHAR(10));
    
    -- Show sample data
    SELECT TOP 5 id, package_name, category, duration, total_amount 
    FROM packages 
    ORDER BY id;
END
ELSE
BEGIN
    PRINT '❌ total_amount column does NOT exist in packages table';
    
    -- Check if price column exists
    IF EXISTS (
        SELECT * FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = 'packages' AND COLUMN_NAME = 'price'
    )
    BEGIN
        PRINT '⚠️  price column exists - need to migrate to total_amount';
        SELECT TOP 5 id, package_name, category, duration, price 
        FROM packages 
        ORDER BY id;
    END
    ELSE
    BEGIN
        PRINT '❌ Neither total_amount nor price column exists in packages table';
    END
END

-- Test sub_packages table
PRINT '--- SUB_PACKAGES TABLE ---';
IF EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'sub_packages' AND COLUMN_NAME = 'total_amount'
)
BEGIN
    PRINT '✅ total_amount column EXISTS in sub_packages table';
    
    -- Check if there's data
    DECLARE @subPackageCount INT;
    SELECT @subPackageCount = COUNT(*) FROM sub_packages WHERE total_amount > 0;
    PRINT '📊 Sub-packages with total_amount > 0: ' + CAST(@subPackageCount AS VARCHAR(10));
    
    -- Show sample data
    SELECT TOP 5 id, package_id, sub_package_name, total_amount 
    FROM sub_packages 
    ORDER BY id;
END
ELSE
BEGIN
    PRINT '❌ total_amount column does NOT exist in sub_packages table';
    
    -- Check if price column exists
    IF EXISTS (
        SELECT * FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = 'sub_packages' AND COLUMN_NAME = 'price'
    )
    BEGIN
        PRINT '⚠️  price column exists - need to migrate to total_amount';
        SELECT TOP 5 id, package_id, sub_package_name, price 
        FROM sub_packages 
        ORDER BY id;
    END
    ELSE
    BEGIN
        PRINT '❌ Neither total_amount nor price column exists in sub_packages table';
    END
END

-- Test bookings table (for reference)
PRINT '--- BOOKINGS TABLE ---';
IF EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'bookings' AND COLUMN_NAME = 'total_amount'
)
BEGIN
    PRINT '✅ total_amount column EXISTS in bookings table';
    
    -- Check if there's data
    DECLARE @bookingCount INT;
    SELECT @bookingCount = COUNT(*) FROM bookings WHERE total_amount > 0;
    PRINT '📊 Bookings with total_amount > 0: ' + CAST(@bookingCount AS VARCHAR(10));
END
ELSE
BEGIN
    PRINT '❌ total_amount column does NOT exist in bookings table';
END

PRINT '=== TEST COMPLETE ===';
