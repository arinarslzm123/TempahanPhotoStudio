-- =============================================
-- TEST OVERLAPPING CHECK QUERY DIRECTLY
-- =============================================
-- This script tests the exact query that the app uses to check for overlaps

USE TempahanPhotoStudio;
GO

-- Test case: Check for bookings on 2025-10-26 at 09:00
DECLARE @testDate VARCHAR(20) = '2025-10-26';
DECLARE @testTime VARCHAR(10) = '09:00';
DECLARE @testUserId INT = 1010;

-- Convert date formats (like the app does)
DECLARE @normalizedDateDDMM VARCHAR(20) = '';
DECLARE @normalizedDateDDMMNoPad VARCHAR(20) = '';

-- Convert YYYY-MM-DD to DD/MM/YYYY
IF LEN(@testDate) = 10 AND @testDate LIKE '%-%-%'
BEGIN
    DECLARE @year VARCHAR(4) = LEFT(@testDate, 4);
    DECLARE @month VARCHAR(2) = SUBSTRING(@testDate, 6, 2);
    DECLARE @day VARCHAR(2) = RIGHT(@testDate, 2);
    
    SET @normalizedDateDDMM = @day + '/' + @month + '/' + @year;
    
    DECLARE @dayInt INT = CAST(@day AS INT);
    DECLARE @monthInt INT = CAST(@month AS INT);
    SET @normalizedDateDDMMNoPad = CAST(@dayInt AS VARCHAR) + '/' + CAST(@monthInt AS VARCHAR) + '/' + @year;
END

DECLARE @normalizedTime VARCHAR(10) = @testTime;
DECLARE @timeWithoutColon VARCHAR(10) = REPLACE(@testTime, ':', '');

PRINT 'Test Parameters:';
PRINT '  Original Date (YYYY-MM-DD): ' + @testDate;
PRINT '  Normalized DD/MM/YYYY: ' + @normalizedDateDDMM;
PRINT '  Normalized D/M/YYYY: ' + @normalizedDateDDMMNoPad;
PRINT '  Original Time: ' + @testTime;
PRINT '  Time Without Colon: ' + @timeWithoutColon;
PRINT '';

-- Check what formats exist in database for this date
PRINT 'Actual data in database for date 2025-10-26:';
SELECT 
    id,
    user_id,
    event_date,
    event_time,
    status,
    LEN(event_date) as date_length,
    LEN(event_time) as time_length
FROM bookings
WHERE event_date = '2025-10-26' 
   OR event_date = '26/10/2025'
   OR event_date = '26/10/2025'
ORDER BY id;
GO

-- Now test the overlapping check query (exact same as app)
PRINT '';
PRINT 'Testing overlapping check query:';
DECLARE @testDate VARCHAR(20) = '2025-10-26';
DECLARE @testTime VARCHAR(10) = '09:00';
DECLARE @normalizedDateDDMM VARCHAR(20) = '26/10/2025';
DECLARE @normalizedDateDDMMNoPad VARCHAR(20) = '26/10/2025';
DECLARE @normalizedTime VARCHAR(10) = '09:00';
DECLARE @timeWithoutColon VARCHAR(10) = '0900';

SELECT 
    COUNT(*) as booking_count,
    SUM(CASE WHEN user_id = 1010 THEN 1 ELSE 0 END) as same_user_count,
    STRING_AGG(CAST(id AS VARCHAR), ', ') as booking_ids,
    STRING_AGG(CAST(user_id AS VARCHAR), ', ') as user_ids,
    STRING_AGG(event_date, ', ') as event_dates,
    STRING_AGG(event_time, ', ') as event_times
FROM bookings 
WHERE 
    ((event_date = @testDate OR event_date = @normalizedDateDDMM OR event_date = @normalizedDateDDMMNoPad) 
     AND 
     (event_time = @testTime OR event_time = @normalizedTime OR event_time = @timeWithoutColon))
    AND status NOT IN ('Cancelled', 'Completed');
GO

-- Also check with LIKE for partial matches
PRINT '';
PRINT 'Checking with LIKE patterns (for debugging):';
SELECT 
    id,
    user_id,
    event_date,
    event_time,
    status,
    CASE 
        WHEN event_date LIKE '2025-10-26%' THEN 'Match YYYY-MM-DD'
        WHEN event_date LIKE '26/10/2025%' THEN 'Match DD/MM/YYYY'
        WHEN event_date LIKE '26/10/2025%' THEN 'Match D/M/YYYY'
        ELSE 'No Match'
    END as date_match,
    CASE
        WHEN event_time = '09:00' THEN 'Exact Match'
        WHEN event_time = '0900' THEN 'Match No Colon'
        ELSE 'No Match'
    END as time_match
FROM bookings
WHERE status NOT IN ('Cancelled', 'Completed')
  AND (
      (event_date LIKE '%2025-10-26%' OR event_date LIKE '%26/10/2025%')
      AND (event_time LIKE '%09:00%' OR event_time LIKE '%0900%')
  );
GO

PRINT '';
PRINT 'Test completed. Review results above.';

