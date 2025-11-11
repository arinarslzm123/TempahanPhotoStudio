-- Debug database packages and sub-packages
-- This script will check what's in the database and fix any issues

PRINT '=== DEBUGGING DATABASE PACKAGES ===';

-- Check all packages
PRINT '--- All packages in database ---';
SELECT id, package_name, event, category, duration, price, description
FROM packages 
ORDER BY id;

-- Check all sub-packages
PRINT '--- All sub-packages in database ---';
SELECT id, package_id, sub_package_name, price, duration, description, media
FROM sub_packages 
ORDER BY id;

-- Check Photography packages specifically
PRINT '--- Photography packages ---';
SELECT id, package_name, event, category, duration, price
FROM packages 
WHERE category = 'Photography'
ORDER BY id;

-- Check if Photography packages have sub-packages
PRINT '--- Sub-packages for Photography packages ---';
SELECT sp.id, sp.package_id, p.package_name, sp.sub_package_name, sp.price
FROM sub_packages sp
JOIN packages p ON sp.package_id = p.id
WHERE p.category = 'Photography'
ORDER BY sp.id;

-- Check if there are any sub-packages at all
PRINT '--- Total sub-packages count ---';
SELECT COUNT(*) as total_sub_packages FROM sub_packages;

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

-- If no sub-packages exist, add them for Photography packages
IF NOT EXISTS (SELECT 1 FROM sub_packages)
BEGIN
    PRINT 'No sub-packages found. Adding sub-packages for Photography packages...';
    
    -- Get Photography package IDs
    DECLARE @basic_photo_id INT, @standard_photo_id INT, @premium_photo_id INT, @wedding_photo_id INT;
    
    SELECT @basic_photo_id = id FROM packages WHERE package_name = 'Basic Photography Package';
    SELECT @standard_photo_id = id FROM packages WHERE package_name = 'Standard Photography Package';
    SELECT @premium_photo_id = id FROM packages WHERE package_name = 'Premium Photography Package';
    SELECT @wedding_photo_id = id FROM packages WHERE package_name = 'Wedding Photography Package';
    
    -- Add sub-packages
    INSERT INTO sub_packages (package_id, sub_package_name, price, duration, description, media) VALUES
    (@basic_photo_id, 'Basic Sub Package', 500.00, '1 hour', 'Basic sub-package with 25 edited photos', ''),
    (@basic_photo_id, 'Standard Sub Package', 700.00, '1.5 hours', 'Standard sub-package with 40 edited photos', ''),
    (@standard_photo_id, 'Standard Sub Package', 800.00, '2 hours', 'Standard sub-package with 60 edited photos', ''),
    (@standard_photo_id, 'Premium Sub Package', 1000.00, '2.5 hours', 'Premium sub-package with 80 edited photos', ''),
    (@premium_photo_id, 'Premium Sub Package', 1200.00, '3 hours', 'Premium sub-package with 100 edited photos', ''),
    (@premium_photo_id, 'Deluxe Sub Package', 1500.00, '3.5 hours', 'Deluxe sub-package with 120 edited photos', ''),
    (@wedding_photo_id, 'Wedding Basic Sub Package', 2000.00, '6 hours', 'Wedding basic sub-package with 200 edited photos', ''),
    (@wedding_photo_id, 'Wedding Premium Sub Package', 2500.00, '8 hours', 'Wedding premium sub-package with 300 edited photos', '');
    
    PRINT '✅ Sub-packages added successfully!';
END
ELSE
BEGIN
    PRINT '✅ Sub-packages already exist';
END

-- Final verification
PRINT '--- Final Photography packages with sub-packages ---';
SELECT p.id, p.package_name, p.event, p.category, p.duration, p.price,
       sp.id as sub_package_id, sp.sub_package_name, sp.price as sub_package_price
FROM packages p
LEFT JOIN sub_packages sp ON p.id = sp.package_id
WHERE p.category = 'Photography'
ORDER BY p.id, sp.id;

-- Summary
SELECT 'SUMMARY:' as Info;
SELECT 
    (SELECT COUNT(*) FROM packages WHERE category = 'Photography') as photography_packages,
    (SELECT COUNT(*) FROM sub_packages) as total_sub_packages,
    (SELECT COUNT(*) FROM sub_packages sp JOIN packages p ON sp.package_id = p.id WHERE p.category = 'Photography') as photography_sub_packages;

PRINT '=== DATABASE DEBUG COMPLETE ===';
