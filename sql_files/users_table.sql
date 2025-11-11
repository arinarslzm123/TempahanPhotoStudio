-- =============================================
-- USERS TABLE QUERY
-- =============================================

USE TempahanPhotoStudio;
GO

-- Create Users Table
CREATE TABLE users (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(50) NOT NULL,
    email NVARCHAR(100) UNIQUE NOT NULL,
    password NVARCHAR(255) NOT NULL,
    role NVARCHAR(20) DEFAULT 'User',
    phone NVARCHAR(20),
    created_at DATETIME DEFAULT GETDATE()
);
GO

-- Insert Sample Users
INSERT INTO users (name, email, password, role) VALUES 
('Admin', 'admin@photostudio.com', 'admin123', 'Admin'),
('User', 'user@example.com', 'user123', 'User'),
('John Doe', 'john@example.com', 'password123', 'User'),
('Jane Smith', 'jane@example.com', 'password123', 'User');
GO

-- Verify Users Table
SELECT * FROM users;
GO
