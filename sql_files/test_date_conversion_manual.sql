-- =============================================
-- MANUAL DATE CONVERSION TEST
-- =============================================

USE TempahanPhotoStudio;
GO

-- Test 1: Clear existing test data
DELETE FROM bookings WHERE notes LIKE '%Test%';
PRINT 'Cleared existing test data';
GO

-- Test 2: Test different date formats
PRINT 'Testing date format: 13/10/2025 -> 2025-10-13';

-- This should work (converted format)
INSERT INTO bookings (
    user_id, package_id, sub_package_id, booking_date, event_date, event_time,
    status, total_amount, payment_method, payment_status, notes
) VALUES (
    1, 1, 1, '2025-01-10', '2025-10-13', '22:00',
    'Pending', 1200.00, 'Cash', 'Pending', 'Test converted format: 13/10/2025 -> 2025-10-13'
);

PRINT 'Converted format test: SUCCESS';
GO

-- Test 3: Test original format (this might fail)
PRINT 'Testing original format: 13/10/2025 (should fail)';

BEGIN TRY
    INSERT INTO bookings (
        user_id, package_id, sub_package_id, booking_date, event_date, event_time,
        status, total_amount, payment_method, payment_status, notes
    ) VALUES (
        1, 1, 1, '2025-01-10', '13/10/2025', '22:00',
        'Pending', 1200.00, 'Cash', 'Pending', 'Test original format: 13/10/2025'
    );
    PRINT 'Original format test: SUCCESS (unexpected)';
END TRY
BEGIN CATCH
    PRINT 'Original format test: FAILED (expected) - ' + ERROR_MESSAGE();
END CATCH
GO

-- Test 4: Test other date formats
PRINT 'Testing other date formats...';

-- Test YYYY/MM/DD format
BEGIN TRY
    INSERT INTO bookings (
        user_id, package_id, sub_package_id, booking_date, event_date, event_time,
        status, total_amount, payment_method, payment_status, notes
    ) VALUES (
        1, 1, 1, '2025-01-10', '2025/10/13', '22:00',
        'Pending', 1200.00, 'Cash', 'Pending', 'Test YYYY/MM/DD format'
    );
    PRINT 'YYYY/MM/DD format test: SUCCESS';
END TRY
BEGIN CATCH
    PRINT 'YYYY/MM/DD format test: FAILED - ' + ERROR_MESSAGE();
END CATCH
GO

-- Test 5: Show all test results
SELECT 
    id,
    event_date,
    event_time,
    notes
FROM bookings
WHERE notes LIKE '%Test%'
ORDER BY id DESC;
GO

-- Test 6: Check what SQL Server expects
PRINT 'SQL Server date format expectations:';
PRINT 'Accepted formats: YYYY-MM-DD, YYYY/MM/DD, MM/DD/YYYY (US format)';
PRINT 'NOT accepted: DD/MM/YYYY (European format)';
PRINT 'Android app must convert DD/MM/YYYY to YYYY-MM-DD';
GO
