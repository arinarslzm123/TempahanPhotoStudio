-- =============================================
-- TEST BOOKING DATABASE INSERT
-- =============================================
-- This script tests inserting a booking directly into the database
-- to verify the booking functionality works correctly

USE TempahanPhotoStudio;
GO

-- =============================================
-- 1. PREPARE TEST DATA
-- =============================================
-- Get a test user (preferably a regular user, not admin)
DECLARE @test_user_id INT = (SELECT TOP 1 id FROM users WHERE role = 'User' ORDER BY id);
DECLARE @test_package_id INT = (SELECT TOP 1 id FROM packages ORDER BY id);
DECLARE @test_sub_package_id INT = (SELECT TOP 1 id FROM sub_packages WHERE package_id = @test_package_id ORDER BY id);

-- Display test data
SELECT 
    'TEST DATA PREPARATION' as Info,
    @test_user_id as user_id,
    @test_package_id as package_id,
    @test_sub_package_id as sub_package_id;

-- Show the test user details
SELECT 
    'TEST USER' as Info,
    id,
    name,
    email,
    role
FROM users 
WHERE id = @test_user_id;

-- Show the test package details
SELECT 
    'TEST PACKAGE' as Info,
    p.id,
    p.package_name,
    p.category,
    p.price
FROM packages p
WHERE p.id = @test_package_id;

-- Show the test sub-package details
SELECT 
    'TEST SUB-PACKAGE' as Info,
    sp.id,
    sp.package_id,
    sp.sub_package_name,
    sp.price,
    sp.duration
FROM sub_packages sp
WHERE sp.id = @test_sub_package_id;

-- =============================================
-- 2. INSERT TEST BOOKING
-- =============================================
IF @test_user_id IS NOT NULL AND @test_package_id IS NOT NULL AND @test_sub_package_id IS NOT NULL
BEGIN
    -- Insert test booking
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
        CONVERT(VARCHAR(10), GETDATE(), 120), -- Current date in YYYY-MM-DD format
        CONVERT(VARCHAR(10), DATEADD(DAY, 30, GETDATE()), 120), -- Event date 30 days from now
        '10:00', -- Event time
        'Pending', -- Status
        500.00, -- Total amount
        'Online Banking', -- Payment method
        'Pending', -- Payment status
        'Test booking inserted via SQL script - ' + CONVERT(VARCHAR(20), GETDATE(), 120)
    );
    
    PRINT 'SUCCESS: Test booking inserted successfully!';
    PRINT 'User ID: ' + CAST(@test_user_id AS VARCHAR(10));
    PRINT 'Package ID: ' + CAST(@test_package_id AS VARCHAR(10));
    PRINT 'Sub-Package ID: ' + CAST(@test_sub_package_id AS VARCHAR(10));
END
ELSE
BEGIN
    PRINT 'ERROR: Cannot insert test booking - missing required data';
    PRINT 'User ID: ' + ISNULL(CAST(@test_user_id AS VARCHAR(10)), 'NULL');
    PRINT 'Package ID: ' + ISNULL(CAST(@test_package_id AS VARCHAR(10)), 'NULL');
    PRINT 'Sub-Package ID: ' + ISNULL(CAST(@test_sub_package_id AS VARCHAR(10)), 'NULL');
END

-- =============================================
-- 3. VERIFY INSERTED BOOKING
-- =============================================
-- Show the latest booking (should be our test booking)
SELECT TOP 1
    'LATEST BOOKING' as Info,
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
    b.notes,
    b.created_at
FROM bookings b
LEFT JOIN users u ON b.user_id = u.id
LEFT JOIN packages p ON b.package_id = p.id
LEFT JOIN sub_packages sp ON b.sub_package_id = sp.id
ORDER BY b.created_at DESC;

-- =============================================
-- 4. COUNT TOTAL BOOKINGS
-- =============================================
SELECT 
    'TOTAL BOOKINGS' as Info,
    COUNT(*) as Booking_Count
FROM bookings;

-- =============================================
-- 5. BOOKINGS BY STATUS
-- =============================================
SELECT 
    'BOOKINGS BY STATUS' as Info,
    status,
    COUNT(*) as Count
FROM bookings
GROUP BY status
ORDER BY status;

-- =============================================
-- 6. BOOKINGS BY PAYMENT METHOD
-- =============================================
SELECT 
    'BOOKINGS BY PAYMENT METHOD' as Info,
    payment_method,
    COUNT(*) as Count
FROM bookings
GROUP BY payment_method
ORDER BY payment_method;

PRINT 'Test booking database insert completed!';
PRINT 'Check the results above to verify the booking was inserted correctly.';
