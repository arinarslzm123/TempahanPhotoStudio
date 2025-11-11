-- Test using name field instead of full_name

-- Check current users table structure
PRINT 'Users table structure:'
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'users' 
ORDER BY ORDINAL_POSITION;

-- Check current data
PRINT 'Current users:'
SELECT id, username, email, name, role FROM users;

-- Insert test user with name field
DELETE FROM users WHERE email = 'testname@example.com';
INSERT INTO users (username, email, password, name, role, created_at)
VALUES ('testname', 'testname@example.com', 'password123', 'Test Name User', 'User', GETDATE());

-- Verify the insertion
PRINT 'After test insertion:'
SELECT id, username, email, name, role FROM users WHERE email = 'testname@example.com';

-- Test the exact query used by getUserByEmail
PRINT 'Testing getUserByEmail query:'
SELECT id, username, email, password, role, name, phone_number 
FROM users 
WHERE email = 'testname@example.com';

-- Test the exact query used by getUserById
PRINT 'Testing getUserById query:'
SELECT id, username, email, password, role, name, phone_number 
FROM users 
WHERE id = (SELECT id FROM users WHERE email = 'testname@example.com');
