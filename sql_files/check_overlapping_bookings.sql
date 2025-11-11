-- =============================================
-- CHECK OVERLAPPING BOOKINGS IN DATABASE
-- =============================================

USE TempahanPhotoStudio;
GO

-- Check all bookings to see date/time formats
SELECT 
    id,
    user_id,
    event_date,
    event_time,
    status,
    created_at,
    LEN(event_date) as date_length,
    LEN(event_time) as time_length
FROM bookings
WHERE status NOT IN ('Cancelled', 'Completed')
ORDER BY event_date, event_time, user_id;
GO

-- Find overlapping bookings (same date and time)
SELECT 
    b1.id as booking_id_1,
    b1.user_id as user_id_1,
    u1.username as username_1,
    b2.id as booking_id_2,
    b2.user_id as user_id_2,
    u2.username as username_2,
    b1.event_date,
    b1.event_time,
    b1.status as status_1,
    b2.status as status_2,
    CASE 
        WHEN b1.user_id = b2.user_id THEN 'SAME USER'
        ELSE 'DIFFERENT USER'
    END as booking_type
FROM bookings b1
INNER JOIN bookings b2 ON 
    b1.event_date = b2.event_date 
    AND b1.event_time = b2.event_time
    AND b1.id < b2.id  -- Avoid duplicate pairs
INNER JOIN users u1 ON b1.user_id = u1.id
INNER JOIN users u2 ON b2.user_id = u2.id
WHERE b1.status NOT IN ('Cancelled', 'Completed')
  AND b2.status NOT IN ('Cancelled', 'Completed')
ORDER BY b1.event_date, b1.event_time;
GO

-- Check specific overlapping case (2025-10-26, 09:00)
SELECT 
    id,
    user_id,
    event_date,
    event_time,
    status,
    created_at
FROM bookings
WHERE event_date = '2025-10-26' 
  AND event_time = '09:00'
  AND status NOT IN ('Cancelled', 'Completed')
ORDER BY id;
GO

-- Try to find bookings with different date formats but same logical date
-- Check if any bookings have dates in DD/MM/YYYY format
SELECT 
    id,
    user_id,
    event_date,
    event_time,
    status
FROM bookings
WHERE event_date LIKE '%/%'  -- Dates with slashes (DD/MM/YYYY)
  AND status NOT IN ('Cancelled', 'Completed');
GO

PRINT 'Analysis complete. Check results above for overlapping bookings.';

