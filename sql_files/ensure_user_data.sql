-- Comprehensive script to ensure user data exists

-- First, check if users table exists
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'users')
BEGIN
    PRINT 'Users table does not exist. Creating...'
    CREATE TABLE users (
        id INT IDENTITY(1,1) PRIMARY KEY,
        username NVARCHAR(50) NOT NULL UNIQUE,
        email NVARCHAR(100) NOT NULL UNIQUE,
        password NVARCHAR(255) NOT NULL,
        role NVARCHAR(20) NOT NULL DEFAULT 'User',
        full_name NVARCHAR(100),
        phone_number NVARCHAR(20),
        created_at DATETIME DEFAULT GETDATE()
    );
    PRINT 'Users table created successfully.'
END
ELSE
BEGIN
    PRINT 'Users table already exists.'
END

-- Check current data
PRINT 'Current users in database:'
SELECT * FROM users;

-- Insert sample data if table is empty
IF NOT EXISTS (SELECT * FROM users)
BEGIN
    PRINT 'No users found. Inserting sample data...'
    
    INSERT INTO users (username, email, password, role, full_name, phone_number, created_at)
    VALUES 
        ('admin', 'admin@photostudio.com', 'password123', 'Admin', 'Admin User', '0123456789', GETDATE()),
        ('user1', 'user1@example.com', 'password123', 'User', 'John Doe', '0123456788', GETDATE()),
        ('user2', 'user2@example.com', 'password123', 'User', 'Jane Smith', '0123456787', GETDATE());
    
    PRINT 'Sample data inserted successfully.'
END
ELSE
BEGIN
    PRINT 'Users already exist in database.'
END

-- Final check
PRINT 'Final users count:'
SELECT COUNT(*) as user_count FROM users;

PRINT 'All users:'
SELECT id, username, email, full_name, role FROM users ORDER BY id;
