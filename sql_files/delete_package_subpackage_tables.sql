-- Delete Package and Sub-Package Tables
-- WARNING: This will permanently delete all data in packages and sub_packages tables

PRINT '=== DELETING PACKAGE AND SUB-PACKAGE TABLES ===';

-- Step 1: Check current data before deletion
PRINT '--- Step 1: Current data count ---';

SELECT 
    'packages' as table_name,
    COUNT(*) as record_count
FROM packages
UNION ALL
SELECT 
    'sub_packages' as table_name,
    COUNT(*) as record_count
FROM sub_packages;

-- Step 2: Show sample data before deletion
PRINT '--- Step 2: Sample data before deletion ---';

SELECT 'PACKAGES:' as Info;
SELECT TOP 5 
    id,
    package_name,
    event,
    category,
    price
FROM packages
ORDER BY id;

SELECT 'SUB-PACKAGES:' as Info;
SELECT TOP 5 
    id,
    package_id,
    sub_package_name,
    price
FROM sub_packages
ORDER BY id;

-- Step 3: Delete sub_packages table first (due to foreign key constraint)
PRINT '--- Step 3: Deleting sub_packages table ---';

-- Check if table exists
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'sub_packages')
BEGIN
    PRINT 'Deleting sub_packages table...';
    DROP TABLE sub_packages;
    PRINT 'sub_packages table deleted successfully';
END
ELSE
BEGIN
    PRINT 'sub_packages table does not exist';
END

-- Step 4: Delete packages table
PRINT '--- Step 4: Deleting packages table ---';

-- Check if table exists
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'packages')
BEGIN
    PRINT 'Deleting packages table...';
    DROP TABLE packages;
    PRINT 'packages table deleted successfully';
END
ELSE
BEGIN
    PRINT 'packages table does not exist';
END

-- Step 5: Verification
PRINT '--- Step 5: Verification ---';

-- Check if tables still exist
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'packages')
BEGIN
    PRINT 'WARNING: packages table still exists';
END
ELSE
BEGIN
    PRINT 'packages table successfully deleted';
END

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'sub_packages')
BEGIN
    PRINT 'WARNING: sub_packages table still exists';
END
ELSE
BEGIN
    PRINT 'sub_packages table successfully deleted';
END

-- Step 6: Show remaining tables
PRINT '--- Step 6: Remaining tables in database ---';

SELECT 
    TABLE_NAME,
    TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;

PRINT '=== PACKAGE AND SUB-PACKAGE TABLES DELETION COMPLETE ===';
