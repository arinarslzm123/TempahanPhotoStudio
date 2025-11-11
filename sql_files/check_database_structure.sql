-- Check database structure and fix Photography packages issue
-- This script will analyze the current database and fix the issue

PRINT '=== CHECKING DATABASE STRUCTURE ===';

-- Check current packages in database
PRINT '--- Current packages in database ---';
SELECT id, package_name, event, category, duration, price 
FROM packages 
ORDER BY id;

-- Check categories
PRINT '--- Available categories ---';
SELECT DISTINCT category, COUNT(*) as count
FROM packages 
GROUP BY category
ORDER BY category;

-- Check events
PRINT '--- Available events ---';
SELECT DISTINCT event, COUNT(*) as count
FROM packages 
GROUP BY event
ORDER BY event;

-- Check Photography packages specifically
PRINT '--- Photography packages ---';
SELECT id, package_name, event, category, duration, price 
FROM packages 
WHERE category = 'Photography'
ORDER BY id;

-- Check if there are any packages with event = 'Wedding' and category = 'Photography'
PRINT '--- Wedding Photography packages ---';
SELECT id, package_name, event, category, duration, price 
FROM packages 
WHERE event = 'Wedding' AND category = 'Photography'
ORDER BY id;

-- Check if there are any packages with event = 'Wedding' and category = 'Videography'
PRINT '--- Wedding Videography packages ---';
SELECT id, package_name, event, category, duration, price 
FROM packages 
WHERE event = 'Wedding' AND category = 'Videography'
ORDER BY id;

-- Summary
PRINT '--- Summary ---';
SELECT 
    (SELECT COUNT(*) FROM packages WHERE category = 'Photography') as photography_packages,
    (SELECT COUNT(*) FROM packages WHERE category = 'Videography') as videography_packages,
    (SELECT COUNT(*) FROM packages WHERE event = 'Wedding') as wedding_packages,
    (SELECT COUNT(*) FROM packages WHERE event = 'Wedding' AND category = 'Photography') as wedding_photography_packages,
    (SELECT COUNT(*) FROM packages WHERE event = 'Wedding' AND category = 'Videography') as wedding_videography_packages;

PRINT '=== DATABASE STRUCTURE CHECK COMPLETE ===';