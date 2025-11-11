-- Check sub-packages issue - why "Tiada sub package tersedia" is showing
-- This script will help identify the sub-package loading problem

PRINT '=== CHECKING SUB-PACKAGES ISSUE ===';

-- Step 1: Check if sub_packages table exists and has data
PRINT '--- Step 1: Check sub_packages table structure and data ---';

-- Check if table exists
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'sub_packages')
BEGIN
    PRINT 'sub_packages table exists';
    
    -- Check table structure
    SELECT 
        COLUMN_NAME,
        DATA_TYPE,
        IS_NULLABLE,
        COLUMN_DEFAULT
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'sub_packages'
    ORDER BY ORDINAL_POSITION;
    
    -- Check if table has data
    DECLARE @sub_package_count INT;
    SELECT @sub_package_count = COUNT(*) FROM sub_packages;
    PRINT 'Total sub-packages in database: ' + CAST(@sub_package_count AS VARCHAR(10));
    
    IF @sub_package_count > 0
    BEGIN
        PRINT 'Sub-packages found:';
        SELECT 
            id,
            package_id,
            sub_package_name,
            price,
            duration,
            description
        FROM sub_packages
        ORDER BY id;
    END
    ELSE
    BEGIN
        PRINT 'ERROR: No sub-packages found in database!';
    END
END
ELSE
BEGIN
    PRINT 'ERROR: sub_packages table does not exist!';
END

-- Step 2: Check packages table and their relationships
PRINT '--- Step 2: Check packages and their relationships ---';

SELECT 
    p.id as package_id,
    p.package_name,
    p.event,
    p.category,
    p.price as package_price,
    COUNT(sp.id) as sub_package_count
FROM packages p
LEFT JOIN sub_packages sp ON p.id = sp.package_id
GROUP BY p.id, p.package_name, p.event, p.category, p.price
ORDER BY p.id;

-- Step 3: Check specific package that might be selected
PRINT '--- Step 3: Check specific packages that might be selected ---';

-- Check packages with "Basic Photography Package" in name
SELECT 
    p.id,
    p.package_name,
    p.event,
    p.category,
    p.price,
    sp.id as sub_package_id,
    sp.sub_package_name,
    sp.price as sub_package_price
FROM packages p
LEFT JOIN sub_packages sp ON p.id = sp.package_id
WHERE p.package_name LIKE '%Basic%' OR p.package_name LIKE '%Photography%'
ORDER BY p.id, sp.id;

-- Step 4: Check if there are any packages without sub-packages
PRINT '--- Step 4: Packages without sub-packages ---';

SELECT 
    p.id,
    p.package_name,
    p.event,
    p.category
FROM packages p
LEFT JOIN sub_packages sp ON p.id = sp.package_id
WHERE sp.id IS NULL
ORDER BY p.id;

-- Step 5: Check database connection and basic queries
PRINT '--- Step 5: Test basic database queries ---';

-- Test if we can query packages
DECLARE @package_count INT;
SELECT @package_count = COUNT(*) FROM packages;
PRINT 'Total packages in database: ' + CAST(@package_count AS VARCHAR(10));

-- Test if we can query sub-packages
DECLARE @sub_count INT;
SELECT @sub_count = COUNT(*) FROM sub_packages;
PRINT 'Total sub-packages in database: ' + CAST(@sub_count AS VARCHAR(10));

-- Step 6: Check for any data inconsistencies
PRINT '--- Step 6: Check for data inconsistencies ---';

-- Check for sub-packages with invalid package_id
SELECT 
    sp.id,
    sp.package_id,
    sp.sub_package_name,
    p.package_name as parent_package_name
FROM sub_packages sp
LEFT JOIN packages p ON sp.package_id = p.id
WHERE p.id IS NULL;

-- Check for packages with sub-packages but no proper relationship
SELECT 
    p.id,
    p.package_name,
    COUNT(sp.id) as sub_package_count
FROM packages p
INNER JOIN sub_packages sp ON p.id = sp.package_id
GROUP BY p.id, p.package_name
HAVING COUNT(sp.id) = 0;

PRINT '=== SUB-PACKAGES CHECK COMPLETE ===';