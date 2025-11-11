-- =============================================
-- COMPLETE PACKAGES DATABASE FIX
-- =============================================
-- This script ensures packages and sub_packages tables exist with correct structure and data

USE TempahanPhotoStudio;
GO

-- =============================================
-- 1. CREATE/UPDATE PACKAGES TABLE
-- =============================================
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'packages')
BEGIN
    CREATE TABLE packages (
        id INT IDENTITY(1,1) PRIMARY KEY,
        package_name NVARCHAR(100) NOT NULL,
        event NVARCHAR(50) NOT NULL,
        duration NVARCHAR(50) NOT NULL,
        category NVARCHAR(50) NOT NULL,
        description NVARCHAR(500),
        image_url NVARCHAR(255),
        price DECIMAL(10,2) DEFAULT 0.00,
        is_active BIT DEFAULT 1,
        created_at DATETIME DEFAULT GETDATE()
    );
    PRINT 'Created packages table with price field';
END
ELSE
BEGIN
    -- Add price field if it doesn't exist
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
                   WHERE TABLE_NAME = 'packages' AND COLUMN_NAME = 'price')
    BEGIN
        ALTER TABLE packages ADD price DECIMAL(10,2) DEFAULT 0.00;
        PRINT 'Added price field to existing packages table';
    END
    ELSE
    BEGIN
        PRINT 'packages table already exists with price field';
    END
END
GO

-- =============================================
-- 2. CREATE/UPDATE SUB_PACKAGES TABLE
-- =============================================
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'sub_packages')
BEGIN
    CREATE TABLE sub_packages (
        id INT IDENTITY(1,1) PRIMARY KEY,
        package_id INT NOT NULL,
        sub_package_name NVARCHAR(100) NOT NULL,
        package_class NVARCHAR(20) NOT NULL,
        details NVARCHAR(500) NOT NULL,
        price DECIMAL(10,2) NOT NULL,
        description NVARCHAR(500),
        duration NVARCHAR(50),
        media NVARCHAR(100),
        is_active BIT DEFAULT 1,
        created_at DATETIME DEFAULT GETDATE(),
        FOREIGN KEY (package_id) REFERENCES packages(id) ON DELETE CASCADE
    );
    PRINT 'Created sub_packages table';
END
ELSE
BEGIN
    PRINT 'sub_packages table already exists';
END
GO

-- =============================================
-- 3. INSERT SAMPLE PACKAGES DATA
-- =============================================
-- Clear existing data and insert fresh sample data
DELETE FROM sub_packages; -- Delete sub_packages first due to foreign key
DELETE FROM packages;

-- Insert sample packages
INSERT INTO packages (package_name, event, duration, category, description, price) VALUES
('Akad Nikah', 'Wedding', '5-6 Hour Per Day', 'Wedding', '(1 Day 1 Event)', 400.00),
('Sanding / Tandang', 'Wedding', '5-6 Hour Per Day', 'Wedding', '(1 Day 1 Event)', 500.00),
('Akad Nikah + Sanding', 'Wedding', '5-6 Hour Per Day', 'Wedding', '(1 Day 2 Event)', 600.00),
('Akad Nikah + Sanding (2 Days)', 'Wedding', '5-6 Hour Per Day', 'Wedding', '(2 Day 2 Event)', 600.00),
('(Akad Nikah & Sanding) + Tandang', 'Wedding', '5-6 Hour Per Day', 'Wedding', '(2 Day 3 Event)', 800.00),
('Akad Nikah + Sanding + Tandang', 'Wedding', '5-6 Hour Per Day', 'Wedding', '(3 Day 3 Event)', 900.00),
('Sanding + Tandang', 'Wedding', '6-7 Hour Per Day', 'Wedding', '(2 Day 2 Event)', 700.00),
('Tunang', 'Engagement', '3-4 Hour Per Day', 'Engagement', '(1 Day)', 300.00),
('Portrait Session', 'Portrait', '2-3 Hour Per Day', 'Portrait', '(1 Day)', 250.00),
('Corporate Event', 'Corporate', '4-5 Hour Per Day', 'Corporate', '(1 Day)', 450.00);

PRINT 'Inserted sample packages data';

-- =============================================
-- 4. INSERT SAMPLE SUB_PACKAGES DATA
-- =============================================
-- Get package IDs for foreign key references
DECLARE @akad_nikah_id INT = (SELECT id FROM packages WHERE package_name = 'Akad Nikah');
DECLARE @sanding_id INT = (SELECT id FROM packages WHERE package_name = 'Sanding / Tandang');
DECLARE @akad_sanding_id INT = (SELECT id FROM packages WHERE package_name = 'Akad Nikah + Sanding');
DECLARE @tunang_id INT = (SELECT id FROM packages WHERE package_name = 'Tunang');

-- Insert sample sub_packages
INSERT INTO sub_packages (package_id, sub_package_name, package_class, details, price, description, duration) VALUES
(@akad_nikah_id, 'Basic Package', 'Regular', 'Basic photography service for Akad Nikah ceremony', 400.00, 'Standard package', '5-6 Hour Per Day'),
(@akad_nikah_id, 'Premium Package', 'Premium', 'Premium photography with additional services', 600.00, 'Enhanced package', '5-6 Hour Per Day'),

(@sanding_id, 'Standard Package', 'Regular', 'Standard photography for Sanding ceremony', 500.00, 'Standard package', '5-6 Hour Per Day'),
(@sanding_id, 'Deluxe Package', 'Deluxe', 'Deluxe photography with extra features', 750.00, 'Deluxe package', '5-6 Hour Per Day'),

(@akad_sanding_id, 'Complete Package', 'Complete', 'Complete photography for both ceremonies', 600.00, 'Complete package', '5-6 Hour Per Day'),
(@akad_sanding_id, 'Ultimate Package', 'Ultimate', 'Ultimate photography with all features', 900.00, 'Ultimate package', '5-6 Hour Per Day'),

(@tunang_id, 'Engagement Basic', 'Basic', 'Basic engagement photography', 300.00, 'Basic engagement', '3-4 Hour Per Day'),
(@tunang_id, 'Engagement Premium', 'Premium', 'Premium engagement photography', 450.00, 'Premium engagement', '3-4 Hour Per Day');

PRINT 'Inserted sample sub_packages data';

-- =============================================
-- 5. VERIFY DATA
-- =============================================
-- Check packages table
SELECT 
    'PACKAGES TABLE' as Table_Name,
    COUNT(*) as Record_Count
FROM packages;

-- Check sub_packages table
SELECT 
    'SUB_PACKAGES TABLE' as Table_Name,
    COUNT(*) as Record_Count
FROM sub_packages;

-- Show sample data
SELECT TOP 5 
    id,
    package_name,
    event,
    category,
    price,
    description
FROM packages 
ORDER BY category, package_name;

SELECT TOP 5 
    sp.id,
    p.package_name,
    sp.sub_package_name,
    sp.package_class,
    sp.price
FROM sub_packages sp
JOIN packages p ON sp.package_id = p.id
ORDER BY p.package_name, sp.sub_package_name;

-- =============================================
-- 6. TEST QUERIES (Same as Android app uses)
-- =============================================
-- Test getAllPackages query
SELECT 
    id,
    package_name,
    event,
    duration,
    category,
    description,
    price
FROM packages 
ORDER BY category, package_name;

-- Test getSubPackagesByPackageId query
SELECT 
    sp.id,
    sp.package_id,
    sp.sub_package_name,
    sp.package_class,
    sp.details,
    sp.price,
    sp.description,
    sp.duration,
    sp.media
FROM sub_packages sp
WHERE sp.package_id = @akad_nikah_id
ORDER BY sp.sub_package_name;

PRINT 'Database setup completed successfully!';
PRINT 'Packages and sub_packages tables are ready for Android app.';
