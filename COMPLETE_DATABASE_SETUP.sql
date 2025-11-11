-- ============================================================================
-- TEMPAHAN PHOTO STUDIO - COMPLETE DATABASE SETUP
-- ============================================================================
-- This file creates the complete database from scratch
-- Run this file in SQL Server to set up everything needed for the app
-- 
-- Database: TempahanPhotoStudio
-- Tables: users, packages, sub_packages, bookings, feedback
-- 
-- Instructions:
-- 1. Open SQL Server Management Studio or Azure Data Studio
-- 2. Connect to your SQL Server (Docker)
-- 3. Open this file and execute it
-- 4. The database will be created with all tables and sample data
-- ============================================================================

USE master;
GO

-- ============================================================================
-- STEP 1: CREATE DATABASE
-- ============================================================================
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'TempahanPhotoStudio')
BEGIN
    ALTER DATABASE TempahanPhotoStudio SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE TempahanPhotoStudio;
END
GO

CREATE DATABASE TempahanPhotoStudio;
GO

USE TempahanPhotoStudio;
GO

PRINT '✅ Database created: TempahanPhotoStudio';
GO

-- ============================================================================
-- STEP 2: CREATE USERS TABLE
-- ============================================================================
CREATE TABLE users (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    email NVARCHAR(100) NOT NULL UNIQUE,
    password NVARCHAR(100) NOT NULL,
    phone_number NVARCHAR(20),
    role NVARCHAR(20) DEFAULT 'User',
    profile_image NVARCHAR(500),
    created_at DATETIME DEFAULT GETDATE()
);
GO

PRINT '✅ Table created: users';
GO

-- ============================================================================
-- STEP 3: CREATE PACKAGES TABLE
-- ============================================================================
CREATE TABLE packages (
    id INT IDENTITY(1,1) PRIMARY KEY,
    package_name NVARCHAR(200) NOT NULL,
    event NVARCHAR(200),
    duration NVARCHAR(100),
    category NVARCHAR(50) NOT NULL,
    created_at DATETIME DEFAULT GETDATE()
);
GO

PRINT '✅ Table created: packages';
GO

-- ============================================================================
-- STEP 4: CREATE SUB_PACKAGES TABLE
-- ============================================================================
CREATE TABLE sub_packages (
    id INT IDENTITY(1,1) PRIMARY KEY,
    package_id INT NOT NULL,
    sub_package_name NVARCHAR(200) NOT NULL,
    price DECIMAL(10,2) NOT NULL DEFAULT 0,
    description NVARCHAR(1000),
    duration NVARCHAR(100),
    media NVARCHAR(500),
    created_at DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_subpackage_package FOREIGN KEY (package_id) REFERENCES packages(id) ON DELETE CASCADE
);
GO

PRINT '✅ Table created: sub_packages';
GO

-- ============================================================================
-- STEP 5: CREATE BOOKINGS TABLE
-- ============================================================================
CREATE TABLE bookings (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    package_id INT NOT NULL,
    sub_package_id INT NOT NULL,
    booking_date NVARCHAR(20) NOT NULL,
    event_date NVARCHAR(20) NOT NULL,
    event_time NVARCHAR(20) NOT NULL,
    status NVARCHAR(20) NOT NULL DEFAULT 'Unpaid',
    total_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
    payment_method NVARCHAR(50),
    payment_status NVARCHAR(20) DEFAULT 'Unpaid',
    notes NVARCHAR(500),
    created_at DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_booking_user FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT FK_booking_package FOREIGN KEY (package_id) REFERENCES packages(id),
    CONSTRAINT FK_booking_subpackage FOREIGN KEY (sub_package_id) REFERENCES sub_packages(id)
);
GO

PRINT '✅ Table created: bookings';
GO

-- ============================================================================
-- STEP 6: CREATE FEEDBACK TABLE
-- ============================================================================
CREATE TABLE feedback (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    name NVARCHAR(100) NOT NULL,
    comment NVARCHAR(1000),
    rating FLOAT NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_feedback_user FOREIGN KEY (user_id) REFERENCES users(id)
);
GO

PRINT '✅ Table created: feedback';
GO

-- ============================================================================
-- STEP 7: INSERT SAMPLE USERS
-- ============================================================================

-- Insert Admin User
INSERT INTO users (name, email, password, phone_number, role) 
VALUES ('Admin', 'admin@photostudio.com', 'admin123', '0123456789', 'Admin');

-- Insert Sample Customer Users
INSERT INTO users (name, email, password, phone_number, role) 
VALUES 
    ('Ahmad Abdullah', 'ahmad@gmail.com', 'password123', '0121234567', 'User'),
    ('Siti Nurhaliza', 'siti@gmail.com', 'password123', '0139876543', 'User'),
    ('Muhammad Ali', 'ali@gmail.com', 'password123', '0167890123', 'User');

GO

PRINT '✅ Sample users created (1 Admin, 3 Customers)';
GO

-- ============================================================================
-- STEP 8: INSERT PHOTOGRAPHY PACKAGES
-- ============================================================================

-- Wedding Photography Packages
INSERT INTO packages (package_name, event, duration, category) VALUES
    ('Wedding Basic', 'Wedding', '4 hours', 'Photography'),
    ('Wedding Premium', 'Wedding', '8 hours', 'Photography'),
    ('Wedding Deluxe', 'Wedding', 'Full Day', 'Photography'),
    ('Engagement', 'Engagement', '2 hours', 'Photography');

-- Event Photography Packages
INSERT INTO packages (package_name, event, duration, category) VALUES
    ('Birthday Party', 'Birthday', '3 hours', 'Photography'),
    ('Corporate Event', 'Corporate', '4 hours', 'Photography'),
    ('Graduation', 'Graduation', '2 hours', 'Photography');

GO

PRINT '✅ Photography packages created';
GO

-- ============================================================================
-- STEP 9: INSERT PHOTOGRAPHY SUB-PACKAGES
-- ============================================================================

-- Wedding Basic Sub-Packages
INSERT INTO sub_packages (package_id, sub_package_name, price, description, duration, media) VALUES
    (1, 'Basic Coverage', 800.00, '4 hours coverage, 200 edited photos, online gallery', '4 hours', 'Photo Only'),
    (1, 'Basic Plus', 1000.00, '4 hours coverage, 250 edited photos, online gallery, photo album', '4 hours', 'Photo Only');

-- Wedding Premium Sub-Packages
INSERT INTO sub_packages (package_id, sub_package_name, price, description, duration, media) VALUES
    (2, 'Premium Coverage', 1500.00, '8 hours coverage, 400 edited photos, online gallery, 2 albums', '8 hours', 'Photo Only'),
    (2, 'Premium Deluxe', 1800.00, '8 hours coverage, 500 edited photos, online gallery, 2 albums, canvas print', '8 hours', 'Photo Only');

-- Wedding Deluxe Sub-Packages
INSERT INTO sub_packages (package_id, sub_package_name, price, description, duration, media) VALUES
    (3, 'Deluxe Full Day', 2500.00, 'Full day coverage, unlimited photos, online gallery, 3 albums, canvas print', 'Full Day', 'Photo Only'),
    (3, 'Deluxe Premium', 3000.00, 'Full day coverage, unlimited photos, online gallery, 3 premium albums, 2 canvas prints, drone shots', 'Full Day', 'Photo + Drone');

-- Engagement Sub-Packages
INSERT INTO sub_packages (package_id, sub_package_name, price, description, duration, media) VALUES
    (4, 'Engagement Basic', 500.00, '2 hours coverage, 100 edited photos, online gallery', '2 hours', 'Photo Only'),
    (4, 'Engagement Premium', 700.00, '2 hours coverage, 150 edited photos, online gallery, photo album', '2 hours', 'Photo Only');

-- Birthday Party Sub-Packages
INSERT INTO sub_packages (package_id, sub_package_name, price, description, duration, media) VALUES
    (5, 'Birthday Basic', 400.00, '3 hours coverage, 100 edited photos', '3 hours', 'Photo Only'),
    (5, 'Birthday Premium', 600.00, '3 hours coverage, 150 edited photos, photo album', '3 hours', 'Photo Only');

-- Corporate Event Sub-Packages
INSERT INTO sub_packages (package_id, sub_package_name, price, description, duration, media) VALUES
    (6, 'Corporate Basic', 700.00, '4 hours coverage, 200 edited photos, online gallery', '4 hours', 'Photo Only'),
    (6, 'Corporate Premium', 1000.00, '4 hours coverage, 300 edited photos, online gallery, photo book', '4 hours', 'Photo Only');

-- Graduation Sub-Packages
INSERT INTO sub_packages (package_id, sub_package_name, price, description, duration, media) VALUES
    (7, 'Graduation Basic', 300.00, '2 hours coverage, 80 edited photos', '2 hours', 'Photo Only'),
    (7, 'Graduation Premium', 450.00, '2 hours coverage, 120 edited photos, photo album', '2 hours', 'Photo Only');

GO

PRINT '✅ Photography sub-packages created';
GO

-- ============================================================================
-- STEP 10: INSERT VIDEOGRAPHY PACKAGES
-- ============================================================================

-- Wedding Videography Packages
INSERT INTO packages (package_name, event, duration, category) VALUES
    ('Wedding Video Basic', 'Wedding', '4 hours', 'Videography'),
    ('Wedding Video Premium', 'Wedding', '8 hours', 'Videography'),
    ('Wedding Video Cinematic', 'Wedding', 'Full Day', 'Videography');

-- Event Videography Packages
INSERT INTO packages (package_name, event, duration, category) VALUES
    ('Event Video Coverage', 'Event', '3 hours', 'Videography'),
    ('Corporate Video', 'Corporate', '4 hours', 'Videography');

GO

PRINT '✅ Videography packages created';
GO

-- ============================================================================
-- STEP 11: INSERT VIDEOGRAPHY SUB-PACKAGES
-- ============================================================================

-- Wedding Video Basic Sub-Packages
INSERT INTO sub_packages (package_id, sub_package_name, price, description, duration, media) VALUES
    (8, 'Video Basic', 1200.00, '4 hours coverage, highlight video 5-7 min, raw footage', '4 hours', 'Video Only'),
    (8, 'Video Basic Plus', 1500.00, '4 hours coverage, highlight video 7-10 min, edited ceremony, raw footage', '4 hours', 'Video Only');

-- Wedding Video Premium Sub-Packages
INSERT INTO sub_packages (package_id, sub_package_name, price, description, duration, media) VALUES
    (9, 'Video Premium', 2200.00, '8 hours coverage, cinematic highlight 10-15 min, ceremony + reception edit', '8 hours', 'Video Only'),
    (9, 'Video Premium Plus', 2800.00, '8 hours coverage, cinematic highlight 15-20 min, full ceremony + reception, drone footage', '8 hours', 'Video + Drone');

-- Wedding Video Cinematic Sub-Packages
INSERT INTO sub_packages (package_id, sub_package_name, price, description, duration, media) VALUES
    (10, 'Cinematic Full Day', 3500.00, 'Full day coverage, 20-30 min cinematic film, same day edit, drone footage', 'Full Day', 'Video + Drone'),
    (10, 'Cinematic Deluxe', 4500.00, 'Full day coverage, 30-40 min cinematic film, same day edit, drone footage, 4K quality', 'Full Day', 'Video + Drone + 4K');

-- Event Video Sub-Packages
INSERT INTO sub_packages (package_id, sub_package_name, price, description, duration, media) VALUES
    (11, 'Event Basic', 800.00, '3 hours coverage, highlight video 5 min', '3 hours', 'Video Only'),
    (11, 'Event Premium', 1200.00, '3 hours coverage, highlight video 8-10 min, full event edit', '3 hours', 'Video Only');

-- Corporate Video Sub-Packages
INSERT INTO sub_packages (package_id, sub_package_name, price, description, duration, media) VALUES
    (12, 'Corporate Basic', 1000.00, '4 hours coverage, professional edit, highlight video', '4 hours', 'Video Only'),
    (12, 'Corporate Premium', 1500.00, '4 hours coverage, professional edit, multiple camera angles, interviews', '4 hours', 'Video Multi-Cam');

GO

PRINT '✅ Videography sub-packages created';
GO

-- ============================================================================
-- STEP 12: INSERT SAMPLE FEEDBACK
-- ============================================================================

INSERT INTO feedback (user_id, name, comment, rating, created_at) VALUES
    (2, 'Ahmad Abdullah', 'Excellent service! The photographer was very professional and the photos came out beautifully. Highly recommended!', 5.0, GETDATE()),
    (3, 'Siti Nurhaliza', 'Great experience booking through this app. The wedding package was worth every penny. Thank you!', 4.5, GETDATE()),
    (4, 'Muhammad Ali', 'Professional team, beautiful photos, and great customer service. Will book again for future events!', 5.0, GETDATE());

GO

PRINT '✅ Sample feedback created';
GO

-- ============================================================================
-- STEP 13: CREATE INDEXES FOR PERFORMANCE
-- ============================================================================

-- Index on bookings for date/time overlap checking
CREATE INDEX IX_bookings_datetime ON bookings(event_date, event_time, status);

-- Index on bookings for user queries
CREATE INDEX IX_bookings_user ON bookings(user_id, created_at DESC);

-- Index on sub_packages for package queries
CREATE INDEX IX_subpackages_package ON sub_packages(package_id);

-- Index on packages for category filtering
CREATE INDEX IX_packages_category ON packages(category);

GO

PRINT '✅ Indexes created for performance';
GO

-- ============================================================================
-- STEP 14: VERIFY SETUP
-- ============================================================================

PRINT '';
PRINT '==================================================================';
PRINT 'DATABASE SETUP COMPLETE!';
PRINT '==================================================================';
PRINT '';
PRINT 'Database Name: TempahanPhotoStudio';
PRINT '';
PRINT 'Tables Created:';
SELECT 
    TABLE_NAME as [Table],
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = t.TABLE_NAME) as [Columns]
FROM INFORMATION_SCHEMA.TABLES t
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;
PRINT '';

PRINT 'Row Counts:';
SELECT 'users' as [Table], COUNT(*) as [Rows] FROM users
UNION ALL
SELECT 'packages', COUNT(*) FROM packages
UNION ALL
SELECT 'sub_packages', COUNT(*) FROM sub_packages
UNION ALL
SELECT 'bookings', COUNT(*) FROM bookings
UNION ALL
SELECT 'feedback', COUNT(*) FROM feedback;
PRINT '';

PRINT '==================================================================';
PRINT 'LOGIN CREDENTIALS:';
PRINT '==================================================================';
PRINT 'Admin Account:';
PRINT '  Email: admin@photostudio.com';
PRINT '  Password: admin123';
PRINT '';
PRINT 'Sample Customer Accounts:';
PRINT '  Email: ahmad@gmail.com | Password: password123';
PRINT '  Email: siti@gmail.com  | Password: password123';
PRINT '  Email: ali@gmail.com   | Password: password123';
PRINT '==================================================================';
PRINT '';
PRINT '✅ Your database is ready to use!';
PRINT '✅ Update ConnectionClass.java with your Docker SQL Server connection details';
PRINT '';

GO

