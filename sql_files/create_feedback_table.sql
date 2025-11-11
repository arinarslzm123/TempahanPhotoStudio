-- =============================================
-- CREATE FEEDBACK TABLE FOR FEEDBACK CUSTOMER PAGE
-- =============================================

USE TempahanPhotoStudio;
GO

-- Drop table if exists (optional - uncomment if you want to recreate)
-- DROP TABLE IF EXISTS feedback;
-- GO

-- Create feedback table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='feedback' AND xtype='U')
BEGIN
    CREATE TABLE feedback (
        id INT IDENTITY(1,1) PRIMARY KEY,
        user_id INT NOT NULL,
        name NVARCHAR(100) NOT NULL,
        comment NVARCHAR(500) NOT NULL,
        rating DECIMAL(3,1) NOT NULL CHECK (rating >= 0 AND rating <= 5),
        created_at DATETIME DEFAULT GETDATE(),
        FOREIGN KEY (user_id) REFERENCES users(id)
    );
    PRINT 'Feedback table created successfully';
END
ELSE
BEGIN
    PRINT 'Feedback table already exists';
END
GO

-- Insert sample feedback data
PRINT '';
PRINT '========================================';
PRINT 'INSERTING SAMPLE FEEDBACK DATA';
PRINT '========================================';

-- Check if sample data already exists
IF NOT EXISTS (SELECT * FROM feedback WHERE name = 'Ali')
BEGIN
    -- Get user IDs (or use default values)
    DECLARE @user1_id INT = (SELECT TOP 1 id FROM users ORDER BY id);
    DECLARE @user2_id INT = (SELECT TOP 1 id FROM users ORDER BY id OFFSET 1 ROWS FETCH NEXT 1 ROWS ONLY);
    DECLARE @user3_id INT = (SELECT TOP 1 id FROM users ORDER BY id OFFSET 2 ROWS FETCH NEXT 1 ROWS ONLY);
    
    -- Use first user if not enough users
    IF @user2_id IS NULL SET @user2_id = @user1_id;
    IF @user3_id IS NULL SET @user3_id = @user1_id;
    
    INSERT INTO feedback (user_id, name, comment, rating, created_at) VALUES
    (@user1_id, 'Ali', 'Pengalaman yang hebat.', 5.0, '2025-04-01'),
    (@user2_id, 'Suren', 'Perkhidmatan yang baik dan menepati masa.', 4.5, '2025-04-04'),
    (@user1_id, 'Amir', 'Studio yang bagus, sangat disarankan.', 4.0, '2025-04-10'),
    (@user2_id, 'Sarah', 'Kualiti gambar sangat memuaskan.', 5.0, '2025-04-15'),
    (@user3_id, 'Ahmad', 'Harga berpatutan dan service yang baik.', 4.0, '2025-04-20');
    
    PRINT 'Sample feedback data inserted successfully';
END
ELSE
BEGIN
    PRINT 'Sample feedback data already exists';
END
GO

-- View all feedback
PRINT '';
PRINT '========================================';
PRINT 'FEEDBACK TABLE DATA';
PRINT '========================================';

SELECT 
    id,
    user_id,
    name,
    comment,
    rating,
    created_at,
    FORMAT(created_at, 'dd MMMM yyyy', 'ms-MY') as formatted_date
FROM feedback
ORDER BY created_at DESC;
GO

PRINT '';
PRINT 'Feedback table setup completed successfully!';
PRINT 'Table structure:';
PRINT '  - id: Primary key (auto increment)';
PRINT '  - user_id: Foreign key to users table';
PRINT '  - name: Customer name (NVARCHAR 100)';
PRINT '  - comment: Feedback comment (NVARCHAR 500)';
PRINT '  - rating: Rating (0.0 to 5.0)';
PRINT '  - created_at: Timestamp when feedback was created';

