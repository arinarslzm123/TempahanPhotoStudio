-- Create Bookings table if not exists
USE TempahanPhotoStudio;
GO

-- Check if bookings table exists, if not create it
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='bookings' AND xtype='U')
BEGIN
    CREATE TABLE bookings (
        id INT IDENTITY(1,1) PRIMARY KEY,
        user_id INT NOT NULL,
        package_id INT NOT NULL,
        sub_package_id INT NOT NULL,
        booking_date NVARCHAR(20) NOT NULL,
        event_date NVARCHAR(20) NOT NULL,
        status NVARCHAR(20) NOT NULL DEFAULT 'Pending',
        total_amount DECIMAL(10,2) NOT NULL,
        payment_method NVARCHAR(50) NOT NULL,
        payment_status NVARCHAR(20) NOT NULL DEFAULT 'Pending',
        notes NVARCHAR(500),
        created_at NVARCHAR(50) NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users(id),
        FOREIGN KEY (package_id) REFERENCES packages(id),
        FOREIGN KEY (sub_package_id) REFERENCES sub_packages(id)
    );
    PRINT 'Bookings table created successfully';
END
ELSE
BEGIN
    PRINT 'Bookings table already exists';
END
GO

-- Insert sample booking data for testing
INSERT INTO bookings (user_id, package_id, sub_package_id, booking_date, event_date, status, total_amount, payment_method, payment_status, notes, created_at)
VALUES 
(1, 1, 1, '2025-01-10', '5/10/2025', 'Pending', 1200.00, 'Cash', 'Pending', 'Test booking', '2025-01-10 08:30:00'),
(1, 2, 2, '2025-01-09', '6/10/2025', 'Confirmed', 1800.00, 'Credit Card', 'Paid', 'Wedding booking', '2025-01-09 10:15:00');
GO

-- Verify the table was created and has data
SELECT COUNT(*) as 'Total Bookings' FROM bookings;
SELECT * FROM bookings;
GO
