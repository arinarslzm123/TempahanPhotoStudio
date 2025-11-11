-- =============================================
-- TEST USER LOGIN AND PROFILE FLOW
-- =============================================
-- This script tests the complete user login and profile display flow

USE TempahanPhotoStudio;
GO

-- =============================================
-- 1. CHECK ALL USERS IN DATABASE
-- =============================================
SELECT 
    'ALL USERS IN DATABASE' as Info,
    id,
    name,
    email,
    role,
    'User ID: ' + CAST(id AS VARCHAR(10)) as user_id_display
FROM users
ORDER BY id;

-- =============================================
-- 2. TEST USER LOGIN SCENARIOS
-- =============================================
-- Test login for different users
SELECT 
    'LOGIN TEST - User 1 (arina)' as Info,
    id,
    name,
    email,
    role,
    'Should display: ' + name as expected_profile_name
FROM users
WHERE id = 1;

SELECT 
    'LOGIN TEST - User 2 (dayu)' as Info,
    id,
    name,
    email,
    role,
    'Should display: ' + name as expected_profile_name
FROM users
WHERE id = 2;

SELECT 
    'LOGIN TEST - User 3 (naa)' as Info,
    id,
    name,
    email,
    role,
    'Should display: ' + name as expected_profile_name
FROM users
WHERE id = 3;

SELECT 
    'LOGIN TEST - Admin User' as Info,
    id,
    name,
    email,
    role,
    'Should display: ' + name as expected_profile_name
FROM users
WHERE role = 'Admin';

-- =============================================
-- 3. TEST USER LOOKUP BY EMAIL
-- =============================================
-- Test getUserByEmail functionality
SELECT 
    'EMAIL LOOKUP TEST - arina@gmail.com' as Info,
    id,
    name,
    email,
    role,
    'This is what getUserByEmail should return' as description
FROM users
WHERE email = 'arina@gmail.com';

SELECT 
    'EMAIL LOOKUP TEST - dayu@gmail.com' as Info,
    id,
    name,
    email,
    role,
    'This is what getUserByEmail should return' as description
FROM users
WHERE email = 'dayu@gmail.com';

SELECT 
    'EMAIL LOOKUP TEST - admin@photostudio.com' as Info,
    id,
    name,
    email,
    role,
    'This is what getUserByEmail should return' as description
FROM users
WHERE email = 'admin@photostudio.com';

-- =============================================
-- 4. TEST USER LOOKUP BY ID
-- =============================================
-- Test getUserById functionality
SELECT 
    'ID LOOKUP TEST - ID 1' as Info,
    id,
    name,
    email,
    role,
    'This is what getUserById(1) should return' as description
FROM users
WHERE id = 1;

SELECT 
    'ID LOOKUP TEST - ID 2' as Info,
    id,
    name,
    email,
    role,
    'This is what getUserById(2) should return' as description
FROM users
WHERE id = 2;

SELECT 
    'ID LOOKUP TEST - ID 3' as Info,
    id,
    name,
    email,
    role,
    'This is what getUserById(3) should return' as description
FROM users
WHERE id = 3;

-- =============================================
-- 5. TEST PROFILE DISPLAY LOGIC
-- =============================================
-- Test what each user should see in their profile
SELECT 
    'PROFILE DISPLAY LOGIC TEST' as Info,
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
-- 6. TEST LOGIN FLOW SIMULATION
-- =============================================
-- Simulate the complete login flow
SELECT 
    'LOGIN FLOW SIMULATION' as Info,
    'Step 1: User enters email' as step_1,
    'Step 2: validateUser(email, password)' as step_2,
    'Step 3: getUserByEmail(email)' as step_3,
    'Step 4: Pass user data to Dashboard' as step_4,
    'Step 5: Dashboard passes USER_ID to ProfileActivity' as step_5,
    'Step 6: ProfileActivity calls getUserById(USER_ID)' as step_6,
    'Step 7: Display user name in profile' as step_7;

-- =============================================
-- 7. TEST DATA FLOW
-- =============================================
-- Test the data flow from login to profile
SELECT 
    'DATA FLOW TEST' as Info,
    id as user_id,
    name as user_name,
    email as user_email,
    role as user_role,
    'Login → Dashboard → ProfileActivity' as flow_path,
    'Should display: ' + name as final_display
FROM users
ORDER BY id;

-- =============================================
-- 8. VERIFY USER ID CONSISTENCY
-- =============================================
-- Check that user IDs are consistent
SELECT 
    'USER ID CONSISTENCY CHECK' as Info,
    id,
    name,
    email,
    role,
    'ID should match getUserById result' as verification
FROM users
WHERE id IN (1, 2, 3, 1003)
ORDER BY id;

-- =============================================
-- 9. TEST ROLE-BASED DISPLAY
-- =============================================
-- Test role-based display
SELECT 
    'ROLE-BASED DISPLAY TEST' as Info,
    id,
    name,
    email,
    role,
    CASE 
        WHEN role = 'Admin' THEN 'Welcome Admin, ' + name
        ELSE 'Welcome ' + name
    END as dashboard_welcome,
    'Profile should show: ' + name as profile_display
FROM users
ORDER BY id;

-- =============================================
-- 10. FINAL VERIFICATION
-- =============================================
-- Final verification of user data
SELECT 
    'FINAL VERIFICATION' as Info,
    id,
    name,
    email,
    role,
    'User ID: ' + CAST(id AS VARCHAR(10)) as user_id_for_app,
    'Display Name: ' + name as display_name_for_app,
    'Email: ' + email as email_for_app,
    'Role: ' + role as role_for_app
FROM users
ORDER BY id;

PRINT 'User login and profile flow test completed!';
PRINT 'Check the results above to verify:';
PRINT '1. All users in database';
PRINT '2. Login test scenarios';
PRINT '3. User lookup by email';
PRINT '4. User lookup by ID';
PRINT '5. Profile display logic';
PRINT '6. Login flow simulation';
PRINT '7. Data flow test';
PRINT '8. User ID consistency';
PRINT '9. Role-based display';
PRINT '10. Final verification';
