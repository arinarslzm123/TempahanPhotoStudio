-- =============================================
-- TEST BOOKING FUNCTIONALITY
-- =============================================
-- This script tests the booking functionality to ensure data is saved correctly

USE TempahanPhotoStudio;
GO

-- =============================================
-- 1. VERIFY BOOKINGS TABLE STRUCTURE
-- =============================================
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'bookings'
ORDER BY ORDINAL_POSITION;

-- =============================================
-- 2. CHECK CURRENT BOOKINGS DATA
-- =============================================
SELECT 
    'CURRENT BOOKINGS' as Info,
    COUNT(*) as Total_Bookings
FROM bookings;

-- Show all bookings with details
SELECT 
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
    b.notes,
    b.created_at
FROM bookings b
LEFT JOIN users u ON b.user_id = u.id
LEFT JOIN packages p ON b.package_id = p.id
LEFT JOIN sub_packages sp ON b.sub_package_id = sp.id
ORDER BY b.created_at DESC;

-- =============================================
-- 3. VERIFY REQUIRED TABLES AND DATA
-- =============================================
-- Check users table
SELECT 
    'USERS TABLE' as Table_Name,
    COUNT(*) as Record_Count
FROM users;

-- Check packages table
SELECT 
    'PACKAGES TABLE' as Table_Name,
    COUNT(*) as Record_Count
FROM packages;

-- Check sub_packages table
SELECT 
    'SUB_PACKAGES TABLE' as Table_Name,
    COUNT(*) as Record_Count
FROM sub_packages;

-- =============================================
-- 4. TEST DATA FOR BOOKING
-- =============================================
-- Show available users for booking
SELECT 
    id,
    name,
    email,
    role
FROM users 
ORDER BY role, name;

-- Show available packages for booking
SELECT 
    p.id,
    p.package_name,
    p.category,
    p.price,
    COUNT(sp.id) as sub_package_count
FROM packages p
LEFT JOIN sub_packages sp ON p.id = sp.package_id
GROUP BY p.id, p.package_name, p.category, p.price
ORDER BY p.category, p.package_name;

-- Show available sub-packages for booking
SELECT 
    sp.id,
    sp.package_id,
    p.package_name,
    sp.sub_package_name,
    sp.price,
    sp.duration
FROM sub_packages sp
JOIN packages p ON sp.package_id = p.id
ORDER BY p.package_name, sp.sub_package_name;

-- =============================================
-- 5. INSERT TEST BOOKING (if needed)
-- =============================================
-- Uncomment the following lines to insert a test booking
/*
DECLARE @test_user_id INT = (SELECT TOP 1 id FROM users WHERE role = 'User');
DECLARE @test_package_id INT = (SELECT TOP 1 id FROM packages);
DECLARE @test_sub_package_id INT = (SELECT TOP 1 id FROM sub_packages WHERE package_id = @test_package_id);

IF @test_user_id IS NOT NULL AND @test_package_id IS NOT NULL AND @test_sub_package_id IS NOT NULL
BEGIN
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
        CONVERT(VARCHAR(10), GETDATE(), 120), -- YYYY-MM-DD format
        CONVERT(VARCHAR(10), DATEADD(DAY, 30, GETDATE()), 120), -- Event 30 days from now
        '10:00',
        'Pending',
        500.00,
        'Online Banking',
        'Pending',
        'Test booking from SQL script'
    );
    
    PRINT 'Test booking inserted successfully!';
END
ELSE
BEGIN
    PRINT 'Cannot insert test booking - missing required data';
END
*/

-- =============================================
-- 6. VERIFY FOREIGN KEY RELATIONSHIPS
-- =============================================
-- Check if all bookings have valid foreign keys
SELECT 
    'BOOKINGS WITH VALID FOREIGN KEYS' as Check_Type,
    COUNT(*) as Valid_Bookings
FROM bookings b
WHERE EXISTS (SELECT 1 FROM users u WHERE u.id = b.user_id)
  AND EXISTS (SELECT 1 FROM packages p WHERE p.id = b.package_id)
  AND EXISTS (SELECT 1 FROM sub_packages sp WHERE sp.id = b.sub_package_id);

-- Check for orphaned bookings
SELECT 
    'ORPHANED BOOKINGS' as Check_Type,
    COUNT(*) as Orphaned_Count
FROM bookings b
WHERE NOT EXISTS (SELECT 1 FROM users u WHERE u.id = b.user_id)
   OR NOT EXISTS (SELECT 1 FROM packages p WHERE p.id = b.package_id)
   OR NOT EXISTS (SELECT 1 FROM sub_packages sp WHERE sp.id = b.sub_package_id);

PRINT 'Booking functionality test completed!';
PRINT 'Check the results above to verify:';
PRINT '1. Bookings table structure is correct';
PRINT '2. Data exists in all related tables';
PRINT '3. Foreign key relationships are valid';
PRINT '4. Test data is available for booking';