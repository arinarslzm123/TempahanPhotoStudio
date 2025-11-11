-- =============================================
-- ADD UNIQUE CONSTRAINT TO PREVENT OVERLAPPING BOOKINGS
-- =============================================
-- This prevents ANY user (including same user) from booking the same date/time
-- Note: This is very strict - only ONE booking allowed per date/time slot

USE TempahanPhotoStudio;
GO

-- First, remove existing overlapping bookings (keep the first one, delete duplicates)
-- This script will keep the booking with the lowest ID for each date/time combination

-- Step 1: Identify duplicates
SELECT 
    event_date,
    event_time,
    COUNT(*) as duplicate_count,
    MIN(id) as keep_this_id
FROM bookings
WHERE status NOT IN ('Cancelled', 'Completed')
GROUP BY event_date, event_time
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;
GO

-- Step 2: Create a backup of bookings to be deleted (optional)
-- Uncomment if you want to backup before deleting
/*
SELECT * 
INTO bookings_backup_duplicates
FROM bookings
WHERE id NOT IN (
    SELECT MIN(id)
    FROM bookings
    WHERE status NOT IN ('Cancelled', 'Completed')
    GROUP BY event_date, event_time
);
GO
*/

-- Step 3: Delete duplicate bookings (keep the one with lowest ID)
-- Uncomment to execute deletion
/*
DELETE FROM bookings
WHERE id NOT IN (
    SELECT MIN(id)
    FROM bookings
    WHERE status NOT IN ('Cancelled', 'Completed')
    GROUP BY event_date, event_time
)
AND status NOT IN ('Cancelled', 'Completed');
GO
*/

-- Step 4: Add unique constraint (only after cleaning duplicates)
-- Note: This prevents overlapping bookings at database level
-- Uncomment to add constraint
/*
-- First normalize all date formats to YYYY-MM-DD if needed
-- Update any DD/MM/YYYY dates to YYYY-MM-DD format
UPDATE bookings
SET event_date = 
    CASE 
        WHEN event_date LIKE '%/%' THEN
            -- Convert DD/MM/YYYY to YYYY-MM-DD
            RIGHT(event_date, 4) + '-' + 
            RIGHT('0' + SUBSTRING(event_date, CHARINDEX('/', event_date) + 1, CHARINDEX('/', event_date, CHARINDEX('/', event_date) + 1) - CHARINDEX('/', event_date) - 1), 2) + '-' +
            RIGHT('0' + LEFT(event_date, CHARINDEX('/', event_date) - 1), 2)
        ELSE event_date
    END
WHERE event_date LIKE '%/%';
GO

-- Normalize time format to HH:mm if needed
UPDATE bookings
SET event_time = 
    CASE 
        WHEN event_time NOT LIKE '%:%' AND LEN(event_time) = 4 THEN
            -- Convert HHmm to HH:mm
            LEFT(event_time, 2) + ':' + RIGHT(event_time, 2)
        ELSE event_time
    END
WHERE event_time NOT LIKE '%:%' AND LEN(event_time) = 4;
GO

-- Now add unique constraint
ALTER TABLE bookings
ADD CONSTRAINT UQ_EventDateTime UNIQUE (event_date, event_time);
GO

PRINT 'Unique constraint added. No overlapping bookings allowed at database level.';
*/

PRINT 'Script prepared. Review and uncomment sections to execute.';

