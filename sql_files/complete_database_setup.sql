-- =============================================
-- COMPLETE DATABASE SETUP FOR TEMPAHAN PHOTO STUDIO
-- =============================================

USE TempahanPhotoStudio;
GO

-- =============================================
-- 1. CREATE USERS TABLE
-- =============================================
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

-- =============================================
-- 2. CREATE PACKAGES TABLE
-- =============================================
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

-- =============================================
-- 3. CREATE SUB_PACKAGES TABLE
-- =============================================
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

-- =============================================
-- 4. CREATE BOOKINGS TABLE
-- =============================================
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

-- =============================================
-- 5. INSERT SAMPLE DATA
-- =============================================

-- Insert Admin User
IF NOT EXISTS (SELECT * FROM users WHERE email = 'admin@photostudio.com')
BEGIN
    INSERT INTO users (name, email, password, role) 
    VALUES ('Admin', 'admin@photostudio.com', 'admin123', 'Admin');
    PRINT 'Admin user created';
END

-- Insert Regular User
IF NOT EXISTS (SELECT * FROM users WHERE email = 'user@example.com')
BEGIN
    INSERT INTO users (name, email, password, role) 
    VALUES ('User', 'user@example.com', 'user123', 'User');
    PRINT 'Regular user created';
END

-- Insert Photography Packages
IF NOT EXISTS (SELECT * FROM packages WHERE category = 'Photography')
BEGIN
    INSERT INTO packages (package_name, event, duration, category, description) VALUES 
    ('Wedding Photography - Full Day', 'Wedding', '8-10 hours', 'Photography', 'Complete wedding photography coverage'),
    ('Engagement Photography', 'Engagement', '4-6 hours', 'Photography', 'Engagement photo session'),
    ('Portrait Photography', 'Portrait', '2-3 hours', 'Photography', 'Professional portrait session'),
    ('Event Photography', 'Corporate Event', '6-8 hours', 'Photography', 'Corporate event coverage');
    PRINT 'Photography packages inserted';
END

-- Insert Videography Packages
IF NOT EXISTS (SELECT * FROM packages WHERE category = 'Videography')
BEGIN
    INSERT INTO packages (package_name, event, duration, category, description) VALUES 
    ('PV1 - Akad Nikah', 'Wedding', '6-7 Hours Per Day', 'Videography', 'Basic wedding videography package'),
    ('PV2 - Akad Nikah', 'Wedding', '6-7 Hours Per Day', 'Videography', 'Advanced wedding videography package'),
    ('PV3 - Akad Nikah', 'Wedding', '6-7 Hours Per Day', 'Videography', 'Premium wedding videography package'),
    ('PV4 - Akad Nikah', 'Wedding', '6-7 Hours Per Day', 'Videography', 'Ultimate wedding videography package'),
    ('PV5 - Akad Nikah', 'Wedding', '6-7 Hours Per Day', 'Videography', 'Luxury wedding videography package'),
    ('Akad Nikah & Sanding', 'Wedding', '8-10 hours', 'Videography', 'Complete wedding ceremony coverage'),
    ('Tunang', 'Engagement', '4-6 hours', 'Videography', 'Engagement ceremony videography');
    PRINT 'Videography packages inserted';
END

-- Insert Sub-packages for Photography
DECLARE @photo_package_id INT = (SELECT id FROM packages WHERE package_name = 'Wedding Photography - Full Day' AND category = 'Photography');
IF @photo_package_id IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT * FROM sub_packages WHERE package_id = @photo_package_id)
    BEGIN
        INSERT INTO sub_packages (package_id, package_class, details, price, description) VALUES 
        (@photo_package_id, 'Regular', '100 edited photos, basic editing', 500.00, 'Basic wedding package'),
        (@photo_package_id, 'Advance', '200 edited photos, advanced editing, album', 800.00, 'Advanced wedding package'),
        (@photo_package_id, 'Premium', '300 edited photos, premium editing, album, video', 1200.00, 'Premium wedding package');
    END
END

-- Insert Sub-packages for Videography (PV1-PV5)
DECLARE @pv1_id INT = (SELECT id FROM packages WHERE package_name = 'PV1 - Akad Nikah');
DECLARE @pv2_id INT = (SELECT id FROM packages WHERE package_name = 'PV2 - Akad Nikah');
DECLARE @pv3_id INT = (SELECT id FROM packages WHERE package_name = 'PV3 - Akad Nikah');
DECLARE @pv4_id INT = (SELECT id FROM packages WHERE package_name = 'PV4 - Akad Nikah');
DECLARE @pv5_id INT = (SELECT id FROM packages WHERE package_name = 'PV5 - Akad Nikah');

-- PV1 Sub-packages
IF @pv1_id IS NOT NULL AND NOT EXISTS (SELECT * FROM sub_packages WHERE package_id = @pv1_id)
BEGIN
    INSERT INTO sub_packages (package_id, package_class, details, price, description) VALUES 
    (@pv1_id, 'Regular', '1 Event 1 Video | Akad Nikah / Sanding (1 Day 1 Event) | 6-7 Hours Per Day | 1 x Full Showreel | 4-6 Minute Highlight Video | 1 x Exclusive Pendrive 16 GB & Case', 1200.00, 'Basic videography package');
END

-- PV2 Sub-packages
IF @pv2_id IS NOT NULL AND NOT EXISTS (SELECT * FROM sub_packages WHERE package_id = @pv2_id)
BEGIN
    INSERT INTO sub_packages (package_id, package_class, details, price, description) VALUES 
    (@pv2_id, 'Advance', '1 Event 1 Video | Akad Nikah / Sanding (1 Day 1 Event) | 6-7 Hours Per Day | 1 x Full Showreel | 4-6 Minute Highlight Video | 1 x Exclusive Pendrive 16 GB & Case | Drone 1/Per Day RM500', 1800.00, 'Advanced videography package');
END

-- PV3 Sub-packages
IF @pv3_id IS NOT NULL AND NOT EXISTS (SELECT * FROM sub_packages WHERE package_id = @pv3_id)
BEGIN
    INSERT INTO sub_packages (package_id, package_class, details, price, description) VALUES 
    (@pv3_id, 'Premium', '1 Event 1 Video | Akad Nikah / Sanding (1 Day 1 Event) | 6-7 Hours Per Day | 1 x Full Showreel | 4-6 Minute Highlight Video | 1 x Exclusive Pendrive 16 GB & Case | Drone 1/Per Day RM500 | +1 Videographer Per Day RM500', 2500.00, 'Premium videography package');
END

-- PV4 Sub-packages
IF @pv4_id IS NOT NULL AND NOT EXISTS (SELECT * FROM sub_packages WHERE package_id = @pv4_id)
BEGIN
    INSERT INTO sub_packages (package_id, package_class, details, price, description) VALUES 
    (@pv4_id, 'Ultimate', '1 Event 1 Video | Akad Nikah / Sanding (1 Day 1 Event) | 6-7 Hours Per Day | 1 x Full Showreel | 4-6 Minute Highlight Video | 1 x Exclusive Pendrive 16 GB & Case | Drone 1/Per Day RM500 | +1 Videographer Per Day RM500 | Raw Footage + 64GB RM150', 3200.00, 'Ultimate videography package');
END

-- PV5 Sub-packages
IF @pv5_id IS NOT NULL AND NOT EXISTS (SELECT * FROM sub_packages WHERE package_id = @pv5_id)
BEGIN
    INSERT INTO sub_packages (package_id, package_class, details, price, description) VALUES 
    (@pv5_id, 'Luxury', '1 Event 1 Video | Akad Nikah / Sanding (1 Day 1 Event) | 6-7 Hours Per Day | 1 x Full Showreel | 4-6 Minute Highlight Video | 1 x Exclusive Pendrive 16 GB & Case | Drone 1/Per Day RM500 | +1 Videographer Per Day RM500 | Raw Footage + 64GB RM150 | Makeup Per Hour RM100 | Termasuk Kos Pengangkutan | Penginapan', 4000.00, 'Luxury videography package');
END

-- Insert Sample Bookings
IF NOT EXISTS (SELECT * FROM bookings)
BEGIN
    INSERT INTO bookings (user_id, package_id, sub_package_id, booking_date, event_date, event_time, status, total_amount, payment_method, payment_status, notes) VALUES 
    (1, @pv1_id, 1, '2025-01-10', '5/10/2025', '08:30', 'Pending', 1200.00, 'Cash', 'Pending', 'Test booking from app'),
    (2, @pv2_id, 2, '2025-01-09', '6/10/2025', '09:00', 'Confirmed', 1800.00, 'Credit Card', 'Paid', 'Wedding booking'),
    (1, @pv3_id, 3, '2025-01-08', '7/10/2025', '10:00', 'Pending', 2500.00, 'Bank Transfer', 'Pending', 'Premium package booking');
    PRINT 'Sample bookings inserted';
END

-- =============================================
-- 6. VERIFY DATA
-- =============================================
PRINT '=============================================';
PRINT 'DATABASE SETUP COMPLETED';
PRINT '=============================================';

SELECT 'Users' as TableName, COUNT(*) as RecordCount FROM users
UNION ALL
SELECT 'Packages', COUNT(*) FROM packages
UNION ALL
SELECT 'Sub Packages', COUNT(*) FROM sub_packages
UNION ALL
SELECT 'Bookings', COUNT(*) FROM bookings;

PRINT '';
PRINT 'Sample Data:';
PRINT 'Admin Login: admin@photostudio.com / admin123';
PRINT 'User Login: user@example.com / user123';
PRINT '';

-- Show packages that will appear in the app
PRINT 'Available Packages for Booking:';
SELECT p.id, p.package_name, p.category, p.event, p.duration, sp.package_class, sp.price
FROM packages p
LEFT JOIN sub_packages sp ON p.id = sp.package_id
WHERE p.is_active = 1
ORDER BY p.category, p.package_name, sp.package_class;

GO