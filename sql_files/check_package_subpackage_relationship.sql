-- Check relationship between packages and sub-packages
-- This script will identify which sub-packages are linked to which packages

PRINT '=== CHECKING PACKAGE-SUBPACKAGE RELATIONSHIP ===';

-- Check all sub-packages and their parent packages
PRINT '--- All sub-packages with their parent packages ---';
SELECT 
    sp.id as sub_package_id,
    sp.package_id as parent_package_id,
    sp.sub_package_name,
    sp.price as sub_package_price,
    p.package_name as parent_package_name,
    p.event as parent_package_event,
    p.category as parent_package_category,
    p.price as parent_package_price
FROM sub_packages sp
LEFT JOIN packages p ON sp.package_id = p.id
ORDER BY sp.id;

-- Check for orphaned sub-packages (sub-packages without valid parent packages)
PRINT '--- Orphaned sub-packages (no valid parent package) ---';
SELECT 
    sp.id as sub_package_id,
    sp.package_id as parent_package_id,
    sp.sub_package_name,
    sp.price
FROM sub_packages sp
LEFT JOIN packages p ON sp.package_id = p.id
WHERE p.id IS NULL;

-- Check for packages without sub-packages
PRINT '--- Packages without sub-packages ---';
SELECT 
    p.id as package_id,
    p.package_name,
    p.event,
    p.category,
    p.price
FROM packages p
LEFT JOIN sub_packages sp ON p.id = sp.package_id
WHERE sp.id IS NULL;

-- Check specifically for Photography packages and their sub-packages
PRINT '--- Photography packages and their sub-packages ---';
SELECT 
    p.id as package_id,
    p.package_name,
    p.event,
    p.category,
    p.price as package_price,
    sp.id as sub_package_id,
    sp.sub_package_name,
    sp.price as sub_package_price
FROM packages p
LEFT JOIN sub_packages sp ON p.id = sp.package_id
WHERE p.category = 'Photography'
ORDER BY p.id, sp.id;

-- Check for any sub-packages that might be linked to wrong packages
PRINT '--- Sub-packages linked to non-Photography packages ---';
SELECT 
    sp.id as sub_package_id,
    sp.package_id as parent_package_id,
    sp.sub_package_name,
    sp.price as sub_package_price,
    p.package_name as parent_package_name,
    p.event as parent_package_event,
    p.category as parent_package_category
FROM sub_packages sp
JOIN packages p ON sp.package_id = p.id
WHERE p.category != 'Photography'
ORDER BY sp.id;

-- Summary
PRINT '--- Summary ---';
SELECT 
    (SELECT COUNT(*) FROM packages) as total_packages,
    (SELECT COUNT(*) FROM packages WHERE category = 'Photography') as photography_packages,
    (SELECT COUNT(*) FROM sub_packages) as total_sub_packages,
    (SELECT COUNT(*) FROM sub_packages sp JOIN packages p ON sp.package_id = p.id WHERE p.category = 'Photography') as photography_sub_packages,
    (SELECT COUNT(*) FROM sub_packages sp LEFT JOIN packages p ON sp.package_id = p.id WHERE p.id IS NULL) as orphaned_sub_packages;

PRINT '=== PACKAGE-SUBPACKAGE RELATIONSHIP CHECK COMPLETE ===';
