-- =============================================
-- CHECK AND REMOVE DUPLICATE FEEDBACK
-- =============================================

USE TempahanPhotoStudio;
GO

-- Step 1: Check for duplicate feedback entries
PRINT '========================================';
PRINT 'STEP 1: CHECKING FOR DUPLICATES';
PRINT '========================================';

SELECT 
    name,
    comment,
    rating,
    created_at,
    COUNT(*) as duplicate_count
FROM feedback
GROUP BY name, comment, rating, created_at
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;
GO

-- Step 2: Show all duplicate entries with IDs
PRINT '';
PRINT '========================================';
PRINT 'STEP 2: DUPLICATE ENTRIES DETAILS';
PRINT '========================================';

SELECT 
    f1.id,
    f1.name,
    f1.comment,
    f1.rating,
    f1.created_at
FROM feedback f1
INNER JOIN (
    SELECT name, comment, rating, created_at
    FROM feedback
    GROUP BY name, comment, rating, created_at
    HAVING COUNT(*) > 1
) f2 ON f1.name = f2.name 
    AND f1.comment = f2.comment 
    AND f1.rating = f2.rating
    AND f1.created_at = f2.created_at
ORDER BY f1.name, f1.created_at, f1.id;
GO

-- Step 3: Remove duplicates (keep the one with lowest ID, delete others)
PRINT '';
PRINT '========================================';
PRINT 'STEP 3: REMOVING DUPLICATES';
PRINT '========================================';
PRINT 'This will keep the feedback with the lowest ID for each duplicate group';
PRINT 'and delete all other duplicates.';
GO

-- Uncomment below to execute deletion
/*
DELETE FROM feedback
WHERE id NOT IN (
    -- Keep the minimum ID for each group of duplicates
    SELECT MIN(id)
    FROM feedback
    GROUP BY name, comment, rating, created_at
);
GO

PRINT 'Duplicates removed successfully.';
*/

-- Step 4: Verify no more duplicates
PRINT '';
PRINT '========================================';
PRINT 'STEP 4: VERIFYING NO MORE DUPLICATES';
PRINT '========================================';

SELECT 
    name,
    comment,
    rating,
    created_at,
    COUNT(*) as count
FROM feedback
GROUP BY name, comment, rating, created_at
HAVING COUNT(*) > 1;
GO

IF @@ROWCOUNT = 0
    PRINT 'SUCCESS: No duplicates found!';
ELSE
    PRINT 'WARNING: Still have duplicates. Review data above.';
GO

-- Step 5: View all feedback (final state)
PRINT '';
PRINT '========================================';
PRINT 'STEP 5: ALL FEEDBACK ENTRIES';
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
ORDER BY created_at DESC, id DESC;
GO

PRINT '';
PRINT 'Script completed. Review results above.';
PRINT 'To remove duplicates, uncomment Step 3 in the script.';

