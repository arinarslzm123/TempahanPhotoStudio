-- =============================================
-- TEST USER PROFILE DISPLAY
-- =============================================
-- This script tests that user names are displayed correctly in the profile

USE TempahanPhotoStudio;
GO

-- =============================================
-- 1. CHECK USERS TABLE STRUCTURE
-- =============================================
SELECT 
    'USERS TABLE STRUCTURE' as Info,
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'users'
ORDER BY ORDINAL_POSITION;

-- =============================================
-- 2. CHECK CURRENT USERS DATA
-- =============================================
SELECT 
    'CURRENT USERS DATA' as Info,
    COUNT(*) as Total_Users
FROM users;

-- Show all users with their details
SELECT 
    'ALL USERS' as Info,
    id,
    name,
    email,
    role,
    CASE 
        WHEN role IS NULL THEN 'NULL'
        WHEN role = '' THEN 'EMPTY'
        ELSE role
    END as role_status
FROM users
ORDER BY id;

-- =============================================
-- 3. TEST USER LOOKUP BY ID
-- =============================================
-- Test getUserById functionality
SELECT 
    'USER LOOKUP TEST' as Info,
    id,
    name,
    email,
    role,
    'This is what getUserById should return' as description
FROM users
WHERE id = 1;

-- Test with different user IDs
SELECT 
    'USER LOOKUP TEST - ID 2' as Info,
    id,
    name,
    email,
    role
FROM users
WHERE id = 2;

SELECT 
    'USER LOOKUP TEST - ID 1003 (Admin)' as Info,
    id,
    name,
    email,
    role
FROM users
WHERE id = 1003;

-- =============================================
-- 4. CHECK FOR NULL ROLES
-- =============================================
-- Check users with NULL roles
SELECT 
    'USERS WITH NULL ROLES' as Info,
    COUNT(*) as Count
FROM users
WHERE role IS NULL;

-- Show users with NULL roles
SELECT 
    'USERS WITH NULL ROLES' as Info,
    id,
    name,
    email,
    role
FROM users
WHERE role IS NULL
ORDER BY id;

-- =============================================
-- 5. UPDATE NULL ROLES TO DEFAULT
-- =============================================
-- Update users with NULL roles to 'User'
UPDATE users 
SET role = 'User'
WHERE role IS NULL;

-- Check the update
SELECT 
    'USERS AFTER ROLE UPDATE' as Info,
    id,
    name,
    email,
    role
FROM users
ORDER BY id;

-- =============================================
-- 6. TEST PROFILE DISPLAY LOGIC
-- =============================================
-- Simulate the profile display logic
SELECT 
    'PROFILE DISPLAY LOGIC TEST' as Info,
    id,
    name as fullName,
    email as username,
    CASE 
        WHEN name IS NOT NULL AND name != '' THEN name
        WHEN email IS NOT NULL AND email != '' THEN email
        ELSE 'Unknown User'
    END as displayName,
    role
FROM users
ORDER BY id;

-- =============================================
-- 7. TEST USER LOGIN SCENARIOS
-- =============================================
-- Test different login scenarios
SELECT 
    'LOGIN SCENARIO 1 - User with name' as Info,
    id,
    name,
    email,
    role,
    'Should display: ' + name as expected_display
FROM users
WHERE name IS NOT NULL AND name != ''
ORDER BY id;

SELECT 
    'LOGIN SCENARIO 2 - User without name' as Info,
    id,
    name,
    email,
    role,
    'Should display: ' + email as expected_display
FROM users
WHERE (name IS NULL OR name = '') AND email IS NOT NULL
ORDER BY id;

-- =============================================
-- 8. VERIFY ADMIN USER
-- =============================================
-- Check admin user specifically
SELECT 
    'ADMIN USER VERIFICATION' as Info,
    id,
    name,
    email,
    role,
    'Admin user should have role: Admin' as verification
FROM users
WHERE role = 'Admin'
ORDER BY id;

-- =============================================
-- 9. TEST USER MODEL FIELDS
-- =============================================
-- Test what fields should be available in UserModel
SELECT 
    'USER MODEL FIELDS TEST' as Info,
    id,
    name as fullName,
    email as username,
    email as email,
    password,
    role,
    '' as phoneNumber
FROM users
ORDER BY id;

-- =============================================
-- 10. PROFILE DISPLAY SUMMARY
-- =============================================
-- Summary of what should be displayed in profile
SELECT 
    'PROFILE DISPLAY SUMMARY' as Info,
    id,
    'User ID: ' + CAST(id AS VARCHAR(10)) as user_id,
    'Display Name: ' + CASE 
        WHEN name IS NOT NULL AND name != '' THEN name
        WHEN email IS NOT NULL AND email != '' THEN email
        ELSE 'Unknown User'
    END as display_name,
    'Email: ' + email as email_display,
    'Role: ' + ISNULL(role, 'NULL') as role_display
FROM users
ORDER BY id;

PRINT 'User profile display test completed!';
PRINT 'Check the results above to verify:';
PRINT '1. Users table structure is correct';
PRINT '2. Current users data';
PRINT '3. User lookup by ID works';
PRINT '4. NULL roles are handled';
PRINT '5. Role updates work';
PRINT '6. Profile display logic';
PRINT '7. Login scenarios';
PRINT '8. Admin user verification';
PRINT '9. User model fields';
PRINT '10. Profile display summary';
