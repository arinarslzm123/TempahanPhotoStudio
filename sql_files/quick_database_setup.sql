-- =============================================
-- QUICK DATABASE SETUP - MINIMAL VERSION
-- =============================================

USE TempahanPhotoStudio;
GO

-- Create tables if not exist
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='users' AND xtype='U')
CREATE TABLE users (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(50) NOT NULL,
    email NVARCHAR(100) UNIQUE NOT NULL,
    password NVARCHAR(255) NOT NULL,
    role NVARCHAR(20) DEFAULT 'User',
    phone NVARCHAR(20),
    created_at DATETIME DEFAULT GETDATE()
);

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='packages' AND xtype='U')
CREATE TABLE packages (
    id INT IDENTITY(1,1) PRIMARY KEY,
    package_name NVARCHAR(100) NOT NULL,
    event NVARCHAR(50) NOT NULL,
    duration NVARCHAR(50) NOT NULL,
    category NVARCHAR(50) NOT NULL,
    description NVARCHAR(500),
    is_active BIT DEFAULT 1,
    created_at DATETIME DEFAULT GETDATE()
);

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sub_packages' AND xtype='U')
CREATE TABLE sub_packages (
    id INT IDENTITY(1,1) PRIMARY KEY,
    package_id INT NOT NULL,
    package_class NVARCHAR(20) NOT NULL,
    details NVARCHAR(500) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    is_active BIT DEFAULT 1,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (package_id) REFERENCES packages(id)
);

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='bookings' AND xtype='U')
CREATE TABLE bookings (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    package_id INT NOT NULL,
    sub_package_id INT NOT NULL,
    booking_date NVARCHAR(20) NOT NULL,
    event_date NVARCHAR(20) NOT NULL,
    event_time NVARCHAR(10),
    status NVARCHAR(20) DEFAULT 'Pending',
    total_amount DECIMAL(10,2) NOT NULL,
    payment_method NVARCHAR(50) NOT NULL,
    payment_status NVARCHAR(20) DEFAULT 'Pending',
    notes NVARCHAR(500),
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (package_id) REFERENCES packages(id),
    FOREIGN KEY (sub_package_id) REFERENCES sub_packages(id)
);

-- Insert essential data
INSERT INTO users (name, email, password, role) VALUES 
('Admin', 'admin@photostudio.com', 'admin123', 'Admin'),
('User', 'user@example.com', 'user123', 'User');

INSERT INTO packages (package_name, event, duration, category) VALUES 
('PV1 - Akad Nikah', 'Wedding', '6-7 Hours Per Day', 'Videography'),
('PV2 - Akad Nikah', 'Wedding', '6-7 Hours Per Day', 'Videography'),
('PV3 - Akad Nikah', 'Wedding', '6-7 Hours Per Day', 'Videography'),
('PV4 - Akad Nikah', 'Wedding', '6-7 Hours Per Day', 'Videography'),
('PV5 - Akad Nikah', 'Wedding', '6-7 Hours Per Day', 'Videography'),
('Akad Nikah & Sanding', 'Wedding', '8-10 hours', 'Videography'),
('Tunang', 'Engagement', '4-6 hours', 'Videography');

-- Insert sub-packages
DECLARE @pv1 INT = (SELECT id FROM packages WHERE package_name = 'PV1 - Akad Nikah');
DECLARE @pv2 INT = (SELECT id FROM packages WHERE package_name = 'PV2 - Akad Nikah');
DECLARE @pv3 INT = (SELECT id FROM packages WHERE package_name = 'PV3 - Akad Nikah');
DECLARE @pv4 INT = (SELECT id FROM packages WHERE package_name = 'PV4 - Akad Nikah');
DECLARE @pv5 INT = (SELECT id FROM packages WHERE package_name = 'PV5 - Akad Nikah');

INSERT INTO sub_packages (package_id, package_class, details, price) VALUES 
(@pv1, 'Regular', '1 Event 1 Video | Akad Nikah / Sanding (1 Day 1 Event) | 6-7 Hours Per Day | 1 x Full Showreel | 4-6 Minute Highlight Video | 1 x Exclusive Pendrive 16 GB & Case', 1200.00),
(@pv2, 'Advance', '1 Event 1 Video | Akad Nikah / Sanding (1 Day 1 Event) | 6-7 Hours Per Day | 1 x Full Showreel | 4-6 Minute Highlight Video | 1 x Exclusive Pendrive 16 GB & Case | Drone 1/Per Day RM500', 1800.00),
(@pv3, 'Premium', '1 Event 1 Video | Akad Nikah / Sanding (1 Day 1 Event) | 6-7 Hours Per Day | 1 x Full Showreel | 4-6 Minute Highlight Video | 1 x Exclusive Pendrive 16 GB & Case | Drone 1/Per Day RM500 | +1 Videographer Per Day RM500', 2500.00),
(@pv4, 'Ultimate', '1 Event 1 Video | Akad Nikah / Sanding (1 Day 1 Event) | 6-7 Hours Per Day | 1 x Full Showreel | 4-6 Minute Highlight Video | 1 x Exclusive Pendrive 16 GB & Case | Drone 1/Per Day RM500 | +1 Videographer Per Day RM500 | Raw Footage + 64GB RM150', 3200.00),
(@pv5, 'Luxury', '1 Event 1 Video | Akad Nikah / Sanding (1 Day 1 Event) | 6-7 Hours Per Day | 1 x Full Showreel | 4-6 Minute Highlight Video | 1 x Exclusive Pendrive 16 GB & Case | Drone 1/Per Day RM500 | +1 Videographer Per Day RM500 | Raw Footage + 64GB RM150 | Makeup Per Hour RM100 | Termasuk Kos Pengangkutan | Penginapan', 4000.00);

PRINT 'Database setup completed successfully!';
PRINT 'Admin: admin@photostudio.com / admin123';
PRINT 'User: user@example.com / user123';
