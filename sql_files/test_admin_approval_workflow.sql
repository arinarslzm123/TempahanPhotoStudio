-- =============================================
-- TEST ADMIN APPROVAL WORKFLOW
-- =============================================
-- This script tests the complete admin approval workflow for new bookings

USE TempahanPhotoStudio;
GO

-- =============================================
-- 1. BOOKING WORKFLOW OVERVIEW
-- =============================================
SELECT 
    'BOOKING WORKFLOW OVERVIEW' as Info,
    'Step 1: User creates booking' as Step_1,
    'Status: Pending' as Step_1_Status,
    'Payment: Pending' as Step_1_Payment,
    'Step 2: Admin reviews booking' as Step_2,
    'Admin can: Confirm or Cancel' as Step_2_Options,
    'Step 3a: If confirmed' as Step_3a,
    'Status: Confirmed, Payment: Paid' as Step_3a_Result,
    'Step 3b: If cancelled' as Step_3b,
    'Status: Cancelled, Payment: Pending' as Step_3b_Result;

-- =============================================
-- 2. CURRENT BOOKINGS STATUS
-- =============================================
SELECT 
    'CURRENT BOOKINGS STATUS' as Info,
    status,
    COUNT(*) as Count,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM bookings) AS DECIMAL(5,2)) as Percentage
FROM bookings
GROUP BY status
ORDER BY Count DESC;

-- =============================================
-- 3. PENDING BOOKINGS FOR ADMIN REVIEW
-- =============================================
SELECT 
    'PENDING BOOKINGS FOR ADMIN REVIEW' as Info,
    b.id,
    'BK-' + RIGHT('000' + CAST(b.id AS VARCHAR(10)), 3) as booking_reference,
    b.user_id,
    u.name as customer_name,
    u.email as customer_email,
    p.package_name,
    sp.sub_package_name,
    b.event_date,
    b.event_time,
    b.total_amount,
    b.payment_method,
    b.created_at,
    DATEDIFF(HOUR, b.created_at, GETDATE()) as hours_since_created
FROM bookings b
LEFT JOIN users u ON b.user_id = u.id
LEFT JOIN packages p ON b.package_id = p.id
LEFT JOIN sub_packages sp ON b.sub_package_id = sp.id
WHERE b.status = 'Pending'
ORDER BY b.created_at DESC;

-- =============================================
-- 4. ADMIN USERS AVAILABLE
-- =============================================
SELECT 
    'ADMIN USERS AVAILABLE' as Info,
    id,
    name,
    email,
    role
FROM users
WHERE role = 'Admin'
ORDER BY id;

-- =============================================
-- 5. SIMULATE USER CREATING NEW BOOKING
-- =============================================
-- Create a new booking with Pending status (simulating user action)
DECLARE @new_user_id INT = (SELECT TOP 1 id FROM users WHERE role = 'User' ORDER BY id);
DECLARE @new_package_id INT = (SELECT TOP 1 id FROM packages ORDER BY id);
DECLARE @new_sub_package_id INT = (SELECT TOP 1 id FROM sub_packages WHERE package_id = @new_package_id ORDER BY id);

IF @new_user_id IS NOT NULL AND @new_package_id IS NOT NULL AND @new_sub_package_id IS NOT NULL
BEGIN
    -- Insert new booking (simulating user creating booking)
    INSERT INTO bookings (
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
        notes
    ) VALUES (
        @new_user_id,
        @new_package_id,
        @new_sub_package_id,
        CONVERT(VARCHAR(10), GETDATE(), 120),
        CONVERT(VARCHAR(10), DATEADD(DAY, 30, GETDATE()), 120),
        '14:00',
        'Pending', -- User creates booking with Pending status
        800.00,
        'Online Banking',
        'Pending', -- Payment status also Pending
        'New booking created by user - Waiting for admin approval'
    );
    
    DECLARE @new_booking_id INT = SCOPE_IDENTITY();
    
    -- Show the new booking
    SELECT 
        'NEW BOOKING CREATED BY USER' as Info,
        @new_booking_id as booking_id,
        'BK-' + RIGHT('000' + CAST(@new_booking_id AS VARCHAR(10)), 3) as booking_reference,
        'Pending' as status,
        'Pending' as payment_status,
        'Waiting for admin approval' as next_step;
    
    PRINT 'SUCCESS: User created new booking with Pending status!';
    PRINT 'Booking ID: ' + CAST(@new_booking_id AS VARCHAR(10));
    PRINT 'Status: Pending (Waiting for admin approval)';
END
ELSE
BEGIN
    PRINT 'ERROR: Cannot create new booking - missing required data';
END

-- =============================================
-- 6. SIMULATE ADMIN CONFIRMING BOOKING
-- =============================================
-- Get the most recent pending booking
DECLARE @admin_pending_booking_id INT = (SELECT TOP 1 id FROM bookings WHERE status = 'Pending' ORDER BY created_at DESC);

IF @admin_pending_booking_id IS NOT NULL
BEGIN
    -- Show booking before admin action
    SELECT 
        'BOOKING BEFORE ADMIN ACTION' as Info,
        id,
        'BK-' + RIGHT('000' + CAST(id AS VARCHAR(10)), 3) as booking_reference,
        status,
        payment_status,
        total_amount,
        event_date,
        event_time,
        created_at
    FROM bookings
    WHERE id = @admin_pending_booking_id;
    
    -- Admin confirms the booking
    UPDATE bookings 
    SET status = 'Confirmed',
        payment_status = 'Paid',
        notes = notes + ' - Confirmed by admin on ' + CONVERT(VARCHAR(20), GETDATE(), 120)
    WHERE id = @admin_pending_booking_id;
    
    -- Show booking after admin confirmation
    SELECT 
        'BOOKING AFTER ADMIN CONFIRMATION' as Info,
        id,
        'BK-' + RIGHT('000' + CAST(id AS VARCHAR(10)), 3) as booking_reference,
        status,
        payment_status,
        total_amount,
        event_date,
        event_time,
        notes
    FROM bookings
    WHERE id = @admin_pending_booking_id;
    
    PRINT 'SUCCESS: Admin confirmed booking ' + CAST(@admin_pending_booking_id AS VARCHAR(10)) + '!';
    PRINT 'Status: Pending → Confirmed';
    PRINT 'Payment: Pending → Paid';
END
ELSE
BEGIN
    PRINT 'No pending bookings found for admin confirmation.';
END

-- =============================================
-- 7. SIMULATE ADMIN CANCELLING BOOKING
-- =============================================
-- Create another pending booking for cancellation test
DECLARE @cancel_user_id INT = (SELECT TOP 1 id FROM users WHERE role = 'User' ORDER BY id);
DECLARE @cancel_package_id INT = (SELECT TOP 1 id FROM packages ORDER BY id);
DECLARE @cancel_sub_package_id INT = (SELECT TOP 1 id FROM sub_packages WHERE package_id = @cancel_package_id ORDER BY id);

IF @cancel_user_id IS NOT NULL AND @cancel_package_id IS NOT NULL AND @cancel_sub_package_id IS NOT NULL
BEGIN
    -- Insert booking for cancellation test
    INSERT INTO bookings (
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
        notes
    ) VALUES (
        @cancel_user_id,
        @cancel_package_id,
        @cancel_sub_package_id,
        CONVERT(VARCHAR(10), GETDATE(), 120),
        CONVERT(VARCHAR(10), DATEADD(DAY, 45, GETDATE()), 120),
        '16:00',
        'Pending',
        600.00,
        'Cash',
        'Pending',
        'Booking for cancellation test - Waiting for admin approval'
    );
    
    DECLARE @cancel_booking_id INT = SCOPE_IDENTITY();
    
    -- Show booking before cancellation
    SELECT 
        'BOOKING BEFORE ADMIN CANCELLATION' as Info,
        id,
        'BK-' + RIGHT('000' + CAST(id AS VARCHAR(10)), 3) as booking_reference,
        status,
        payment_status,
        total_amount,
        event_date,
        event_time
    FROM bookings
    WHERE id = @cancel_booking_id;
    
    -- Admin cancels the booking
    UPDATE bookings 
    SET status = 'Cancelled',
        notes = notes + ' - Cancelled by admin on ' + CONVERT(VARCHAR(20), GETDATE(), 120)
    WHERE id = @cancel_booking_id;
    
    -- Show booking after cancellation
    SELECT 
        'BOOKING AFTER ADMIN CANCELLATION' as Info,
        id,
        'BK-' + RIGHT('000' + CAST(id AS VARCHAR(10)), 3) as booking_reference,
        status,
        payment_status,
        total_amount,
        event_date,
        event_time,
        notes
    FROM bookings
    WHERE id = @cancel_booking_id;
    
    PRINT 'SUCCESS: Admin cancelled booking ' + CAST(@cancel_booking_id AS VARCHAR(10)) + '!';
    PRINT 'Status: Pending → Cancelled';
    PRINT 'Payment: Pending (unchanged)';
END
ELSE
BEGIN
    PRINT 'Cannot create booking for cancellation test.';
END

-- =============================================
-- 8. FINAL WORKFLOW SUMMARY
-- =============================================
SELECT 
    'FINAL WORKFLOW SUMMARY' as Info,
    status,
    COUNT(*) as Count,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM bookings) AS DECIMAL(5,2)) as Percentage
FROM bookings
GROUP BY status
ORDER BY Count DESC;

-- =============================================
-- 9. RECENT BOOKING ACTIVITY
-- =============================================
SELECT TOP 10
    'RECENT BOOKING ACTIVITY' as Info,
    id,
    'BK-' + RIGHT('000' + CAST(id AS VARCHAR(10)), 3) as booking_reference,
    status,
    payment_status,
    total_amount,
    event_date,
    event_time,
    created_at
FROM bookings
ORDER BY created_at DESC;

-- =============================================
-- 10. ADMIN DASHBOARD VIEW
-- =============================================
-- Show what admin would see in their dashboard
SELECT 
    'ADMIN DASHBOARD VIEW' as Info,
    'Pending Bookings' as Section,
    COUNT(*) as Count
FROM bookings
WHERE status = 'Pending'
UNION ALL
SELECT 
    'ADMIN DASHBOARD VIEW' as Info,
    'Confirmed Bookings' as Section,
    COUNT(*) as Count
FROM bookings
WHERE status = 'Confirmed'
UNION ALL
SELECT 
    'ADMIN DASHBOARD VIEW' as Info,
    'Cancelled Bookings' as Section,
    COUNT(*) as Count
FROM bookings
WHERE status = 'Cancelled';

PRINT 'Admin approval workflow test completed!';
PRINT 'Check the results above to verify:';
PRINT '1. Booking workflow overview';
PRINT '2. Current bookings status';
PRINT '3. Pending bookings for admin review';
PRINT '4. Admin users available';
PRINT '5. User creating new booking';
PRINT '6. Admin confirming booking';
PRINT '7. Admin cancelling booking';
PRINT '8. Final workflow summary';
PRINT '9. Recent booking activity';
PRINT '10. Admin dashboard view';
