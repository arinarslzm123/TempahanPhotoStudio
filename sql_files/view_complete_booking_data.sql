-- =============================================
-- VIEW COMPLETE BOOKING DATA WITH JOINS
-- =============================================

USE TempahanPhotoStudio;
GO

-- View all bookings with complete details
SELECT 
    b.id as 'Booking ID',
    u.name as 'Customer Name',
    u.email as 'Customer Email',
    p.package_name as 'Package Name',
    p.category as 'Category',
    p.event as 'Event Type',
    sp.package_class as 'Package Class',
    sp.details as 'Package Details',
    sp.price as 'Package Price (RM)',
    b.booking_date as 'Booking Date',
    b.event_date as 'Event Date',
    b.event_time as 'Event Time',
    b.status as 'Booking Status',
    b.total_amount as 'Total Amount (RM)',
    b.payment_method as 'Payment Method',
    b.payment_status as 'Payment Status',
    b.notes as 'Notes',
    b.created_at as 'Created At'
FROM bookings b
JOIN users u ON b.user_id = u.id
JOIN packages p ON b.package_id = p.id
JOIN sub_packages sp ON b.sub_package_id = sp.id
ORDER BY b.created_at DESC;
GO

-- View packages available for booking
SELECT 
    p.id as 'Package ID',
    p.package_name as 'Package Name',
    p.category as 'Category',
    p.event as 'Event Type',
    p.duration as 'Duration',
    sp.package_class as 'Class',
    sp.price as 'Price (RM)',
    sp.details as 'Details'
FROM packages p
LEFT JOIN sub_packages sp ON p.id = sp.package_id
WHERE p.is_active = 1
ORDER BY p.category, p.package_name, sp.package_class;
GO

-- View users in the system
SELECT 
    id as 'User ID',
    name as 'Name',
    email as 'Email',
    role as 'Role',
    phone as 'Phone',
    created_at as 'Created At'
FROM users
ORDER BY role, name;
GO

-- Summary statistics
SELECT 
    'Total Users' as 'Metric',
    COUNT(*) as 'Count'
FROM users
UNION ALL
SELECT 
    'Total Packages',
    COUNT(*)
FROM packages
UNION ALL
SELECT 
    'Total Sub-packages',
    COUNT(*)
FROM sub_packages
UNION ALL
SELECT 
    'Total Bookings',
    COUNT(*)
FROM bookings
UNION ALL
SELECT 
    'Pending Bookings',
    COUNT(*)
FROM bookings
WHERE status = 'Pending'
UNION ALL
SELECT 
    'Confirmed Bookings',
    COUNT(*)
FROM bookings
WHERE status = 'Confirmed';
GO
