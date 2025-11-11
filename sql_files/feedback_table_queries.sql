-- =============================================
-- USEFUL QUERIES FOR FEEDBACK TABLE
-- =============================================

USE TempahanPhotoStudio;
GO

-- 1. View all feedback with user information
SELECT 
    f.id,
    f.name,
    f.comment,
    f.rating,
    f.created_at,
    u.email as user_email,
    FORMAT(f.created_at, 'dd MMMM yyyy', 'ms-MY') as formatted_date
FROM feedback f
LEFT JOIN users u ON f.user_id = u.id
ORDER BY f.created_at DESC;
GO

-- 2. Get feedback by rating (highest first)
SELECT 
    id,
    name,
    comment,
    rating,
    FORMAT(created_at, 'dd MMMM yyyy', 'ms-MY') as date
FROM feedback
ORDER BY rating DESC, created_at DESC;
GO

-- 3. Get average rating
SELECT 
    COUNT(*) as total_feedback,
    AVG(rating) as average_rating,
    MIN(rating) as lowest_rating,
    MAX(rating) as highest_rating
FROM feedback;
GO

-- 4. Add new feedback (example)
/*
INSERT INTO feedback (user_id, name, comment, rating, created_at) 
VALUES 
(1, 'John Doe', 'Sangat puas dengan perkhidmatan!', 5.0, GETDATE());
GO
*/

-- 5. Search feedback by name or comment
/*
DECLARE @searchTerm NVARCHAR(100) = 'bagus';
SELECT 
    id,
    name,
    comment,
    rating,
    FORMAT(created_at, 'dd MMMM yyyy', 'ms-MY') as date
FROM feedback
WHERE name LIKE '%' + @searchTerm + '%' 
   OR comment LIKE '%' + @searchTerm + '%'
ORDER BY created_at DESC;
GO
*/

-- 6. Get feedback count by rating
SELECT 
    rating,
    COUNT(*) as count
FROM feedback
GROUP BY rating
ORDER BY rating DESC;
GO

-- 7. Delete feedback (use with caution)
/*
DELETE FROM feedback WHERE id = 1;
GO
*/

-- 8. Update feedback (use with caution)
/*
UPDATE feedback 
SET comment = 'Updated comment', rating = 4.5
WHERE id = 1;
GO
*/

-- 9. Get feedback for specific user
/*
DECLARE @userId INT = 1;
SELECT 
    id,
    name,
    comment,
    rating,
    FORMAT(created_at, 'dd MMMM yyyy', 'ms-MY') as date
FROM feedback
WHERE user_id = @userId
ORDER BY created_at DESC;
GO
*/

-- 10. Get recent feedback (last 10)
SELECT TOP 10
    id,
    name,
    comment,
    rating,
    FORMAT(created_at, 'dd MMMM yyyy', 'ms-MY') as date
FROM feedback
ORDER BY created_at DESC;
GO

