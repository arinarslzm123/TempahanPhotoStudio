-- Check Photography packages data in database
-- This script will verify what data is actually in the database

PRINT '=== CHECKING PHOTOGRAPHY PACKAGES DATA ===';

-- Check all packages first
PRINT '--- All packages in database ---';
SELECT id, package_name, event, category, duration, price, description
FROM packages 
ORDER BY id;

-- Check Photography packages specifically
PRINT '--- Photography packages only ---';
SELECT id, package_name, event, category, duration, price, description
FROM packages 
WHERE category = 'Photography'
ORDER BY id;

-- Check if there are any packages with event = 'Wedding' and category = 'Photography'
PRINT '--- Wedding Photography packages ---';
SELECT id, package_name, event, category, duration, price, description
FROM packages 
WHERE event = 'Wedding' AND category = 'Photography'
ORDER BY id;

-- Check sub-packages for Photography packages
PRINT '--- Sub-packages for Photography packages ---';
SELECT sp.id, sp.package_id, p.package_name, p.event, p.category, sp.sub_package_name, sp.price, sp.duration
FROM sub_packages sp
JOIN packages p ON sp.package_id = p.id
WHERE p.category = 'Photography'
ORDER BY sp.id;

-- Check if there are any sub-packages at all
PRINT '--- All sub-packages ---';
SELECT id, package_id, sub_package_name, price, duration, description
FROM sub_packages 
ORDER BY id;

-- Summary
PRINT '--- Summary ---';
SELECT 
    (SELECT COUNT(*) FROM packages) as total_packages,
    (SELECT COUNT(*) FROM packages WHERE category = 'Photography') as photography_packages,
    (SELECT COUNT(*) FROM packages WHERE event = 'Wedding') as wedding_packages,
    (SELECT COUNT(*) FROM packages WHERE event = 'Wedding' AND category = 'Photography') as wedding_photography_packages,
    (SELECT COUNT(*) FROM sub_packages) as total_sub_packages,
    (SELECT COUNT(*) FROM sub_packages sp JOIN packages p ON sp.package_id = p.id WHERE p.category = 'Photography') as photography_sub_packages;

PRINT '=== PHOTOGRAPHY DATA CHECK COMPLETE ===';
