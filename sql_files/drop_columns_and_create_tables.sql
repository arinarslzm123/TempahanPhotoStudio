-- Drop Columns and Create Tables (without description, image_url, price)
-- This script will drop specified columns and create clean table structure

PRINT '=== DROPPING COLUMNS AND CREATING TABLES ===';

-- Step 1: Drop specified columns from existing tables
PRINT '--- Step 1: Dropping specified columns ---';

-- Drop 'description' column from packages table
IF EXISTS (SELECT * FROM sys.columns WHERE Name = N'description' AND Object_ID = Object_ID(N'packages'))
BEGIN
    ALTER TABLE packages DROP COLUMN description;
    PRINT 'Column "description" dropped from "packages" table.';
END
ELSE
BEGIN
    PRINT 'Column "description" does not exist in "packages" table, skipping.';
END;

-- Drop 'image_url' column from packages table
IF EXISTS (SELECT * FROM sys.columns WHERE Name = N'image_url' AND Object_ID = Object_ID(N'packages'))
BEGIN
    ALTER TABLE packages DROP COLUMN image_url;
    PRINT 'Column "image_url" dropped from "packages" table.';
END
ELSE
BEGIN
    PRINT 'Column "image_url" does not exist in "packages" table, skipping.';
END;

-- Drop 'price' column from packages table
IF EXISTS (SELECT * FROM sys.columns WHERE Name = N'price' AND Object_ID = Object_ID(N'packages'))
BEGIN
    ALTER TABLE packages DROP COLUMN price;
    PRINT 'Column "price" dropped from "packages" table.';
END
ELSE
BEGIN
    PRINT 'Column "price" does not exist in "packages" table, skipping.';
END;

-- Drop 'price' column from sub_packages table
IF EXISTS (SELECT * FROM sys.columns WHERE Name = N'price' AND Object_ID = Object_ID(N'sub_packages'))
BEGIN
    ALTER TABLE sub_packages DROP COLUMN price;
    PRINT 'Column "price" dropped from "sub_packages" table.';
END
ELSE
BEGIN
    PRINT 'Column "price" does not exist in "sub_packages" table, skipping.';
END;

PRINT 'Column dropping completed';

-- Step 2: Show current table structure
PRINT '--- Step 2: Current table structure ---';

PRINT 'PACKAGES TABLE STRUCTURE:';
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'packages'
ORDER BY ORDINAL_POSITION;

PRINT 'SUB_PACKAGES TABLE STRUCTURE:';
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'sub_packages'
ORDER BY ORDINAL_POSITION;

PRINT '=== COLUMN DROPPING COMPLETE ===';
