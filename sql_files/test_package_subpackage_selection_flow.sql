-- =============================================
-- TEST PACKAGE AND SUB-PACKAGE SELECTION FLOW
-- =============================================
-- This script tests the complete flow from package selection to booking

USE TempahanPhotoStudio;
GO

-- =============================================
-- 1. CHECK PACKAGES TABLE
-- =============================================
SELECT 
    'PACKAGES TABLE' as Info,
    id,
    package_name,
    event,
    duration,
    category,
    description,
    'Package ID: ' + CAST(id AS VARCHAR(10)) as package_id_display
FROM packages
ORDER BY id;

-- =============================================
-- 2. CHECK SUB-PACKAGES TABLE
-- =============================================
SELECT 
    'SUB-PACKAGES TABLE' as Info,
    id,
    package_id,
    sub_package_name,
    price,
    duration,
    description,
    media,
    'Sub-Package ID: ' + CAST(id AS VARCHAR(10)) as sub_package_id_display,
    'Parent Package ID: ' + CAST(package_id AS VARCHAR(10)) as parent_package_id_display
FROM sub_packages
ORDER BY package_id, id;

-- =============================================
-- 3. TEST PACKAGE-SUBPACKAGE RELATIONSHIPS
-- =============================================
SELECT 
    'PACKAGE-SUBPACKAGE RELATIONSHIPS' as Info,
    p.id as package_id,
    p.package_name,
    p.category,
    sp.id as sub_package_id,
    sp.sub_package_name,
    sp.price,
    sp.duration,
    'Package: ' + p.package_name + ' → Sub-Package: ' + sp.sub_package_name as relationship
FROM packages p
LEFT JOIN sub_packages sp ON p.id = sp.package_id
ORDER BY p.id, sp.id;

-- =============================================
-- 4. TEST USER SELECTION SCENARIOS
-- =============================================
-- Scenario 1: User selects Photography package
SELECT 
    'SCENARIO 1 - PHOTOGRAPHY PACKAGE SELECTION' as Info,
    id,
    package_name,
    category,
    duration,
    'User selects this package' as user_action
FROM packages
WHERE category = 'Photography'
ORDER BY id;

-- Scenario 2: User selects Videography package
SELECT 
    'SCENARIO 2 - VIDEOGRAPHY PACKAGE SELECTION' as Info,
    id,
    package_name,
    category,
    duration,
    'User selects this package' as user_action
FROM packages
WHERE category = 'Videography'
ORDER BY id;

-- =============================================
-- 5. TEST SUB-PACKAGE SELECTION FOR EACH PACKAGE
-- =============================================
-- For each package, show available sub-packages
SELECT 
    'SUB-PACKAGE SELECTION FOR PACKAGE 1' as Info,
    sp.id as sub_package_id,
    sp.sub_package_name,
    sp.price,
    sp.duration,
    sp.description,
    'User can select this sub-package' as user_action
FROM sub_packages sp
WHERE sp.package_id = 1
ORDER BY sp.id;

SELECT 
    'SUB-PACKAGE SELECTION FOR PACKAGE 2' as Info,
    sp.id as sub_package_id,
    sp.sub_package_name,
    sp.price,
    sp.duration,
    sp.description,
    'User can select this sub-package' as user_action
FROM sub_packages sp
WHERE sp.package_id = 2
ORDER BY sp.id;

SELECT 
    'SUB-PACKAGE SELECTION FOR PACKAGE 3' as Info,
    sp.id as sub_package_id,
    sp.sub_package_name,
    sp.price,
    sp.duration,
    sp.description,
    'User can select this sub-package' as user_action
FROM sub_packages sp
WHERE sp.package_id = 3
ORDER BY sp.id;

-- =============================================
-- 6. TEST COMPLETE BOOKING FLOW
-- =============================================
-- Simulate user selecting Package 1, Sub-Package 1
SELECT 
    'COMPLETE BOOKING FLOW - PACKAGE 1, SUB-PACKAGE 1' as Info,
    p.id as package_id,
    p.package_name as selected_package,
    p.category,
    p.duration as package_duration,
    sp.id as sub_package_id,
    sp.sub_package_name as selected_sub_package,
    sp.price as sub_package_price,
    sp.duration as sub_package_duration,
    'User will see both selections pre-filled in BookingActivity' as result
FROM packages p
JOIN sub_packages sp ON p.id = sp.package_id
WHERE p.id = 1 AND sp.id = 1;

-- Simulate user selecting Package 2, Sub-Package 3
SELECT 
    'COMPLETE BOOKING FLOW - PACKAGE 2, SUB-PACKAGE 3' as Info,
    p.id as package_id,
    p.package_name as selected_package,
    p.category,
    p.duration as package_duration,
    sp.id as sub_package_id,
    sp.sub_package_name as selected_sub_package,
    sp.price as sub_package_price,
    sp.duration as sub_package_duration,
    'User will see both selections pre-filled in BookingActivity' as result
FROM packages p
JOIN sub_packages sp ON p.id = sp.package_id
WHERE p.id = 2 AND sp.id = 3;

-- =============================================
-- 7. TEST DATA INTEGRITY
-- =============================================
-- Check for orphaned sub-packages
SELECT 
    'ORPHANED SUB-PACKAGES CHECK' as Info,
    sp.id,
    sp.package_id,
    sp.sub_package_name,
    'This sub-package has no parent package' as issue
FROM sub_packages sp
LEFT JOIN packages p ON sp.package_id = p.id
WHERE p.id IS NULL;

-- Check for packages without sub-packages
SELECT 
    'PACKAGES WITHOUT SUB-PACKAGES' as Info,
    p.id,
    p.package_name,
    p.category,
    'This package has no sub-packages' as note
FROM packages p
LEFT JOIN sub_packages sp ON p.id = sp.package_id
WHERE sp.id IS NULL;

-- =============================================
-- 8. TEST INTENT DATA FLOW
-- =============================================
-- Simulate the data that would be passed via Intent
SELECT 
    'INTENT DATA FLOW SIMULATION' as Info,
    'Package Data' as data_type,
    'PACKAGE_ID' as intent_key,
    CAST(p.id AS VARCHAR(10)) as intent_value,
    'Passed from PhotographyPackageActivity to BookingActivity' as source
FROM packages p
WHERE p.id = 1

UNION ALL

SELECT 
    'INTENT DATA FLOW SIMULATION' as Info,
    'Package Data' as data_type,
    'PACKAGE_NAME' as intent_key,
    p.package_name as intent_value,
    'Passed from PhotographyPackageActivity to BookingActivity' as source
FROM packages p
WHERE p.id = 1

UNION ALL

SELECT 
    'INTENT DATA FLOW SIMULATION' as Info,
    'Sub-Package Data' as data_type,
    'SUB_PACKAGE_ID' as intent_key,
    CAST(sp.id AS VARCHAR(10)) as intent_value,
    'Passed from DetailSubPackageActivity to BookingActivity' as source
FROM sub_packages sp
WHERE sp.id = 1

UNION ALL

SELECT 
    'INTENT DATA FLOW SIMULATION' as Info,
    'Sub-Package Data' as data_type,
    'SUB_PACKAGE_NAME' as intent_key,
    sp.sub_package_name as intent_value,
    'Passed from DetailSubPackageActivity to BookingActivity' as source
FROM sub_packages sp
WHERE sp.id = 1;

-- =============================================
-- 9. VERIFY BOOKING ACTIVITY PRE-FILLING
-- =============================================
-- Test what BookingActivity should display
SELECT 
    'BOOKING ACTIVITY PRE-FILLING TEST' as Info,
    'Package Spinner' as spinner_name,
    p.package_name as display_text,
    'Should be pre-selected' as status
FROM packages p
WHERE p.id = 1

UNION ALL

SELECT 
    'BOOKING ACTIVITY PRE-FILLING TEST' as Info,
    'Sub-Package Spinner' as spinner_name,
    sp.sub_package_name + ' - RM ' + CAST(sp.price AS VARCHAR(10)) as display_text,
    'Should be pre-selected' as status
FROM sub_packages sp
WHERE sp.id = 1;

-- =============================================
-- 10. FINAL VERIFICATION
-- =============================================
-- Final check of all data
SELECT 
    'FINAL VERIFICATION' as Info,
    p.id as package_id,
    p.package_name,
    p.category,
    COUNT(sp.id) as sub_package_count,
    'Package has ' + CAST(COUNT(sp.id) AS VARCHAR(10)) + ' sub-packages' as summary
FROM packages p
LEFT JOIN sub_packages sp ON p.id = sp.package_id
GROUP BY p.id, p.package_name, p.category
ORDER BY p.id;

PRINT 'Package and Sub-Package selection flow test completed!';
PRINT 'Check the results above to verify:';
PRINT '1. Packages table structure and data';
PRINT '2. Sub-packages table structure and data';
PRINT '3. Package-subpackage relationships';
PRINT '4. User selection scenarios';
PRINT '5. Sub-package selection for each package';
PRINT '6. Complete booking flow simulation';
PRINT '7. Data integrity checks';
PRINT '8. Intent data flow simulation';
PRINT '9. Booking activity pre-filling test';
PRINT '10. Final verification';
