-- =============================================
-- VERIFY BOOKING FLOW
-- =============================================
-- This script verifies the complete booking flow from app to database

USE TempahanPhotoStudio;
GO

-- =============================================
-- 1. CHECK BOOKING TABLE STRUCTURE
-- =============================================
SELECT 
    'BOOKINGS TABLE STRUCTURE' as Info,
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'bookings'
ORDER BY ORDINAL_POSITION;

-- =============================================
-- 2. VERIFY FOREIGN KEY CONSTRAINTS
-- =============================================
SELECT 
    'FOREIGN KEY CONSTRAINTS' as Info,
    CONSTRAINT_NAME,
    COLUMN_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE 
WHERE TABLE_NAME = 'bookings' 
  AND CONSTRAINT_NAME LIKE 'FK_%'
ORDER BY CONSTRAINT_NAME;

-- =============================================
-- 3. CHECK DATA INTEGRITY
-- =============================================
-- Count total bookings
SELECT 
    'TOTAL BOOKINGS' as Info,
    COUNT(*) as Count
FROM bookings;

-- Check bookings with valid foreign keys
SELECT 
    'VALID BOOKINGS' as Info,
    COUNT(*) as Count
FROM bookings b
WHERE EXISTS (SELECT 1 FROM users u WHERE u.id = b.user_id)
  AND EXISTS (SELECT 1 FROM packages p WHERE p.id = b.package_id)
  AND EXISTS (SELECT 1 FROM sub_packages sp WHERE sp.id = b.sub_package_id);

-- Check for orphaned bookings
SELECT 
    'ORPHANED BOOKINGS' as Info,
    COUNT(*) as Count
FROM bookings b
WHERE NOT EXISTS (SELECT 1 FROM users u WHERE u.id = b.user_id)
   OR NOT EXISTS (SELECT 1 FROM packages p WHERE p.id = b.package_id)
   OR NOT EXISTS (SELECT 1 FROM sub_packages sp WHERE sp.id = b.sub_package_id);

-- =============================================
-- 4. RECENT BOOKINGS (Last 10)
-- =============================================
SELECT TOP 10
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
-- 5. BOOKING STATISTICS
-- =============================================
-- Bookings by status
SELECT 
    'BOOKINGS BY STATUS' as Info,
    status,
    COUNT(*) as Count,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM bookings) AS DECIMAL(5,2)) as Percentage
FROM bookings
GROUP BY status
ORDER BY Count DESC;

-- Bookings by payment method
SELECT 
    'BOOKINGS BY PAYMENT METHOD' as Info,
    payment_method,
    COUNT(*) as Count,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM bookings) AS DECIMAL(5,2)) as Percentage
FROM bookings
GROUP BY payment_method
ORDER BY Count DESC;

-- Bookings by payment status
SELECT 
    'BOOKINGS BY PAYMENT STATUS' as Info,
    payment_status,
    COUNT(*) as Count,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM bookings) AS DECIMAL(5,2)) as Percentage
FROM bookings
GROUP BY payment_status
ORDER BY Count DESC;

-- =============================================
-- 6. USER BOOKING SUMMARY
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

-- =============================================
-- 7. PACKAGE BOOKING SUMMARY
-- =============================================
SELECT 
    'PACKAGE BOOKING SUMMARY' as Info,
    p.id as package_id,
    p.package_name,
    p.category,
    COUNT(b.id) as total_bookings,
    SUM(b.total_amount) as total_revenue,
    AVG(b.total_amount) as avg_booking_amount
FROM packages p
LEFT JOIN bookings b ON p.id = b.package_id
GROUP BY p.id, p.package_name, p.category
ORDER BY total_bookings DESC, p.package_name;

-- =============================================
-- 8. SUB-PACKAGE BOOKING SUMMARY
-- =============================================
SELECT 
    'SUB-PACKAGE BOOKING SUMMARY' as Info,
    sp.id as sub_package_id,
    sp.sub_package_name,
    p.package_name,
    sp.price,
    COUNT(b.id) as total_bookings,
    SUM(b.total_amount) as total_revenue
FROM sub_packages sp
LEFT JOIN packages p ON sp.package_id = p.id
LEFT JOIN bookings b ON sp.id = b.sub_package_id
GROUP BY sp.id, sp.sub_package_name, p.package_name, sp.price
ORDER BY total_bookings DESC, sp.sub_package_name;

-- =============================================
-- 9. DATE RANGE ANALYSIS
-- =============================================
-- Bookings by month
SELECT 
    'BOOKINGS BY MONTH' as Info,
    YEAR(created_at) as year,
    MONTH(created_at) as month,
    COUNT(*) as booking_count,
    SUM(total_amount) as total_revenue
FROM bookings
GROUP BY YEAR(created_at), MONTH(created_at)
ORDER BY year DESC, month DESC;

-- =============================================
-- 10. DATA VALIDATION CHECKS
-- =============================================
-- Check for invalid dates
SELECT 
    'INVALID DATES' as Info,
    COUNT(*) as Count
FROM bookings
WHERE booking_date IS NULL 
   OR event_date IS NULL
   OR booking_date = ''
   OR event_date = '';

-- Check for invalid amounts
SELECT 
    'INVALID AMOUNTS' as Info,
    COUNT(*) as Count
FROM bookings
WHERE total_amount IS NULL 
   OR total_amount <= 0;

-- Check for missing required fields
SELECT 
    'MISSING REQUIRED FIELDS' as Info,
    COUNT(*) as Count
FROM bookings
WHERE user_id IS NULL 
   OR package_id IS NULL 
   OR sub_package_id IS NULL
   OR status IS NULL 
   OR payment_method IS NULL 
   OR payment_status IS NULL;

PRINT 'Booking flow verification completed!';
PRINT 'Review the results above to ensure:';
PRINT '1. Table structure is correct';
PRINT '2. Foreign key constraints are in place';
PRINT '3. Data integrity is maintained';
PRINT '4. Booking statistics are accurate';
PRINT '5. No data validation issues exist';
