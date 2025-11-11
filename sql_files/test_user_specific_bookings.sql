-- =============================================
-- TEST USER-SPECIFIC BOOKINGS FUNCTIONALITY
-- =============================================
-- This script tests the user-specific booking display functionality

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
    phone_number
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
    b.created_at
FROM bookings b
LEFT JOIN users u ON b.user_id = u.id
ORDER BY b.created_at DESC;

-- =============================================
-- 3. TEST USER-SPECIFIC BOOKING QUERIES
-- =============================================
-- Test query for regular user (should only see their own bookings)
SELECT 
    'USER-SPECIFIC BOOKINGS (User ID: 1)' as Info,
    b.id as booking_id,
    b.user_id,
    u.name as user_name,
    b.status,
    b.total_amount,
    'Should only see bookings for user_id = 1' as description
FROM bookings b
LEFT JOIN users u ON b.user_id = u.id
WHERE b.user_id = 1
ORDER BY b.created_at DESC;

-- Test query for admin (should see all bookings)
SELECT 
    'ADMIN VIEW - ALL BOOKINGS' as Info,
    b.id as booking_id,
    b.user_id,
    u.name as user_name,
    u.role as user_role,
    b.status,
    b.total_amount,
    'Admin should see all bookings' as description
FROM bookings b
LEFT JOIN users u ON b.user_id = u.id
ORDER BY b.created_at DESC;

-- =============================================
-- 4. TEST BOOKING STATUS UPDATES
-- =============================================
-- Test booking status update functionality
SELECT 
    'BOOKING STATUS UPDATE TEST' as Info,
    b.id as booking_id,
    b.user_id,
    u.name as user_name,
    u.role as user_role,
    b.status as current_status,
    CASE 
        WHEN u.role = 'Admin' THEN 'Can confirm and cancel any booking'
        WHEN u.role = 'User' THEN 'Can only cancel own pending bookings'
        ELSE 'Unknown role'
    END as permission_description
FROM bookings b
LEFT JOIN users u ON b.user_id = u.id
ORDER BY b.id;

-- =============================================
-- 5. TEST USER PERMISSIONS FOR BOOKING ACTIONS
-- =============================================
-- Test what actions each user can perform
SELECT 
    'USER PERMISSIONS FOR BOOKING ACTIONS' as Info,
    u.id as user_id,
    u.name as user_name,
    u.role as user_role,
    b.id as booking_id,
    b.status as booking_status,
    CASE 
        WHEN u.role = 'Admin' AND b.status = 'Pending' THEN 'Can confirm and cancel'
        WHEN u.role = 'Admin' AND b.status = 'Confirmed' THEN 'Can cancel only'
        WHEN u.role = 'User' AND b.status = 'Pending' AND b.user_id = u.id THEN 'Can cancel own booking'
        WHEN u.role = 'User' AND b.status = 'Confirmed' AND b.user_id = u.id THEN 'Cannot cancel confirmed booking'
        WHEN u.role = 'User' AND b.user_id != u.id THEN 'Cannot see other users bookings'
        ELSE 'No actions allowed'
    END as allowed_actions
FROM users u
CROSS JOIN bookings b
WHERE u.role = 'User' OR u.role = 'Admin'
ORDER BY u.id, b.id;

-- =============================================
-- 6. SIMULATE BOOKING VIEW SCENARIOS
-- =============================================
-- Scenario 1: Regular user viewing their bookings
SELECT 
    'SCENARIO 1 - REGULAR USER VIEW (User ID: 1)' as Info,
    b.id as booking_id,
    b.user_id,
    u.name as user_name,
    b.status,
    b.total_amount,
    'User 1 should only see their own bookings' as expected_result
FROM bookings b
LEFT JOIN users u ON b.user_id = u.id
WHERE b.user_id = 1
ORDER BY b.created_at DESC;

-- Scenario 2: Admin viewing all bookings
SELECT 
    'SCENARIO 2 - ADMIN VIEW (All Bookings)' as Info,
    b.id as booking_id,
    b.user_id,
    u.name as user_name,
    u.role as user_role,
    b.status,
    b.total_amount,
    'Admin should see all bookings from all users' as expected_result
FROM bookings b
LEFT JOIN users u ON b.user_id = u.id
ORDER BY b.created_at DESC;

-- =============================================
-- 7. TEST BOOKING HISTORY ADAPTER BEHAVIOR
-- =============================================
-- Test what the BookingHistoryAdapter should display
SELECT 
    'BOOKING HISTORY ADAPTER BEHAVIOR' as Info,
    u.id as user_id,
    u.name as user_name,
    u.role as user_role,
    COUNT(b.id) as total_bookings,
    COUNT(CASE WHEN b.status = 'Pending' THEN 1 END) as pending_bookings,
    COUNT(CASE WHEN b.status = 'Confirmed' THEN 1 END) as confirmed_bookings,
    COUNT(CASE WHEN b.status = 'Completed' THEN 1 END) as completed_bookings,
    COUNT(CASE WHEN b.status = 'Cancelled' THEN 1 END) as cancelled_bookings,
    'Adapter should show these counts for each user' as description
FROM users u
LEFT JOIN bookings b ON u.id = b.user_id
GROUP BY u.id, u.name, u.role
ORDER BY u.id;

-- =============================================
-- 8. TEST BOOKING ACTION BUTTONS VISIBILITY
-- =============================================
-- Test which buttons should be visible for each user and booking status
SELECT 
    'BOOKING ACTION BUTTONS VISIBILITY' as Info,
    u.id as user_id,
    u.name as user_name,
    u.role as user_role,
    b.id as booking_id,
    b.status as booking_status,
    CASE 
        WHEN u.role = 'Admin' AND b.status = 'Pending' THEN 'Confirm button: VISIBLE, Cancel button: VISIBLE'
        WHEN u.role = 'Admin' AND b.status = 'Confirmed' THEN 'Confirm button: HIDDEN, Cancel button: VISIBLE'
        WHEN u.role = 'User' AND b.status = 'Pending' AND b.user_id = u.id THEN 'Confirm button: HIDDEN, Cancel button: VISIBLE'
        WHEN u.role = 'User' AND b.status = 'Confirmed' AND b.user_id = u.id THEN 'Confirm button: HIDDEN, Cancel button: HIDDEN'
        WHEN u.role = 'User' AND b.user_id != u.id THEN 'Confirm button: HIDDEN, Cancel button: HIDDEN (Cannot see other users bookings)'
        ELSE 'Confirm button: HIDDEN, Cancel button: HIDDEN'
    END as button_visibility
FROM users u
CROSS JOIN bookings b
WHERE u.role = 'User' OR u.role = 'Admin'
ORDER BY u.id, b.id;

-- =============================================
-- 9. TEST DATABASE CONNECTION METHODS
-- =============================================
-- Test the methods that HistoryActivity uses
SELECT 
    'DATABASE CONNECTION METHODS TEST' as Info,
    'getBookingsByUserId(1)' as method_name,
    COUNT(*) as booking_count,
    'Should return bookings for user ID 1 only' as description
FROM bookings
WHERE user_id = 1

UNION ALL

SELECT 
    'DATABASE CONNECTION METHODS TEST' as Info,
    'getAllBookings()' as method_name,
    COUNT(*) as booking_count,
    'Should return all bookings (admin only)' as description
FROM bookings;

-- =============================================
-- 10. VERIFY USER-SPECIFIC BOOKING INTEGRITY
-- =============================================
-- Check if all bookings have valid user references
SELECT 
    'USER-SPECIFIC BOOKING INTEGRITY CHECK' as Info,
    b.id as booking_id,
    b.user_id,
    u.name as user_name,
    u.role as user_role,
    CASE 
        WHEN u.id IS NULL THEN 'ERROR: Booking has invalid user_id'
        WHEN u.role IS NULL THEN 'WARNING: User has no role assigned'
        ELSE 'OK: Valid user reference'
    END as integrity_status
FROM bookings b
LEFT JOIN users u ON b.user_id = u.id
ORDER BY b.id;

-- =============================================
-- 11. TEST BOOKING STATUS TRANSITIONS
-- =============================================
-- Test valid booking status transitions
SELECT 
    'BOOKING STATUS TRANSITIONS' as Info,
    b.id as booking_id,
    b.user_id,
    u.name as user_name,
    u.role as user_role,
    b.status as current_status,
    CASE 
        WHEN b.status = 'Pending' AND u.role = 'Admin' THEN 'Can transition to: Confirmed, Cancelled'
        WHEN b.status = 'Pending' AND u.role = 'User' THEN 'Can transition to: Cancelled (own bookings only)'
        WHEN b.status = 'Confirmed' AND u.role = 'Admin' THEN 'Can transition to: Completed, Cancelled'
        WHEN b.status = 'Confirmed' AND u.role = 'User' THEN 'Cannot transition (admin only)'
        WHEN b.status = 'Completed' THEN 'Cannot transition (final status)'
        WHEN b.status = 'Cancelled' THEN 'Cannot transition (final status)'
        ELSE 'Unknown status'
    END as allowed_transitions
FROM bookings b
LEFT JOIN users u ON b.user_id = u.id
ORDER BY b.id;

-- =============================================
-- 12. FINAL VERIFICATION
-- =============================================
-- Final check of user-specific booking functionality
SELECT 
    'FINAL VERIFICATION' as Info,
    'User-Specific Booking Display' as test_case,
    COUNT(DISTINCT b.user_id) as unique_users_with_bookings,
    COUNT(b.id) as total_bookings,
    'Each user should only see their own bookings' as expected_behavior
FROM bookings b

UNION ALL

SELECT 
    'FINAL VERIFICATION' as Info,
    'Admin Booking Display' as test_case,
    COUNT(DISTINCT b.user_id) as unique_users_with_bookings,
    COUNT(b.id) as total_bookings,
    'Admin should see all bookings from all users' as expected_behavior
FROM bookings b;

PRINT 'User-specific bookings test completed!';
PRINT 'Check the results above to verify:';
PRINT '1. Current users and their roles';
PRINT '2. Current bookings and their users';
PRINT '3. User-specific booking queries';
PRINT '4. Booking status updates';
PRINT '5. User permissions for booking actions';
PRINT '6. Booking view scenarios';
PRINT '7. Booking history adapter behavior';
PRINT '8. Booking action buttons visibility';
PRINT '9. Database connection methods test';
PRINT '10. User-specific booking integrity check';
PRINT '11. Booking status transitions';
PRINT '12. Final verification';
PRINT '';
PRINT 'Expected behavior:';
PRINT '- Regular users should only see their own bookings';
PRINT '- Admin users should see all bookings from all users';
PRINT '- Users can only cancel their own pending bookings';
PRINT '- Admin can confirm and cancel any booking';
PRINT '- Users cannot see other users bookings';
