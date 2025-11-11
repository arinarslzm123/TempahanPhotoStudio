-- Check and fix Photography packages issue
-- This script will check the packages table and add Photography packages if missing

PRINT '=== CHECKING PHOTOGRAPHY PACKAGES ===';

-- Check current packages in database
PRINT '--- Current packages in database ---';
SELECT id, package_name, category, duration, price 
FROM packages 
ORDER BY category, id;

-- Check if Photography category exists
DECLARE @photographyCount INT;
SELECT @photographyCount = COUNT(*) FROM packages WHERE category = 'Photography';
PRINT '📊 Photography packages found: ' + CAST(@photographyCount AS VARCHAR(10));

-- If no Photography packages found, add them
IF @photographyCount = 0
BEGIN
    PRINT '❌ No Photography packages found. Adding sample Photography packages...';
    
    -- Insert sample Photography packages
    INSERT INTO packages (package_name, category, duration, price, description) VALUES
    ('Basic Photography Package', 'Photography', '2 hours', 800.00, 'Basic photography session with 50 edited photos'),
    ('Standard Photography Package', 'Photography', '3 hours', 1200.00, 'Standard photography session with 100 edited photos'),
    ('Premium Photography Package', 'Photography', '4 hours', 1800.00, 'Premium photography session with 150 edited photos'),
    ('Wedding Photography Package', 'Photography', '8 hours', 3000.00, 'Full wedding photography coverage with 300+ edited photos'),
    ('Event Photography Package', 'Photography', '6 hours', 2200.00, 'Event photography coverage with 200+ edited photos'),
    ('Portrait Photography Package', 'Photography', '1 hour', 500.00, 'Professional portrait session with 20 edited photos'),
    ('Family Photography Package', 'Photography', '2 hours', 1000.00, 'Family photography session with 80 edited photos'),
    ('Corporate Photography Package', 'Photography', '4 hours', 1500.00, 'Corporate event photography with 120 edited photos');
    
    PRINT '✅ Sample Photography packages added successfully!';
    
    -- Show the newly added packages
    SELECT id, package_name, category, duration, price 
    FROM packages 
    WHERE category = 'Photography'
    ORDER BY id;
END
ELSE
BEGIN
    PRINT '✅ Photography packages already exist in database';
    
    -- Show existing Photography packages
    SELECT id, package_name, category, duration, price 
    FROM packages 
    WHERE category = 'Photography'
    ORDER BY id;
END

-- Check sub_packages for Photography packages
PRINT '';
PRINT '--- Checking sub_packages for Photography packages ---';

-- Get Photography package IDs
DECLARE @photographyPackageIds TABLE (id INT);
INSERT INTO @photographyPackageIds
SELECT id FROM packages WHERE category = 'Photography';

-- Check if sub_packages exist for Photography packages
DECLARE @subPackageCount INT;
SELECT @subPackageCount = COUNT(*) 
FROM sub_packages sp
INNER JOIN @photographyPackageIds p ON sp.package_id = p.id;

PRINT '📊 Sub-packages for Photography packages: ' + CAST(@subPackageCount AS VARCHAR(10));

-- If no sub_packages found, add them
IF @subPackageCount = 0
BEGIN
    PRINT '❌ No sub-packages found for Photography packages. Adding sample sub-packages...';
    
    -- Add sub-packages for each Photography package
    INSERT INTO sub_packages (package_id, sub_package_name, price, description, duration, media) VALUES
    -- Basic Photography Package sub-packages
    ((SELECT id FROM packages WHERE package_name = 'Basic Photography Package'), 'Basic - Regular', 800.00, 'Basic photography with standard editing', '2 hours', ''),
    ((SELECT id FROM packages WHERE package_name = 'Basic Photography Package'), 'Basic - Premium', 1000.00, 'Basic photography with premium editing', '2 hours', ''),
    
    -- Standard Photography Package sub-packages
    ((SELECT id FROM packages WHERE package_name = 'Standard Photography Package'), 'Standard - Regular', 1200.00, 'Standard photography with standard editing', '3 hours', ''),
    ((SELECT id FROM packages WHERE package_name = 'Standard Photography Package'), 'Standard - Premium', 1500.00, 'Standard photography with premium editing', '3 hours', ''),
    
    -- Premium Photography Package sub-packages
    ((SELECT id FROM packages WHERE package_name = 'Premium Photography Package'), 'Premium - Regular', 1800.00, 'Premium photography with standard editing', '4 hours', ''),
    ((SELECT id FROM packages WHERE package_name = 'Premium Photography Package'), 'Premium - Deluxe', 2200.00, 'Premium photography with deluxe editing', '4 hours', ''),
    
    -- Wedding Photography Package sub-packages
    ((SELECT id FROM packages WHERE package_name = 'Wedding Photography Package'), 'Wedding - Basic', 3000.00, 'Full wedding coverage with basic editing', '8 hours', ''),
    ((SELECT id FROM packages WHERE package_name = 'Wedding Photography Package'), 'Wedding - Premium', 3500.00, 'Full wedding coverage with premium editing', '8 hours', ''),
    
    -- Event Photography Package sub-packages
    ((SELECT id FROM packages WHERE package_name = 'Event Photography Package'), 'Event - Standard', 2200.00, 'Event coverage with standard editing', '6 hours', ''),
    ((SELECT id FROM packages WHERE package_name = 'Event Photography Package'), 'Event - Premium', 2600.00, 'Event coverage with premium editing', '6 hours', '');
    
    PRINT '✅ Sample sub-packages for Photography packages added successfully!';
    
    -- Show the newly added sub-packages
    SELECT sp.id, sp.package_id, p.package_name, sp.sub_package_name, sp.price 
    FROM sub_packages sp
    INNER JOIN packages p ON sp.package_id = p.id
    WHERE p.category = 'Photography'
    ORDER BY sp.package_id, sp.id;
END
ELSE
BEGIN
    PRINT '✅ Sub-packages for Photography packages already exist';
    
    -- Show existing sub-packages
    SELECT sp.id, sp.package_id, p.package_name, sp.sub_package_name, sp.price 
    FROM sub_packages sp
    INNER JOIN packages p ON sp.package_id = p.id
    WHERE p.category = 'Photography'
    ORDER BY sp.package_id, sp.id;
END

-- Final verification
PRINT '';
PRINT '--- Final verification ---';
SELECT 
    (SELECT COUNT(*) FROM packages WHERE category = 'Photography') as photography_packages,
    (SELECT COUNT(*) FROM sub_packages sp INNER JOIN packages p ON sp.package_id = p.id WHERE p.category = 'Photography') as photography_sub_packages;

PRINT '=== PHOTOGRAPHY PACKAGES CHECK COMPLETE ===';
