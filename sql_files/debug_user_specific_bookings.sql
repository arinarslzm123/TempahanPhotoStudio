-- =============================================
-- DEBUG USER-SPECIFIC BOOKINGS ISSUE
-- =============================================
-- This script helps debug why users can still see other users' bookings

USE TempahanPhotoStudio;
GO

-- =============================================
-- 1. CHECK CURRENT USERS AND THEIR BOOKINGS
-- =============================================
SELECT 
    'CURRENT USERS AND THEIR BOOKINGS' as Info,
    u.id as user_id,
    u.name as user_name,
    u.email,
    u.role,
    COUNT(b.id) as booking_count,
    'User should only see their own bookings' as description
FROM users u
LEFT JOIN bookings b ON u.id = b.user_id
GROUP BY u.id, u.name, u.email, u.role
ORDER BY u.id;

-- =============================================
-- 2. DETAILED BOOKING BREAKDOWN BY USER
-- =============================================
SELECT 
    'DETAILED BOOKING BREAKDOWN' as Info,
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
-- 3. TEST USER-SPECIFIC QUERIES
-- =============================================
-- Test what each user should see
SELECT 
    'USER 1 BOOKINGS (Should only see these)' as Info,
    b.id as booking_id,
    b.user_id,
    u.name as user_name,
    b.status,
    b.total_amount,
    'User 1 should only see bookings where user_id = 1' as description
FROM bookings b
LEFT JOIN users u ON b.user_id = u.id
WHERE b.user_id = 1
ORDER BY b.created_at DESC;

SELECT 
    'USER 2 BOOKINGS (Should only see these)' as Info,
    b.id as booking_id,
    b.user_id,
    u.name as user_name,
    b.status,
    b.total_amount,
    'User 2 should only see bookings where user_id = 2' as description
FROM bookings b
LEFT JOIN users u ON b.user_id = u.id
WHERE b.user_id = 2
ORDER BY b.created_at DESC;

-- =============================================
-- 4. TEST ADMIN VIEW (Should see all)
-- =============================================
SELECT 
    'ADMIN VIEW (Should see all bookings)' as Info,
    b.id as booking_id,
    b.user_id,
    u.name as user_name,
    u.role as user_role,
    b.status,
    b.total_amount,
    'Admin should see all bookings from all users' as description
FROM bookings b
LEFT JOIN users u ON b.user_id = u.id
ORDER BY b.created_at DESC;

-- =============================================
-- 5. CHECK FOR DUPLICATE USER IDS
-- =============================================
-- Check if there are any issues with user ID assignment
SELECT 
    'DUPLICATE USER ID CHECK' as Info,
    user_id,
    COUNT(*) as booking_count,
    'Multiple bookings for same user' as description
FROM bookings
GROUP BY user_id
HAVING COUNT(*) > 1
ORDER BY user_id;

-- =============================================
-- 6. CHECK FOR MISSING USER REFERENCES
-- =============================================
-- Check if there are bookings with invalid user_id
SELECT 
    'MISSING USER REFERENCES CHECK' as Info,
    b.id as booking_id,
    b.user_id,
    u.name as user_name,
    CASE 
        WHEN u.id IS NULL THEN 'ERROR: Booking has invalid user_id'
        ELSE 'OK: Valid user reference'
    END as status
FROM bookings b
LEFT JOIN users u ON b.user_id = u.id
ORDER BY b.id;

-- =============================================
-- 7. SIMULATE ANDROID APP SCENARIOS
-- =============================================
-- Scenario 1: User 1 logs in and views history
SELECT 
    'SCENARIO 1 - USER 1 LOGIN' as Info,
    'User ID: 1' as user_id,
    'Role: User' as user_role,
    COUNT(*) as bookings_visible,
    'Should only see ' + CAST(COUNT(*) AS VARCHAR(10)) + ' bookings' as expected_result
FROM bookings
WHERE user_id = 1;

-- Scenario 2: User 2 logs in and views history
SELECT 
    'SCENARIO 2 - USER 2 LOGIN' as Info,
    'User ID: 2' as user_id,
    'Role: User' as user_role,
    COUNT(*) as bookings_visible,
    'Should only see ' + CAST(COUNT(*) AS VARCHAR(10)) + ' bookings' as expected_result
FROM bookings
WHERE user_id = 2;

-- Scenario 3: Admin logs in and views history
SELECT 
    'SCENARIO 3 - ADMIN LOGIN' as Info,
    'User ID: Any' as user_id,
    'Role: Admin' as user_role,
    COUNT(*) as bookings_visible,
    'Should see all ' + CAST(COUNT(*) AS VARCHAR(10)) + ' bookings' as expected_result
FROM bookings;

-- =============================================
-- 8. CHECK USER ROLE ASSIGNMENTS
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
    'TEST getAllBookings()' as Info,
    COUNT(*) as result_count,
    'Should return all bookings (admin only)' as description
FROM bookings;

-- =============================================
-- 10. CHECK FOR HARDCODED VALUES
-- =============================================
-- Check if there are any hardcoded user IDs in the database
SELECT 
    'HARDCODED VALUES CHECK' as Info,
    'Current bookings user_id distribution' as description,
    user_id,
    COUNT(*) as count
FROM bookings
GROUP BY user_id
ORDER BY user_id;

-- =============================================
-- 11. VERIFY INTENT DATA FLOW
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
-- 12. DEBUG LOGGING SIMULATION
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
    'Check Android logs for USER_ID passing' as recommendation
FROM bookings b
CROSS JOIN users u;

PRINT 'User-specific bookings debug completed!';
PRINT 'Check the results above to identify:';
PRINT '1. Current users and their bookings';
PRINT '2. Detailed booking breakdown by user';
PRINT '3. User-specific query results';
PRINT '4. Admin view results';
PRINT '5. Duplicate user ID issues';
PRINT '6. Missing user references';
PRINT '7. Android app scenarios';
PRINT '8. User role assignments';
PRINT '9. Database connection method tests';
PRINT '10. Hardcoded values check';
PRINT '11. Intent data flow simulation';
PRINT '12. Debug logging simulation';
PRINT '13. Final diagnosis';
PRINT '';
PRINT 'Common issues to check:';
PRINT '- USER_ID not being passed correctly from Login to Dashboard';
PRINT '- USER_ID not being passed correctly from Dashboard to HistoryActivity';
PRINT '- Hardcoded USER_ID values in the code';
PRINT '- getBookingsByUserId method not working correctly';
PRINT '- User role not being retrieved correctly';
PRINT '- Database connection issues';
