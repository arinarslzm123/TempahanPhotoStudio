-- =============================================
-- FIX USER ROLES AND PROFILE DISPLAY
-- =============================================
-- This script fixes user roles and ensures profile display works correctly

USE TempahanPhotoStudio;
GO

-- =============================================
-- 1. CHECK CURRENT USERS STATUS
-- =============================================
SELECT 
    'CURRENT USERS STATUS' as Info,
    COUNT(*) as Total_Users,
    SUM(CASE WHEN role IS NULL THEN 1 ELSE 0 END) as Users_With_NULL_Role,
    SUM(CASE WHEN role = 'Admin' THEN 1 ELSE 0 END) as Admin_Users,
    SUM(CASE WHEN role = 'User' THEN 1 ELSE 0 END) as Regular_Users
FROM users;

-- =============================================
-- 2. SHOW ALL USERS BEFORE FIX
-- =============================================
SELECT 
    'USERS BEFORE FIX' as Info,
    id,
    name,
    email,
    role,
    CASE 
        WHEN role IS NULL THEN 'NEEDS_FIX'
        WHEN role = '' THEN 'NEEDS_FIX'
        ELSE 'OK'
    END as status
FROM users
ORDER BY id;

-- =============================================
-- 3. FIX NULL ROLES
-- =============================================
-- Update users with NULL roles to 'User'
UPDATE users 
SET role = 'User'
WHERE role IS NULL;

-- Update users with empty roles to 'User'
UPDATE users 
SET role = 'User'
WHERE role = '';

-- =============================================
-- 4. ENSURE ADMIN USER EXISTS
-- =============================================
-- Check if admin user exists
IF NOT EXISTS (SELECT 1 FROM users WHERE role = 'Admin')
BEGIN
    -- Insert admin user if not exists
    INSERT INTO users (name, email, password, role)
    VALUES ('Admin', 'admin@photostudio.com', 'admin123', 'Admin');
    
    PRINT 'Admin user created successfully!';
END
ELSE
BEGIN
    PRINT 'Admin user already exists.';
END

-- =============================================
-- 5. SHOW USERS AFTER FIX
-- =============================================
SELECT 
    'USERS AFTER FIX' as Info,
    id,
    name,
    email,
    role,
    'OK' as status
FROM users
ORDER BY id;

-- =============================================
-- 6. TEST PROFILE DISPLAY FOR EACH USER
-- =============================================
-- Test what each user should see in their profile
SELECT 
    'PROFILE DISPLAY TEST' as Info,
    id,
    name as fullName,
    email as username,
    email as email,
    role,
    CASE 
        WHEN name IS NOT NULL AND name != '' THEN name
        WHEN email IS NOT NULL AND email != '' THEN email
        ELSE 'Unknown User'
    END as displayName,
    'Should show: ' + CASE 
        WHEN name IS NOT NULL AND name != '' THEN name
        WHEN email IS NOT NULL AND email != '' THEN email
        ELSE 'Unknown User'
    END as expected_display
FROM users
ORDER BY id;

-- =============================================
-- 7. TEST USER LOOKUP BY ID
-- =============================================
-- Test getUserById for each user
DECLARE @user_id INT = 1;
WHILE @user_id <= (SELECT MAX(id) FROM users)
BEGIN
    IF EXISTS (SELECT 1 FROM users WHERE id = @user_id)
    BEGIN
        SELECT 
            'USER LOOKUP TEST - ID ' + CAST(@user_id AS VARCHAR(10)) as Info,
            id,
            name,
            email,
            role,
            'This is what getUserById(' + CAST(@user_id AS VARCHAR(10)) + ') should return' as description
        FROM users
        WHERE id = @user_id;
    END
    SET @user_id = @user_id + 1;
END

-- =============================================
-- 8. VERIFY ADMIN FUNCTIONALITY
-- =============================================
-- Check admin user
SELECT 
    'ADMIN USER VERIFICATION' as Info,
    id,
    name,
    email,
    role,
    'Admin user verified' as status
FROM users
WHERE role = 'Admin';

-- =============================================
-- 9. TEST REGULAR USER FUNCTIONALITY
-- =============================================
-- Check regular users
SELECT 
    'REGULAR USERS VERIFICATION' as Info,
    id,
    name,
    email,
    role,
    'Regular user verified' as status
FROM users
WHERE role = 'User'
ORDER BY id;

-- =============================================
-- 10. FINAL SUMMARY
-- =============================================
-- Final summary of users
SELECT 
    'FINAL USERS SUMMARY' as Info,
    role,
    COUNT(*) as Count,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM users) AS DECIMAL(5,2)) as Percentage
FROM users
GROUP BY role
ORDER BY role;

-- =============================================
-- 11. PROFILE DISPLAY RULES
-- =============================================
-- Summary of profile display rules
SELECT 
    'PROFILE DISPLAY RULES' as Info,
    '1. If name exists and not empty, display name' as Rule_1,
    '2. If name is null/empty, display email' as Rule_2,
    '3. If both are null/empty, display "Unknown User"' as Rule_3,
    '4. Role should be retrieved from database' as Rule_4,
    '5. Admin users should have role "Admin"' as Rule_5,
    '6. Regular users should have role "User"' as Rule_6;

PRINT 'User roles and profile display fix completed!';
PRINT 'Check the results above to verify:';
PRINT '1. Current users status';
PRINT '2. Users before fix';
PRINT '3. NULL roles fixed';
PRINT '4. Admin user exists';
PRINT '5. Users after fix';
PRINT '6. Profile display test';
PRINT '7. User lookup by ID';
PRINT '8. Admin functionality';
PRINT '9. Regular user functionality';
PRINT '10. Final summary';
PRINT '11. Profile display rules';
