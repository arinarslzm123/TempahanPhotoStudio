-- =============================================
-- VERIFY DATABASE DATA FOR TESTING
-- =============================================

USE TempahanPhotoStudio;
GO

-- Check if we have valid data for testing
PRINT '=== CHECKING DATABASE DATA ===';

-- Check users
SELECT 'Users' as 'Table', COUNT(*) as 'Count' FROM users;
SELECT TOP 3 id, name, email, role FROM users;

-- Check packages
SELECT 'Packages' as 'Table', COUNT(*) as 'Count' FROM packages;
SELECT TOP 3 id, package_name, category FROM packages;

-- Check sub_packages
SELECT 'Sub Packages' as 'Table', COUNT(*) as 'Count' FROM sub_packages;
SELECT TOP 3 id, package_id, package_class, price FROM sub_packages;

-- If no data exists, insert test data
IF NOT EXISTS (SELECT * FROM users WHERE id = 1)
BEGIN
    INSERT INTO users (name, email, password, role) VALUES 
    ('Test User', 'test@example.com', 'password', 'User');
    PRINT 'Test user created';
END

IF NOT EXISTS (SELECT * FROM packages WHERE id = 1)
BEGIN
    INSERT INTO packages (package_name, event, duration, category) VALUES 
    ('Test Package', 'Wedding', '8 hours', 'Videography');
    PRINT 'Test package created';
END

IF NOT EXISTS (SELECT * FROM sub_packages WHERE id = 1)
BEGIN
    INSERT INTO sub_packages (package_id, package_class, details, price) VALUES 
    (1, 'Regular', 'Test sub package', 1200.00);
    PRINT 'Test sub package created';
END

-- Test insert with exact values from Android app
PRINT '=== TESTING INSERT WITH ANDROID VALUES ===';

BEGIN TRY
    INSERT INTO bookings (
        user_id, package_id, sub_package_id, 
        booking_date, event_date, event_time,
        status, total_amount, payment_method, payment_status, notes,
        created_at
    ) VALUES (
        1, 1, 1,
        '2025-01-10', '2025-10-13', '22:00',
        'Pending', 1200.00, 'Cash', 'Pending', 'Test from Android app',
        GETDATE()
    );
    PRINT 'Android test insert: SUCCESS';
END TRY
BEGIN CATCH
    PRINT 'Android test insert: FAILED - ' + ERROR_MESSAGE();
END CATCH
GO

-- Show current bookings
SELECT 
    id, user_id, package_id, sub_package_id,
    booking_date, event_date, event_time, status, notes, created_at
FROM bookings
ORDER BY id DESC;
GO

PRINT '=== DATABASE VERIFICATION COMPLETED ===';
