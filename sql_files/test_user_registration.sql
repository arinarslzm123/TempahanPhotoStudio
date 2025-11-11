-- Test user registration and verify data

-- First, check current users
PRINT 'Current users before test:'
SELECT id, username, email, full_name, role FROM users;

-- Insert test user (simulating registration)
INSERT INTO users (username, email, password, full_name, role, phone_number, created_at)
VALUES ('testuser', 'test@example.com', 'password123', 'Test User', 'User', '0123456789', GETDATE());

-- Verify the insertion
PRINT 'After test registration:'
SELECT id, username, email, full_name, role, phone_number FROM users WHERE email = 'test@example.com';

-- Test the exact query used by getUserByEmail
PRINT 'Testing getUserByEmail query:'
SELECT id, username, email, password, role, full_name, phone_number 
FROM users 
WHERE email = 'test@example.com';

-- Test the exact query used by getUserById
PRINT 'Testing getUserById query:'
SELECT id, username, email, password, role, full_name, phone_number 
FROM users 
WHERE id = (SELECT id FROM users WHERE email = 'test@example.com');
