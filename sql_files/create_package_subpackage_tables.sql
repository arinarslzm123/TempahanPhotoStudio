-- Create Package and Sub-Package Tables
-- This script creates the table structure only, no data insertion

PRINT '=== CREATING PACKAGE AND SUB-PACKAGE TABLES ===';

-- Step 1: Create packages table
PRINT '--- Step 1: Creating packages table ---';

CREATE TABLE packages (
    id INT IDENTITY(1,1) PRIMARY KEY,
    package_name NVARCHAR(255) NOT NULL,
    event NVARCHAR(100) NOT NULL,
    category NVARCHAR(100) NOT NULL,
    duration NVARCHAR(100),
    price DECIMAL(10,2) DEFAULT 0.00,
    description NVARCHAR(500),
    image_url NVARCHAR(255),
    created_date DATETIME DEFAULT GETDATE(),
    updated_date DATETIME DEFAULT GETDATE()
);

PRINT 'packages table created successfully';

-- Step 2: Create sub_packages table
PRINT '--- Step 2: Creating sub_packages table ---';

CREATE TABLE sub_packages (
    id INT IDENTITY(1,1) PRIMARY KEY,
    package_id INT NOT NULL,
    sub_package_name NVARCHAR(255) NOT NULL,
    price DECIMAL(10,2) DEFAULT 0.00,
    duration NVARCHAR(100),
    description NVARCHAR(500),
    media NVARCHAR(255),
    created_date DATETIME DEFAULT GETDATE(),
    updated_date DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (package_id) REFERENCES packages(id) ON DELETE CASCADE
);

PRINT 'sub_packages table created successfully';

-- Step 3: Create indexes for better performance
PRINT '--- Step 3: Creating indexes ---';

-- Index on packages table
CREATE INDEX IX_packages_category ON packages(category);
CREATE INDEX IX_packages_event ON packages(event);
CREATE INDEX IX_packages_price ON packages(price);

-- Index on sub_packages table
CREATE INDEX IX_sub_packages_package_id ON sub_packages(package_id);
CREATE INDEX IX_sub_packages_price ON sub_packages(price);

PRINT 'Indexes created successfully';

-- Step 4: Verification
PRINT '--- Step 4: Verification ---';

-- Check if tables exist
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'packages')
BEGIN
    PRINT 'packages table exists';
    
    -- Show table structure
    SELECT 
        COLUMN_NAME,
        DATA_TYPE,
        IS_NULLABLE,
        COLUMN_DEFAULT
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'packages'
    ORDER BY ORDINAL_POSITION;
END
ELSE
BEGIN
    PRINT 'ERROR: packages table not created';
END

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'sub_packages')
BEGIN
    PRINT 'sub_packages table exists';
    
    -- Show table structure
    SELECT 
        COLUMN_NAME,
        DATA_TYPE,
        IS_NULLABLE,
        COLUMN_DEFAULT
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'sub_packages'
    ORDER BY ORDINAL_POSITION;
END
ELSE
BEGIN
    PRINT 'ERROR: sub_packages table not created';
END

-- Show foreign key constraints
PRINT '--- Foreign Key Constraints ---';
SELECT 
    fk.name AS constraint_name,
    tp.name AS parent_table,
    cp.name AS parent_column,
    tr.name AS referenced_table,
    cr.name AS referenced_column
FROM sys.foreign_keys fk
INNER JOIN sys.tables tp ON fk.parent_object_id = tp.object_id
INNER JOIN sys.tables tr ON fk.referenced_object_id = tr.object_id
INNER JOIN sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
INNER JOIN sys.columns cp ON fkc.parent_column_id = cp.column_id AND fkc.parent_object_id = cp.object_id
INNER JOIN sys.columns cr ON fkc.referenced_column_id = cr.column_id AND fkc.referenced_object_id = cr.object_id
WHERE tp.name = 'sub_packages' AND tr.name = 'packages';

-- Show indexes
PRINT '--- Indexes Created ---';
SELECT 
    t.name AS table_name,
    i.name AS index_name,
    i.type_desc AS index_type,
    c.name AS column_name
FROM sys.indexes i
INNER JOIN sys.tables t ON i.object_id = t.object_id
INNER JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
INNER JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
WHERE t.name IN ('packages', 'sub_packages')
ORDER BY t.name, i.name, ic.key_ordinal;

PRINT '=== TABLE CREATION COMPLETE ===';
