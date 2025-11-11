-- Delete Tables with Foreign Key Constraints
-- This will handle foreign key constraints properly

PRINT '=== DELETING TABLES WITH FOREIGN KEY CONSTRAINTS ===';

-- Step 1: Check foreign key constraints
PRINT '--- Step 1: Check foreign key constraints ---';

SELECT 
    fk.name AS constraint_name,
    tp.name AS parent_table,
    cp.name AS parent_column,
    tr.name AS referenced_table,
    cr.name AS referenced_column
FROM sys.foreign_keys fk
INNER JOIN sys.tables tp ON fk.parent_object_id = tp.object_id
INNER JOIN sys.tables tr ON fk.referenced_object_id = tr.object_id
INNER JOIN sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
INNER JOIN sys.columns cp ON fkc.parent_column_id = cp.column_id AND fkc.parent_object_id = cp.object_id
INNER JOIN sys.columns cr ON fkc.referenced_column_id = cr.column_id AND fkc.referenced_object_id = cr.object_id
WHERE tp.name IN ('packages', 'sub_packages') OR tr.name IN ('packages', 'sub_packages');

-- Step 2: Drop foreign key constraints first
PRINT '--- Step 2: Drop foreign key constraints ---';

-- Find and drop foreign key constraints that reference packages or sub_packages
DECLARE @sql NVARCHAR(MAX) = '';

SELECT @sql = @sql + 'ALTER TABLE ' + QUOTENAME(SCHEMA_NAME(tp.schema_id)) + '.' + QUOTENAME(tp.name) + 
              ' DROP CONSTRAINT ' + QUOTENAME(fk.name) + ';' + CHAR(13)
FROM sys.foreign_keys fk
INNER JOIN sys.tables tp ON fk.parent_object_id = tp.object_id
INNER JOIN sys.tables tr ON fk.referenced_object_id = tr.object_id
WHERE tr.name IN ('packages', 'sub_packages');

IF @sql != ''
BEGIN
    PRINT 'Dropping foreign key constraints:';
    PRINT @sql;
    EXEC sp_executesql @sql;
    PRINT 'Foreign key constraints dropped successfully';
END
ELSE
BEGIN
    PRINT 'No foreign key constraints found';
END

-- Step 3: Drop tables
PRINT '--- Step 3: Drop tables ---';

-- Drop sub_packages table first
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'sub_packages')
BEGIN
    PRINT 'Dropping sub_packages table...';
    DROP TABLE sub_packages;
    PRINT 'sub_packages table dropped successfully';
END
ELSE
BEGIN
    PRINT 'sub_packages table does not exist';
END

-- Drop packages table
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'packages')
BEGIN
    PRINT 'Dropping packages table...';
    DROP TABLE packages;
    PRINT 'packages table dropped successfully';
END
ELSE
BEGIN
    PRINT 'packages table does not exist';
END

-- Step 4: Verification
PRINT '--- Step 4: Verification ---';

-- Check if tables still exist
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'packages')
BEGIN
    PRINT 'WARNING: packages table still exists';
END
ELSE
BEGIN
    PRINT 'packages table successfully deleted';
END

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'sub_packages')
BEGIN
    PRINT 'WARNING: sub_packages table still exists';
END
ELSE
BEGIN
    PRINT 'sub_packages table successfully deleted';
END

-- Show remaining tables
PRINT '--- Remaining tables ---';
SELECT 
    TABLE_NAME,
    TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;

PRINT '=== TABLE DELETION COMPLETE ===';
