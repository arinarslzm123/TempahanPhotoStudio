-- =============================================
-- TEST DATE FORMAT FOR BOOKING
-- =============================================

USE TempahanPhotoStudio;
GO

-- Test inserting booking with correct date format
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
    '2025-01-10', -- booking_date (YYYY-MM-DD)
    '2025-10-15', -- event_date (YYYY-MM-DD) - converted from 15/10/2025
    '08:00', -- event_time
    'Pending',
    1200.00,
    'Cash',
    'Pending',
    'Test booking with correct date format'
);

PRINT 'Test booking with correct date format inserted successfully';
GO

-- View the test booking
SELECT 
    id as 'Booking ID',
    booking_date as 'Booking Date',
    event_date as 'Event Date',
    event_time as 'Event Time',
    status as 'Status',
    total_amount as 'Amount (RM)',
    notes as 'Notes'
FROM bookings
WHERE notes LIKE '%correct date format%';
GO

-- Test date conversion examples
SELECT 
    '15/10/2025' as 'Input Date (DD/MM/YYYY)',
    '2025-10-15' as 'Converted Date (YYYY-MM-DD)',
    '08:00' as 'Event Time'
UNION ALL
SELECT 
    '25/12/2025',
    '2025-12-25',
    '14:30'
UNION ALL
SELECT 
    '01/01/2026',
    '2026-01-01',
    '09:15';
GO

PRINT 'Date format conversion examples shown above';
PRINT 'Android app should convert DD/MM/YYYY to YYYY-MM-DD before sending to database';
GO
