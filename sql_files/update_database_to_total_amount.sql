-- Comprehensive script to update database from price to total_amount
-- This script handles both packages and sub_packages tables

-- =============================================
-- UPDATE PACKAGES TABLE
-- =============================================

-- Check if price column exists in packages table
IF EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'packages' AND COLUMN_NAME = 'price'
)
BEGIN
    PRINT 'price column exists in packages table';
    
    -- Add total_amount column if it doesn't exist
    IF NOT EXISTS (
        SELECT * FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = 'packages' AND COLUMN_NAME = 'total_amount'
    )
    BEGIN
        ALTER TABLE packages
        ADD total_amount DECIMAL(10,2) DEFAULT 0.00;
        PRINT 'total_amount column added to packages table';
    END
    
    -- Copy data from price to total_amount
    UPDATE packages
    SET total_amount = price
    WHERE total_amount IS NULL OR total_amount = 0;
    PRINT 'Data copied from price to total_amount in packages table';
    
    -- Show sample data
    SELECT id, package_name, category, duration, price, total_amount 
    FROM packages 
    ORDER BY id;
END
ELSE
BEGIN
    PRINT 'price column does NOT exist in packages table';
    
    -- Add total_amount column if it doesn't exist
    IF NOT EXISTS (
        SELECT * FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = 'packages' AND COLUMN_NAME = 'total_amount'
    )
    BEGIN
        ALTER TABLE packages
        ADD total_amount DECIMAL(10,2) DEFAULT 0.00;
        PRINT 'total_amount column added to packages table';
        
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
        PRINT 'Sample total_amount values set in packages table';
    END
    
    -- Show sample data
    SELECT id, package_name, category, duration, total_amount 
    FROM packages 
    ORDER BY id;
END

-- =============================================
-- UPDATE SUB_PACKAGES TABLE
-- =============================================

-- Check if price column exists in sub_packages table
IF EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'sub_packages' AND COLUMN_NAME = 'price'
)
BEGIN
    PRINT 'price column exists in sub_packages table';
    
    -- Add total_amount column if it doesn't exist
    IF NOT EXISTS (
        SELECT * FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = 'sub_packages' AND COLUMN_NAME = 'total_amount'
    )
    BEGIN
        ALTER TABLE sub_packages
        ADD total_amount DECIMAL(10,2) DEFAULT 0.00;
        PRINT 'total_amount column added to sub_packages table';
    END
    
    -- Copy data from price to total_amount
    UPDATE sub_packages
    SET total_amount = price
    WHERE total_amount IS NULL OR total_amount = 0;
    PRINT 'Data copied from price to total_amount in sub_packages table';
    
    -- Show sample data
    SELECT id, package_id, sub_package_name, price, total_amount 
    FROM sub_packages 
    ORDER BY id;
END
ELSE
BEGIN
    PRINT 'price column does NOT exist in sub_packages table';
    
    -- Add total_amount column if it doesn't exist
    IF NOT EXISTS (
        SELECT * FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = 'sub_packages' AND COLUMN_NAME = 'total_amount'
    )
    BEGIN
        ALTER TABLE sub_packages
        ADD total_amount DECIMAL(10,2) DEFAULT 0.00;
        PRINT 'total_amount column added to sub_packages table';
        
        -- Set sample values
        UPDATE sub_packages
        SET total_amount = CASE
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
            ELSE 500.00
        END
        WHERE total_amount IS NULL OR total_amount = 0;
        PRINT 'Sample total_amount values set in sub_packages table';
    END
    
    -- Show sample data
    SELECT id, package_id, sub_package_name, total_amount 
    FROM sub_packages 
    ORDER BY id;
END

-- =============================================
-- FINAL VERIFICATION
-- =============================================

PRINT '=== FINAL TABLE STRUCTURES ===';

-- Show packages table structure
SELECT 'PACKAGES TABLE:' as TableName;
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'packages'
ORDER BY ORDINAL_POSITION;

-- Show sub_packages table structure
SELECT 'SUB_PACKAGES TABLE:' as TableName;
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'sub_packages'
ORDER BY ORDINAL_POSITION;

PRINT '=== DATABASE UPDATE COMPLETE ===';
