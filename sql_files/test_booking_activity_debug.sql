-- =============================================
-- TEST BOOKING ACTIVITY DEBUG FLOW
-- =============================================
-- This script helps debug the BookingActivity package/sub-package selection issue

USE TempahanPhotoStudio;
GO

-- =============================================
-- 1. CHECK CURRENT PACKAGES AND SUB-PACKAGES
-- =============================================
SELECT 
    'CURRENT PACKAGES' as Info,
    id,
    package_name,
    category,
    duration,
    'Package ID: ' + CAST(id AS VARCHAR(10)) as package_id_display
FROM packages
ORDER BY id;

SELECT 
    'CURRENT SUB-PACKAGES' as Info,
    id,
    package_id,
    sub_package_name,
    price,
    duration,
    'Sub-Package ID: ' + CAST(id AS VARCHAR(10)) as sub_package_id_display,
    'Parent Package ID: ' + CAST(package_id AS VARCHAR(10)) as parent_package_id_display
FROM sub_packages
ORDER BY package_id, id;

-- =============================================
-- 2. TEST INTENT DATA SIMULATION
-- =============================================
-- Simulate data that should be passed from PhotographyPackageActivity
SELECT 
    'INTENT DATA FROM PHOTOGRAPHY PACKAGE ACTIVITY' as Info,
    'PACKAGE_ID' as intent_key,
    CAST(id AS VARCHAR(10)) as intent_value,
    'Should be passed to BookingActivity' as description
FROM packages
WHERE id = 1

UNION ALL

SELECT 
    'INTENT DATA FROM PHOTOGRAPHY PACKAGE ACTIVITY' as Info,
    'PACKAGE_NAME' as intent_key,
    package_name as intent_value,
    'Should be passed to BookingActivity' as description
FROM packages
WHERE id = 1

UNION ALL

SELECT 
    'INTENT DATA FROM PHOTOGRAPHY PACKAGE ACTIVITY' as Info,
    'PACKAGE_CATEGORY' as intent_key,
    category as intent_value,
    'Should be passed to BookingActivity' as description
FROM packages
WHERE id = 1;

-- =============================================
-- 3. TEST INTENT DATA FROM DETAIL SUB-PACKAGE ACTIVITY
-- =============================================
-- Simulate data that should be passed from DetailSubPackageActivity
SELECT 
    'INTENT DATA FROM DETAIL SUB-PACKAGE ACTIVITY' as Info,
    'SUB_PACKAGE_ID' as intent_key,
    CAST(sp.id AS VARCHAR(10)) as intent_value,
    'Should be passed to BookingActivity' as description
FROM sub_packages sp
WHERE sp.id = 1

UNION ALL

SELECT 
    'INTENT DATA FROM DETAIL SUB-PACKAGE ACTIVITY' as Info,
    'SUB_PACKAGE_NAME' as intent_key,
    sp.sub_package_name as intent_value,
    'Should be passed to BookingActivity' as description
FROM sub_packages sp
WHERE sp.id = 1

UNION ALL

SELECT 
    'INTENT DATA FROM DETAIL SUB-PACKAGE ACTIVITY' as Info,
    'SUB_PACKAGE_PRICE' as intent_key,
    CAST(sp.price AS VARCHAR(10)) as intent_value,
    'Should be passed to BookingActivity' as description
FROM sub_packages sp
WHERE sp.id = 1

UNION ALL

SELECT 
    'INTENT DATA FROM DETAIL SUB-PACKAGE ACTIVITY' as Info,
    'PARENT_PACKAGE_ID' as intent_key,
    CAST(sp.package_id AS VARCHAR(10)) as intent_value,
    'Should be passed to BookingActivity' as description
FROM sub_packages sp
WHERE sp.id = 1;

-- =============================================
-- 4. TEST COMPLETE FLOW SCENARIOS
-- =============================================
-- Scenario 1: User selects Package 1 from PhotographyPackageActivity
SELECT 
    'SCENARIO 1 - PACKAGE SELECTION FROM PHOTOGRAPHY PACKAGE ACTIVITY' as Info,
    p.id as package_id,
    p.package_name as selected_package,
    p.category,
    'User clicks package → PhotographyPackageActivity → BookingActivity' as flow,
    'Package spinner should show: ' + p.package_name as expected_result,
    'Sub-package spinner should show: Pilih Sub Package' as expected_sub_result
FROM packages p
WHERE p.id = 1;

-- Scenario 2: User selects Sub-Package 1 from DetailSubPackageActivity
SELECT 
    'SCENARIO 2 - SUB-PACKAGE SELECTION FROM DETAIL SUB-PACKAGE ACTIVITY' as Info,
    p.id as package_id,
    p.package_name as parent_package,
    sp.id as sub_package_id,
    sp.sub_package_name as selected_sub_package,
    sp.price,
    'User clicks sub-package → DetailSubPackageActivity → BookingActivity' as flow,
    'Package spinner should show: ' + p.package_name as expected_package_result,
    'Sub-package spinner should show: ' + sp.sub_package_name + ' - RM ' + CAST(sp.price AS VARCHAR(10)) as expected_sub_result
FROM packages p
JOIN sub_packages sp ON p.id = sp.package_id
WHERE sp.id = 1;

-- =============================================
-- 5. DEBUG BOOKING ACTIVITY EXPECTED BEHAVIOR
-- =============================================
-- What BookingActivity should display for each scenario
SELECT 
    'BOOKING ACTIVITY EXPECTED BEHAVIOR' as Info,
    'Scenario 1 - Package Selection' as scenario,
    'Package Spinner' as spinner,
    p.package_name as display_text,
    'Pre-selected' as status
FROM packages p
WHERE p.id = 1

UNION ALL

SELECT 
    'BOOKING ACTIVITY EXPECTED BEHAVIOR' as Info,
    'Scenario 1 - Package Selection' as scenario,
    'Sub-Package Spinner' as spinner,
    'Pilih Sub Package' as display_text,
    'Default option' as status

UNION ALL

SELECT 
    'BOOKING ACTIVITY EXPECTED BEHAVIOR' as Info,
    'Scenario 2 - Sub-Package Selection' as scenario,
    'Package Spinner' as spinner,
    p.package_name as display_text,
    'Pre-selected' as status
FROM packages p
JOIN sub_packages sp ON p.id = sp.package_id
WHERE sp.id = 1

UNION ALL

SELECT 
    'BOOKING ACTIVITY EXPECTED BEHAVIOR' as Info,
    'Scenario 2 - Sub-Package Selection' as scenario,
    'Sub-Package Spinner' as spinner,
    sp.sub_package_name + ' - RM ' + CAST(sp.price AS VARCHAR(10)) as display_text,
    'Pre-selected' as status
FROM sub_packages sp
WHERE sp.id = 1;

-- =============================================
-- 6. TEST DATABASE CONNECTION METHODS
-- =============================================
-- Test methods that BookingActivity uses
SELECT 
    'DATABASE CONNECTION METHODS TEST' as Info,
    'getAllPackages()' as method_name,
    COUNT(*) as package_count,
    'Should return all packages' as description
FROM packages

UNION ALL

SELECT 
    'DATABASE CONNECTION METHODS TEST' as Info,
    'getSubPackagesByPackageId(1)' as method_name,
    COUNT(*) as sub_package_count,
    'Should return sub-packages for package 1' as description
FROM sub_packages
WHERE package_id = 1;

-- =============================================
-- 7. VERIFY INTENT DATA INTEGRITY
-- =============================================
-- Check if all required data exists for Intent passing
SELECT 
    'INTENT DATA INTEGRITY CHECK' as Info,
    p.id as package_id,
    p.package_name,
    p.category,
    p.duration,
    p.description,
    'All package data available for Intent' as status
FROM packages p
WHERE p.id = 1

UNION ALL

SELECT 
    'INTENT DATA INTEGRITY CHECK' as Info,
    sp.id as sub_package_id,
    sp.sub_package_name,
    sp.duration,
    sp.description,
    CAST(sp.price AS VARCHAR(10)) as price,
    'All sub-package data available for Intent' as status
FROM sub_packages sp
WHERE sp.id = 1;

-- =============================================
-- 8. TEST SPINNER ADAPTER DATA
-- =============================================
-- Simulate what spinner adapters should contain
SELECT 
    'PACKAGE SPINNER ADAPTER DATA' as Info,
    'Package Names' as data_type,
    package_name as display_text,
    'Should be in package spinner' as description
FROM packages
ORDER BY id;

SELECT 
    'SUB-PACKAGE SPINNER ADAPTER DATA' as Info,
    'Sub-Package Names with Price' as data_type,
    sub_package_name + ' - RM ' + CAST(price AS VARCHAR(10)) as display_text,
    'Should be in sub-package spinner' as description
FROM sub_packages
ORDER BY package_id, id;

-- =============================================
-- 9. DEBUG LOGGING SIMULATION
-- =============================================
-- Simulate debug output that should appear in logs
SELECT 
    'DEBUG LOGGING SIMULATION' as Info,
    'DEBUG - ========== HANDLING INTENT DATA ==========' as log_message,
    'Should appear in BookingActivity logs' as description

UNION ALL

SELECT 
    'DEBUG LOGGING SIMULATION' as Info,
    'DEBUG - PACKAGE_ID: true' as log_message,
    'Should appear if package data is passed' as description

UNION ALL

SELECT 
    'DEBUG LOGGING SIMULATION' as Info,
    'DEBUG - SUB_PACKAGE_ID: true' as log_message,
    'Should appear if sub-package data is passed' as description

UNION ALL

SELECT 
    'DEBUG LOGGING SIMULATION' as Info,
    'DEBUG - Package spinner set with: [Package Name]' as log_message,
    'Should appear when package spinner is updated' as description

UNION ALL

SELECT 
    'DEBUG LOGGING SIMULATION' as Info,
    'DEBUG - Sub-package spinner set with: [Sub-Package Name]' as log_message,
    'Should appear when sub-package spinner is updated' as description;

-- =============================================
-- 10. FINAL VERIFICATION
-- =============================================
-- Final check of all data and expected behavior
SELECT 
    'FINAL VERIFICATION' as Info,
    'Package 1' as test_case,
    p.package_name as package_name,
    COUNT(sp.id) as sub_package_count,
    'Package should be pre-selected in BookingActivity' as expected_behavior
FROM packages p
LEFT JOIN sub_packages sp ON p.id = sp.package_id
WHERE p.id = 1
GROUP BY p.id, p.package_name

UNION ALL

SELECT 
    'FINAL VERIFICATION' as Info,
    'Sub-Package 1' as test_case,
    sp.sub_package_name as sub_package_name,
    1 as parent_package_id,
    'Both package and sub-package should be pre-selected in BookingActivity' as expected_behavior
FROM sub_packages sp
WHERE sp.id = 1;

PRINT 'BookingActivity debug test completed!';
PRINT 'Check the results above to verify:';
PRINT '1. Current packages and sub-packages data';
PRINT '2. Intent data simulation from PhotographyPackageActivity';
PRINT '3. Intent data simulation from DetailSubPackageActivity';
PRINT '4. Complete flow scenarios';
PRINT '5. BookingActivity expected behavior';
PRINT '6. Database connection methods test';
PRINT '7. Intent data integrity check';
PRINT '8. Spinner adapter data simulation';
PRINT '9. Debug logging simulation';
PRINT '10. Final verification';
PRINT '';
PRINT 'If the issue persists, check the Android logs for the debug messages';
PRINT 'and verify that Intent data is being passed correctly between activities.';
