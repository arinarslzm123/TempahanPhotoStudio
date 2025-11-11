-- Test Photography packages in database
-- This script will check and ensure Photography packages exist

PRINT '=== TESTING PHOTOGRAPHY PACKAGES ===';

-- Check current Photography packages
PRINT '--- Current Photography packages ---';
SELECT id, package_name, event, category, duration, price 
FROM packages 
WHERE category = 'Photography'
ORDER BY id;

-- Check if we have any packages at all
PRINT '--- All packages in database ---';
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

-- If no Photography packages exist, add them
IF NOT EXISTS (SELECT 1 FROM packages WHERE category = 'Photography')
BEGIN
    PRINT 'No Photography packages found. Adding Photography packages...';
    
    INSERT INTO packages (package_name, event, category, duration, price, description) VALUES
    ('Basic Photography Package', 'General', 'Photography', '2 hours', 800.00, 'Basic photography session with 50 edited photos'),
    ('Standard Photography Package', 'General', 'Photography', '3 hours', 1200.00, 'Standard photography session with 100 edited photos'),
    ('Premium Photography Package', 'General', 'Photography', '4 hours', 1800.00, 'Premium photography session with 150 edited photos'),
    ('Wedding Photography Package', 'Wedding', 'Photography', '8 hours', 3000.00, 'Full wedding photography coverage with 300+ edited photos'),
    ('Event Photography Package', 'Event', 'Photography', '6 hours', 2200.00, 'Event photography coverage with 200+ edited photos'),
    ('Portrait Photography Package', 'Portrait', 'Photography', '1 hour', 500.00, 'Professional portrait session with 20 edited photos'),
    ('Family Photography Package', 'Family', 'Photography', '2 hours', 1000.00, 'Family photography session with 80 edited photos'),
    ('Corporate Photography Package', 'Corporate', 'Photography', '4 hours', 1500.00, 'Corporate event photography with 120 edited photos');
    
    PRINT '✅ Photography packages added successfully!';
END
ELSE
BEGIN
    PRINT '✅ Photography packages already exist';
END

-- Final verification
PRINT '--- Final Photography packages ---';
SELECT id, package_name, event, category, duration, price 
FROM packages 
WHERE category = 'Photography'
ORDER BY id;

-- Summary
SELECT 'SUMMARY:' as Info;
SELECT 
    (SELECT COUNT(*) FROM packages WHERE category = 'Photography') as photography_packages,
    (SELECT COUNT(*) FROM packages WHERE category = 'Videography') as videography_packages,
    (SELECT COUNT(*) FROM packages WHERE event = 'Wedding') as wedding_packages;

PRINT '=== PHOTOGRAPHY PACKAGES TEST COMPLETE ===';
