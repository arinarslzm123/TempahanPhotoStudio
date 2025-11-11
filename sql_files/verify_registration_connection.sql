-- Verify registration connection and table structure

-- 1. Check if users table exists
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'users')
BEGIN
    PRINT 'Users table exists';
    
    -- Check table structure
    SELECT 
        COLUMN_NAME, 
        DATA_TYPE, 
        IS_NULLABLE, 
        CHARACTER_MAXIMUM_LENGTH
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'users' 
    ORDER BY ORDINAL_POSITION;
    
    -- Check current data
    SELECT COUNT(*) as total_users FROM users;
    SELECT TOP 5 id, name, email, created_at FROM users ORDER BY id;
END
ELSE
BEGIN
    PRINT 'Users table does not exist - need to create it';
END

-- 2. Test registration query structure
PRINT 'Testing registration query structure:'
PRINT 'INSERT INTO users (name, email, password) VALUES (?, ?, ?)'

-- 3. Test email check query
PRINT 'Testing email check query:'
PRINT 'SELECT COUNT(*) FROM users WHERE email = ?'

-- 4. Test user retrieval query
PRINT 'Testing user retrieval query:'
PRINT 'SELECT * FROM users WHERE email = ?'
