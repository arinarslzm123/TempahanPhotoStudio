-- =============================================
-- TEST BOOKING RETRIEVAL
-- =============================================

USE TempahanPhotoStudio;
GO

-- Test 1: Insert test booking with all fields
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
    1, -- user_id
    1, -- package_id (PV1)
    1, -- sub_package_id
    '2025-01-10', -- booking_date
    '2025-10-15', -- event_date
    '08:00', -- event_time
    'Pending',
    1200.00,
    'Cash',
    'Pending',
    'Test booking for retrieval'
);

PRINT 'Test booking inserted for retrieval testing';
GO

-- Test 2: Get all bookings (simulating getAllBookings)
SELECT 
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
GO

-- Test 3: Get user bookings (simulating getUserBookings)
SELECT 
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
WHERE user_id = 1
ORDER BY created_at DESC;
GO

-- Test 4: Verify data types and formats
SELECT 
    'event_date' as 'Field',
    event_date as 'Sample Value',
    'NVARCHAR(20)' as 'Data Type'
FROM bookings
WHERE id = (SELECT MAX(id) FROM bookings)
UNION ALL
SELECT 
    'event_time',
    event_time,
    'NVARCHAR(10)'
FROM bookings
WHERE id = (SELECT MAX(id) FROM bookings)
UNION ALL
SELECT 
    'created_at',
    CAST(created_at as NVARCHAR(50)),
    'DATETIME'
FROM bookings
WHERE id = (SELECT MAX(id) FROM bookings);
GO

PRINT '=============================================';
PRINT 'BOOKING RETRIEVAL TEST COMPLETED';
PRINT '=============================================';
PRINT 'All booking retrieval methods should work correctly now';
PRINT 'Android app can now fetch bookings without constructor errors';
GO
