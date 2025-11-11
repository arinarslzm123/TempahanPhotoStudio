-- Comprehensive user setup script

-- First, check if users table exists and show structure
PRINT 'Checking users table structure...'
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'users' 
ORDER BY ORDINAL_POSITION;

-- Check current data
PRINT 'Current users in database:'
SELECT * FROM users;

-- Delete any existing user with ID 1
DELETE FROM users WHERE id = 1;

-- Insert new user with explicit values
INSERT INTO users (id, username, email, password, role, full_name, phone_number, created_at)
VALUES (1, 'admin', 'admin@photostudio.com', 'password123', 'Admin', 'Admin User', '0123456789', GETDATE());

-- Verify the insertion
PRINT 'After insertion:'
SELECT id, username, email, full_name, role, phone_number, created_at FROM users WHERE id = 1;

-- Test specific fields
PRINT 'Testing field values:'
SELECT 
    id,
    username,
    email,
    full_name,
    CASE WHEN full_name IS NULL THEN 'NULL' ELSE 'NOT NULL' END as full_name_status,
    CASE WHEN username IS NULL THEN 'NULL' ELSE 'NOT NULL' END as username_status,
    LEN(full_name) as full_name_length,
    LEN(username) as username_length
FROM users WHERE id = 1;
