-- Test script untuk verify packages table dan data display
-- Run this script in SQL Server Management Studio

-- 1. Check if packages table exists
SELECT 
    TABLE_NAME,
    TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_NAME = 'packages';

-- 2. Check packages table structure
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'packages'
ORDER BY ORDINAL_POSITION;

-- 3. Check current data in packages table
SELECT * FROM packages ORDER BY id;

-- 4. Count total packages
SELECT COUNT(*) as total_packages FROM packages;

-- 5. If no data, insert sample packages
IF NOT EXISTS (SELECT 1 FROM packages)
BEGIN
    INSERT INTO packages (package_name, event, duration, category, description, image_url, price) VALUES
    ('Akad Nikah', 'Wedding', '5-6 Hour Per Day', 'Wedding', '(1 Day 1 Event)', '', 400.0),
    ('Sanding / Tandang', 'Wedding', '5-6 Hour Per Day', 'Wedding', '(1 Day 1 Event)', '', 500.0),
    ('Akad Nikah + Sanding', 'Wedding', '5-6 Hour Per Day', 'Wedding', '(1 Day 2 Event)', '', 600.0),
    ('Akad Nikah + Sanding', 'Wedding', '5-6 Hour Per Day', 'Wedding', '(2 Day 2 Event)', '', 600.0),
    ('(Akad Nikah & Sanding) + Tandang', 'Wedding', '5-6 Hour Per Day', 'Wedding', '(2 Day 3 Event)', '', 800.0),
    ('Akad Nikah + Sanding + Tandang', 'Wedding', '5-6 Hour Per Day', 'Wedding', '(3 Day 3 Event)', '', 900.0),
    ('Sanding + Tandang', 'Wedding', '6-7 Hour Per Day', 'Wedding', '(2 Day 2 Event)', '', 700.0),
    ('Tunang', 'Engagement', '3-4 Hour Per Day', 'Engagement', '(1 Day)', '', 300.0);
    
    PRINT 'Sample packages inserted successfully!';
END
ELSE
BEGIN
    PRINT 'Packages table already contains data.';
END

-- 6. Verify data after insertion
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

-- 7. Test connection (this should return 1 if connection works)
SELECT 1 as connection_test;
