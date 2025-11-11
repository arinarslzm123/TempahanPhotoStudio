-- Test packages database connection and data

-- 1. Check if packages table exists
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'packages')
BEGIN
    PRINT 'Packages table exists';
    
    -- Check table structure
    SELECT 
        COLUMN_NAME, 
        DATA_TYPE, 
        IS_NULLABLE, 
        CHARACTER_MAXIMUM_LENGTH
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'packages' 
    ORDER BY ORDINAL_POSITION;
    
    -- Check total count
    SELECT COUNT(*) as total_packages FROM packages;
    
    -- Show all packages
    SELECT id, package_name, event, duration, category, description, price 
    FROM packages 
    ORDER BY id;
    
    -- Test specific query that ConnectionClass.getAllPackages() uses
    PRINT 'Testing getAllPackages query:'
    SELECT * FROM packages ORDER BY category, package_name;
    
END
ELSE
BEGIN
    PRINT 'Packages table does not exist - need to create it';
    
    -- Create packages table
    CREATE TABLE packages (
        id INT IDENTITY(1,1) PRIMARY KEY,
        package_name NVARCHAR(255) NOT NULL,
        event NVARCHAR(255),
        duration NVARCHAR(255),
        category NVARCHAR(255),
        description NVARCHAR(MAX),
        image_url NVARCHAR(500),
        price DECIMAL(10,2) DEFAULT 0.00
    );
    
    PRINT 'Created packages table';
    
    -- Insert sample data
    INSERT INTO packages (package_name, event, duration, category, description, price) VALUES 
    ('Akad Nikah', 'Wedding', '5-6 Hour Per Day', 'Photography', '(1 Day 1 Event)', 400.00),
    ('Sanding / Tandang', 'Wedding', '5-6 Hour Per Day', 'Photography', '(1 Day 1 Event)', 500.00),
    ('Akad Nikah + Sanding', 'Wedding', '5-6 Hour Per Day', 'Photography', '(1 Day 2 Event)', 600.00),
    ('Akad Nikah + Sanding', 'Wedding', '5-6 Hour Per Day', 'Photography', '(2 Day 2 Event)', 600.00),
    ('(Akad Nikah & Sanding) + Tandang', 'Wedding', '5-6 Hour Per Day', 'Photography', '(2 Day 3 Event)', 800.00),
    ('Akad Nikah + Sanding + Tandang', 'Wedding', '5-6 Hour Per Day', 'Photography', '(3 Day 3 Event)', 900.00),
    ('Sanding + Tandang', 'Wedding', '6-7 Hour Per Day', 'Photography', '(2 Day 2 Event)', 700.00),
    ('Tunang', 'Engagement', '3-4 Hour Per Day', 'Photography', '(1 Day)', 300.00);
    
    PRINT 'Inserted sample data';
    
    -- Verify data
    SELECT COUNT(*) as total_packages FROM packages;
    SELECT * FROM packages ORDER BY id;
END
