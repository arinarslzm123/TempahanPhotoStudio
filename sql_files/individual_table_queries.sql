-- =============================================
-- INDIVIDUAL TABLE QUERIES
-- =============================================

USE TempahanPhotoStudio;
GO

-- =============================================
-- 1. USERS TABLE
-- =============================================
PRINT 'Creating USERS table...';

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='users' AND xtype='U')
BEGIN
    CREATE TABLE users (
        id INT IDENTITY(1,1) PRIMARY KEY,
        name NVARCHAR(50) NOT NULL,
        email NVARCHAR(100) UNIQUE NOT NULL,
        password NVARCHAR(255) NOT NULL,
        role NVARCHAR(20) DEFAULT 'User',
        phone NVARCHAR(20),
        created_at DATETIME DEFAULT GETDATE()
    );
    PRINT 'Users table created successfully';
END
ELSE
BEGIN
    PRINT 'Users table already exists';
END
GO

-- Insert sample users
INSERT INTO users (name, email, password, role) VALUES 
('Admin', 'admin@photostudio.com', 'admin123', 'Admin'),
('User', 'user@example.com', 'user123', 'User');
PRINT 'Sample users inserted';
GO

-- =============================================
-- 2. PACKAGES TABLE
-- =============================================
PRINT 'Creating PACKAGES table...';

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='packages' AND xtype='U')
BEGIN
    CREATE TABLE packages (
        id INT IDENTITY(1,1) PRIMARY KEY,
        package_name NVARCHAR(100) NOT NULL,
        event NVARCHAR(50) NOT NULL,
        duration NVARCHAR(50) NOT NULL,
        category NVARCHAR(50) NOT NULL,
        description NVARCHAR(500),
        image_url NVARCHAR(255),
        is_active BIT DEFAULT 1,
        created_at DATETIME DEFAULT GETDATE()
    );
    PRINT 'Packages table created successfully';
END
ELSE
BEGIN
    PRINT 'Packages table already exists';
END
GO

-- Insert videography packages
INSERT INTO packages (package_name, event, duration, category, description) VALUES 
('PV1 - Akad Nikah', 'Wedding', '6-7 Hours Per Day', 'Videography', 'Basic wedding videography package'),
('PV2 - Akad Nikah', 'Wedding', '6-7 Hours Per Day', 'Videography', 'Advanced wedding videography package'),
('PV3 - Akad Nikah', 'Wedding', '6-7 Hours Per Day', 'Videography', 'Premium wedding videography package'),
('PV4 - Akad Nikah', 'Wedding', '6-7 Hours Per Day', 'Videography', 'Ultimate wedding videography package'),
('PV5 - Akad Nikah', 'Wedding', '6-7 Hours Per Day', 'Videography', 'Luxury wedding videography package'),
('Akad Nikah & Sanding', 'Wedding', '8-10 hours', 'Videography', 'Complete wedding ceremony coverage'),
('Tunang', 'Engagement', '4-6 hours', 'Videography', 'Engagement ceremony videography');
PRINT 'Videography packages inserted';
GO

-- =============================================
-- 3. SUB_PACKAGES TABLE
-- =============================================
PRINT 'Creating SUB_PACKAGES table...';

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sub_packages' AND xtype='U')
BEGIN
    CREATE TABLE sub_packages (
        id INT IDENTITY(1,1) PRIMARY KEY,
        package_id INT NOT NULL,
        package_class NVARCHAR(20) NOT NULL,
        details NVARCHAR(500) NOT NULL,
        price DECIMAL(10,2) NOT NULL,
        description NVARCHAR(500),
        is_active BIT DEFAULT 1,
        created_at DATETIME DEFAULT GETDATE(),
        FOREIGN KEY (package_id) REFERENCES packages(id) ON DELETE CASCADE
    );
    PRINT 'Sub_packages table created successfully';
END
ELSE
BEGIN
    PRINT 'Sub_packages table already exists';
END
GO

-- Insert sub-packages for PV1-PV5
DECLARE @pv1_id INT = (SELECT id FROM packages WHERE package_name = 'PV1 - Akad Nikah');
DECLARE @pv2_id INT = (SELECT id FROM packages WHERE package_name = 'PV2 - Akad Nikah');
DECLARE @pv3_id INT = (SELECT id FROM packages WHERE package_name = 'PV3 - Akad Nikah');
DECLARE @pv4_id INT = (SELECT id FROM packages WHERE package_name = 'PV4 - Akad Nikah');
DECLARE @pv5_id INT = (SELECT id FROM packages WHERE package_name = 'PV5 - Akad Nikah');

-- PV1 Sub-package
INSERT INTO sub_packages (package_id, package_class, details, price, description) VALUES 
(@pv1_id, 'Regular', '1 Event 1 Video | Akad Nikah / Sanding (1 Day 1 Event) | 6-7 Hours Per Day | 1 x Full Showreel | 4-6 Minute Highlight Video | 1 x Exclusive Pendrive 16 GB & Case', 1200.00, 'Basic videography package');

-- PV2 Sub-package
INSERT INTO sub_packages (package_id, package_class, details, price, description) VALUES 
(@pv2_id, 'Advance', '1 Event 1 Video | Akad Nikah / Sanding (1 Day 1 Event) | 6-7 Hours Per Day | 1 x Full Showreel | 4-6 Minute Highlight Video | 1 x Exclusive Pendrive 16 GB & Case | Drone 1/Per Day RM500', 1800.00, 'Advanced videography package');

-- PV3 Sub-package
INSERT INTO sub_packages (package_id, package_class, details, price, description) VALUES 
(@pv3_id, 'Premium', '1 Event 1 Video | Akad Nikah / Sanding (1 Day 1 Event) | 6-7 Hours Per Day | 1 x Full Showreel | 4-6 Minute Highlight Video | 1 x Exclusive Pendrive 16 GB & Case | Drone 1/Per Day RM500 | +1 Videographer Per Day RM500', 2500.00, 'Premium videography package');

-- PV4 Sub-package
INSERT INTO sub_packages (package_id, package_class, details, price, description) VALUES 
(@pv4_id, 'Ultimate', '1 Event 1 Video | Akad Nikah / Sanding (1 Day 1 Event) | 6-7 Hours Per Day | 1 x Full Showreel | 4-6 Minute Highlight Video | 1 x Exclusive Pendrive 16 GB & Case | Drone 1/Per Day RM500 | +1 Videographer Per Day RM500 | Raw Footage + 64GB RM150', 3200.00, 'Ultimate videography package');

-- PV5 Sub-package
INSERT INTO sub_packages (package_id, package_class, details, price, description) VALUES 
(@pv5_id, 'Luxury', '1 Event 1 Video | Akad Nikah / Sanding (1 Day 1 Event) | 6-7 Hours Per Day | 1 x Full Showreel | 4-6 Minute Highlight Video | 1 x Exclusive Pendrive 16 GB & Case | Drone 1/Per Day RM500 | +1 Videographer Per Day RM500 | Raw Footage + 64GB RM150 | Makeup Per Hour RM100 | Termasuk Kos Pengangkutan | Penginapan', 4000.00, 'Luxury videography package');

PRINT 'Sub-packages inserted';
GO

-- =============================================
-- 4. BOOKINGS TABLE
-- =============================================
PRINT 'Creating BOOKINGS table...';

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='bookings' AND xtype='U')
BEGIN
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
    PRINT 'Bookings table created successfully';
END
ELSE
BEGIN
    PRINT 'Bookings table already exists';
END
GO

-- Insert sample bookings
DECLARE @pv1_booking_id INT = (SELECT id FROM packages WHERE package_name = 'PV1 - Akad Nikah');
DECLARE @pv1_sub_id INT = (SELECT id FROM sub_packages WHERE package_id = @pv1_booking_id);

INSERT INTO bookings (user_id, package_id, sub_package_id, booking_date, event_date, event_time, status, total_amount, payment_method, payment_status, notes) VALUES 
(1, @pv1_booking_id, @pv1_sub_id, '2025-01-10', '5/10/2025', '08:30', 'Pending', 1200.00, 'Cash', 'Pending', 'Test booking from app');

PRINT 'Sample booking inserted';
GO

-- =============================================
-- 5. VERIFY ALL TABLES
-- =============================================
PRINT '=============================================';
PRINT 'VERIFICATION COMPLETE';
PRINT '=============================================';

SELECT 'users' as TableName, COUNT(*) as RecordCount FROM users
UNION ALL
SELECT 'packages', COUNT(*) FROM packages
UNION ALL
SELECT 'sub_packages', COUNT(*) FROM sub_packages
UNION ALL
SELECT 'bookings', COUNT(*) FROM bookings;

PRINT '';
PRINT 'All tables created successfully!';
PRINT 'Login credentials:';
PRINT 'Admin: admin@photostudio.com / admin123';
PRINT 'User: user@example.com / user123';
