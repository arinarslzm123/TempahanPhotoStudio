-- Create users table with name, email, password fields

-- Drop table if exists
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'users')
BEGIN
    DROP TABLE users;
    PRINT 'Existing users table dropped';
END

-- Create users table with required fields
CREATE TABLE users (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    email NVARCHAR(100) NOT NULL UNIQUE,
    password NVARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT GETDATE()
);

PRINT 'Users table created successfully';

-- Insert sample data
INSERT INTO users (name, email, password) VALUES 
('Admin User', 'admin@photostudio.com', 'admin123'),
('Test User', 'test@example.com', 'password123');

PRINT 'Sample data inserted';

-- Verify table structure
PRINT 'Table structure:'
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'users' 
ORDER BY ORDINAL_POSITION;

-- Verify data
PRINT 'Sample data:'
SELECT id, name, email, created_at FROM users;
