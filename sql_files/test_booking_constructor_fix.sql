-- =============================================
-- TEST BOOKING CONSTRUCTOR FIX
-- =============================================
-- This script tests the booking functionality after fixing the SubPackageModel constructor

USE TempahanPhotoStudio;
GO

-- =============================================
-- 1. VERIFY SUB_PACKAGES TABLE STRUCTURE
-- =============================================
SELECT 
    'SUB_PACKAGES TABLE STRUCTURE' as Info,
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'sub_packages'
ORDER BY ORDINAL_POSITION;

-- =============================================
-- 2. CHECK SUB_PACKAGES DATA
-- =============================================
SELECT 
    'SUB_PACKAGES DATA COUNT' as Info,
    COUNT(*) as Total_Records
FROM sub_packages;

-- Show sample sub-packages with all fields
SELECT TOP 3
    'SAMPLE SUB_PACKAGES' as Info,
    id,
    package_id,
    sub_package_name,
    price,
    description,
    duration,
    CASE 
        WHEN media IS NULL THEN 'NULL'
        WHEN media = '' THEN 'EMPTY'
        ELSE 'HAS_DATA'
    END as media_status
FROM sub_packages
ORDER BY id;

-- =============================================
-- 3. CHECK PACKAGES TABLE STRUCTURE
-- =============================================
SELECT 
    'PACKAGES TABLE STRUCTURE' as Info,
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'packages'
ORDER BY ORDINAL_POSITION;

-- =============================================
-- 4. CHECK PACKAGES DATA
-- =============================================
SELECT 
    'PACKAGES DATA COUNT' as Info,
    COUNT(*) as Total_Records
FROM packages;

-- Show sample packages
SELECT TOP 3
    'SAMPLE PACKAGES' as Info,
    id,
    package_name,
    category,
    duration,
    description
FROM packages
ORDER BY id;

-- =============================================
-- 5. CHECK USERS TABLE
-- =============================================
SELECT 
    'USERS DATA COUNT' as Info,
    COUNT(*) as Total_Records
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
-- 6. CHECK BOOKINGS TABLE
-- =============================================
SELECT 
    'BOOKINGS DATA COUNT' as Info,
    COUNT(*) as Total_Records
FROM bookings;

-- Show recent bookings
SELECT TOP 3
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
    created_at
FROM bookings
ORDER BY created_at DESC;

-- =============================================
-- 7. TEST PACKAGE LOOKUP BY NAME
-- =============================================
-- Test package lookup
SELECT 
    'PACKAGE LOOKUP TEST' as Info,
    id,
    package_name,
    category,
    duration
FROM packages 
WHERE package_name = 'Akad Nikah';

-- =============================================
-- 8. TEST SUB_PACKAGE LOOKUP BY NAME
-- =============================================
-- Test sub-package lookup
SELECT 
    'SUB_PACKAGE LOOKUP TEST' as Info,
    id,
    package_id,
    sub_package_name,
    price,
    description,
    duration,
    media
FROM sub_packages 
WHERE sub_package_name = 'Regular';

-- =============================================
-- 9. VERIFY FOREIGN KEY RELATIONSHIPS
-- =============================================
-- Check if all bookings have valid foreign keys
SELECT 
    'VALID BOOKINGS CHECK' as Info,
    COUNT(*) as Valid_Count
FROM bookings b
WHERE EXISTS (SELECT 1 FROM users u WHERE u.id = b.user_id)
  AND EXISTS (SELECT 1 FROM packages p WHERE p.id = b.package_id)
  AND EXISTS (SELECT 1 FROM sub_packages sp WHERE sp.id = b.sub_package_id);

-- Check for orphaned bookings
SELECT 
    'ORPHANED BOOKINGS CHECK' as Info,
    COUNT(*) as Orphaned_Count
FROM bookings b
WHERE NOT EXISTS (SELECT 1 FROM users u WHERE u.id = b.user_id)
   OR NOT EXISTS (SELECT 1 FROM packages p WHERE p.id = b.package_id)
   OR NOT EXISTS (SELECT 1 FROM sub_packages sp WHERE sp.id = b.sub_package_id);

-- =============================================
-- 10. BOOKING STATISTICS
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

PRINT 'Booking constructor fix test completed!';
PRINT 'Check the results above to verify:';
PRINT '1. Sub-packages table structure is correct';
PRINT '2. All required fields exist (id, package_id, sub_package_name, price, description, duration, media)';
PRINT '3. Packages table structure is correct';
PRINT '4. Users table has data';
PRINT '5. Bookings table has data';
PRINT '6. Package and sub-package lookup functions work';
PRINT '7. Foreign key relationships are valid';
PRINT '8. Booking statistics are accurate';
