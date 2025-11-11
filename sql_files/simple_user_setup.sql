-- Simple script to ensure user data exists

-- Delete existing user with ID 1 if exists
DELETE FROM users WHERE id = 1;

-- Insert new user with ID 1
INSERT INTO users (id, username, email, password, role, full_name, phone_number, created_at)
VALUES (1, 'admin', 'admin@photostudio.com', 'password123', 'Admin', 'Admin User', '0123456789', GETDATE());

-- Verify the data
SELECT id, username, email, full_name, role FROM users WHERE id = 1;
