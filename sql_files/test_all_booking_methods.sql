-- =============================================
-- TEST ALL BOOKING METHODS
-- =============================================

USE TempahanPhotoStudio;
GO

-- Test 1: Insert multiple test bookings
INSERT INTO bookings (
    user_id, package_id, sub_package_id, booking_date, event_date, event_time, 
    status, total_amount, payment_method, payment_status, notes
) VALUES 
(1, 1, 1, '2025-01-10', '2025-10-15', '08:00', 'Pending', 1200.00, 'Cash', 'Pending', 'Test booking 1'),
(1, 2, 2, '2025-01-11', '2025-10-16', '09:00', 'Confirmed', 1800.00, 'Credit Card', 'Paid', 'Test booking 2'),
(2, 3, 3, '2025-01-12', '2025-10-17', '10:00', 'Pending', 2500.00, 'Bank Transfer', 'Pending', 'Test booking 3');

PRINT 'Test bookings inserted successfully';
GO

-- Test 2: getAllBookings() - Admin view all bookings
PRINT '=== getAllBookings() Test ===';
SELECT 
    id as 'Booking ID',
    user_id as 'User ID',
    package_id as 'Package ID',
    sub_package_id as 'Sub Package ID',
    booking_date as 'Booking Date',
    event_date as 'Event Date',
    event_time as 'Event Time',
    status as 'Status',
    total_amount as 'Total Amount',
    payment_method as 'Payment Method',
    payment_status as 'Payment Status',
    notes as 'Notes',
    created_at as 'Created At'
FROM bookings
ORDER BY created_at DESC;
GO

-- Test 3: getUserBookings(userId) - User view own bookings
PRINT '=== getUserBookings(1) Test ===';
SELECT 
    id as 'Booking ID',
    user_id as 'User ID',
    package_id as 'Package ID',
    sub_package_id as 'Sub Package ID',
    booking_date as 'Booking Date',
    event_date as 'Event Date',
    event_time as 'Event Time',
    status as 'Status',
    total_amount as 'Total Amount',
    payment_method as 'Payment Method',
    payment_status as 'Payment Status',
    notes as 'Notes',
    created_at as 'Created At'
FROM bookings
WHERE user_id = 1
ORDER BY created_at DESC;
GO

-- Test 4: getBookingById(bookingId) - Get specific booking
PRINT '=== getBookingById(1) Test ===';
SELECT 
    id as 'Booking ID',
    user_id as 'User ID',
    package_id as 'Package ID',
    sub_package_id as 'Sub Package ID',
    booking_date as 'Booking Date',
    event_date as 'Event Date',
    event_time as 'Event Time',
    status as 'Status',
    total_amount as 'Total Amount',
    payment_method as 'Payment Method',
    payment_status as 'Payment Status',
    notes as 'Notes',
    created_at as 'Created At'
FROM bookings
WHERE id = 1;
GO

-- Test 5: Update booking status (Admin functions)
PRINT '=== Update Booking Status Test ===';
UPDATE bookings 
SET status = 'Confirmed', 
    payment_status = 'Paid',
    notes = notes + ' - Updated by admin'
WHERE id = 1;

SELECT 
    id as 'Booking ID',
    status as 'New Status',
    payment_status as 'New Payment Status',
    notes as 'Updated Notes'
FROM bookings
WHERE id = 1;
GO

-- Test 6: Cancel booking (User function)
PRINT '=== Cancel Booking Test ===';
UPDATE bookings 
SET status = 'Cancelled',
    notes = notes + ' - Cancelled by user'
WHERE id = 2;

SELECT 
    id as 'Booking ID',
    status as 'New Status',
    notes as 'Updated Notes'
FROM bookings
WHERE id = 2;
GO

-- Test 7: Summary statistics
PRINT '=== Booking Statistics ===';
SELECT 
    status as 'Booking Status',
    COUNT(*) as 'Count',
    SUM(total_amount) as 'Total Amount (RM)',
    AVG(total_amount) as 'Average Amount (RM)'
FROM bookings
GROUP BY status
ORDER BY COUNT(*) DESC;
GO

PRINT '=============================================';
PRINT 'ALL BOOKING METHODS TEST COMPLETED';
PRINT '=============================================';
PRINT 'All BookingModel constructors should work correctly now';
PRINT 'Android app can now:';
PRINT '- Create bookings';
PRINT '- Retrieve all bookings (Admin)';
PRINT '- Retrieve user bookings (User)';
PRINT '- Get specific booking by ID';
PRINT '- Update booking status';
PRINT '- Cancel bookings';
GO
