-- Add total_amount column to packages table if it doesn't exist
IF NOT EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'packages' AND COLUMN_NAME = 'total_amount'
)
BEGIN
    ALTER TABLE packages
    ADD total_amount DECIMAL(10,2) DEFAULT 0.00;

    PRINT 'total_amount column added successfully to packages table';
END
ELSE
BEGIN
    PRINT 'total_amount column already exists in packages table';
END

-- Update existing packages with sample total amounts
UPDATE packages
SET total_amount = CASE
    WHEN id = 1 THEN 1200.00
    WHEN id = 2 THEN 1500.00
    WHEN id = 3 THEN 1800.00
    WHEN id = 4 THEN 2000.00
    WHEN id = 5 THEN 2200.00
    WHEN id = 6 THEN 2500.00
    WHEN id = 7 THEN 2800.00
    WHEN id = 8 THEN 3000.00
    WHEN id = 9 THEN 1200.00
    ELSE 1000.00
END
WHERE total_amount IS NULL OR total_amount = 0;

-- Show updated table structure
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'packages'
ORDER BY ORDINAL_POSITION;

-- Show sample data with total amounts
SELECT id, name, category, duration, total_amount FROM packages ORDER BY id;
