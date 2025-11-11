-- Add sub-packages if they are missing from the database
-- This script will check and add sub-packages for existing packages

PRINT '=== ADDING SUB-PACKAGES IF MISSING ===';

-- Step 1: Check current state
PRINT '--- Step 1: Current packages and sub-packages ---';

SELECT 
    p.id as package_id,
    p.package_name,
    p.event,
    p.category,
    COUNT(sp.id) as sub_package_count
FROM packages p
LEFT JOIN sub_packages sp ON p.id = sp.package_id
GROUP BY p.id, p.package_name, p.event, p.category
ORDER BY p.id;

-- Step 2: Check if sub_packages table exists
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'sub_packages')
BEGIN
    PRINT 'Creating sub_packages table...';
    
    CREATE TABLE sub_packages (
        id INT IDENTITY(1,1) PRIMARY KEY,
        package_id INT NOT NULL,
        sub_package_name NVARCHAR(255) NOT NULL,
        price DECIMAL(10,2) DEFAULT 0.00,
        duration NVARCHAR(100),
        description NVARCHAR(500),
        media NVARCHAR(255),
        FOREIGN KEY (package_id) REFERENCES packages(id)
    );
    
    PRINT 'sub_packages table created successfully';
END
ELSE
BEGIN
    PRINT 'sub_packages table already exists';
END

-- Step 3: Add sub-packages for existing packages
PRINT '--- Step 3: Adding sub-packages for existing packages ---';

-- Get package IDs for reference
DECLARE @akad_id INT, @sanding_id INT, @akad_sanding_id INT, @full_wedding_id INT;
DECLARE @tunang_id INT, @pv1_id INT, @pv2_id INT, @pv3_id INT, @pv4_id INT;

-- Get package IDs (using LIKE to match partial names)
SELECT @akad_id = id FROM packages WHERE package_name LIKE '%Akad Nikah%' AND package_name NOT LIKE '%+%';
SELECT @sanding_id = id FROM packages WHERE package_name LIKE '%Sanding%' AND package_name NOT LIKE '%+%';
SELECT @akad_sanding_id = id FROM packages WHERE package_name LIKE '%Akad Nikah + Sanding%';
SELECT @full_wedding_id = id FROM packages WHERE package_name LIKE '%Full Wedding%' OR package_name LIKE '%Akad Nikah & Sanding%';
SELECT @tunang_id = id FROM packages WHERE package_name LIKE '%Tunang%' OR package_name LIKE '%Engagement%';
SELECT @pv1_id = id FROM packages WHERE package_name LIKE '%PV1%';
SELECT @pv2_id = id FROM packages WHERE package_name LIKE '%PV2%';
SELECT @pv3_id = id FROM packages WHERE package_name LIKE '%PV3%';
SELECT @pv4_id = id FROM packages WHERE package_name LIKE '%PV4%';

PRINT 'Package IDs found:';
PRINT 'Akad Nikah ID: ' + ISNULL(CAST(@akad_id AS VARCHAR(10)), 'NULL');
PRINT 'Sanding ID: ' + ISNULL(CAST(@sanding_id AS VARCHAR(10)), 'NULL');
PRINT 'Akad + Sanding ID: ' + ISNULL(CAST(@akad_sanding_id AS VARCHAR(10)), 'NULL');
PRINT 'Full Wedding ID: ' + ISNULL(CAST(@full_wedding_id AS VARCHAR(10)), 'NULL');
PRINT 'Tunang ID: ' + ISNULL(CAST(@tunang_id AS VARCHAR(10)), 'NULL');
PRINT 'PV1 ID: ' + ISNULL(CAST(@pv1_id AS VARCHAR(10)), 'NULL');
PRINT 'PV2 ID: ' + ISNULL(CAST(@pv2_id AS VARCHAR(10)), 'NULL');
PRINT 'PV3 ID: ' + ISNULL(CAST(@pv3_id AS VARCHAR(10)), 'NULL');
PRINT 'PV4 ID: ' + ISNULL(CAST(@pv4_id AS VARCHAR(10)), 'NULL');

-- Add sub-packages for Akad Nikah (if exists and no sub-packages)
IF @akad_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sub_packages WHERE package_id = @akad_id)
BEGIN
    INSERT INTO sub_packages (package_id, sub_package_name, price, duration, description, media) VALUES
    (@akad_id, 'Basic Akad Nikah', 500.00, '1 hour', 'Basic photography for Akad Nikah ceremony', '50 photos'),
    (@akad_id, 'Standard Akad Nikah', 700.00, '1.5 hours', 'Standard photography for Akad Nikah ceremony', '80 photos'),
    (@akad_id, 'Premium Akad Nikah', 900.00, '2 hours', 'Premium photography for Akad Nikah ceremony', '100 photos');
    PRINT 'Added sub-packages for Akad Nikah package';
END

-- Add sub-packages for Sanding/Tandang (if exists and no sub-packages)
IF @sanding_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sub_packages WHERE package_id = @sanding_id)
BEGIN
    INSERT INTO sub_packages (package_id, sub_package_name, price, duration, description, media) VALUES
    (@sanding_id, 'Basic Sanding/Tandang', 600.00, '1 hour', 'Basic photography for Sanding/Tandang ceremony', '60 photos'),
    (@sanding_id, 'Standard Sanding/Tandang', 800.00, '1.5 hours', 'Standard photography for Sanding/Tandang ceremony', '90 photos'),
    (@sanding_id, 'Premium Sanding/Tandang', 1000.00, '2 hours', 'Premium photography for Sanding/Tandang ceremony', '120 photos');
    PRINT 'Added sub-packages for Sanding/Tandang package';
END

-- Add sub-packages for Akad + Sanding (if exists and no sub-packages)
IF @akad_sanding_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sub_packages WHERE package_id = @akad_sanding_id)
BEGIN
    INSERT INTO sub_packages (package_id, sub_package_name, price, duration, description, media) VALUES
    (@akad_sanding_id, 'Basic Akad + Sanding', 800.00, '3 hours', 'Basic photography for both Akad Nikah and Sanding', '100 photos'),
    (@akad_sanding_id, 'Standard Akad + Sanding', 1000.00, '4 hours', 'Standard photography for both Akad Nikah and Sanding', '150 photos'),
    (@akad_sanding_id, 'Premium Akad + Sanding', 1200.00, '5 hours', 'Premium photography for both Akad Nikah and Sanding', '200 photos');
    PRINT 'Added sub-packages for Akad + Sanding package';
END

-- Add sub-packages for Full Wedding (if exists and no sub-packages)
IF @full_wedding_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sub_packages WHERE package_id = @full_wedding_id)
BEGIN
    INSERT INTO sub_packages (package_id, sub_package_name, price, duration, description, media) VALUES
    (@full_wedding_id, 'Basic Full Wedding', 1000.00, '6 hours', 'Basic photography for full wedding ceremony', '150 photos'),
    (@full_wedding_id, 'Standard Full Wedding', 1200.00, '8 hours', 'Standard photography for full wedding ceremony', '200 photos'),
    (@full_wedding_id, 'Premium Full Wedding', 1500.00, '10 hours', 'Premium photography for full wedding ceremony', '300 photos');
    PRINT 'Added sub-packages for Full Wedding package';
END

-- Add sub-packages for Tunang/Engagement (if exists and no sub-packages)
IF @tunang_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sub_packages WHERE package_id = @tunang_id)
BEGIN
    INSERT INTO sub_packages (package_id, sub_package_name, price, duration, description, media) VALUES
    (@tunang_id, 'Basic Engagement', 400.00, '1 hour', 'Basic photography for engagement ceremony', '40 photos'),
    (@tunang_id, 'Standard Engagement', 500.00, '1.5 hours', 'Standard photography for engagement ceremony', '60 photos'),
    (@tunang_id, 'Premium Engagement', 600.00, '2 hours', 'Premium photography for engagement ceremony', '80 photos');
    PRINT 'Added sub-packages for Engagement package';
END

-- Add sub-packages for PV1 (if exists and no sub-packages)
IF @pv1_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sub_packages WHERE package_id = @pv1_id)
BEGIN
    INSERT INTO sub_packages (package_id, sub_package_name, price, duration, description, media) VALUES
    (@pv1_id, 'PV1 Basic', 700.00, '4 hours', 'Basic PV1 photography package', '100 photos'),
    (@pv1_id, 'PV1 Standard', 900.00, '6 hours', 'Standard PV1 photography package', '150 photos'),
    (@pv1_id, 'PV1 Premium', 1100.00, '8 hours', 'Premium PV1 photography package', '200 photos');
    PRINT 'Added sub-packages for PV1 package';
END

-- Add sub-packages for PV2 (if exists and no sub-packages)
IF @pv2_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sub_packages WHERE package_id = @pv2_id)
BEGIN
    INSERT INTO sub_packages (package_id, sub_package_name, price, duration, description, media) VALUES
    (@pv2_id, 'PV2 Basic', 800.00, '5 hours', 'Basic PV2 photography package', '120 photos'),
    (@pv2_id, 'PV2 Standard', 1000.00, '7 hours', 'Standard PV2 photography package', '180 photos'),
    (@pv2_id, 'PV2 Premium', 1200.00, '9 hours', 'Premium PV2 photography package', '250 photos');
    PRINT 'Added sub-packages for PV2 package';
END

-- Add sub-packages for PV3 (if exists and no sub-packages)
IF @pv3_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sub_packages WHERE package_id = @pv3_id)
BEGIN
    INSERT INTO sub_packages (package_id, sub_package_name, price, duration, description, media) VALUES
    (@pv3_id, 'PV3 Basic', 1000.00, '6 hours', 'Basic PV3 photography package', '150 photos'),
    (@pv3_id, 'PV3 Standard', 1200.00, '8 hours', 'Standard PV3 photography package', '200 photos'),
    (@pv3_id, 'PV3 Premium', 1500.00, '10 hours', 'Premium PV3 photography package', '300 photos');
    PRINT 'Added sub-packages for PV3 package';
END

-- Add sub-packages for PV4 (if exists and no sub-packages)
IF @pv4_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sub_packages WHERE package_id = @pv4_id)
BEGIN
    INSERT INTO sub_packages (package_id, sub_package_name, price, duration, description, media) VALUES
    (@pv4_id, 'PV4 Basic', 1200.00, '8 hours', 'Basic PV4 photography package', '200 photos'),
    (@pv4_id, 'PV4 Standard', 1500.00, '10 hours', 'Standard PV4 photography package', '300 photos'),
    (@pv4_id, 'PV4 Premium', 1800.00, '12 hours', 'Premium PV4 photography package', '400 photos');
    PRINT 'Added sub-packages for PV4 package';
END

-- Step 4: Add sub-packages for any remaining packages without sub-packages
PRINT '--- Step 4: Adding sub-packages for remaining packages ---';

INSERT INTO sub_packages (package_id, sub_package_name, price, duration, description, media)
SELECT 
    p.id,
    'Basic ' + p.package_name,
    CASE 
        WHEN p.price > 0 THEN p.price * 0.6
        ELSE 500.00
    END,
    '2 hours',
    'Basic sub-package for ' + p.package_name,
    '50 photos'
FROM packages p
WHERE NOT EXISTS (SELECT 1 FROM sub_packages sp WHERE sp.package_id = p.id)
AND p.id NOT IN (ISNULL(@akad_id, 0), ISNULL(@sanding_id, 0), ISNULL(@akad_sanding_id, 0), 
                 ISNULL(@full_wedding_id, 0), ISNULL(@tunang_id, 0), ISNULL(@pv1_id, 0), 
                 ISNULL(@pv2_id, 0), ISNULL(@pv3_id, 0), ISNULL(@pv4_id, 0));

-- Step 5: Final verification
PRINT '--- Step 5: Final verification ---';

SELECT 
    p.id as package_id,
    p.package_name,
    p.event,
    p.category,
    COUNT(sp.id) as sub_package_count
FROM packages p
LEFT JOIN sub_packages sp ON p.id = sp.package_id
GROUP BY p.id, p.package_name, p.event, p.category
ORDER BY p.id;

SELECT 'SUB-PACKAGES DETAILS:' as Info;
SELECT 
    sp.id as sub_package_id,
    sp.package_id as parent_package_id,
    sp.sub_package_name,
    sp.price as sub_package_price,
    p.package_name as parent_package_name
FROM sub_packages sp
LEFT JOIN packages p ON sp.package_id = p.id
ORDER BY sp.package_id, sp.id;

-- Summary
SELECT 'SUMMARY:' as Info;
SELECT 
    (SELECT COUNT(*) FROM packages) as total_packages,
    (SELECT COUNT(*) FROM sub_packages) as total_sub_packages,
    (SELECT COUNT(*) FROM packages p WHERE EXISTS (SELECT 1 FROM sub_packages sp WHERE sp.package_id = p.id)) as packages_with_sub_packages;

PRINT '=== SUB-PACKAGES ADDITION COMPLETE ===';
