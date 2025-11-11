-- Test simple registration with name, email, password only

-- 1. Create simple users table
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'users')
BEGIN
    DROP TABLE users;
    PRINT 'Dropped existing users table';
END

CREATE TABLE users (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    email NVARCHAR(100) NOT NULL UNIQUE,
    password NVARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT GETDATE()
);

PRINT 'Created simple users table with name, email, password';

-- 2. Insert test user
INSERT INTO users (name, email, password) VALUES 
('John Doe', 'john@example.com', 'password123');

PRINT 'Inserted test user: John Doe';

-- 3. Verify data
SELECT id, name, email, created_at FROM users;

-- 4. Test registration query (same as in ConnectionClass)
PRINT 'Testing registration query:'
SELECT COUNT(*) as existing_users FROM users WHERE email = 'jane@example.com';

-- 5. Simulate new registration
INSERT INTO users (name, email, password) VALUES 
('Jane Smith', 'jane@example.com', 'password456');

PRINT 'Simulated registration for Jane Smith';

-- 6. Final verification
SELECT id, name, email, created_at FROM users ORDER BY id;
