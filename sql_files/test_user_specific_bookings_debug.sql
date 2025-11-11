-- =============================================
-- TEST USER-SPECIFIC BOOKINGS DEBUG
-- =============================================
-- This script helps debug why users can still see other users' bookings

USE TempahanPhotoStudio;
GO

-- =============================================
-- 1. CHECK CURRENT USERS AND THEIR ROLES
-- =============================================
SELECT 
    'CURRENT USERS AND ROLES' as Info,
    id as user_id,
    name as user_name,
    email,
    role,
    phone_number,
    'User should only see their own bookings' as description
FROM users
ORDER BY id;

-- =============================================
-- 2. CHECK CURRENT BOOKINGS AND THEIR USERS
-- =============================================
SELECT 
    'CURRENT BOOKINGS AND USERS' as Info,
    b.id as booking_id,
    b.user_id,
    u.name as user_name,
    u.role as user_role,
    b.status,
    b.total_amount,
    b.created_at,
    'This booking belongs to user ' + CAST(b.user_id AS VARCHAR(10)) as ownership
FROM bookings b
LEFT JOIN users u ON b.user_id = u.id
ORDER BY b.user_id, b.created_at DESC;

-- =============================================
-- 3. TEST USER-SPECIFIC QUERIES (SIMULATE APP BEHAVIOR)
-- =============================================
-- Test what the app should return for each user
SELECT 
    'APP SIMULATION - User ID 1 Bookings' as Info,
    b.id as booking_id,
    b.user_id,
    u.name as user_name,
    u.role as user_role,
    b.status,
    b.total_amount,
    'getBookingsByUserId(1) should return these' as description
FROM bookings b
LEFT JOIN users u ON b.user_id = u.id
WHERE b.user_id = 1
ORDER BY b.created_at DESC;

SELECT 
    'APP SIMULATION - User ID 2 Bookings' as Info,
    b.id as booking_id,
    b.user_id,
    u.name as user_name,
    u.role as user_role,
    b.status,
    b.total_amount,
    'getBookingsByUserId(2) should return these' as description
FROM bookings b
LEFT JOIN users u ON b.user_id = u.id
WHERE b.user_id = 2
ORDER BY b.created_at DESC;

SELECT 
    'APP SIMULATION - User ID 3 Bookings' as Info,
    b.id as booking_id,
    b.user_id,
    u.name as user_name,
    u.role as user_role,
    b.status,
    b.total_amount,
    'getBookingsByUserId(3) should return these' as description
FROM bookings b
LEFT JOIN users u ON b.user_id = u.id
WHERE b.user_id = 3
ORDER BY b.created_at DESC;

-- =============================================
-- 4. TEST ADMIN VIEW (Should see all)
-- =============================================
SELECT 
    'APP SIMULATION - Admin View (All Bookings)' as Info,
    b.id as booking_id,
    b.user_id,
    u.name as user_name,
    u.role as user_role,
    b.status,
    b.total_amount,
    'getAllBookings() should return these' as description
FROM bookings b
LEFT JOIN users u ON b.user_id = u.id
ORDER BY b.created_at DESC;

-- =============================================
-- 5. CHECK FOR DATA INTEGRITY ISSUES
-- =============================================
-- Check if there are bookings with invalid user_id
SELECT 
    'DATA INTEGRITY CHECK' as Info,
    b.id as booking_id,
    b.user_id,
    u.name as user_name,
    CASE 
        WHEN u.id IS NULL THEN 'ERROR: Booking has invalid user_id'
        WHEN u.role IS NULL THEN 'WARNING: User has no role assigned'
        ELSE 'OK: Valid user reference'
    END as integrity_status
FROM bookings b
LEFT JOIN users u ON b.user_id = u.id
ORDER BY b.id;

-- =============================================
-- 6. TEST ROLE-BASED ACCESS CONTROL
-- =============================================
-- Test what each role should see
SELECT 
    'ROLE-BASED ACCESS CONTROL' as Info,
    u.id as user_id,
    u.name as user_name,
    u.role as user_role,
    COUNT(b.id) as booking_count,
    CASE 
        WHEN u.role = 'Admin' THEN 'Should see all bookings from all users'
        WHEN u.role = 'User' THEN 'Should only see own bookings'
        WHEN u.role IS NULL THEN 'ERROR: No role assigned'
        ELSE 'Unknown role'
    END as expected_behavior
FROM users u
LEFT JOIN bookings b ON u.id = b.user_id
GROUP BY u.id, u.name, u.role
ORDER BY u.id;

-- =============================================
-- 7. SIMULATE ANDROID APP SCENARIOS
-- =============================================
-- Scenario 1: User 1 logs in and views history
SELECT 
    'SCENARIO 1 - USER 1 LOGIN' as Info,
    'User ID: 1' as user_id,
    'Role: ' + ISNULL(u.role, 'NULL') as user_role,
    COUNT(b.id) as bookings_visible,
    'Should only see ' + CAST(COUNT(b.id) AS VARCHAR(10)) + ' bookings' as expected_result
FROM users u
LEFT JOIN bookings b ON u.id = b.user_id
WHERE u.id = 1
GROUP BY u.id, u.role;

-- Scenario 2: User 2 logs in and views history
SELECT 
    'SCENARIO 2 - USER 2 LOGIN' as Info,
    'User ID: 2' as user_id,
    'Role: ' + ISNULL(u.role, 'NULL') as user_role,
    COUNT(b.id) as bookings_visible,
    'Should only see ' + CAST(COUNT(b.id) AS VARCHAR(10)) + ' bookings' as expected_result
FROM users u
LEFT JOIN bookings b ON u.id = b.user_id
WHERE u.id = 2
GROUP BY u.id, u.role;

-- Scenario 3: Admin logs in and views history
SELECT 
    'SCENARIO 3 - ADMIN LOGIN' as Info,
    'User ID: Any' as user_id,
    'Role: Admin' as user_role,
    COUNT(b.id) as bookings_visible,
    'Should see all ' + CAST(COUNT(b.id) AS VARCHAR(10)) + ' bookings' as expected_result
FROM bookings b;

-- =============================================
-- 8. CHECK FOR HARDCODED VALUES
-- =============================================
-- Check if there are any hardcoded user IDs in the database
SELECT 
    'HARDCODED VALUES CHECK' as Info,
    'Current bookings user_id distribution' as description,
    user_id,
    COUNT(*) as count,
    'Check if these match actual user IDs' as note
FROM bookings
GROUP BY user_id
ORDER BY user_id;

-- =============================================
-- 9. TEST DATABASE CONNECTION METHODS
-- =============================================
-- Test the exact queries that the app uses
SELECT 
    'TEST getBookingsByUserId(1)' as Info,
    COUNT(*) as result_count,
    'Should return bookings for user ID 1 only' as description
FROM bookings
WHERE user_id = 1;

SELECT 
    'TEST getBookingsByUserId(2)' as Info,
    COUNT(*) as result_count,
    'Should return bookings for user ID 2 only' as description
FROM bookings
WHERE user_id = 2;

SELECT 
    'TEST getBookingsByUserId(3)' as Info,
    COUNT(*) as result_count,
    'Should return bookings for user ID 3 only' as description
FROM bookings
WHERE user_id = 3;

SELECT 
    'TEST getAllBookings()' as Info,
    COUNT(*) as result_count,
    'Should return all bookings (admin only)' as description
FROM bookings;

-- =============================================
-- 10. CHECK USER ROLE ASSIGNMENTS
-- =============================================
-- Verify that users have correct roles
SELECT 
    'USER ROLE ASSIGNMENTS' as Info,
    id as user_id,
    name as user_name,
    email,
    role,
    CASE 
        WHEN role = 'Admin' THEN 'Can see all bookings'
        WHEN role = 'User' THEN 'Can only see own bookings'
        WHEN role IS NULL THEN 'ERROR: No role assigned'
        ELSE 'Unknown role'
    END as permission_description
FROM users
ORDER BY id;

-- =============================================
-- 11. DEBUG LOGGING SIMULATION
-- =============================================
-- Simulate what debug logs should show
SELECT 
    'DEBUG LOGGING SIMULATION' as Info,
    'Dashboard onCreate' as log_source,
    'DEBUG Dashboard - User ID: ' + CAST(u.id AS VARCHAR(10)) as log_message
FROM users u
WHERE u.id = 1

UNION ALL

SELECT 
    'DEBUG LOGGING SIMULATION' as Info,
    'HistoryActivity onCreate' as log_source,
    'DEBUG HistoryActivity - Received User ID: ' + CAST(u.id AS VARCHAR(10)) as log_message
FROM users u
WHERE u.id = 1

UNION ALL

SELECT 
    'DEBUG LOGGING SIMULATION' as Info,
    'loadBookings()' as log_source,
    'User view - User''s bookings: ' + CAST(COUNT(b.id) AS VARCHAR(10)) as log_message
FROM users u
LEFT JOIN bookings b ON u.id = b.user_id
WHERE u.id = 1
GROUP BY u.id;

-- =============================================
-- 12. TEST INTENT DATA FLOW
-- =============================================
-- Simulate the Intent data flow from Login → Dashboard → HistoryActivity
SELECT 
    'INTENT DATA FLOW SIMULATION' as Info,
    'Login → Dashboard → HistoryActivity' as flow,
    u.id as login_user_id,
    u.name as login_user_name,
    u.role as login_user_role,
    'Should pass user_id=' + CAST(u.id AS VARCHAR(10)) + ' to HistoryActivity' as expected_intent_data
FROM users u
ORDER BY u.id;

-- =============================================
-- 13. FINAL DIAGNOSIS
-- =============================================
-- Final diagnosis of the issue
SELECT 
    'FINAL DIAGNOSIS' as Info,
    'Issue Analysis' as category,
    CASE 
        WHEN COUNT(DISTINCT b.user_id) > 1 THEN 'Multiple users have bookings'
        ELSE 'Only one user has bookings'
    END as booking_distribution,
    CASE 
        WHEN COUNT(DISTINCT u.role) > 1 THEN 'Multiple roles exist'
        ELSE 'Only one role exists'
    END as role_distribution,
    'Check Android logs for USER_ID and ROLE passing' as recommendation
FROM bookings b
CROSS JOIN users u;

-- =============================================
-- 14. TEST SPECIFIC USER SCENARIOS
-- =============================================
-- Test specific user scenarios that might be causing the issue
SELECT 
    'SPECIFIC USER SCENARIOS' as Info,
    'User 1 (Admin) - Should see all bookings' as scenario,
    COUNT(*) as total_bookings,
    'Admin should see all bookings' as expected
FROM bookings

UNION ALL

SELECT 
    'SPECIFIC USER SCENARIOS' as Info,
    'User 2 (User) - Should see only own bookings' as scenario,
    COUNT(*) as total_bookings,
    'User should only see own bookings' as expected
FROM bookings
WHERE user_id = 2

UNION ALL

SELECT 
    'SPECIFIC USER SCENARIOS' as Info,
    'User 3 (User) - Should see only own bookings' as scenario,
    COUNT(*) as total_bookings,
    'User should only see own bookings' as expected
FROM bookings
WHERE user_id = 3;

PRINT 'User-specific bookings debug test completed!';
PRINT 'Check the results above to identify:';
PRINT '1. Current users and their roles';
PRINT '2. Current bookings and their users';
PRINT '3. User-specific query results';
PRINT '4. Admin view results';
PRINT '5. Data integrity issues';
PRINT '6. Role-based access control';
PRINT '7. Android app scenarios';
PRINT '8. Hardcoded values check';
PRINT '9. Database connection method tests';
PRINT '10. User role assignments';
PRINT '11. Debug logging simulation';
PRINT '12. Intent data flow simulation';
PRINT '13. Final diagnosis';
PRINT '14. Specific user scenarios';
PRINT '';
PRINT 'Common issues to check:';
PRINT '- USER_ID not being passed correctly from Login to Dashboard';
PRINT '- USER_ID not being passed correctly from Dashboard to HistoryActivity';
PRINT '- ROLE not being passed correctly or is null';
PRINT '- Hardcoded USER_ID values in the code';
PRINT '- getBookingsByUserId method not working correctly';
PRINT '- User role not being retrieved correctly from database';
PRINT '- Database connection issues';
PRINT '- Intent extras not being set properly';
