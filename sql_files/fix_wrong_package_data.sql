-- Fix wrong package data in database
-- This script will identify and fix packages that have wrong names

PRINT '=== FIXING WRONG PACKAGE DATA ===';

-- Step 1: Check current packages
PRINT '--- Step 1: Current packages in database ---';
SELECT id, package_name, event, category, duration, price, description
FROM packages 
ORDER BY id;

-- Step 2: Check sub-packages and their parent packages
PRINT '--- Step 2: Sub-packages and their parent packages ---';
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

-- Step 3: Find packages with wrong names (like "Akad Nikah")
PRINT '--- Step 3: Packages with wrong names ---';
SELECT id, package_name, event, category, duration, price
FROM packages 
WHERE package_name LIKE '%Akad%' 
   OR package_name LIKE '%Nikah%' 
   OR package_name LIKE '%Sanding%' 
   OR package_name LIKE '%Tandang%'
   OR package_name LIKE '%Wedding%'
   OR (event = 'Wedding' AND category != 'Photography')
ORDER BY id;

-- Step 4: Update existing packages with proper names and add prices
PRINT '--- Step 4: Updating existing packages ---';

-- Update existing packages to have proper names and prices
UPDATE packages 
SET package_name = 'Basic Photography Package - Akad Nikah',
    price = 800.00,
    description = 'Basic photography package for Akad Nikah ceremony'
WHERE id = 1 AND package_name = 'Akad Nikah';

UPDATE packages 
SET package_name = 'Standard Photography Package - Sanding/Tandang',
    price = 1200.00,
    description = 'Standard photography package for Sanding/Tandang ceremony'
WHERE id = 3 AND package_name = 'Sanding / Tandang';

UPDATE packages 
SET package_name = 'Premium Photography Package - Akad Nikah + Sanding',
    price = 1500.00,
    description = 'Premium photography package for Akad Nikah + Sanding ceremony'
WHERE id = 4 AND package_name = 'Akad Nikah + Sanding';

UPDATE packages 
SET package_name = 'Deluxe Photography Package - Full Wedding',
    price = 2000.00,
    description = 'Deluxe photography package for full wedding ceremony'
WHERE id = 5 AND package_name = '(Akad Nikah & Sanding) + Tandang';

UPDATE packages 
SET package_name = 'Engagement Photography Package',
    price = 600.00,
    description = 'Photography package for engagement ceremony'
WHERE id = 6 AND package_name = 'Tunang';

-- Update PV packages
UPDATE packages 
SET package_name = 'PV1 Photography Package',
    price = 1000.00,
    description = 'PV1 photography package for wedding'
WHERE id = 7 AND package_name LIKE 'PV1%';

UPDATE packages 
SET package_name = 'PV2 Photography Package',
    price = 1200.00,
    description = 'PV2 photography package for wedding'
WHERE id = 8 AND package_name LIKE 'PV2%';

UPDATE packages 
SET package_name = 'PV3 Photography Package',
    price = 1500.00,
    description = 'PV3 photography package for wedding'
WHERE id = 9 AND package_name LIKE 'PV3%';

UPDATE packages 
SET package_name = 'PV4 Photography Package',
    price = 1800.00,
    description = 'PV4 photography package for wedding'
WHERE id = 12 AND package_name LIKE 'PV4%';

PRINT 'Updated existing packages with proper names and prices';

-- Step 5: Add General Photography packages if they don't exist
PRINT '--- Step 5: Adding General Photography packages if needed ---';

-- Add some general photography packages for non-wedding events
IF NOT EXISTS (SELECT 1 FROM packages WHERE event = 'General' AND category = 'Photography')
BEGIN
    INSERT INTO packages (package_name, event, category, duration, price, description) VALUES
    ('Basic Photography Package', 'General', 'Photography', '2 hours', 800.00, 'Basic photography session with 50 edited photos'),
    ('Standard Photography Package', 'General', 'Photography', '3 hours', 1200.00, 'Standard photography session with 100 edited photos'),
    ('Premium Photography Package', 'General', 'Photography', '4 hours', 1800.00, 'Premium photography session with 150 edited photos');
    PRINT 'Added General Photography packages';
END
ELSE
BEGIN
    PRINT 'General Photography packages already exist';
END

-- Step 6: Final verification
PRINT '--- Step 6: Final verification ---';
SELECT 'FINAL PACKAGES:' as Info;
SELECT id, package_name, event, category, duration, price
FROM packages 
ORDER BY id;

SELECT 'FINAL SUB-PACKAGES WITH PARENT PACKAGES:' as Info;
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
    (SELECT COUNT(*) FROM packages WHERE package_name LIKE '%Photography%') as photography_named_packages,
    (SELECT COUNT(*) FROM sub_packages) as total_sub_packages;

PRINT '=== WRONG PACKAGE DATA FIX COMPLETE ===';
