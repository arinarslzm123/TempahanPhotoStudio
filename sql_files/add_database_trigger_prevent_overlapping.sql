-- =============================================
-- DATABASE TRIGGER TO PREVENT OVERLAPPING BOOKINGS
-- =============================================
-- This trigger runs BEFORE INSERT and prevents any overlapping bookings
-- at the database level, regardless of application code

USE TempahanPhotoStudio;
GO

-- Drop trigger if exists
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'TR' AND name = 'trg_PreventOverlappingBookings')
    DROP TRIGGER trg_PreventOverlappingBookings;
GO

-- Create trigger
CREATE TRIGGER trg_PreventOverlappingBookings
ON bookings
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Check for overlapping bookings
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN bookings b ON 
            (
                -- Check multiple date formats
                (b.event_date = i.event_date) OR
                -- Handle DD/MM/YYYY format if inserted is YYYY-MM-DD
                (i.event_date LIKE '%-%-%' AND b.event_date LIKE '%/%/%' AND
                 RIGHT(i.event_date, 2) + '/' + SUBSTRING(i.event_date, 6, 2) + '/' + LEFT(i.event_date, 4) = b.event_date) OR
                -- Handle YYYY-MM-DD format if inserted is DD/MM/YYYY  
                (i.event_date LIKE '%/%/%' AND b.event_date LIKE '%-%-%' AND
                 RIGHT(b.event_date, 2) + '/' + SUBSTRING(b.event_date, 6, 2) + '/' + LEFT(b.event_date, 4) = i.event_date)
            )
            AND
            (
                -- Check multiple time formats
                (b.event_time = i.event_time) OR
                -- Handle time without colon
                (i.event_time LIKE '%:%' AND b.event_time = REPLACE(i.event_time, ':', '')) OR
                (i.event_time NOT LIKE '%:%' AND b.event_time = LEFT(i.event_time, 2) + ':' + RIGHT(i.event_time, 2))
            )
            AND b.status NOT IN ('Cancelled', 'Completed')
    )
    BEGIN
        -- Raise error and prevent insert
        RAISERROR('Tempahan pada tarikh dan masa ini sudah wujud. Sila pilih tarikh atau masa lain.', 16, 1);
        RETURN;
    END
    
    -- No overlap found, proceed with insert
    INSERT INTO bookings (
        user_id, package_id, sub_package_id, booking_date, event_date, event_time,
        status, total_amount, payment_method, payment_status, notes, created_at
    )
    SELECT 
        user_id, package_id, sub_package_id, booking_date, event_date, event_time,
        status, total_amount, payment_method, payment_status, notes, created_at
    FROM inserted;
END;
GO

PRINT 'Trigger trg_PreventOverlappingBookings created successfully.';
PRINT 'This trigger will prevent overlapping bookings at database level.';
GO

-- Test the trigger (optional - uncomment to test)
/*
BEGIN TRY
    -- Try to insert a duplicate booking
    INSERT INTO bookings (
        user_id, package_id, sub_package_id, booking_date, event_date, event_time,
        status, total_amount, payment_method, payment_status, notes
    ) VALUES (
        1010, 1, 1, '2025-10-17', '2025-10-26', '09:00',
        'Pending', 1000.00, 'Cash', 'Pending', 'Test duplicate booking'
    );
    PRINT 'ERROR: Trigger did not prevent duplicate!';
END TRY
BEGIN CATCH
    PRINT 'SUCCESS: Trigger prevented duplicate - ' + ERROR_MESSAGE();
END CATCH;
GO
*/

