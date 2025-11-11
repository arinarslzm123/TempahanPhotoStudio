-- Update existing packages with better names and add prices
-- This script will keep your existing packages but improve their names and add prices

PRINT '=== UPDATING EXISTING PACKAGES ===';

-- Step 1: Check current packages
PRINT '--- Step 1: Current packages in database ---';
SELECT id, package_name, event, category, duration, price, description
FROM packages 
ORDER BY id;

-- Step 2: Update existing packages with better names and add prices
PRINT '--- Step 2: Updating existing packages ---';

-- Update ID 1: "Akad Nikah" - keep the essence but make it clearer
UPDATE packages 
SET package_name = 'Photography Package - Akad Nikah',
    price = 800.00,
    description = 'Photography package for Akad Nikah ceremony (1 Day 1 Event)'
WHERE id = 1;

-- Update ID 3: "Sanding / Tandang" 
UPDATE packages 
SET package_name = 'Photography Package - Sanding/Tandang',
    price = 1000.00,
    description = 'Photography package for Sanding/Tandang ceremony (1 Day 1 Event)'
WHERE id = 3;

-- Update ID 4: "Akad Nikah + Sanding"
UPDATE packages 
SET package_name = 'Photography Package - Akad Nikah + Sanding',
    price = 1200.00,
    description = 'Photography package for Akad Nikah + Sanding ceremony (1 Day 2 Event)'
WHERE id = 4;

-- Update ID 5: "(Akad Nikah & Sanding) + Tandang"
UPDATE packages 
SET package_name = 'Photography Package - Full Wedding',
    price = 1500.00,
    description = 'Complete photography package for full wedding ceremony (2 Day 3 Event)'
WHERE id = 5;

-- Update ID 6: "Tunang" (Engagement)
UPDATE packages 
SET package_name = 'Photography Package - Engagement',
    price = 600.00,
    description = 'Photography package for engagement ceremony (1 Day)'
WHERE id = 6;

-- Update ID 7: "PV1 - Akad Nikah / Sanding"
UPDATE packages 
SET package_name = 'Photography Package - PV1',
    price = 1000.00,
    description = 'PV1 Photography package for wedding (1 Day 1 Event)'
WHERE id = 7;

-- Update ID 8: "PV2 - Akad Nikah / Sanding"
UPDATE packages 
SET package_name = 'Photography Package - PV2',
    price = 1200.00,
    description = 'PV2 Photography package for wedding (1 Day 2 Event)'
WHERE id = 8;

-- Update ID 9: "PV3 - Akad Nikah & Sanding"
UPDATE packages 
SET package_name = 'Photography Package - PV3',
    price = 1500.00,
    description = 'PV3 Photography package for wedding (2 Day 2 Event)'
WHERE id = 9;

-- Update ID 12: "PV4 - Akad Nikah Sanding & Tandang"
UPDATE packages 
SET package_name = 'Photography Package - PV4',
    price = 1800.00,
    description = 'PV4 Photography package for wedding (3 Day 3 Event)'
WHERE id = 12;

PRINT 'Updated existing packages with better names and prices';

-- Step 3: Add some general photography packages if needed
PRINT '--- Step 3: Adding general photography packages if needed ---';

-- Add general photography packages for non-wedding events
IF NOT EXISTS (SELECT 1 FROM packages WHERE event = 'General' AND category = 'Photography')
BEGIN
    INSERT INTO packages (package_name, event, category, duration, price, description) VALUES
    ('Photography Package - General', 'General', 'Photography', '2 hours', 800.00, 'General photography session for various events'),
    ('Photography Package - Portrait', 'Portrait', 'Photography', '1 hour', 500.00, 'Professional portrait photography session'),
    ('Photography Package - Family', 'Family', 'Photography', '2 hours', 1000.00, 'Family photography session');
    PRINT 'Added general photography packages';
END
ELSE
BEGIN
    PRINT 'General photography packages already exist';
END

-- Step 4: Check sub-packages and add if needed
PRINT '--- Step 4: Checking sub-packages ---';

-- Check if sub-packages exist for the updated packages
IF NOT EXISTS (SELECT 1 FROM sub_packages)
BEGIN
    PRINT 'No sub-packages found. Adding sub-packages for main packages...';
    
    -- Get package IDs
    DECLARE @akad_id INT, @sanding_id INT, @full_wedding_id INT, @pv1_id INT;
    
    SELECT @akad_id = id FROM packages WHERE package_name = 'Photography Package - Akad Nikah';
    SELECT @sanding_id = id FROM packages WHERE package_name = 'Photography Package - Sanding/Tandang';
    SELECT @full_wedding_id = id FROM packages WHERE package_name = 'Photography Package - Full Wedding';
    SELECT @pv1_id = id FROM packages WHERE package_name = 'Photography Package - PV1';
    
    -- Add sub-packages
    INSERT INTO sub_packages (package_id, sub_package_name, price, duration, description, media) VALUES
    (@akad_id, 'Basic Sub Package', 500.00, '1 hour', 'Basic sub-package for Akad Nikah', ''),
    (@akad_id, 'Premium Sub Package', 700.00, '1.5 hours', 'Premium sub-package for Akad Nikah', ''),
    (@sanding_id, 'Standard Sub Package', 600.00, '1 hour', 'Standard sub-package for Sanding/Tandang', ''),
    (@sanding_id, 'Deluxe Sub Package', 800.00, '1.5 hours', 'Deluxe sub-package for Sanding/Tandang', ''),
    (@full_wedding_id, 'Full Wedding Basic', 1000.00, '6 hours', 'Basic full wedding sub-package', ''),
    (@full_wedding_id, 'Full Wedding Premium', 1200.00, '8 hours', 'Premium full wedding sub-package', ''),
    (@pv1_id, 'PV1 Basic', 700.00, '4 hours', 'Basic PV1 sub-package', ''),
    (@pv1_id, 'PV1 Premium', 900.00, '6 hours', 'Premium PV1 sub-package', '');
    
    PRINT 'Added sub-packages for main packages';
END
ELSE
BEGIN
    PRINT 'Sub-packages already exist';
END

-- Step 5: Final verification
PRINT '--- Step 5: Final verification ---';
SELECT 'UPDATED PACKAGES:' as Info;
SELECT id, package_name, event, category, duration, price, description
FROM packages 
ORDER BY id;

SELECT 'SUB-PACKAGES:' as Info;
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
    (SELECT COUNT(*) FROM packages WHERE event = 'Wedding') as wedding_packages,
    (SELECT COUNT(*) FROM packages WHERE event = 'Engagement') as engagement_packages,
    (SELECT COUNT(*) FROM sub_packages) as total_sub_packages;

PRINT '=== PACKAGE UPDATE COMPLETE ===';
