-- Check user data in database
SELECT * FROM users;

-- Check if user with ID 1 exists
SELECT * FROM users WHERE id = 1;

-- Check table structure
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'users' 
ORDER BY ORDINAL_POSITION;
