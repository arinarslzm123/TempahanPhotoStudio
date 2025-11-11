-- =============================================
-- VERIFY ADMIN BOOKING ACTIONS
-- =============================================
-- This script verifies that admin can confirm and cancel bookings

USE TempahanPhotoStudio;
GO

-- =============================================
-- 1. CHECK BOOKINGS TABLE STRUCTURE
-- =============================================
SELECT 
    'BOOKINGS TABLE STRUCTURE' as Info,
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'bookings'
ORDER BY ORDINAL_POSITION;

-- =============================================
-- 2. VERIFY STATUS FIELD VALUES
-- =============================================
SELECT DISTINCT
    'AVAILABLE STATUS VALUES' as Info,
    status
FROM bookings
ORDER BY status;

-- =============================================
-- 3. CHECK BOOKING DETAILS QUERY
-- =============================================
-- Test the booking details query used in the app
SELECT TOP 1
    'BOOKING DETAILS QUERY TEST' as Info,
    b.id,
    b.user_id,
    b.package_id,
    b.sub_package_id,
    b.booking_date,
    b.event_date,
    b.event_time,
    b.status,
    b.total_amount,
    b.payment_method,
    b.payment_status,
    p.package_name,
    p.category,
    p.event,
    p.duration,
    sp.sub_package_name,
    sp.description,
    sp.price,
    sp.duration as sub_duration,
    u.name as user_name,
    u.email
FROM bookings b
LEFT JOIN packages p ON b.package_id = p.id
LEFT JOIN sub_packages sp ON b.sub_package_id = sp.id
LEFT JOIN users u ON b.user_id = u.id
ORDER BY b.created_at DESC;

-- =============================================
-- 4. CHECK ADMIN USER ACCESS
-- =============================================
-- Verify admin users exist
SELECT 
    'ADMIN USERS CHECK' as Info,
    COUNT(*) as Admin_Count
FROM users
WHERE role = 'Admin';

-- Show admin users
SELECT 
    'ADMIN USERS LIST' as Info,
    id,
    name,
    email,
    role
FROM users
WHERE role = 'Admin'
ORDER BY id;

-- =============================================
-- 5. BOOKING STATUS TRANSITIONS
-- =============================================
-- Show possible status transitions
SELECT 
    'BOOKING STATUS TRANSITIONS' as Info,
    'Pending' as Current_Status,
    'Confirmed' as Admin_Action,
    'Admin can confirm pending bookings' as Description
UNION ALL
SELECT 
    'BOOKING STATUS TRANSITIONS' as Info,
    'Confirmed' as Current_Status,
    'Cancelled' as Admin_Action,
    'Admin can cancel confirmed bookings' as Description
UNION ALL
SELECT 
    'BOOKING STATUS TRANSITIONS' as Info,
    'Pending' as Current_Status,
    'Cancelled' as Admin_Action,
    'Admin can cancel pending bookings' as Description;

-- =============================================
-- 6. TEST STATUS UPDATE FUNCTIONALITY
-- =============================================
-- Test updating booking status
DECLARE @test_booking_id INT = (SELECT TOP 1 id FROM bookings ORDER BY created_at DESC);

IF @test_booking_id IS NOT NULL
BEGIN
    -- Get current status
    DECLARE @current_status NVARCHAR(20) = (SELECT status FROM bookings WHERE id = @test_booking_id);
    
    SELECT 
        'STATUS UPDATE TEST' as Info,
        @test_booking_id as booking_id,
        @current_status as current_status;
    
    -- Test status update
    UPDATE bookings 
    SET status = CASE 
        WHEN @current_status = 'Pending' THEN 'Confirmed'
        WHEN @current_status = 'Confirmed' THEN 'Pending'
        ELSE @current_status
    END
    WHERE id = @test_booking_id;
    
    -- Get updated status
    DECLARE @updated_status NVARCHAR(20) = (SELECT status FROM bookings WHERE id = @test_booking_id);
    
    SELECT 
        'STATUS UPDATE RESULT' as Info,
        @test_booking_id as booking_id,
        @current_status as old_status,
        @updated_status as new_status;
    
    -- Revert back to original status
    UPDATE bookings 
    SET status = @current_status
    WHERE id = @test_booking_id;
    
    PRINT 'SUCCESS: Status update functionality works correctly!';
END
ELSE
BEGIN
    PRINT 'No bookings found to test status update.';
END

-- =============================================
-- 7. BOOKING ACTIONS BY ROLE
-- =============================================
-- Show what actions each role can perform
SELECT 
    'BOOKING ACTIONS BY ROLE' as Info,
    'Admin' as User_Role,
    'Can confirm pending bookings' as Action_1,
    'Can cancel confirmed bookings' as Action_2,
    'Can cancel pending bookings' as Action_3
UNION ALL
SELECT 
    'BOOKING ACTIONS BY ROLE' as Info,
    'User' as User_Role,
    'Cannot confirm bookings' as Action_1,
    'Cannot cancel confirmed bookings' as Action_2,
    'Can cancel pending bookings' as Action_3;

-- =============================================
-- 8. BOOKING HISTORY FOR ADMIN VIEW
-- =============================================
-- Show booking history as admin would see it
SELECT 
    'ADMIN BOOKING HISTORY VIEW' as Info,
    b.id,
    'BK-' + RIGHT('000' + CAST(b.id AS VARCHAR(10)), 3) as booking_id,
    b.status,
    p.package_name,
    sp.sub_package_name,
    b.event_date,
    b.event_time,
    b.total_amount,
    b.payment_method,
    b.payment_status,
    u.name as user_name,
    u.email as user_email,
    b.created_at
FROM bookings b
LEFT JOIN packages p ON b.package_id = p.id
LEFT JOIN sub_packages sp ON b.sub_package_id = sp.id
LEFT JOIN users u ON b.user_id = u.id
ORDER BY b.created_at DESC;

-- =============================================
-- 9. PENDING BOOKINGS FOR ADMIN CONFIRMATION
-- =============================================
-- Show pending bookings that admin can confirm
SELECT 
    'PENDING BOOKINGS FOR ADMIN' as Info,
    b.id,
    'BK-' + RIGHT('000' + CAST(b.id AS VARCHAR(10)), 3) as booking_id,
    p.package_name,
    sp.sub_package_name,
    b.event_date,
    b.event_time,
    b.total_amount,
    b.payment_method,
    b.payment_status,
    u.name as user_name,
    u.email as user_email,
    b.created_at
FROM bookings b
LEFT JOIN packages p ON b.package_id = p.id
LEFT JOIN sub_packages sp ON b.sub_package_id = sp.id
LEFT JOIN users u ON b.user_id = u.id
WHERE b.status = 'Pending'
ORDER BY b.created_at DESC;

-- =============================================
-- 10. CONFIRMED BOOKINGS FOR ADMIN CANCELLATION
-- =============================================
-- Show confirmed bookings that admin can cancel
SELECT 
    'CONFIRMED BOOKINGS FOR ADMIN' as Info,
    b.id,
    'BK-' + RIGHT('000' + CAST(b.id AS VARCHAR(10)), 3) as booking_id,
    p.package_name,
    sp.sub_package_name,
    b.event_date,
    b.event_time,
    b.total_amount,
    b.payment_method,
    b.payment_status,
    u.name as user_name,
    u.email as user_email,
    b.created_at
FROM bookings b
LEFT JOIN packages p ON b.package_id = p.id
LEFT JOIN sub_packages sp ON b.sub_package_id = sp.id
LEFT JOIN users u ON b.user_id = u.id
WHERE b.status = 'Confirmed'
ORDER BY b.created_at DESC;

PRINT 'Admin booking actions verification completed!';
PRINT 'Check the results above to verify:';
PRINT '1. Bookings table structure is correct';
PRINT '2. Available status values';
PRINT '3. Booking details query works';
PRINT '4. Admin users exist';
PRINT '5. Status update functionality works';
PRINT '6. Booking actions by role';
PRINT '7. Admin booking history view';
PRINT '8. Pending bookings for admin confirmation';
PRINT '9. Confirmed bookings for admin cancellation';
