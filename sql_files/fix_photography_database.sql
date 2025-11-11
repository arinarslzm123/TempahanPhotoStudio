-- Comprehensive fix for Photography packages database
-- This script will check, clean, and add correct Photography packages

PRINT '=== COMPREHENSIVE PHOTOGRAPHY DATABASE FIX ===';

-- Step 1: Check current state
PRINT '--- Step 1: Current database state ---';
SELECT 'PACKAGES:' as Info;
SELECT id, package_name, event, category, duration, price, description
FROM packages 
ORDER BY id;

SELECT 'SUB_PACKAGES:' as Info;
SELECT id, package_id, sub_package_name, price, duration, description
FROM sub_packages 
ORDER BY id;

-- Step 2: Clean up any incorrect data
PRINT '--- Step 2: Cleaning up incorrect data ---';

-- Remove any packages with wrong category or event combinations
DELETE FROM sub_packages WHERE package_id IN (
    SELECT id FROM packages WHERE category = 'Wedding' OR event = 'Wedding'
);

DELETE FROM packages WHERE category = 'Wedding' OR (event = 'Wedding' AND category != 'Photography');

PRINT 'Cleaned up incorrect packages and sub-packages';

-- Step 3: Add Photography packages
PRINT '--- Step 3: Adding Photography packages ---';

-- Check if Photography packages exist
IF NOT EXISTS (SELECT 1 FROM packages WHERE category = 'Photography')
BEGIN
    PRINT 'Adding Photography packages...';
    
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

-- Step 4: Add sub-packages for Photography packages
PRINT '--- Step 4: Adding sub-packages for Photography packages ---';

-- Get Photography package IDs
DECLARE @basic_photo_id INT, @standard_photo_id INT, @premium_photo_id INT, @wedding_photo_id INT;

SELECT @basic_photo_id = id FROM packages WHERE package_name = 'Basic Photography Package';
SELECT @standard_photo_id = id FROM packages WHERE package_name = 'Standard Photography Package';
SELECT @premium_photo_id = id FROM packages WHERE package_name = 'Premium Photography Package';
SELECT @wedding_photo_id = id FROM packages WHERE package_name = 'Wedding Photography Package';

-- Check if sub-packages exist for Photography packages
IF NOT EXISTS (SELECT 1 FROM sub_packages sp JOIN packages p ON sp.package_id = p.id WHERE p.category = 'Photography')
BEGIN
    PRINT 'Adding sub-packages for Photography packages...';
    
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
    PRINT '✅ Sub-packages already exist for Photography packages';
END

-- Step 5: Final verification
PRINT '--- Step 5: Final verification ---';
SELECT 'FINAL PHOTOGRAPHY PACKAGES:' as Info;
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
    (SELECT COUNT(*) FROM sub_packages sp JOIN packages p ON sp.package_id = p.id WHERE p.category = 'Photography') as photography_sub_packages,
    (SELECT COUNT(*) FROM packages WHERE event = 'Wedding' AND category = 'Photography') as wedding_photography_packages;

PRINT '=== PHOTOGRAPHY DATABASE FIX COMPLETE ===';
