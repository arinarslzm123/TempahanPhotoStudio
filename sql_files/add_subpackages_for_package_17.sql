-- Add sub-packages for Package ID 17 (Basic Photography Package)
-- This package exists but has no sub-packages

PRINT '=== ADDING SUB-PACKAGES FOR PACKAGE ID 17 ===';

-- Step 1: Check current state of Package ID 17
PRINT '--- Step 1: Check Package ID 17 ---';

SELECT 
    id,
    package_name,
    event,
    category,
    price,
    duration,
    description
FROM packages 
WHERE id = 17;

-- Step 2: Check if Package ID 17 has any sub-packages
PRINT '--- Step 2: Check existing sub-packages for Package ID 17 ---';

SELECT 
    id,
    package_id,
    sub_package_name,
    price,
    duration,
    description
FROM sub_packages 
WHERE package_id = 17;

-- Step 3: Add sub-packages for Package ID 17
PRINT '--- Step 3: Adding sub-packages for Package ID 17 ---';

-- Add sub-packages for Basic Photography Package
INSERT INTO sub_packages (package_id, sub_package_name, price, duration, description, media) VALUES
(17, 'Basic Photography - Standard', 600.00, '2 hours', 'Standard photography session with 50 edited photos', '50 photos'),
(17, 'Basic Photography - Premium', 800.00, '3 hours', 'Premium photography session with 80 edited photos', '80 photos'),
(17, 'Basic Photography - Deluxe', 1000.00, '4 hours', 'Deluxe photography session with 100 edited photos', '100 photos');

PRINT 'Added 3 sub-packages for Package ID 17 (Basic Photography Package)';

-- Step 4: Verify the addition
PRINT '--- Step 4: Verify sub-packages added ---';

SELECT 
    sp.id,
    sp.package_id,
    sp.sub_package_name,
    sp.price,
    sp.duration,
    sp.description,
    p.package_name as parent_package_name
FROM sub_packages sp
LEFT JOIN packages p ON sp.package_id = p.id
WHERE sp.package_id = 17
ORDER BY sp.id;

-- Step 5: Check all packages without sub-packages
PRINT '--- Step 5: Check other packages without sub-packages ---';

SELECT 
    p.id,
    p.package_name,
    p.event,
    p.category,
    COUNT(sp.id) as sub_package_count
FROM packages p
LEFT JOIN sub_packages sp ON p.id = sp.package_id
GROUP BY p.id, p.package_name, p.event, p.category
HAVING COUNT(sp.id) = 0
ORDER BY p.id;

-- Step 6: Add sub-packages for any other packages without sub-packages
PRINT '--- Step 6: Adding sub-packages for other packages without sub-packages ---';

-- Get packages without sub-packages (excluding ID 17 which we already handled)
DECLARE @package_id INT;
DECLARE package_cursor CURSOR FOR 
    SELECT p.id 
    FROM packages p
    LEFT JOIN sub_packages sp ON p.id = sp.package_id
    WHERE sp.id IS NULL AND p.id != 17;

OPEN package_cursor;
FETCH NEXT FROM package_cursor INTO @package_id;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Add basic sub-packages for each package without sub-packages
    INSERT INTO sub_packages (package_id, sub_package_name, price, duration, description, media) VALUES
    (@package_id, 'Standard Package', 500.00, '2 hours', 'Standard package for ' + (SELECT package_name FROM packages WHERE id = @package_id), '50 photos'),
    (@package_id, 'Premium Package', 700.00, '3 hours', 'Premium package for ' + (SELECT package_name FROM packages WHERE id = @package_id), '80 photos'),
    (@package_id, 'Deluxe Package', 900.00, '4 hours', 'Deluxe package for ' + (SELECT package_name FROM packages WHERE id = @package_id), '100 photos');
    
    PRINT 'Added sub-packages for Package ID: ' + CAST(@package_id AS VARCHAR(10));
    
    FETCH NEXT FROM package_cursor INTO @package_id;
END

CLOSE package_cursor;
DEALLOCATE package_cursor;

-- Step 7: Final verification
PRINT '--- Step 7: Final verification ---';

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

-- Summary
SELECT 'SUMMARY:' as Info;
SELECT 
    (SELECT COUNT(*) FROM packages) as total_packages,
    (SELECT COUNT(*) FROM sub_packages) as total_sub_packages,
    (SELECT COUNT(*) FROM packages p WHERE EXISTS (SELECT 1 FROM sub_packages sp WHERE sp.package_id = p.id)) as packages_with_sub_packages;

PRINT '=== SUB-PACKAGES ADDITION COMPLETE ===';
