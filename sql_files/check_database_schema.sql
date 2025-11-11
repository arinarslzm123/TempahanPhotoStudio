-- =============================================
-- CHECK DATABASE SCHEMA FOR DATE COLUMNS
-- =============================================

USE TempahanPhotoStudio;
GO

-- Check bookings table structure
SELECT 
    COLUMN_NAME as 'Column Name',
    DATA_TYPE as 'Data Type',
    CHARACTER_MAXIMUM_LENGTH as 'Max Length',
    IS_NULLABLE as 'Nullable',
    COLUMN_DEFAULT as 'Default Value'
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'bookings'
ORDER BY ORDINAL_POSITION;
GO

-- Test inserting different date formats
PRINT 'Testing different date formats...';

-- Test 1: YYYY-MM-DD format (should work)
INSERT INTO bookings (
    user_id, package_id, sub_package_id, booking_date, event_date, event_time,
    status, total_amount, payment_method, payment_status, notes
) VALUES (
    1, 1, 1, '2025-01-10', '2025-10-13', '22:00',
    'Pending', 1200.00, 'Cash', 'Pending', 'Test YYYY-MM-DD format'
);

PRINT 'YYYY-MM-DD format test: SUCCESS';
GO

-- Test 2: Check what was actually inserted
SELECT 
    id,
    booking_date,
    event_date,
    event_time,
    notes
FROM bookings
WHERE notes LIKE '%YYYY-MM-DD format%';
GO

-- Test 3: Try different date formats to see which ones work
PRINT 'Testing various date formats...';

-- Test DD/MM/YYYY format (this might fail)
BEGIN TRY
    INSERT INTO bookings (
        user_id, package_id, sub_package_id, booking_date, event_date, event_time,
        status, total_amount, payment_method, payment_status, notes
    ) VALUES (
        1, 1, 1, '2025-01-10', '13/10/2025', '22:00',
        'Pending', 1200.00, 'Cash', 'Pending', 'Test DD/MM/YYYY format'
    );
    PRINT 'DD/MM/YYYY format test: SUCCESS';
END TRY
BEGIN CATCH
    PRINT 'DD/MM/YYYY format test: FAILED - ' + ERROR_MESSAGE();
END CATCH
GO

-- Test 4: Check current data in bookings table
SELECT 
    id,
    booking_date,
    event_date,
    event_time,
    status,
    notes
FROM bookings
ORDER BY id DESC;
GO

PRINT '=============================================';
PRINT 'DATABASE SCHEMA CHECK COMPLETED';
PRINT '=============================================';
PRINT 'Check the results above to see which date formats work';
GO
