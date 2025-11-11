-- =============================================
-- TEST NEW BOOKING WITH PENDING STATUS
-- =============================================
-- This script tests that new bookings are created with "Pending" status for admin approval

USE TempahanPhotoStudio;
GO

-- =============================================
-- 1. CHECK CURRENT BOOKINGS STATUS DISTRIBUTION
-- =============================================
SELECT 
    'CURRENT BOOKINGS BY STATUS' as Info,
    status,
    COUNT(*) as Count,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM bookings) AS DECIMAL(5,2)) as Percentage
FROM bookings
GROUP BY status
ORDER BY Count DESC;

-- =============================================
-- 2. SHOW RECENT BOOKINGS
-- =============================================
SELECT TOP 10
    'RECENT BOOKINGS' as Info,
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
    notes,
    created_at
FROM bookings
ORDER BY created_at DESC;

-- =============================================
-- 3. SHOW PENDING BOOKINGS (Admin can confirm these)
-- =============================================
SELECT 
    'PENDING BOOKINGS FOR ADMIN APPROVAL' as Info,
    b.id,
    'BK-' + RIGHT('000' + CAST(b.id AS VARCHAR(10)), 3) as booking_id,
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
    b.notes,
    b.created_at
FROM bookings b
LEFT JOIN users u ON b.user_id = u.id
LEFT JOIN packages p ON b.package_id = p.id
LEFT JOIN sub_packages sp ON b.sub_package_id = sp.id
WHERE b.status = 'Pending'
ORDER BY b.created_at DESC;

-- =============================================
-- 4. SHOW CONFIRMED BOOKINGS (Admin can cancel these)
-- =============================================
SELECT 
    'CONFIRMED BOOKINGS' as Info,
    b.id,
    'BK-' + RIGHT('000' + CAST(b.id AS VARCHAR(10)), 3) as booking_id,
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
-- 5. CHECK ADMIN USERS
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
-- 6. SIMULATE NEW BOOKING CREATION
-- =============================================
-- Insert a test booking with Pending status
DECLARE @test_user_id INT = (SELECT TOP 1 id FROM users WHERE role = 'User' ORDER BY id);
DECLARE @test_package_id INT = (SELECT TOP 1 id FROM packages ORDER BY id);
DECLARE @test_sub_package_id INT = (SELECT TOP 1 id FROM sub_packages WHERE package_id = @test_package_id ORDER BY id);

IF @test_user_id IS NOT NULL AND @test_package_id IS NOT NULL AND @test_sub_package_id IS NOT NULL
BEGIN
    -- Insert test booking with Pending status
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
        @test_user_id,
        @test_package_id,
        @test_sub_package_id,
        CONVERT(VARCHAR(10), GETDATE(), 120), -- Current date
        CONVERT(VARCHAR(10), DATEADD(DAY, 30, GETDATE()), 120), -- Event 30 days from now
        '10:00',
        'Pending', -- New bookings start as Pending
        500.00,
        'Online Banking',
        'Pending', -- Payment status also Pending
        'Test booking - Status: Pending (Waiting for admin approval)'
    );
    
    -- Get the inserted booking ID
    DECLARE @new_booking_id INT = SCOPE_IDENTITY();
    
    -- Show the new booking
    SELECT 
        'NEW BOOKING CREATED' as Info,
        @new_booking_id as booking_id,
        'BK-' + RIGHT('000' + CAST(@new_booking_id AS VARCHAR(10)), 3) as booking_reference,
        'Pending' as status,
        'Pending' as payment_status,
        'Waiting for admin approval' as description;
    
    PRINT 'SUCCESS: New booking created with Pending status!';
    PRINT 'Booking ID: ' + CAST(@new_booking_id AS VARCHAR(10));
    PRINT 'Status: Pending (Waiting for admin approval)';
END
ELSE
BEGIN
    PRINT 'ERROR: Cannot create test booking - missing required data';
END

-- =============================================
-- 7. SIMULATE ADMIN CONFIRMATION
-- =============================================
-- Get the most recent pending booking
DECLARE @pending_booking_id INT = (SELECT TOP 1 id FROM bookings WHERE status = 'Pending' ORDER BY created_at DESC);

IF @pending_booking_id IS NOT NULL
BEGIN
    -- Show booking before confirmation
    SELECT 
        'BOOKING BEFORE ADMIN CONFIRMATION' as Info,
        id,
        'BK-' + RIGHT('000' + CAST(id AS VARCHAR(10)), 3) as booking_reference,
        status,
        payment_status,
        total_amount,
        event_date,
        event_time
    FROM bookings
    WHERE id = @pending_booking_id;
    
    -- Admin confirms the booking
    UPDATE bookings 
    SET status = 'Confirmed',
        payment_status = 'Paid'
    WHERE id = @pending_booking_id;
    
    -- Show booking after confirmation
    SELECT 
        'BOOKING AFTER ADMIN CONFIRMATION' as Info,
        id,
        'BK-' + RIGHT('000' + CAST(id AS VARCHAR(10)), 3) as booking_reference,
        status,
        payment_status,
        total_amount,
        event_date,
        event_time
    FROM bookings
    WHERE id = @pending_booking_id;
    
    PRINT 'SUCCESS: Admin confirmed booking ' + CAST(@pending_booking_id AS VARCHAR(10)) + '!';
    PRINT 'Status changed from Pending to Confirmed';
    PRINT 'Payment status changed from Pending to Paid';
END
ELSE
BEGIN
    PRINT 'No pending bookings found for admin confirmation test.';
END

-- =============================================
-- 8. FINAL STATUS SUMMARY
-- =============================================
SELECT 
    'FINAL BOOKINGS STATUS SUMMARY' as Info,
    status,
    COUNT(*) as Count,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM bookings) AS DECIMAL(5,2)) as Percentage
FROM bookings
GROUP BY status
ORDER BY Count DESC;

-- =============================================
-- 9. BOOKING WORKFLOW SUMMARY
-- =============================================
SELECT 
    'BOOKING WORKFLOW SUMMARY' as Info,
    '1. User creates booking' as Step_1,
    'Status: Pending' as Step_1_Result,
    '2. Admin reviews booking' as Step_2,
    'Admin can: Confirm or Cancel' as Step_2_Options,
    '3. If confirmed: Status = Confirmed' as Step_3_Confirm,
    '3. If cancelled: Status = Cancelled' as Step_3_Cancel;

PRINT 'New booking pending status test completed!';
PRINT 'Check the results above to verify:';
PRINT '1. Current bookings status distribution';
PRINT '2. Recent bookings';
PRINT '3. Pending bookings for admin approval';
PRINT '4. Confirmed bookings';
PRINT '5. Admin users exist';
PRINT '6. New booking creation with Pending status';
PRINT '7. Admin confirmation workflow';
PRINT '8. Final status summary';
PRINT '9. Booking workflow summary';
