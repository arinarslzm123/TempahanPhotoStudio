-- Add Photography Packages to Database
-- This script will add sample photography packages to the packages table

PRINT '=== ADDING PHOTOGRAPHY PACKAGES TO DATABASE ===';

-- Step 1: Check current packages
PRINT '--- Step 1: Current packages in database ---';

SELECT 
    id,
    package_name,
    event,
    category,
    duration
FROM packages 
ORDER BY id;

-- Step 2: Add Photography packages if they don't exist
PRINT '--- Step 2: Adding Photography packages ---';

-- Check if Photography packages already exist
IF NOT EXISTS (SELECT 1 FROM packages WHERE category = 'Photography')
BEGIN
    PRINT 'No Photography packages found, adding sample packages...';
    
    INSERT INTO packages (package_name, event, category, duration) VALUES
    ('Basic Photography Package', 'General', 'Photography', '2 hours'),
    ('Standard Photography Package', 'General', 'Photography', '3 hours'),
    ('Premium Photography Package', 'General', 'Photography', '4 hours'),
    ('Wedding Photography Package', 'Wedding', 'Photography', '8 hours'),
    ('Event Photography Package', 'Event', 'Photography', '6 hours'),
    ('Portrait Photography Package', 'Portrait', 'Photography', '1 hour'),
    ('Family Photography Package', 'Family', 'Photography', '2 hours'),
    ('Corporate Photography Package', 'Corporate', 'Photography', '4 hours');
    
    PRINT 'Added 8 Photography packages successfully';
END
ELSE
BEGIN
    PRINT 'Photography packages already exist in database';
END

-- Step 3: Add sub-packages for Photography packages
PRINT '--- Step 3: Adding sub-packages for Photography packages ---';

-- Get Photography package IDs
DECLARE @basic_id INT, @standard_id INT, @premium_id INT, @wedding_id INT;
DECLARE @event_id INT, @portrait_id INT, @family_id INT, @corporate_id INT;

SELECT @basic_id = id FROM packages WHERE package_name = 'Basic Photography Package';
SELECT @standard_id = id FROM packages WHERE package_name = 'Standard Photography Package';
SELECT @premium_id = id FROM packages WHERE package_name = 'Premium Photography Package';
SELECT @wedding_id = id FROM packages WHERE package_name = 'Wedding Photography Package';
SELECT @event_id = id FROM packages WHERE package_name = 'Event Photography Package';
SELECT @portrait_id = id FROM packages WHERE package_name = 'Portrait Photography Package';
SELECT @family_id = id FROM packages WHERE package_name = 'Family Photography Package';
SELECT @corporate_id = id FROM packages WHERE package_name = 'Corporate Photography Package';

PRINT 'Photography package IDs:';
PRINT 'Basic: ' + ISNULL(CAST(@basic_id AS VARCHAR(10)), 'NULL');
PRINT 'Standard: ' + ISNULL(CAST(@standard_id AS VARCHAR(10)), 'NULL');
PRINT 'Premium: ' + ISNULL(CAST(@premium_id AS VARCHAR(10)), 'NULL');
PRINT 'Wedding: ' + ISNULL(CAST(@wedding_id AS VARCHAR(10)), 'NULL');
PRINT 'Event: ' + ISNULL(CAST(@event_id AS VARCHAR(10)), 'NULL');
PRINT 'Portrait: ' + ISNULL(CAST(@portrait_id AS VARCHAR(10)), 'NULL');
PRINT 'Family: ' + ISNULL(CAST(@family_id AS VARCHAR(10)), 'NULL');
PRINT 'Corporate: ' + ISNULL(CAST(@corporate_id AS VARCHAR(10)), 'NULL');

-- Add sub-packages for each Photography package
IF @basic_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sub_packages WHERE package_id = @basic_id)
BEGIN
    INSERT INTO sub_packages (package_id, sub_package_name, duration, description, media) VALUES
    (@basic_id, 'Basic Standard', '2 hours', 'Standard basic photography session', '50 photos'),
    (@basic_id, 'Basic Premium', '2 hours', 'Premium basic photography session', '80 photos');
    PRINT 'Added sub-packages for Basic Photography Package';
END

IF @standard_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sub_packages WHERE package_id = @standard_id)
BEGIN
    INSERT INTO sub_packages (package_id, sub_package_name, duration, description, media) VALUES
    (@standard_id, 'Standard Regular', '3 hours', 'Regular standard photography session', '100 photos'),
    (@standard_id, 'Standard Premium', '3 hours', 'Premium standard photography session', '150 photos');
    PRINT 'Added sub-packages for Standard Photography Package';
END

IF @premium_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sub_packages WHERE package_id = @premium_id)
BEGIN
    INSERT INTO sub_packages (package_id, sub_package_name, duration, description, media) VALUES
    (@premium_id, 'Premium Standard', '4 hours', 'Standard premium photography session', '200 photos'),
    (@premium_id, 'Premium Deluxe', '4 hours', 'Deluxe premium photography session', '300 photos');
    PRINT 'Added sub-packages for Premium Photography Package';
END

IF @wedding_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sub_packages WHERE package_id = @wedding_id)
BEGIN
    INSERT INTO sub_packages (package_id, sub_package_name, duration, description, media) VALUES
    (@wedding_id, 'Wedding Basic', '8 hours', 'Basic wedding photography coverage', '300 photos'),
    (@wedding_id, 'Wedding Premium', '8 hours', 'Premium wedding photography coverage', '500 photos');
    PRINT 'Added sub-packages for Wedding Photography Package';
END

IF @event_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sub_packages WHERE package_id = @event_id)
BEGIN
    INSERT INTO sub_packages (package_id, sub_package_name, duration, description, media) VALUES
    (@event_id, 'Event Basic', '6 hours', 'Basic event photography coverage', '200 photos'),
    (@event_id, 'Event Premium', '6 hours', 'Premium event photography coverage', '300 photos');
    PRINT 'Added sub-packages for Event Photography Package';
END

IF @portrait_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sub_packages WHERE package_id = @portrait_id)
BEGIN
    INSERT INTO sub_packages (package_id, sub_package_name, duration, description, media) VALUES
    (@portrait_id, 'Portrait Basic', '1 hour', 'Basic portrait photography session', '20 photos'),
    (@portrait_id, 'Portrait Premium', '1 hour', 'Premium portrait photography session', '30 photos');
    PRINT 'Added sub-packages for Portrait Photography Package';
END

IF @family_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sub_packages WHERE package_id = @family_id)
BEGIN
    INSERT INTO sub_packages (package_id, sub_package_name, duration, description, media) VALUES
    (@family_id, 'Family Basic', '2 hours', 'Basic family photography session', '80 photos'),
    (@family_id, 'Family Premium', '2 hours', 'Premium family photography session', '120 photos');
    PRINT 'Added sub-packages for Family Photography Package';
END

IF @corporate_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sub_packages WHERE package_id = @corporate_id)
BEGIN
    INSERT INTO sub_packages (package_id, sub_package_name, duration, description, media) VALUES
    (@corporate_id, 'Corporate Basic', '4 hours', 'Basic corporate photography', '150 photos'),
    (@corporate_id, 'Corporate Premium', '4 hours', 'Premium corporate photography', '200 photos');
    PRINT 'Added sub-packages for Corporate Photography Package';
END

-- Step 4: Final verification
PRINT '--- Step 4: Final verification ---';

SELECT 
    p.id as package_id,
    p.package_name,
    p.event,
    p.category,
    p.duration,
    COUNT(sp.id) as sub_package_count
FROM packages p
LEFT JOIN sub_packages sp ON p.id = sp.package_id
WHERE p.category = 'Photography'
GROUP BY p.id, p.package_name, p.event, p.category, p.duration
ORDER BY p.id;

SELECT 'SUB-PACKAGES FOR PHOTOGRAPHY:' as Info;
SELECT 
    sp.id as sub_package_id,
    sp.package_id as parent_package_id,
    sp.sub_package_name,
    sp.duration,
    p.package_name as parent_package_name
FROM sub_packages sp
LEFT JOIN packages p ON sp.package_id = p.id
WHERE p.category = 'Photography'
ORDER BY sp.package_id, sp.id;

-- Summary
SELECT 'SUMMARY:' as Info;
SELECT 
    (SELECT COUNT(*) FROM packages WHERE category = 'Photography') as photography_packages,
    (SELECT COUNT(*) FROM sub_packages sp JOIN packages p ON sp.package_id = p.id WHERE p.category = 'Photography') as photography_sub_packages;

PRINT '=== PHOTOGRAPHY PACKAGES ADDITION COMPLETE ===';
