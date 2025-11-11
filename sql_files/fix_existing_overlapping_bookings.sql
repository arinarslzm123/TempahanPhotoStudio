-- =============================================
-- FIX EXISTING OVERLAPPING BOOKINGS
-- =============================================
-- This script identifies and optionally removes duplicate bookings
-- that have the same event_date and event_time

USE TempahanPhotoStudio;
GO

-- Step 1: Check for overlapping bookings
PRINT '========================================';
PRINT 'STEP 1: IDENTIFYING OVERLAPPING BOOKINGS';
PRINT '========================================';
GO

SELECT 
    event_date,
    event_time,
    COUNT(*) as duplicate_count,
    STRING_AGG(CAST(id AS VARCHAR), ', ') as booking_ids,
    STRING_AGG(CAST(user_id AS VARCHAR), ', ') as user_ids
FROM bookings
WHERE status NOT IN ('Cancelled', 'Completed')
GROUP BY event_date, event_time
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC, event_date, event_time;
GO

-- Step 2: Show details of overlapping bookings
PRINT '';
PRINT '========================================';
PRINT 'STEP 2: DETAILS OF OVERLAPPING BOOKINGS';
PRINT '========================================';
GO

SELECT 
    b1.id as booking_id,
    b1.user_id,
    u.username,
    b1.event_date,
    b1.event_time,
    b1.status,
    b1.created_at,
    b1.total_amount,
    CASE 
        WHEN EXISTS (
            SELECT 1 FROM bookings b2 
            WHERE b2.event_date = b1.event_date 
            AND b2.event_time = b1.event_time
            AND b2.id < b1.id
            AND b2.status NOT IN ('Cancelled', 'Completed')
        ) THEN 'DUPLICATE - Not First'
        ELSE 'KEEP - First Booking'
    END as action
FROM bookings b1
INNER JOIN users u ON b1.user_id = u.id
WHERE b1.id IN (
    SELECT id FROM bookings
    WHERE status NOT IN ('Cancelled', 'Completed')
    AND (event_date, event_time) IN (
        SELECT event_date, event_time
        FROM bookings
        WHERE status NOT IN ('Cancelled', 'Completed')
        GROUP BY event_date, event_time
        HAVING COUNT(*) > 1
    )
)
ORDER BY b1.event_date, b1.event_time, b1.id;
GO

-- Step 3: DELETE DUPLICATE BOOKINGS (Keep the first one - lowest ID)
-- UNCOMMENT BELOW TO EXECUTE DELETION
/*
PRINT '';
PRINT '========================================';
PRINT 'STEP 3: DELETING DUPLICATE BOOKINGS';
PRINT '========================================';
PRINT 'This will keep the booking with the lowest ID for each date/time combination';
PRINT 'and delete all duplicates.';
GO

DELETE FROM bookings
WHERE id IN (
    -- Find IDs of duplicate bookings (not the first one)
    SELECT b2.id
    FROM bookings b1
    INNER JOIN bookings b2 ON 
        b1.event_date = b2.event_date 
        AND b1.event_time = b2.event_time
        AND b1.id < b2.id  -- b2 is duplicate (higher ID)
    WHERE b1.status NOT IN ('Cancelled', 'Completed')
      AND b2.status NOT IN ('Cancelled', 'Completed')
);

PRINT 'Duplicate bookings deleted.';
PRINT 'First booking (lowest ID) kept for each date/time combination.';
GO
*/

-- Step 4: Verify no more duplicates after cleanup
PRINT '';
PRINT '========================================';
PRINT 'STEP 4: VERIFYING NO MORE DUPLICATES';
PRINT '========================================';
GO

SELECT 
    event_date,
    event_time,
    COUNT(*) as booking_count
FROM bookings
WHERE status NOT IN ('Cancelled', 'Completed')
GROUP BY event_date, event_time
HAVING COUNT(*) > 1;
GO

IF @@ROWCOUNT = 0
    PRINT 'SUCCESS: No overlapping bookings found!';
ELSE
    PRINT 'WARNING: Still have overlapping bookings. Review data above.';
GO

PRINT '';
PRINT 'Script completed. Review results above.';
PRINT 'To delete duplicates, uncomment Step 3 in the script.';

