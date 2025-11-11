-- =============================================
-- ADD PHONE NUMBER COLUMN TO USERS TABLE
-- =============================================
-- This script adds a phone_number column to the users table

USE TempahanPhotoStudio;
GO

-- =============================================
-- 1. CHECK CURRENT TABLE STRUCTURE
-- =============================================
SELECT 
    'CURRENT USERS TABLE STRUCTURE' as Info,
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'users'
ORDER BY ORDINAL_POSITION;

-- =============================================
-- 2. ADD PHONE_NUMBER COLUMN
-- =============================================
-- Add phone_number column to users table
IF NOT EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'users' AND COLUMN_NAME = 'phone_number'
)
BEGIN
    ALTER TABLE users 
    ADD phone_number VARCHAR(20) NULL;
    
    PRINT 'phone_number column added successfully to users table';
END
ELSE
BEGIN
    PRINT 'phone_number column already exists in users table';
END

-- =============================================
-- 3. VERIFY COLUMN ADDITION
-- =============================================
SELECT 
    'VERIFIED USERS TABLE STRUCTURE' as Info,
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'users'
ORDER BY ORDINAL_POSITION;

-- =============================================
-- 4. UPDATE EXISTING USERS WITH SAMPLE PHONE NUMBERS
-- =============================================
-- Update existing users with sample phone numbers
UPDATE users 
SET phone_number = CASE 
    WHEN id = 1 THEN '012-3456789'
    WHEN id = 2 THEN '013-4567890'
    WHEN id = 3 THEN '014-5678901'
    WHEN id = 1003 THEN '015-6789012'
    ELSE '012-0000000'
END
WHERE phone_number IS NULL;

-- =============================================
-- 5. VERIFY UPDATED DATA
-- =============================================
SELECT 
    'UPDATED USERS WITH PHONE NUMBERS' as Info,
    id,
    name,
    email,
    phone_number,
    role
FROM users
ORDER BY id;

-- =============================================
-- 6. TEST INSERT WITH PHONE NUMBER
-- =============================================
-- Test inserting a new user with phone number
INSERT INTO users (name, email, phone_number, password, role)
VALUES ('Test User', 'test@example.com', '012-9999999', 'password123', 'User');

-- =============================================
-- 7. VERIFY TEST INSERT
-- =============================================
SELECT 
    'TEST INSERT VERIFICATION' as Info,
    id,
    name,
    email,
    phone_number,
    role
FROM users
WHERE email = 'test@example.com';

-- =============================================
-- 8. CLEAN UP TEST DATA
-- =============================================
-- Remove test user
DELETE FROM users WHERE email = 'test@example.com';

-- =============================================
-- 9. FINAL VERIFICATION
-- =============================================
SELECT 
    'FINAL USERS TABLE VERIFICATION' as Info,
    id,
    name,
    email,
    phone_number,
    role,
    'Phone number: ' + ISNULL(phone_number, 'NULL') as phone_status
FROM users
ORDER BY id;

PRINT 'Phone number column addition completed successfully!';
PRINT 'The users table now includes:';
PRINT '1. id (int, primary key)';
PRINT '2. name (varchar)';
PRINT '3. email (varchar)';
PRINT '4. phone_number (varchar(20), nullable)';
PRINT '5. password (varchar)';
PRINT '6. role (varchar)';
PRINT '7. created_at (datetime)';
