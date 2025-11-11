-- Update packages table structure to match the database shown in the image

-- Check if price column exists, if not add it
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'packages' AND COLUMN_NAME = 'price')
BEGIN
    ALTER TABLE packages ADD price DECIMAL(10,2) DEFAULT 0.00;
    PRINT 'Added price column to packages table';
END
ELSE
BEGIN
    PRINT 'Price column already exists in packages table';
END

-- Update existing records with sample prices based on the data shown
UPDATE packages SET price = 400.00 WHERE id = 1 AND package_name = 'Akad Nikah';
UPDATE packages SET price = 500.00 WHERE id = 3 AND package_name LIKE 'Sanding%';
UPDATE packages SET price = 600.00 WHERE id = 4 AND package_name LIKE 'Akad Nikah + S%';
UPDATE packages SET price = 600.00 WHERE id = 5 AND package_name LIKE 'Akad Nikah + S%';
UPDATE packages SET price = 800.00 WHERE id = 6 AND package_name LIKE '%Akad Nikah &%';
UPDATE packages SET price = 900.00 WHERE id = 7 AND package_name LIKE 'Akad Nikah + S%';
UPDATE packages SET price = 700.00 WHERE id = 8 AND package_name LIKE 'Sanding + T%';
UPDATE packages SET price = 300.00 WHERE id = 9 AND package_name = 'Tunang';

-- Update videography packages with sample prices
UPDATE packages SET price = 500.00 WHERE id = 12 AND package_name LIKE 'PV1%';
UPDATE packages SET price = 600.00 WHERE id = 13 AND package_name LIKE 'PV2%';
UPDATE packages SET price = 700.00 WHERE id = 14 AND package_name LIKE 'PV3%';
UPDATE packages SET price = 800.00 WHERE id = 15 AND package_name LIKE 'PV4%';
UPDATE packages SET price = 900.00 WHERE id = 16 AND package_name LIKE 'PV5%';

-- Verify the table structure
PRINT 'Current packages table structure:'
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'packages' 
ORDER BY ORDINAL_POSITION;

-- Show sample data with prices
PRINT 'Sample data with prices:'
SELECT TOP 10 id, package_name, event, duration, category, description, price 
FROM packages 
ORDER BY id;
