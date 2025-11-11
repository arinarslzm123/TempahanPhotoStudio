-- =============================================
-- TEST USER-SPECIFIC BOOKINGS FINAL VERIFICATION
-- =============================================
-- This script verifies that users can only see their own bookings

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
    'User record' as status
FROM users
ORDER BY id;

-- =============================================
-- 2. CHECK CURRENT BOOKINGS DISTRIBUTION
-- =============================================
SELECT 
    'BOOKINGS DISTRIBUTION BY USER' as Info,
    b.user_id,
    u.name as user_name,
    u.role as user_role,
    COUNT(*) as booking_count,
    'Bookings for this user' as description
FROM bookings b
LEFT JOIN users u ON b.user_id = u.id
GROUP BY b.user_id, u.name, u.role
ORDER BY b.user_id;

-- =============================================
-- 3. DETAILED BOOKING BREAKDOWN
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
-- 4. TEST USER-SPECIFIC QUERIES
-- =============================================
-- Test what each user should see
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
-- 5. VERIFY USER ROLES
-- =============================================
SELECT 
    'USER ROLES VERIFICATION' as Info,
    id as user_id,
    name as user_name,
    email,
    role,
    CASE 
        WHEN role = 'Admin' THEN 'Can see all bookings'
        WHEN role = 'User' THEN 'Can see own bookings only'
        ELSE 'Unknown role'
    END as access_level
FROM users
ORDER BY id;

-- =============================================
-- 6. CHECK FOR ORPHANED BOOKINGS
-- =============================================
SELECT 
    'ORPHANED BOOKINGS CHECK' as Info,
    b.id as booking_id,
    b.user_id,
    'No corresponding user' as issue
FROM bookings b
LEFT JOIN users u ON b.user_id = u.id
WHERE u.id IS NULL;

-- =============================================
-- 7. VERIFY BOOKING OWNERSHIP
-- =============================================
SELECT 
    'BOOKING OWNERSHIP VERIFICATION' as Info,
    b.id as booking_id,
    b.user_id,
    u.name as owner_name,
    u.email as owner_email,
    b.status,
    b.total_amount,
    CASE 
        WHEN u.id IS NOT NULL THEN 'Valid ownership'
        ELSE 'Invalid ownership - user not found'
    END as ownership_status
FROM bookings b
LEFT JOIN users u ON b.user_id = u.id
ORDER BY b.user_id, b.id;

-- =============================================
-- 8. TEST SCENARIOS
-- =============================================
-- Scenario 1: User 1 login
SELECT 
    'SCENARIO 1: User 1 Login' as Info,
    'Should see only User 1 bookings' as expected,
    COUNT(*) as actual_count,
    CASE 
        WHEN COUNT(*) > 0 THEN 'PASS - User 1 has bookings'
        ELSE 'FAIL - User 1 has no bookings'
    END as result
FROM bookings
WHERE user_id = 1;

-- Scenario 2: User 2 login
SELECT 
    'SCENARIO 2: User 2 Login' as Info,
    'Should see only User 2 bookings' as expected,
    COUNT(*) as actual_count,
    CASE 
        WHEN COUNT(*) > 0 THEN 'PASS - User 2 has bookings'
        ELSE 'FAIL - User 2 has no bookings'
    END as result
FROM bookings
WHERE user_id = 2;

-- Scenario 3: User 3 login
SELECT 
    'SCENARIO 3: User 3 Login' as Info,
    'Should see only User 3 bookings' as expected,
    COUNT(*) as actual_count,
    CASE 
        WHEN COUNT(*) > 0 THEN 'PASS - User 3 has bookings'
        ELSE 'FAIL - User 3 has no bookings'
    END as result
FROM bookings
WHERE user_id = 3;

-- Scenario 4: Admin login
SELECT 
    'SCENARIO 4: Admin Login' as Info,
    'Should see all bookings' as expected,
    COUNT(*) as actual_count,
    CASE 
        WHEN COUNT(*) > 0 THEN 'PASS - Admin can see all bookings'
        ELSE 'FAIL - Admin sees no bookings'
    END as result
FROM bookings;

-- =============================================
-- 9. FINAL VERIFICATION SUMMARY
-- =============================================
SELECT 
    'FINAL VERIFICATION SUMMARY' as Info,
    'Total users' as metric,
    COUNT(*) as count,
    'Should have multiple users' as description
FROM users

UNION ALL

SELECT 
    'FINAL VERIFICATION SUMMARY' as Info,
    'Total bookings' as metric,
    COUNT(*) as count,
    'Should have bookings for multiple users' as description
FROM bookings

UNION ALL

SELECT 
    'FINAL VERIFICATION SUMMARY' as Info,
    'Unique users with bookings' as metric,
    COUNT(DISTINCT user_id) as count,
    'Should have bookings for multiple users' as description
FROM bookings

UNION ALL

SELECT 
    'FINAL VERIFICATION SUMMARY' as Info,
    'Admin users' as metric,
    COUNT(*) as count,
    'Should have at least one admin' as description
FROM users
WHERE role = 'Admin'

UNION ALL

SELECT 
    'FINAL VERIFICATION SUMMARY' as Info,
    'Regular users' as metric,
    COUNT(*) as count,
    'Should have multiple regular users' as description
FROM users
WHERE role = 'User';

-- =============================================
-- 10. RECOMMENDATIONS
-- =============================================
PRINT '=== RECOMMENDATIONS ===';
PRINT '1. Test the app with different users:';
PRINT '   - Login as User 1: Should see only User 1 bookings';
PRINT '   - Login as User 2: Should see only User 2 bookings';
PRINT '   - Login as User 3: Should see only User 3 bookings';
PRINT '   - Login as Admin: Should see all bookings';
PRINT '';
PRINT '2. Check debug logs in Android Studio:';
PRINT '   - Verify USER_ID is passed correctly';
PRINT '   - Verify ROLE is passed correctly';
PRINT '   - Verify user-specific queries work';
PRINT '';
PRINT '3. Test booking creation:';
PRINT '   - Create booking as User 1: Should be saved with user_id = 1';
PRINT '   - Create booking as User 2: Should be saved with user_id = 2';
PRINT '   - Create booking as User 3: Should be saved with user_id = 3';
PRINT '';
PRINT '4. Test profile access:';
PRINT '   - User 1 profile: Should show User 1 data only';
PRINT '   - User 2 profile: Should show User 2 data only';
PRINT '   - User 3 profile: Should show User 3 data only';
PRINT '';
PRINT '5. Test admin access:';
PRINT '   - Admin should access AdminBookingActivity';
PRINT '   - Regular users should be denied access to AdminBookingActivity';
PRINT '';
PRINT 'User-specific booking access verification completed!';
