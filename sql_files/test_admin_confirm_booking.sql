-- =============================================
-- TEST ADMIN CONFIRM BOOKING FUNCTIONALITY
-- =============================================
-- This script tests the admin confirm booking functionality

USE TempahanPhotoStudio;
GO

-- =============================================
-- 1. CHECK CURRENT BOOKINGS STATUS
-- =============================================
SELECT 
    'CURRENT BOOKINGS BY STATUS' as Info,
    status,
    COUNT(*) as Count
FROM bookings
GROUP BY status
ORDER BY Count DESC;

-- =============================================
-- 2. SHOW PENDING BOOKINGS (Admin can confirm these)
-- =============================================
SELECT 
    'PENDING BOOKINGS FOR CONFIRMATION' as Info,
    b.id,
    b.user_id,
    u.name as user_name,
    u.email as user_email,
    b.package_id,
    p.package_name,
    b.sub_package_id,
    sp.sub_package_name,
    b.booking_date,
    b.event_date,
    b.event_time,
    b.status,
    b.total_amount,
    b.payment_method,
    b.payment_status,
    b.created_at
FROM bookings b
LEFT JOIN users u ON b.user_id = u.id
LEFT JOIN packages p ON b.package_id = p.id
LEFT JOIN sub_packages sp ON b.sub_package_id = sp.id
WHERE b.status = 'Pending'
ORDER BY b.created_at DESC;

-- =============================================
-- 3. SHOW CONFIRMED BOOKINGS (Admin can cancel these)
-- =============================================
SELECT 
    'CONFIRMED BOOKINGS' as Info,
    b.id,
    b.user_id,
    u.name as user_name,
    b.package_id,
    p.package_name,
    b.sub_package_id,
    sp.sub_package_name,
    b.booking_date,
    b.event_date,
    b.event_time,
    b.status,
    b.total_amount,
    b.payment_method,
    b.payment_status,
    b.created_at
FROM bookings b
LEFT JOIN users u ON b.user_id = u.id
LEFT JOIN packages p ON b.package_id = p.id
LEFT JOIN sub_packages sp ON b.sub_package_id = sp.id
WHERE b.status = 'Confirmed'
ORDER BY b.created_at DESC;

-- =============================================
-- 4. CHECK ADMIN USERS
-- =============================================
SELECT 
    'ADMIN USERS' as Info,
    id,
    name,
    email,
    role
FROM users
WHERE role = 'Admin'
ORDER BY id;

-- =============================================
-- 5. TEST CONFIRM BOOKING (Simulate admin action)
-- =============================================
-- Get a pending booking to test confirmation
DECLARE @pending_booking_id INT = (SELECT TOP 1 id FROM bookings WHERE status = 'Pending' ORDER BY created_at DESC);

IF @pending_booking_id IS NOT NULL
BEGIN
    -- Show the booking before confirmation
    SELECT 
        'BOOKING BEFORE CONFIRMATION' as Info,
        id,
        status,
        total_amount,
        payment_method,
        payment_status
    FROM bookings
    WHERE id = @pending_booking_id;
    
    -- Confirm the booking
    UPDATE bookings 
    SET status = 'Confirmed'
    WHERE id = @pending_booking_id;
    
    -- Show the booking after confirmation
    SELECT 
        'BOOKING AFTER CONFIRMATION' as Info,
        id,
        status,
        total_amount,
        payment_method,
        payment_status
    FROM bookings
    WHERE id = @pending_booking_id;
    
    PRINT 'SUCCESS: Booking ' + CAST(@pending_booking_id AS VARCHAR(10)) + ' has been confirmed!';
END
ELSE
BEGIN
    PRINT 'No pending bookings found to test confirmation.';
END

-- =============================================
-- 6. TEST CANCEL CONFIRMED BOOKING (Simulate admin action)
-- =============================================
-- Get a confirmed booking to test cancellation
DECLARE @confirmed_booking_id INT = (SELECT TOP 1 id FROM bookings WHERE status = 'Confirmed' ORDER BY created_at DESC);

IF @confirmed_booking_id IS NOT NULL
BEGIN
    -- Show the booking before cancellation
    SELECT 
        'BOOKING BEFORE CANCELLATION' as Info,
        id,
        status,
        total_amount,
        payment_method,
        payment_status
    FROM bookings
    WHERE id = @confirmed_booking_id;
    
    -- Cancel the booking
    UPDATE bookings 
    SET status = 'Cancelled'
    WHERE id = @confirmed_booking_id;
    
    -- Show the booking after cancellation
    SELECT 
        'BOOKING AFTER CANCELLATION' as Info,
        id,
        status,
        total_amount,
        payment_method,
        payment_status
    FROM bookings
    WHERE id = @confirmed_booking_id;
    
    PRINT 'SUCCESS: Booking ' + CAST(@confirmed_booking_id AS VARCHAR(10)) + ' has been cancelled!';
END
ELSE
BEGIN
    PRINT 'No confirmed bookings found to test cancellation.';
END

-- =============================================
-- 7. FINAL STATUS SUMMARY
-- =============================================
SELECT 
    'FINAL BOOKINGS STATUS SUMMARY' as Info,
    status,
    COUNT(*) as Count
FROM bookings
GROUP BY status
ORDER BY Count DESC;

-- =============================================
-- 8. RECENT BOOKING ACTIVITY
-- =============================================
SELECT TOP 10
    'RECENT BOOKING ACTIVITY' as Info,
    id,
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
    created_at
FROM bookings
ORDER BY created_at DESC;

PRINT 'Admin confirm booking functionality test completed!';
PRINT 'Check the results above to verify:';
PRINT '1. Current bookings status distribution';
PRINT '2. Pending bookings available for confirmation';
PRINT '3. Confirmed bookings available for cancellation';
PRINT '4. Admin users exist in the system';
PRINT '5. Booking confirmation functionality works';
PRINT '6. Booking cancellation functionality works';
PRINT '7. Final status summary';
PRINT '8. Recent booking activity';
