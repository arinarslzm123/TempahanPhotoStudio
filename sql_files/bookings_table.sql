-- =============================================
-- BOOKINGS TABLE QUERY
-- =============================================

USE TempahanPhotoStudio;
GO

-- Create Bookings Table
CREATE TABLE bookings (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    package_id INT NOT NULL,
    sub_package_id INT NOT NULL,
    booking_date NVARCHAR(20) NOT NULL,
    event_date NVARCHAR(20) NOT NULL,
    event_time NVARCHAR(10),
    status NVARCHAR(20) NOT NULL DEFAULT 'Pending',
    total_amount DECIMAL(10,2) NOT NULL,
    payment_method NVARCHAR(50) NOT NULL,
    payment_status NVARCHAR(20) NOT NULL DEFAULT 'Pending',
    notes NVARCHAR(500),
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (package_id) REFERENCES packages(id),
    FOREIGN KEY (sub_package_id) REFERENCES sub_packages(id)
);
GO

-- Insert Sample Bookings
DECLARE @user1_id INT = (SELECT id FROM users WHERE email = 'user@example.com');
DECLARE @user2_id INT = (SELECT id FROM users WHERE email = 'john@example.com');
DECLARE @pv1_id INT = (SELECT id FROM packages WHERE package_name = 'PV1 - Akad Nikah');
DECLARE @pv2_id INT = (SELECT id FROM packages WHERE package_name = 'PV2 - Akad Nikah');
DECLARE @pv3_id INT = (SELECT id FROM packages WHERE package_name = 'PV3 - Akad Nikah');
DECLARE @pv1_sub_id INT = (SELECT id FROM sub_packages WHERE package_id = @pv1_id);
DECLARE @pv2_sub_id INT = (SELECT id FROM sub_packages WHERE package_id = @pv2_id);
DECLARE @pv3_sub_id INT = (SELECT id FROM sub_packages WHERE package_id = @pv3_id);

INSERT INTO bookings (user_id, package_id, sub_package_id, booking_date, event_date, event_time, status, total_amount, payment_method, payment_status, notes) VALUES 
(@user1_id, @pv1_id, @pv1_sub_id, '2025-01-10', '5/10/2025', '08:30', 'Pending', 1200.00, 'Cash', 'Pending', 'Test booking from app'),

(@user2_id, @pv2_id, @pv2_sub_id, '2025-01-09', '6/10/2025', '09:00', 'Confirmed', 1800.00, 'Credit Card', 'Paid', 'Wedding booking - confirmed'),

(@user1_id, @pv3_id, @pv3_sub_id, '2025-01-08', '7/10/2025', '10:00', 'Pending', 2500.00, 'Bank Transfer', 'Pending', 'Premium package booking'),

(@user2_id, @pv1_id, @pv1_sub_id, '2025-01-07', '8/10/2025', '14:00', 'Completed', 1200.00, 'Cash', 'Paid', 'Completed wedding videography'),

(@user1_id, @pv2_id, @pv2_sub_id, '2025-01-06', '9/10/2025', '11:00', 'Cancelled', 1800.00, 'Credit Card', 'Refunded', 'Booking cancelled by customer');
GO

-- Verify Bookings Table
SELECT 
    b.id as 'Booking ID',
    u.name as 'Customer',
    p.package_name as 'Package',
    sp.package_class as 'Class',
    b.event_date as 'Event Date',
    b.event_time as 'Event Time',
    b.status as 'Status',
    b.total_amount as 'Amount (RM)',
    b.payment_method as 'Payment Method',
    b.payment_status as 'Payment Status'
FROM bookings b
JOIN users u ON b.user_id = u.id
JOIN packages p ON b.package_id = p.id
JOIN sub_packages sp ON b.sub_package_id = sp.id
ORDER BY b.created_at DESC;
GO
