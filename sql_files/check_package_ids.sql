-- Check package IDs in database to match with app
-- This will help identify the correct package IDs

PRINT '=== CHECKING PACKAGE IDs ===';

-- Step 1: Show all packages with their IDs
PRINT '--- Step 1: All packages with IDs ---';

SELECT 
    id,
    package_name,
    event,
    category,
    price,
    duration
FROM packages 
ORDER BY id;

-- Step 2: Show sub-packages with their package_id references
PRINT '--- Step 2: Sub-packages with package_id references ---';

SELECT 
    sp.id as sub_package_id,
    sp.package_id,
    sp.sub_package_name,
    sp.price,
    p.package_name as parent_package_name
FROM sub_packages sp
LEFT JOIN packages p ON sp.package_id = p.id
ORDER BY sp.package_id, sp.id;

-- Step 3: Check which packages have sub-packages
PRINT '--- Step 3: Packages that have sub-packages ---';

SELECT DISTINCT
    sp.package_id,
    p.package_name,
    COUNT(sp.id) as sub_package_count
FROM sub_packages sp
LEFT JOIN packages p ON sp.package_id = p.id
GROUP BY sp.package_id, p.package_name
ORDER BY sp.package_id;

-- Step 4: Check packages without sub-packages
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

-- Step 5: Test specific package IDs that might be used in app
PRINT '--- Step 5: Test specific package IDs ---';

-- Test package ID 1
PRINT 'Package ID 1:';
SELECT * FROM packages WHERE id = 1;
SELECT * FROM sub_packages WHERE package_id = 1;

-- Test package ID 3
PRINT 'Package ID 3:';
SELECT * FROM packages WHERE id = 3;
SELECT * FROM sub_packages WHERE package_id = 3;

-- Test package ID 4
PRINT 'Package ID 4:';
SELECT * FROM packages WHERE id = 4;
SELECT * FROM sub_packages WHERE package_id = 4;

-- Test package ID 5
PRINT 'Package ID 5:';
SELECT * FROM packages WHERE id = 5;
SELECT * FROM sub_packages WHERE package_id = 5;

-- Test package ID 12
PRINT 'Package ID 12:';
SELECT * FROM packages WHERE id = 12;
SELECT * FROM sub_packages WHERE package_id = 12;

-- Step 6: Check for packages with "Basic Photography Package" in name
PRINT '--- Step 6: Packages with "Basic" in name ---';

SELECT 
    id,
    package_name,
    event,
    category,
    price
FROM packages 
WHERE package_name LIKE '%Basic%'
ORDER BY id;

-- Step 7: Summary
PRINT '--- Step 7: Summary ---';

SELECT 
    'Total Packages' as Info,
    COUNT(*) as Count
FROM packages
UNION ALL
SELECT 
    'Total Sub-packages' as Info,
    COUNT(*) as Count
FROM sub_packages
UNION ALL
SELECT 
    'Packages with Sub-packages' as Info,
    COUNT(DISTINCT package_id) as Count
FROM sub_packages;

PRINT '=== PACKAGE ID CHECK COMPLETE ===';
