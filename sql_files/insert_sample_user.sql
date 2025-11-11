-- Insert sample user data if not exists
IF NOT EXISTS (SELECT * FROM users WHERE id = 1)
BEGIN
    INSERT INTO users (id, username, email, password, role, full_name, phone_number, created_at)
    VALUES (1, 'admin', 'admin@photostudio.com', 'password123', 'Admin', 'Admin User', '0123456789', GETDATE());
END

-- Insert another sample user
IF NOT EXISTS (SELECT * FROM users WHERE id = 2)
BEGIN
    INSERT INTO users (id, username, email, password, role, full_name, phone_number, created_at)
    VALUES (2, 'user1', 'user1@example.com', 'password123', 'User', 'John Doe', '0123456788', GETDATE());
END

-- Check inserted data
SELECT * FROM users;
