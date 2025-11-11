-- =============================================
-- FIX DATABASE ISSUES
-- =============================================
-- This script fixes the database issues identified from debug logs

USE TempahanPhotoStudio;
GO

-- =============================================
-- 1. CHECK CURRENT BOOKINGS WITH NULL CREATED_AT
-- =============================================
SELECT 
    'BOOKINGS WITH NULL CREATED_AT' as Info,
    id as booking_id,
    user_id,
    status,
    created_at,
    'Has NULL created_at' as issue
FROM bookings
WHERE created_at IS NULL
ORDER BY id;

-- =============================================
-- 2. FIX NULL CREATED_AT VALUES
-- =============================================
-- Update bookings with NULL created_at to current timestamp
UPDATE bookings 
SET created_at = GETDATE()
WHERE created_at IS NULL;

-- Verify the fix
SELECT 
    'AFTER FIX - BOOKINGS WITH NULL CREATED_AT' as Info,
    COUNT(*) as count,
    'Should be 0' as expected
FROM bookings
WHERE created_at IS NULL;

-- =============================================
-- 3. CHECK CURRENT USERS
-- =============================================
SELECT 
    'CURRENT USERS' as Info,
    id as user_id,
    name as user_name,
    email,
    role,
    'User record' as status
FROM users
ORDER BY id;

-- =============================================
-- 4. CREATE ADDITIONAL USERS FOR TESTING
-- =============================================
-- Create additional users if they don't exist
IF NOT EXISTS (SELECT 1 FROM users WHERE id = 2)
BEGIN
    INSERT INTO users (id, name, email, phone_number, password, role)
    VALUES (2, 'Test User 2', 'user2@example.com', '012-3456790', 'user123', 'User');
    PRINT 'User 2 created';
END

IF NOT EXISTS (SELECT 1 FROM users WHERE id = 3)
BEGIN
    INSERT INTO users (id, name, email, phone_number, password, role)
    VALUES (3, 'Test User 3', 'user3@example.com', '012-3456791', 'user123', 'User');
    PRINT 'User 3 created';
END

-- =============================================
-- 5. CREATE BOOKINGS FOR DIFFERENT USERS
-- =============================================
-- Create bookings for User 2
INSERT INTO bookings (user_id, package_id, sub_package_id, booking_date, event_date, event_time, status, total_amount, payment_method, payment_status, notes, created_at)
VALUES 
    (2, 1, 1, '2024-01-20', '2024-02-20', '10:00', 'Pending', 500.00, 'Online Banking', 'Pending', 'Test booking for User 2', GETDATE()),
    (2, 1, 2, '2024-01-21', '2024-02-21', '11:00', 'Confirmed', 750.00, 'Cash', 'Paid', 'Test booking for User 2', GETDATE());

-- Create bookings for User 3
INSERT INTO bookings (user_id, package_id, sub_package_id, booking_date, event_date, event_time, status, total_amount, payment_method, payment_status, notes, created_at)
VALUES 
    (3, 2, 3, '2024-01-22', '2024-02-22', '12:00', 'Pending', 600.00, 'Online Banking', 'Pending', 'Test booking for User 3', GETDATE()),
    (3, 2, 4, '2024-01-23', '2024-02-23', '13:00', 'Confirmed', 800.00, 'Cash', 'Paid', 'Test booking for User 3', GETDATE());

PRINT 'Test bookings created for User 2 and User 3';

-- =============================================
-- 6. VERIFY BOOKINGS DISTRIBUTION
-- =============================================
SELECT 
    'BOOKINGS DISTRIBUTION BY USER' as Info,
    user_id,
    COUNT(*) as booking_count,
    'Bookings for this user' as description
FROM bookings
GROUP BY user_id
ORDER BY user_id;

-- =============================================
-- 7. TEST USER-SPECIFIC QUERIES
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
-- 8. DETAILED BOOKING BREAKDOWN
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
-- 9. CHECK FOR REMAINING NULL VALUES
-- =============================================
SELECT 
    'REMAINING NULL VALUES CHECK' as Info,
    'created_at' as column_name,
    COUNT(*) as null_count,
    'Should be 0' as expected
FROM bookings
WHERE created_at IS NULL

UNION ALL

SELECT 
    'REMAINING NULL VALUES CHECK' as Info,
    'user_id' as column_name,
    COUNT(*) as null_count,
    'Should be 0' as expected
FROM bookings
WHERE user_id IS NULL;

-- =============================================
-- 10. FINAL VERIFICATION
-- =============================================
SELECT 
    'FINAL VERIFICATION' as Info,
    'Total users' as metric,
    COUNT(*) as count,
    'Should have multiple users' as description
FROM users

UNION ALL

SELECT 
    'FINAL VERIFICATION' as Info,
    'Total bookings' as metric,
    COUNT(*) as count,
    'Should have bookings for multiple users' as description
FROM bookings

UNION ALL

SELECT 
    'FINAL VERIFICATION' as Info,
    'Unique users with bookings' as metric,
    COUNT(DISTINCT user_id) as count,
    'Should have bookings for multiple users' as description
FROM bookings;

PRINT 'Database issues fix completed!';
PRINT 'Changes made:';
PRINT '1. Fixed NULL created_at values';
PRINT '2. Created additional users (User 2 and User 3)';
PRINT '3. Created test bookings for different users';
PRINT '4. Verified bookings distribution';
PRINT '5. Tested user-specific queries';
PRINT '6. Checked for remaining NULL values';
PRINT '7. Final verification';
PRINT '';
PRINT 'Now test the app with different users:';
PRINT '- Login as User 1 (should see bookings for User 1)';
PRINT '- Login as User 2 (should see bookings for User 2)';
PRINT '- Login as User 3 (should see bookings for User 3)';
PRINT '- Login as Admin (should see all bookings)';
