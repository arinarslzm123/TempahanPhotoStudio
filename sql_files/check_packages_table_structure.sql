-- Check packages table structure
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'packages'
ORDER BY ORDINAL_POSITION;

-- Check if total_amount column exists
IF EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'packages' AND COLUMN_NAME = 'total_amount'
)
BEGIN
    PRINT 'total_amount column exists in packages table';
    SELECT id, name, category, duration, total_amount FROM packages LIMIT 5;
END
ELSE
BEGIN
    PRINT 'total_amount column does NOT exist in packages table';
    SELECT id, name, category, duration FROM packages LIMIT 5;
END

-- Check sub_packages table structure
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'sub_packages'
ORDER BY ORDINAL_POSITION;
