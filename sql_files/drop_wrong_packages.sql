-- Drop wrong packages from database
-- This script will remove packages that are not needed for Photography packages

PRINT '=== DROPPING WRONG PACKAGES ===';

-- Step 1: Check current packages before dropping
PRINT '--- Step 1: Current packages before dropping ---';
SELECT id, package_name, event, category, duration, price, description
FROM packages 
ORDER BY id;

-- Step 2: Check sub-packages that will be affected
PRINT '--- Step 2: Sub-packages that will be affected ---';
SELECT 
    sp.id as sub_package_id,
    sp.package_id as parent_package_id,
    sp.sub_package_name,
    sp.price as sub_package_price,
    p.package_name as parent_package_name,
    p.event as parent_package_event,
    p.category as parent_package_category
FROM sub_packages sp
LEFT JOIN packages p ON sp.package_id = p.id
ORDER BY sp.id;

-- Step 3: Drop sub-packages first (to avoid foreign key constraint)
PRINT '--- Step 3: Dropping sub-packages for packages to be deleted ---';

-- Drop sub-packages for packages that will be deleted
DELETE FROM sub_packages 
WHERE package_id IN (
    SELECT id FROM packages 
    WHERE package_name LIKE '%Akad%' 
       OR package_name LIKE '%Nikah%' 
       OR package_name LIKE '%Sanding%' 
       OR package_name LIKE '%Tandang%'
       OR package_name LIKE 'PV%'
       OR package_name = 'Tunang'
);

PRINT 'Dropped sub-packages for packages to be deleted';

-- Step 4: Drop packages
PRINT '--- Step 4: Dropping packages ---';

-- Drop packages with wrong names
DELETE FROM packages 
WHERE package_name LIKE '%Akad%' 
   OR package_name LIKE '%Nikah%' 
   OR package_name LIKE '%Sanding%' 
   OR package_name LIKE '%Tandang%'
   OR package_name LIKE 'PV%'
   OR package_name = 'Tunang';

PRINT 'Dropped packages with wrong names';

-- Step 5: Check remaining packages
PRINT '--- Step 5: Remaining packages after dropping ---';
SELECT id, package_name, event, category, duration, price, description
FROM packages 
ORDER BY id;

-- Step 6: Check remaining sub-packages
PRINT '--- Step 6: Remaining sub-packages after dropping ---';
SELECT 
    sp.id as sub_package_id,
    sp.package_id as parent_package_id,
    sp.sub_package_name,
    sp.price as sub_package_price,
    p.package_name as parent_package_name,
    p.event as parent_package_event,
    p.category as parent_package_category
FROM sub_packages sp
LEFT JOIN packages p ON sp.package_id = p.id
ORDER BY sp.id;

-- Step 7: Add proper Photography packages
PRINT '--- Step 7: Adding proper Photography packages ---';

INSERT INTO packages (package_name, event, category, duration, price, description) VALUES
('Basic Photography Package', 'General', 'Photography', '2 hours', 800.00, 'Basic photography session with 50 edited photos'),
('Standard Photography Package', 'General', 'Photography', '3 hours', 1200.00, 'Standard photography session with 100 edited photos'),
('Premium Photography Package', 'General', 'Photography', '4 hours', 1800.00, 'Premium photography session with 150 edited photos'),
('Wedding Photography Package', 'Wedding', 'Photography', '8 hours', 3000.00, 'Full wedding photography coverage with 300+ edited photos'),
('Event Photography Package', 'Event', 'Photography', '6 hours', 2200.00, 'Event photography coverage with 200+ edited photos'),
('Portrait Photography Package', 'Portrait', 'Photography', '1 hour', 500.00, 'Professional portrait session with 20 edited photos'),
('Family Photography Package', 'Family', 'Photography', '2 hours', 1000.00, 'Family photography session with 80 edited photos'),
('Corporate Photography Package', 'Corporate', 'Photography', '4 hours', 1500.00, 'Corporate event photography with 120 edited photos');

PRINT 'Added proper Photography packages';

-- Step 8: Add sub-packages for Photography packages
PRINT '--- Step 8: Adding sub-packages for Photography packages ---';

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

PRINT 'Added sub-packages for Photography packages';

-- Step 9: Final verification
PRINT '--- Step 9: Final verification ---';
SELECT 'FINAL PACKAGES:' as Info;
SELECT id, package_name, event, category, duration, price
FROM packages 
ORDER BY id;

SELECT 'FINAL SUB-PACKAGES:' as Info;
SELECT 
    sp.id as sub_package_id,
    sp.package_id as parent_package_id,
    sp.sub_package_name,
    sp.price as sub_package_price,
    p.package_name as parent_package_name,
    p.event as parent_package_event,
    p.category as parent_package_category
FROM sub_packages sp
LEFT JOIN packages p ON sp.package_id = p.id
ORDER BY sp.id;

-- Summary
SELECT 'SUMMARY:' as Info;
SELECT 
    (SELECT COUNT(*) FROM packages WHERE category = 'Photography') as photography_packages,
    (SELECT COUNT(*) FROM packages WHERE event = 'General') as general_packages,
    (SELECT COUNT(*) FROM sub_packages) as total_sub_packages;

PRINT '=== PACKAGE DROPPING COMPLETE ===';
