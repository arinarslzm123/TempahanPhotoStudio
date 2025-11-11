-- Debug package and sub-package matching issue
-- Check which package is being selected and if it has sub-packages

PRINT '=== DEBUGGING PACKAGE-SUBPACKAGE MATCHING ===';

-- Step 1: Check all packages and their sub-packages
PRINT '--- Step 1: All packages with their sub-packages ---';

SELECT 
    p.id as package_id,
    p.package_name,
    p.event,
    p.category,
    p.price as package_price,
    COUNT(sp.id) as sub_package_count,
    STRING_AGG(sp.sub_package_name, ', ') as sub_package_names
FROM packages p
LEFT JOIN sub_packages sp ON p.id = sp.package_id
GROUP BY p.id, p.package_name, p.event, p.category, p.price
ORDER BY p.id;

-- Step 2: Check specific packages that might be selected
PRINT '--- Step 2: Check packages with "Basic Photography Package" ---';

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

-- Step 3: Check packages with ID 1 (most likely to be selected)
PRINT '--- Step 3: Check package ID 1 specifically ---';

SELECT 
    p.id,
    p.package_name,
    p.event,
    p.category,
    p.price
FROM packages p
WHERE p.id = 1;

SELECT 
    sp.id,
    sp.package_id,
    sp.sub_package_name,
    sp.price,
    sp.description
FROM sub_packages sp
WHERE sp.package_id = 1;

-- Step 4: Check all sub-packages for reference
PRINT '--- Step 4: All sub-packages by package_id ---';

SELECT 
    sp.package_id,
    p.package_name as parent_package_name,
    COUNT(sp.id) as sub_package_count,
    STRING_AGG(sp.sub_package_name, ', ') as sub_package_names
FROM sub_packages sp
LEFT JOIN packages p ON sp.package_id = p.id
GROUP BY sp.package_id, p.package_name
ORDER BY sp.package_id;

-- Step 5: Check if there are any packages without sub-packages
PRINT '--- Step 5: Packages without sub-packages ---';

SELECT 
    p.id,
    p.package_name,
    p.event,
    p.category
FROM packages p
LEFT JOIN sub_packages sp ON p.id = sp.package_id
WHERE sp.id IS NULL
ORDER BY p.id;

-- Step 6: Test the exact query that the app uses
PRINT '--- Step 6: Test app query for package_id = 1 ---';

SELECT * FROM sub_packages WHERE package_id = 1;

PRINT '--- Test app query for package_id = 3 ---';
SELECT * FROM sub_packages WHERE package_id = 3;

PRINT '--- Test app query for package_id = 4 ---';
SELECT * FROM sub_packages WHERE package_id = 4;

PRINT '--- Test app query for package_id = 5 ---';
SELECT * FROM sub_packages WHERE package_id = 5;

PRINT '--- Test app query for package_id = 12 ---';
SELECT * FROM sub_packages WHERE package_id = 12;

PRINT '=== DEBUGGING COMPLETE ===';
