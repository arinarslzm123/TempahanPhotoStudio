-- =============================================
-- TEST UPDATED BOOKING FUNCTIONALITY
-- =============================================
-- This script tests the updated booking functionality where data is saved to database

USE TempahanPhotoStudio;
GO

-- =============================================
-- 1. CHECK CURRENT BOOKINGS COUNT
-- =============================================
SELECT 
    'CURRENT BOOKINGS COUNT' as Info,
    COUNT(*) as Total_Bookings
FROM bookings;

-- =============================================
-- 2. SHOW RECENT BOOKINGS (Last 5)
-- =============================================
SELECT TOP 5
    'RECENT BOOKINGS' as Info,
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
-- 3. VERIFY PACKAGE AND SUB-PACKAGE DATA
-- =============================================
-- Check packages table
SELECT 
    'PACKAGES TABLE' as Info,
    COUNT(*) as Record_Count
FROM packages;

-- Show sample packages
SELECT TOP 3
    'SAMPLE PACKAGES' as Info,
    id,
    package_name,
    category,
    duration
FROM packages
ORDER BY id;

-- Check sub-packages table
SELECT 
    'SUB-PACKAGES TABLE' as Info,
    COUNT(*) as Record_Count
FROM sub_packages;

-- Show sample sub-packages
SELECT TOP 3
    'SAMPLE SUB-PACKAGES' as Info,
    id,
    package_id,
    sub_package_name,
    price,
    duration
FROM sub_packages
ORDER BY id;

-- =============================================
-- 4. CHECK USERS TABLE
-- =============================================
SELECT 
    'USERS TABLE' as Info,
    COUNT(*) as Record_Count
FROM users;

-- Show sample users
SELECT TOP 3
    'SAMPLE USERS' as Info,
    id,
    name,
    email,
    role
FROM users
ORDER BY id;

-- =============================================
-- 5. TEST PACKAGE AND SUB-PACKAGE LOOKUP
-- =============================================
-- Test package lookup by name
SELECT 
    'PACKAGE LOOKUP TEST' as Info,
    id,
    package_name,
    category,
    duration
FROM packages 
WHERE package_name LIKE '%Akad%'
ORDER BY id;

-- Test sub-package lookup by name
SELECT 
    'SUB-PACKAGE LOOKUP TEST' as Info,
    id,
    package_id,
    sub_package_name,
    price,
    duration
FROM sub_packages 
WHERE sub_package_name LIKE '%Regular%'
ORDER BY id;

-- =============================================
-- 6. BOOKING STATISTICS
-- =============================================
-- Bookings by status
SELECT 
    'BOOKINGS BY STATUS' as Info,
    status,
    COUNT(*) as Count
FROM bookings
GROUP BY status
ORDER BY Count DESC;

-- Bookings by payment method
SELECT 
    'BOOKINGS BY PAYMENT METHOD' as Info,
    payment_method,
    COUNT(*) as Count
FROM bookings
GROUP BY payment_method
ORDER BY Count DESC;

-- Bookings by payment status
SELECT 
    'BOOKINGS BY PAYMENT STATUS' as Info,
    payment_status,
    COUNT(*) as Count
FROM bookings
GROUP BY payment_status
ORDER BY Count DESC;

-- =============================================
-- 7. DATA INTEGRITY CHECK
-- =============================================
-- Check for orphaned bookings
SELECT 
    'ORPHANED BOOKINGS CHECK' as Info,
    COUNT(*) as Orphaned_Count
FROM bookings b
WHERE NOT EXISTS (SELECT 1 FROM users u WHERE u.id = b.user_id)
   OR NOT EXISTS (SELECT 1 FROM packages p WHERE p.id = b.package_id)
   OR NOT EXISTS (SELECT 1 FROM sub_packages sp WHERE sp.id = b.sub_package_id);

-- Check for valid bookings
SELECT 
    'VALID BOOKINGS CHECK' as Info,
    COUNT(*) as Valid_Count
FROM bookings b
WHERE EXISTS (SELECT 1 FROM users u WHERE u.id = b.user_id)
  AND EXISTS (SELECT 1 FROM packages p WHERE p.id = b.package_id)
  AND EXISTS (SELECT 1 FROM sub_packages sp WHERE sp.id = b.sub_package_id);

-- =============================================
-- 8. RECENT BOOKING ACTIVITY
-- =============================================
-- Bookings created today
SELECT 
    'TODAY''S BOOKINGS' as Info,
    COUNT(*) as Count
FROM bookings
WHERE CAST(created_at AS DATE) = CAST(GETDATE() AS DATE);

-- Bookings created in the last 7 days
SELECT 
    'LAST 7 DAYS BOOKINGS' as Info,
    COUNT(*) as Count
FROM bookings
WHERE created_at >= DATEADD(DAY, -7, GETDATE());

-- =============================================
-- 9. USER BOOKING SUMMARY
-- =============================================
SELECT 
    'USER BOOKING SUMMARY' as Info,
    u.id as user_id,
    u.name as user_name,
    u.email as user_email,
    COUNT(b.id) as total_bookings,
    SUM(b.total_amount) as total_amount,
    MIN(b.created_at) as first_booking,
    MAX(b.created_at) as last_booking
FROM users u
LEFT JOIN bookings b ON u.id = b.user_id
GROUP BY u.id, u.name, u.email
ORDER BY total_bookings DESC, u.name;

PRINT 'Updated booking functionality test completed!';
PRINT 'Check the results above to verify:';
PRINT '1. Current bookings count';
PRINT '2. Recent bookings data';
PRINT '3. Package and sub-package data availability';
PRINT '4. User data availability';
PRINT '5. Data integrity';
PRINT '6. Booking statistics';
PRINT '7. Recent booking activity';
PRINT '8. User booking summary';
