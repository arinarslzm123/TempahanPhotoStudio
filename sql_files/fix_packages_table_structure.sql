-- =============================================
-- FIX PACKAGES TABLE STRUCTURE
-- =============================================
-- Add missing 'price' field to packages table

USE TempahanPhotoStudio;
GO

-- Check current packages table structure
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'packages'
ORDER BY ORDINAL_POSITION;

-- Add price field if it doesn't exist
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'packages' AND COLUMN_NAME = 'price')
BEGIN
    ALTER TABLE packages ADD price DECIMAL(10,2) DEFAULT 0.00;
    PRINT 'Added price field to packages table';
END
ELSE
BEGIN
    PRINT 'Price field already exists in packages table';
END
GO

-- Update existing packages with sample prices if price is 0
UPDATE packages 
SET price = CASE 
    WHEN package_name LIKE '%Akad Nikah%' AND category = 'Wedding' THEN 400.00
    WHEN package_name LIKE '%Sanding%' AND category = 'Wedding' THEN 500.00
    WHEN package_name LIKE '%Tunang%' THEN 300.00
    WHEN package_name LIKE '%Wedding%' THEN 600.00
    ELSE 500.00
END
WHERE price = 0.00 OR price IS NULL;

-- Verify the updated structure
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

-- Check if sub_packages table exists and has correct structure
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'sub_packages')
BEGIN
    SELECT 
        COLUMN_NAME,
        DATA_TYPE,
        IS_NULLABLE
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'sub_packages'
    ORDER BY ORDINAL_POSITION;
    
    -- Show sample sub_packages data
    SELECT TOP 5 * FROM sub_packages;
END
ELSE
BEGIN
    PRINT 'sub_packages table does not exist';
END
