-- Test database connection and data
-- This script will test if database is accessible and has correct data

PRINT '=== TESTING DATABASE CONNECTION AND DATA ===';

-- Test 1: Check if packages table exists and has data
PRINT '--- Test 1: Packages table ---';
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'packages')
BEGIN
    PRINT '✅ Packages table exists';
    SELECT COUNT(*) as package_count FROM packages;
    
    -- Show first 5 packages
    SELECT TOP 5 id, package_name, event, category, duration, price
    FROM packages 
    ORDER BY id;
END
ELSE
BEGIN
    PRINT '❌ Packages table does not exist';
END

-- Test 2: Check if sub_packages table exists and has data
PRINT '--- Test 2: Sub-packages table ---';
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'sub_packages')
BEGIN
    PRINT '✅ Sub-packages table exists';
    SELECT COUNT(*) as sub_package_count FROM sub_packages;
    
    -- Show first 5 sub-packages
    SELECT TOP 5 id, package_id, sub_package_name, price, duration
    FROM sub_packages 
    ORDER BY id;
END
ELSE
BEGIN
    PRINT '❌ Sub-packages table does not exist';
END

-- Test 3: Check Photography packages specifically
PRINT '--- Test 3: Photography packages ---';
SELECT COUNT(*) as photography_package_count 
FROM packages 
WHERE category = 'Photography';

IF (SELECT COUNT(*) FROM packages WHERE category = 'Photography') > 0
BEGIN
    PRINT '✅ Photography packages exist';
    SELECT id, package_name, event, category, duration, price
    FROM packages 
    WHERE category = 'Photography'
    ORDER BY id;
END
ELSE
BEGIN
    PRINT '❌ No Photography packages found';
END

-- Test 4: Check sub-packages for Photography packages
PRINT '--- Test 4: Sub-packages for Photography packages ---';
SELECT COUNT(*) as photography_sub_package_count
FROM sub_packages sp
JOIN packages p ON sp.package_id = p.id
WHERE p.category = 'Photography';

IF (SELECT COUNT(*) FROM sub_packages sp JOIN packages p ON sp.package_id = p.id WHERE p.category = 'Photography') > 0
BEGIN
    PRINT '✅ Sub-packages for Photography packages exist';
    SELECT sp.id, sp.package_id, p.package_name, sp.sub_package_name, sp.price
    FROM sub_packages sp
    JOIN packages p ON sp.package_id = p.id
    WHERE p.category = 'Photography'
    ORDER BY sp.id;
END
ELSE
BEGIN
    PRINT '❌ No sub-packages found for Photography packages';
END

-- Test 5: Check for any Wedding packages (that might be causing confusion)
PRINT '--- Test 5: Wedding packages check ---';
SELECT COUNT(*) as wedding_package_count
FROM packages 
WHERE event = 'Wedding' OR category = 'Wedding';

IF (SELECT COUNT(*) FROM packages WHERE event = 'Wedding' OR category = 'Wedding') > 0
BEGIN
    PRINT '⚠️ Found Wedding packages (might be causing confusion)';
    SELECT id, package_name, event, category, duration, price
    FROM packages 
    WHERE event = 'Wedding' OR category = 'Wedding'
    ORDER BY id;
END
ELSE
BEGIN
    PRINT '✅ No confusing Wedding packages found';
END

PRINT '=== DATABASE CONNECTION AND DATA TEST COMPLETE ===';