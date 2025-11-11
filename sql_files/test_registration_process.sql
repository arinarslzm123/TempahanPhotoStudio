-- Test registration process step by step

-- 1. Check users table structure
PRINT '1. Users table structure:'
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'users' 
ORDER BY ORDINAL_POSITION;

-- 2. Check current users
PRINT '2. Current users:'
SELECT id, username, email, name, role, created_at FROM users;

-- 3. Test email check query (simulating checkQuery)
PRINT '3. Testing email check query:'
SELECT COUNT(*) as user_count FROM users WHERE email = 'test@example.com';

-- 4. Insert test user (simulating registration)
PRINT '4. Inserting test user...'
DELETE FROM users WHERE email = 'test@example.com';
INSERT INTO users (username, email, password, name, role, created_at)
VALUES ('test', 'test@example.com', 'password123', 'Test User', 'User', GETDATE());

-- 5. Verify insertion
PRINT '5. After insertion:'
SELECT id, username, email, name, role, created_at FROM users WHERE email = 'test@example.com';

-- 6. Test getUserByEmail query
PRINT '6. Testing getUserByEmail query:'
SELECT id, username, email, password, role, name, phone_number 
FROM users 
WHERE email = 'test@example.com';

-- 7. Test getUserById query
PRINT '7. Testing getUserById query:'
SELECT id, username, email, password, role, name, phone_number 
FROM users 
WHERE id = (SELECT id FROM users WHERE email = 'test@example.com');
