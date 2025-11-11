-- =============================================
-- TEST DATABASE CONNECTION AND BOOKINGS
-- =============================================
-- This script tests database connection and booking data

USE TempahanPhotoStudio;
GO

-- =============================================
-- 1. TEST DATABASE CONNECTION
-- =============================================
SELECT 
    'DATABASE CONNECTION TEST' as Info,
    'Connection successful' as status,
    'Database: TempahanPhotoStudio' as database_name,
    'Server: Local' as server_name;

-- =============================================
-- 2. CHECK DATABASE TABLES
-- =============================================
SELECT 
    'DATABASE TABLES CHECK' as Info,
    TABLE_NAME as table_name,
    'Table exists' as status
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;

-- =============================================
-- 3. CHECK USERS TABLE STRUCTURE AND DATA
-- =============================================
SELECT 
    'USERS TABLE STRUCTURE' as Info,
    COLUMN_NAME as column_name,
    DATA_TYPE as data_type,
    IS_NULLABLE as nullable,
    'Column exists' as status
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'users'
ORDER BY ORDINAL_POSITION;

SELECT 
    'USERS TABLE DATA' as Info,
    id as user_id,
    name as user_name,
    email,
    role,
    phone_number,
    'User record' as status
FROM users
ORDER BY id;

-- =============================================
-- 4. CHECK BOOKINGS TABLE STRUCTURE AND DATA
-- =============================================
SELECT 
    'BOOKINGS TABLE STRUCTURE' as Info,
    COLUMN_NAME as column_name,
    DATA_TYPE as data_type,
    IS_NULLABLE as nullable,
    'Column exists' as status
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'bookings'
ORDER BY ORDINAL_POSITION;

SELECT 
    'BOOKINGS TABLE DATA' as Info,
    id as booking_id,
    user_id,
    package_id,
    sub_package_id,
    booking_date,
    event_date,
    event_time,
    status,
    total_amount,
    payment_method,
    payment_status,
    notes,
    created_at,
    'Booking record' as status
FROM bookings
ORDER BY created_at DESC;

-- =============================================
-- 5. TEST USER-SPECIFIC BOOKING QUERIES
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
-- 6. DETAILED BOOKING BREAKDOWN BY USER
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
-- 7. TEST ROLE-BASED ACCESS CONTROL
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
-- 8. CHECK FOR DATA INTEGRITY ISSUES
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
-- 9. TEST SPECIFIC USER SCENARIOS
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

-- =============================================
-- 10. CHECK FOR EMPTY DATABASE
-- =============================================
-- Check if database is empty
SELECT 
    'EMPTY DATABASE CHECK' as Info,
    'Users count' as table_name,
    COUNT(*) as record_count,
    CASE 
        WHEN COUNT(*) = 0 THEN 'ERROR: No users in database'
        ELSE 'OK: Users exist'
    END as status
FROM users

UNION ALL

SELECT 
    'EMPTY DATABASE CHECK' as Info,
    'Bookings count' as table_name,
    COUNT(*) as record_count,
    CASE 
        WHEN COUNT(*) = 0 THEN 'WARNING: No bookings in database'
        ELSE 'OK: Bookings exist'
    END as status
FROM bookings;

-- =============================================
-- 11. TEST DATABASE CONNECTION METHODS
-- =============================================
-- Test the methods that the app uses
SELECT 
    'DATABASE CONNECTION METHODS TEST' as Info,
    'getUserById(1)' as method_name,
    CASE 
        WHEN COUNT(*) > 0 THEN 'User found'
        ELSE 'User not found'
    END as result,
    'Should return user with ID 1' as description
FROM users
WHERE id = 1

UNION ALL

SELECT 
    'DATABASE CONNECTION METHODS TEST' as Info,
    'getUserById(2)' as method_name,
    CASE 
        WHEN COUNT(*) > 0 THEN 'User found'
        ELSE 'User not found'
    END as result,
    'Should return user with ID 2' as description
FROM users
WHERE id = 2;

-- =============================================
-- 12. SIMULATE ANDROID APP SCENARIOS
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
-- 13. FINAL DIAGNOSIS
-- =============================================
-- Final diagnosis of the issue
SELECT 
    'FINAL DIAGNOSIS' as Info,
    'Issue Analysis' as category,
    CASE 
        WHEN COUNT(DISTINCT b.user_id) > 1 THEN 'Multiple users have bookings'
        WHEN COUNT(DISTINCT b.user_id) = 1 THEN 'Only one user has bookings'
        ELSE 'No bookings in database'
    END as booking_distribution,
    CASE 
        WHEN COUNT(DISTINCT u.role) > 1 THEN 'Multiple roles exist'
        WHEN COUNT(DISTINCT u.role) = 1 THEN 'Only one role exists'
        ELSE 'No users in database'
    END as role_distribution,
    'Check Android logs for database connection and query results' as recommendation
FROM bookings b
CROSS JOIN users u;

-- =============================================
-- 14. CREATE TEST DATA IF EMPTY
-- =============================================
-- Create test data if database is empty
IF NOT EXISTS (SELECT 1 FROM users)
BEGIN
    INSERT INTO users (name, email, phone_number, password, role)
    VALUES 
        ('Admin User', 'admin@photostudio.com', '012-3456789', 'admin123', 'Admin'),
        ('Test User 1', 'user1@example.com', '012-3456790', 'user123', 'User'),
        ('Test User 2', 'user2@example.com', '012-3456791', 'user123', 'User');
    
    PRINT 'Test users created';
END

IF NOT EXISTS (SELECT 1 FROM bookings)
BEGIN
    INSERT INTO bookings (user_id, package_id, sub_package_id, booking_date, event_date, event_time, status, total_amount, payment_method, payment_status, notes, created_at)
    VALUES 
        (1, 1, 1, '2024-01-15', '2024-02-15', '10:00', 'Pending', 500.00, 'Online Banking', 'Pending', 'Test booking 1', GETDATE()),
        (2, 1, 2, '2024-01-16', '2024-02-16', '11:00', 'Confirmed', 750.00, 'Cash', 'Paid', 'Test booking 2', GETDATE()),
        (3, 2, 3, '2024-01-17', '2024-02-17', '12:00', 'Pending', 600.00, 'Online Banking', 'Pending', 'Test booking 3', GETDATE());
    
    PRINT 'Test bookings created';
END

-- =============================================
-- 15. VERIFY TEST DATA
-- =============================================
-- Verify the test data was created
SELECT 
    'VERIFY TEST DATA' as Info,
    'Users created' as data_type,
    COUNT(*) as count,
    'Test users should exist' as description
FROM users

UNION ALL

SELECT 
    'VERIFY TEST DATA' as Info,
    'Bookings created' as data_type,
    COUNT(*) as count,
    'Test bookings should exist' as description
FROM bookings;

PRINT 'Database connection and bookings test completed!';
PRINT 'Check the results above to verify:';
PRINT '1. Database connection status';
PRINT '2. Database tables existence';
PRINT '3. Users table structure and data';
PRINT '4. Bookings table structure and data';
PRINT '5. User-specific booking queries';
PRINT '6. Detailed booking breakdown';
PRINT '7. Role-based access control';
PRINT '8. Data integrity issues';
PRINT '9. Specific user scenarios';
PRINT '10. Empty database check';
PRINT '11. Database connection methods test';
PRINT '12. Android app scenarios';
PRINT '13. Final diagnosis';
PRINT '14. Test data creation';
PRINT '15. Test data verification';
PRINT '';
PRINT 'Common issues to check:';
PRINT '- Database connection problems';
PRINT '- Empty database (no users or bookings)';
PRINT '- Incorrect user ID in bookings table';
PRINT '- Missing user roles';
PRINT '- Database table structure issues';
PRINT '- SQL query problems';
PRINT '- Android app database connection issues';
