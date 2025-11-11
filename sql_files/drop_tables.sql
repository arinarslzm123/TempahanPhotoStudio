-- =============================================
-- DROP ALL TABLES (IF NEEDED)
-- =============================================

USE TempahanPhotoStudio;
GO

-- Drop tables in correct order (due to foreign key constraints)
IF EXISTS (SELECT * FROM sysobjects WHERE name='bookings' AND xtype='U')
BEGIN
    DROP TABLE bookings;
    PRINT 'Bookings table dropped';
END

IF EXISTS (SELECT * FROM sysobjects WHERE name='sub_packages' AND xtype='U')
BEGIN
    DROP TABLE sub_packages;
    PRINT 'Sub_packages table dropped';
END

IF EXISTS (SELECT * FROM sysobjects WHERE name='packages' AND xtype='U')
BEGIN
    DROP TABLE packages;
    PRINT 'Packages table dropped';
END

IF EXISTS (SELECT * FROM sysobjects WHERE name='users' AND xtype='U')
BEGIN
    DROP TABLE users;
    PRINT 'Users table dropped';
END

PRINT 'All tables dropped successfully';
GO
