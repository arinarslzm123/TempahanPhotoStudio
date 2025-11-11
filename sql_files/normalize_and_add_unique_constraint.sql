-- =============================================
-- NORMALIZE DATE/TIME FORMATS AND ADD UNIQUE CONSTRAINT
-- =============================================
-- This script normalizes all date/time formats in the database
-- and adds a unique constraint to prevent overlapping bookings at database level

USE TempahanPhotoStudio;
GO

PRINT '========================================';
PRINT 'STEP 1: BACKUP CURRENT DATA';
PRINT '========================================';
-- Create backup table (optional)
SELECT * INTO bookings_backup_before_normalize 
FROM bookings;
PRINT 'Backup created: bookings_backup_before_normalize';
GO

PRINT '';
PRINT '========================================';
PRINT 'STEP 2: CHECK CURRENT FORMATS';
PRINT '========================================';
SELECT 
    id,
    event_date,
    event_time,
    LEN(event_date) as date_len,
    CASE 
        WHEN event_date LIKE '%-%-%' THEN 'YYYY-MM-DD'
        WHEN event_date LIKE '%/%/%' THEN 'DD/MM/YYYY'
        ELSE 'UNKNOWN'
    END as date_format,
    CASE 
        WHEN event_time LIKE '%:%' THEN 'HH:mm'
        ELSE 'HHmm'
    END as time_format
FROM bookings
ORDER BY id;
GO

PRINT '';
PRINT '========================================';
PRINT 'STEP 3: NORMALIZE DATE FORMATS TO YYYY-MM-DD';
PRINT '========================================';
-- Convert all DD/MM/YYYY to YYYY-MM-DD
UPDATE bookings
SET event_date = 
    CASE 
        WHEN event_date LIKE '%/%/%' THEN
            -- Extract parts: DD/MM/YYYY
            RIGHT('0000' + RIGHT(event_date, 4), 4) + '-' +  -- Year
            RIGHT('00' + SUBSTRING(event_date, CHARINDEX('/', event_date) + 1, 
                CASE WHEN CHARINDEX('/', event_date, CHARINDEX('/', event_date) + 1) > 0 
                     THEN CHARINDEX('/', event_date, CHARINDEX('/', event_date) + 1) - CHARINDEX('/', event_date) - 1
                     ELSE LEN(event_date) END), 2) + '-' +  -- Month
            RIGHT('00' + LEFT(event_date, CHARINDEX('/', event_date) - 1), 2)  -- Day
        ELSE event_date
    END
WHERE event_date LIKE '%/%/%';
GO

PRINT '';
PRINT '========================================';
PRINT 'STEP 4: NORMALIZE TIME FORMATS TO HH:mm';
PRINT '========================================';
-- Convert all HHmm to HH:mm
UPDATE bookings
SET event_time = 
    CASE 
        WHEN event_time NOT LIKE '%:%' AND LEN(LTRIM(RTRIM(event_time))) = 4 THEN
            LEFT(LTRIM(RTRIM(event_time)), 2) + ':' + RIGHT(LTRIM(RTRIM(event_time)), 2)
        ELSE LTRIM(RTRIM(event_time))
    END
WHERE event_time NOT LIKE '%:%' AND LEN(LTRIM(RTRIM(event_time))) = 4;
GO

PRINT '';
PRINT '========================================';
PRINT 'STEP 5: TRIM ALL WHITESPACE';
PRINT '========================================';
-- Trim all whitespace from date and time columns
UPDATE bookings
SET event_date = LTRIM(RTRIM(event_date)),
    event_time = LTRIM(RTRIM(event_time)),
    status = LTRIM(RTRIM(status));
GO

PRINT '';
PRINT '========================================';
PRINT 'STEP 6: REMOVE DUPLICATE BOOKINGS';
PRINT '========================================';
-- Keep only the first booking (lowest ID) for each date/time combination
-- Delete all duplicates
DELETE FROM bookings
WHERE id NOT IN (
    SELECT MIN(id)
    FROM bookings
    WHERE status NOT IN ('Cancelled', 'Completed')
    GROUP BY event_date, event_time
);
GO

PRINT '';
PRINT '========================================';
PRINT 'STEP 7: VERIFY NO DUPLICATES';
PRINT '========================================';
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
    PRINT 'SUCCESS: No duplicates found!';
ELSE
    PRINT 'WARNING: Still have duplicates. Manual review needed.';
GO

PRINT '';
PRINT '========================================';
PRINT 'STEP 8: ADD UNIQUE CONSTRAINT';
PRINT '========================================';
-- Add unique constraint to prevent overlapping bookings at database level
-- Uncomment below to add constraint

/*
-- First check if constraint already exists
IF NOT EXISTS (
    SELECT * FROM sys.indexes 
    WHERE name = 'UQ_EventDateTime' 
    AND object_id = OBJECT_ID('bookings')
)
BEGIN
    CREATE UNIQUE NONCLUSTERED INDEX UQ_EventDateTime
    ON bookings(event_date, event_time)
    WHERE status NOT IN ('Cancelled', 'Completed');
    
    PRINT 'Unique constraint UQ_EventDateTime created successfully.';
END
ELSE
BEGIN
    PRINT 'Constraint UQ_EventDateTime already exists.';
END
GO
*/

PRINT '';
PRINT '========================================';
PRINT 'VERIFICATION: FINAL DATA';
PRINT '========================================';
SELECT 
    id,
    user_id,
    event_date,
    event_time,
    status
FROM bookings
ORDER BY event_date, event_time, id;
GO

PRINT '';
PRINT 'Script completed. Review results above.';
PRINT 'To add unique constraint, uncomment Step 8.';

