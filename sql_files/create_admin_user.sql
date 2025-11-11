-- =============================================
-- CREATE ADMIN USER FOR TESTING
-- =============================================
-- This script creates an admin user for testing the admin functionality

USE TempahanPhotoStudio;
GO

-- Check if admin user already exists
IF NOT EXISTS (SELECT 1 FROM users WHERE email = 'admin@photostudio.com')
BEGIN
    -- Insert admin user
    INSERT INTO users (name, email, password, role) 
    VALUES ('Admin User', 'admin@photostudio.com', 'admin123', 'Admin');
    
    PRINT 'Admin user created successfully!';
    PRINT 'Email: admin@photostudio.com';
    PRINT 'Password: admin123';
    PRINT 'Role: Admin';
END
ELSE
BEGIN
    -- Update existing admin user role
    UPDATE users 
    SET role = 'Admin' 
    WHERE email = 'admin@photostudio.com';
    
    PRINT 'Admin user role updated successfully!';
END

-- Verify admin user
SELECT 
    id,
    name,
    email,
    role,
    created_at
FROM users 
WHERE email = 'admin@photostudio.com';

-- Show all users for verification
SELECT 
    id,
    name,
    email,
    role,
    created_at
FROM users 
ORDER BY role, name;

PRINT 'Admin user setup completed!';
PRINT 'You can now login with:';
PRINT 'Email: admin@photostudio.com';
PRINT 'Password: admin123';
