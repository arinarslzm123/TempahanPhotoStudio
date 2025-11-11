-- =============================================
-- DEBUG DATABASE ERROR - COMPREHENSIVE CHECK
-- =============================================

USE TempahanPhotoStudio;
GO

-- Check 1: Verify all tables exist
SELECT 
    TABLE_NAME as 'Table Name',
    TABLE_TYPE as 'Type'
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_NAME IN ('users', 'packages', 'sub_packages', 'bookings')
ORDER BY TABLE_NAME;
GO

-- Check 2: Verify bookings table structure
SELECT 
    COLUMN_NAME as 'Column',
    DATA_TYPE as 'Type',
    CHARACTER_MAXIMUM_LENGTH as 'Max Length',
    IS_NULLABLE as 'Nullable',
    COLUMN_DEFAULT as 'Default'
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'bookings'
ORDER BY ORDINAL_POSITION;
GO

-- Check 3: Check foreign key constraints
SELECT 
    fk.name as 'FK Name',
    tp.name as 'Parent Table',
    cp.name as 'Parent Column',
    tr.name as 'Referenced Table',
    cr.name as 'Referenced Column'
FROM sys.foreign_keys fk
INNER JOIN sys.tables tp ON fk.parent_object_id = tp.object_id
INNER JOIN sys.tables tr ON fk.referenced_object_id = tr.object_id
INNER JOIN sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
INNER JOIN sys.columns cp ON fkc.parent_column_id = cp.column_id AND fkc.parent_object_id = cp.object_id
INNER JOIN sys.columns cr ON fkc.referenced_column_id = cr.column_id AND fkc.referenced_object_id = cr.object_id
WHERE tp.name = 'bookings';
GO

-- Check 4: Verify data exists in referenced tables
SELECT 'users' as 'Table', COUNT(*) as 'Count' FROM users
UNION ALL
SELECT 'packages', COUNT(*) FROM packages
UNION ALL
SELECT 'sub_packages', COUNT(*) FROM sub_packages
UNION ALL
SELECT 'bookings', COUNT(*) FROM bookings;
GO

-- Check 5: Test minimal insert without foreign keys
PRINT 'Testing minimal insert...';
BEGIN TRY
    -- Create temporary table for testing
    CREATE TABLE #test_bookings (
        id INT IDENTITY(1,1) PRIMARY KEY,
        user_id INT,
        package_id INT,
        sub_package_id INT,
        booking_date NVARCHAR(20),
        event_date NVARCHAR(20),
        event_time NVARCHAR(10),
        status NVARCHAR(20),
        total_amount DECIMAL(10,2),
        payment_method NVARCHAR(50),
        payment_status NVARCHAR(20),
        notes NVARCHAR(500),
        created_at DATETIME
    );
    
    -- Test insert
    INSERT INTO #test_bookings (
        user_id, package_id, sub_package_id, booking_date, event_date, event_time,
        status, total_amount, payment_method, payment_status, notes
    ) VALUES (
        1, 1, 1, '2025-01-10', '2025-10-13', '22:00',
        'Pending', 1200.00, 'Cash', 'Pending', 'Test minimal insert'
    );
    
    PRINT 'Minimal insert: SUCCESS';
    
    -- Clean up
    DROP TABLE #test_bookings;
END TRY
BEGIN CATCH
    PRINT 'Minimal insert: FAILED - ' + ERROR_MESSAGE();
END CATCH
GO

-- Check 6: Test with actual foreign key values
PRINT 'Testing with actual foreign key values...';
BEGIN TRY
    -- Get valid IDs
    DECLARE @valid_user_id INT = (SELECT TOP 1 id FROM users);
    DECLARE @valid_package_id INT = (SELECT TOP 1 id FROM packages);
    DECLARE @valid_sub_package_id INT = (SELECT TOP 1 id FROM sub_packages);
    
    PRINT 'Valid user_id: ' + CAST(@valid_user_id as NVARCHAR(10));
    PRINT 'Valid package_id: ' + CAST(@valid_package_id as NVARCHAR(10));
    PRINT 'Valid sub_package_id: ' + CAST(@valid_sub_package_id as NVARCHAR(10));
    
    -- Test insert with valid foreign keys
    INSERT INTO bookings (
        user_id, package_id, sub_package_id, booking_date, event_date, event_time,
        status, total_amount, payment_method, payment_status, notes
    ) VALUES (
        @valid_user_id, @valid_package_id, @valid_sub_package_id, 
        '2025-01-10', '2025-10-13', '22:00',
        'Pending', 1200.00, 'Cash', 'Pending', 'Test with valid FKs'
    );
    
    PRINT 'Insert with valid FKs: SUCCESS';
END TRY
BEGIN CATCH
    PRINT 'Insert with valid FKs: FAILED - ' + ERROR_MESSAGE();
END CATCH
GO

-- Check 7: Test different date formats
PRINT 'Testing different date formats...';
DECLARE @test_dates TABLE (date_format NVARCHAR(20), date_value NVARCHAR(20));
INSERT INTO @test_dates VALUES 
('YYYY-MM-DD', '2025-10-13'),
('YYYY/MM/DD', '2025/10/13'),
('DD/MM/YYYY', '13/10/2025'),
('MM/DD/YYYY', '10/13/2025');

DECLARE @valid_user_id2 INT = (SELECT TOP 1 id FROM users);
DECLARE @valid_package_id2 INT = (SELECT TOP 1 id FROM packages);
DECLARE @valid_sub_package_id2 INT = (SELECT TOP 1 id FROM sub_packages);

DECLARE date_cursor CURSOR FOR 
SELECT date_format, date_value FROM @test_dates;

DECLARE @format NVARCHAR(20), @value NVARCHAR(20);
OPEN date_cursor;
FETCH NEXT FROM date_cursor INTO @format, @value;

WHILE @@FETCH_STATUS = 0
BEGIN
    BEGIN TRY
        INSERT INTO bookings (
            user_id, package_id, sub_package_id, booking_date, event_date, event_time,
            status, total_amount, payment_method, payment_status, notes
        ) VALUES (
            @valid_user_id2, @valid_package_id2, @valid_sub_package_id2,
            '2025-01-10', @value, '22:00',
            'Pending', 1200.00, 'Cash', 'Pending', 'Test format: ' + @format
        );
        PRINT @format + ': SUCCESS';
    END TRY
    BEGIN CATCH
        PRINT @format + ': FAILED - ' + ERROR_MESSAGE();
    END CATCH
    
    FETCH NEXT FROM date_cursor INTO @format, @value;
END

CLOSE date_cursor;
DEALLOCATE date_cursor;
GO

-- Check 8: Show current bookings
SELECT 
    id, user_id, package_id, sub_package_id, 
    booking_date, event_date, event_time, status, notes
FROM bookings
ORDER BY id DESC;
GO

PRINT '=============================================';
PRINT 'DATABASE DEBUG COMPLETED';
PRINT 'Check the results above to identify the exact issue';
GO
