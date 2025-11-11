-- Add sub-packages for existing packages
-- This script will add sub-packages if they don't exist

PRINT '=== ADDING SUB-PACKAGES FOR EXISTING PACKAGES ===';

-- Step 1: Check current sub-packages
PRINT '--- Step 1: Current sub-packages ---';
SELECT 
    sp.id,
    sp.package_id,
    sp.sub_package_name,
    sp.price,
    p.package_name as parent_package_name
FROM sub_packages sp
LEFT JOIN packages p ON sp.package_id = p.id
ORDER BY sp.id;

-- Step 2: Add sub-packages for each existing package if they don't exist
PRINT '--- Step 2: Adding sub-packages for existing packages ---';

-- Get package IDs
DECLARE @akad_id INT, @sanding_id INT, @akad_sanding_id INT, @full_wedding_id INT;
DECLARE @tunang_id INT, @pv1_id INT, @pv2_id INT, @pv3_id INT, @pv4_id INT;

-- Get package IDs (using original names from database)
SELECT @akad_id = id FROM packages WHERE package_name = 'Akad Nikah';
SELECT @sanding_id = id FROM packages WHERE package_name = 'Sanding / Tandang';
SELECT @akad_sanding_id = id FROM packages WHERE package_name = 'Akad Nikah + Sanding';
SELECT @full_wedding_id = id FROM packages WHERE package_name = '(Akad Nikah & Sanding) + Tandang';
SELECT @tunang_id = id FROM packages WHERE package_name = 'Tunang';
SELECT @pv1_id = id FROM packages WHERE package_name = 'PV1 - Akad Nikah / Sanding';
SELECT @pv2_id = id FROM packages WHERE package_name = 'PV2 - Akad Nikah / Sanding';
SELECT @pv3_id = id FROM packages WHERE package_name = 'PV3 - Akad Nikah & Sanding';
SELECT @pv4_id = id FROM packages WHERE package_name = 'PV4 - Akad Nikah Sanding & Tandang';

PRINT 'Package IDs found:';
PRINT 'Akad Nikah ID: ' + CAST(ISNULL(@akad_id, 0) AS VARCHAR);
PRINT 'Sanding ID: ' + CAST(ISNULL(@sanding_id, 0) AS VARCHAR);
PRINT 'Akad + Sanding ID: ' + CAST(ISNULL(@akad_sanding_id, 0) AS VARCHAR);
PRINT 'Full Wedding ID: ' + CAST(ISNULL(@full_wedding_id, 0) AS VARCHAR);
PRINT 'Tunang ID: ' + CAST(ISNULL(@tunang_id, 0) AS VARCHAR);
PRINT 'PV1 ID: ' + CAST(ISNULL(@pv1_id, 0) AS VARCHAR);
PRINT 'PV2 ID: ' + CAST(ISNULL(@pv2_id, 0) AS VARCHAR);
PRINT 'PV3 ID: ' + CAST(ISNULL(@pv3_id, 0) AS VARCHAR);
PRINT 'PV4 ID: ' + CAST(ISNULL(@pv4_id, 0) AS VARCHAR);

-- Add sub-packages for Akad Nikah (ID 1)
IF @akad_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sub_packages WHERE package_id = @akad_id)
BEGIN
    INSERT INTO sub_packages (package_id, sub_package_name, price, duration, description, media) VALUES
    (@akad_id, 'Basic Akad Nikah', 500.00, '1 hour', 'Basic photography for Akad Nikah ceremony', ''),
    (@akad_id, 'Standard Akad Nikah', 700.00, '1.5 hours', 'Standard photography for Akad Nikah ceremony', ''),
    (@akad_id, 'Premium Akad Nikah', 900.00, '2 hours', 'Premium photography for Akad Nikah ceremony', '');
    PRINT 'Added sub-packages for Akad Nikah (ID: ' + CAST(@akad_id AS VARCHAR) + ')';
END

-- Add sub-packages for Sanding/Tandang (ID 3)
IF @sanding_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sub_packages WHERE package_id = @sanding_id)
BEGIN
    INSERT INTO sub_packages (package_id, sub_package_name, price, duration, description, media) VALUES
    (@sanding_id, 'Basic Sanding', 600.00, '1 hour', 'Basic photography for Sanding/Tandang ceremony', ''),
    (@sanding_id, 'Standard Sanding', 800.00, '1.5 hours', 'Standard photography for Sanding/Tandang ceremony', ''),
    (@sanding_id, 'Premium Sanding', 1000.00, '2 hours', 'Premium photography for Sanding/Tandang ceremony', '');
    PRINT 'Added sub-packages for Sanding/Tandang (ID: ' + CAST(@sanding_id AS VARCHAR) + ')';
END

-- Add sub-packages for Akad Nikah + Sanding (ID 4)
IF @akad_sanding_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sub_packages WHERE package_id = @akad_sanding_id)
BEGIN
    INSERT INTO sub_packages (package_id, sub_package_name, price, duration, description, media) VALUES
    (@akad_sanding_id, 'Basic Combo', 800.00, '2 hours', 'Basic photography for Akad Nikah + Sanding', ''),
    (@akad_sanding_id, 'Standard Combo', 1000.00, '3 hours', 'Standard photography for Akad Nikah + Sanding', ''),
    (@akad_sanding_id, 'Premium Combo', 1200.00, '4 hours', 'Premium photography for Akad Nikah + Sanding', '');
    PRINT 'Added sub-packages for Akad Nikah + Sanding (ID: ' + CAST(@akad_sanding_id AS VARCHAR) + ')';
END

-- Add sub-packages for Full Wedding (ID 5)
IF @full_wedding_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sub_packages WHERE package_id = @full_wedding_id)
BEGIN
    INSERT INTO sub_packages (package_id, sub_package_name, price, duration, description, media) VALUES
    (@full_wedding_id, 'Full Wedding Basic', 1000.00, '6 hours', 'Basic full wedding photography package', ''),
    (@full_wedding_id, 'Full Wedding Standard', 1200.00, '8 hours', 'Standard full wedding photography package', ''),
    (@full_wedding_id, 'Full Wedding Premium', 1500.00, '10 hours', 'Premium full wedding photography package', '');
    PRINT 'Added sub-packages for Full Wedding (ID: ' + CAST(@full_wedding_id AS VARCHAR) + ')';
END

-- Add sub-packages for Tunang/Engagement (ID 6)
IF @tunang_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sub_packages WHERE package_id = @tunang_id)
BEGIN
    INSERT INTO sub_packages (package_id, sub_package_name, price, duration, description, media) VALUES
    (@tunang_id, 'Basic Engagement', 400.00, '1 hour', 'Basic engagement photography', ''),
    (@tunang_id, 'Standard Engagement', 500.00, '1.5 hours', 'Standard engagement photography', ''),
    (@tunang_id, 'Premium Engagement', 600.00, '2 hours', 'Premium engagement photography', '');
    PRINT 'Added sub-packages for Tunang/Engagement (ID: ' + CAST(@tunang_id AS VARCHAR) + ')';
END

-- Add sub-packages for PV1 (ID 7)
IF @pv1_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sub_packages WHERE package_id = @pv1_id)
BEGIN
    INSERT INTO sub_packages (package_id, sub_package_name, price, duration, description, media) VALUES
    (@pv1_id, 'PV1 Basic', 700.00, '4 hours', 'Basic PV1 photography package', ''),
    (@pv1_id, 'PV1 Standard', 900.00, '6 hours', 'Standard PV1 photography package', ''),
    (@pv1_id, 'PV1 Premium', 1100.00, '8 hours', 'Premium PV1 photography package', '');
    PRINT 'Added sub-packages for PV1 (ID: ' + CAST(@pv1_id AS VARCHAR) + ')';
END

-- Add sub-packages for PV2 (ID 8)
IF @pv2_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sub_packages WHERE package_id = @pv2_id)
BEGIN
    INSERT INTO sub_packages (package_id, sub_package_name, price, duration, description, media) VALUES
    (@pv2_id, 'PV2 Basic', 800.00, '4 hours', 'Basic PV2 photography package', ''),
    (@pv2_id, 'PV2 Standard', 1000.00, '6 hours', 'Standard PV2 photography package', ''),
    (@pv2_id, 'PV2 Premium', 1200.00, '8 hours', 'Premium PV2 photography package', '');
    PRINT 'Added sub-packages for PV2 (ID: ' + CAST(@pv2_id AS VARCHAR) + ')';
END

-- Add sub-packages for PV3 (ID 9)
IF @pv3_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sub_packages WHERE package_id = @pv3_id)
BEGIN
    INSERT INTO sub_packages (package_id, sub_package_name, price, duration, description, media) VALUES
    (@pv3_id, 'PV3 Basic', 1000.00, '6 hours', 'Basic PV3 photography package', ''),
    (@pv3_id, 'PV3 Standard', 1200.00, '8 hours', 'Standard PV3 photography package', ''),
    (@pv3_id, 'PV3 Premium', 1500.00, '10 hours', 'Premium PV3 photography package', '');
    PRINT 'Added sub-packages for PV3 (ID: ' + CAST(@pv3_id AS VARCHAR) + ')';
END

-- Add sub-packages for PV4 (ID 12)
IF @pv4_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sub_packages WHERE package_id = @pv4_id)
BEGIN
    INSERT INTO sub_packages (package_id, sub_package_name, price, duration, description, media) VALUES
    (@pv4_id, 'PV4 Basic', 1200.00, '8 hours', 'Basic PV4 photography package', ''),
    (@pv4_id, 'PV4 Standard', 1500.00, '10 hours', 'Standard PV4 photography package', ''),
    (@pv4_id, 'PV4 Premium', 1800.00, '12 hours', 'Premium PV4 photography package', '');
    PRINT 'Added sub-packages for PV4 (ID: ' + CAST(@pv4_id AS VARCHAR) + ')';
END

-- Step 3: Final verification
PRINT '--- Step 3: Final verification ---';
SELECT 'UPDATED SUB-PACKAGES:' as Info;
SELECT 
    sp.id,
    sp.package_id,
    sp.sub_package_name,
    sp.price,
    sp.duration,
    p.package_name as parent_package_name
FROM sub_packages sp
LEFT JOIN packages p ON sp.package_id = p.id
ORDER BY sp.package_id, sp.id;

-- Summary
SELECT 'SUMMARY:' as Info;
SELECT 
    COUNT(*) as total_sub_packages,
    COUNT(DISTINCT package_id) as packages_with_sub_packages
FROM sub_packages;

PRINT '=== SUB-PACKAGES ADDITION COMPLETE ===';
