-- Drop Columns with Default Constraints
-- This script will drop default constraints first, then drop columns

PRINT '=== DROPPING COLUMNS WITH DEFAULT CONSTRAINTS ===';

-- Step 1: Find and drop default constraints
PRINT '--- Step 1: Finding and dropping default constraints ---';

-- Drop default constraint for packages.price
DECLARE @constraint_name NVARCHAR(255);
SELECT @constraint_name = dc.name 
FROM sys.default_constraints dc
INNER JOIN sys.columns c ON dc.parent_object_id = c.object_id AND dc.parent_column_id = c.column_id
INNER JOIN sys.tables t ON c.object_id = t.object_id
WHERE t.name = 'packages' AND c.name = 'price';

IF @constraint_name IS NOT NULL
BEGIN
    DECLARE @sql1 NVARCHAR(MAX) = 'ALTER TABLE packages DROP CONSTRAINT ' + QUOTENAME(@constraint_name);
    PRINT 'Dropping default constraint: ' + @constraint_name;
    EXEC sp_executesql @sql1;
    PRINT 'Default constraint dropped successfully';
END
ELSE
BEGIN
    PRINT 'No default constraint found for packages.price';
END

-- Drop default constraint for sub_packages.price
SELECT @constraint_name = dc.name 
FROM sys.default_constraints dc
INNER JOIN sys.columns c ON dc.parent_object_id = c.object_id AND dc.parent_column_id = c.column_id
INNER JOIN sys.tables t ON c.object_id = t.object_id
WHERE t.name = 'sub_packages' AND c.name = 'price';

IF @constraint_name IS NOT NULL
BEGIN
    DECLARE @sql2 NVARCHAR(MAX) = 'ALTER TABLE sub_packages DROP CONSTRAINT ' + QUOTENAME(@constraint_name);
    PRINT 'Dropping default constraint: ' + @constraint_name;
    EXEC sp_executesql @sql2;
    PRINT 'Default constraint dropped successfully';
END
ELSE
BEGIN
    PRINT 'No default constraint found for sub_packages.price';
END

-- Step 2: Now drop the columns
PRINT '--- Step 2: Dropping columns ---';

-- Drop 'description' column from packages table
IF EXISTS (SELECT * FROM sys.columns WHERE Name = N'description' AND Object_ID = Object_ID(N'packages'))
BEGIN
    ALTER TABLE packages DROP COLUMN description;
    PRINT 'Column "description" dropped from "packages" table.';
END
ELSE
BEGIN
    PRINT 'Column "description" does not exist in "packages" table, skipping.';
END;

-- Drop 'image_url' column from packages table
IF EXISTS (SELECT * FROM sys.columns WHERE Name = N'image_url' AND Object_ID = Object_ID(N'packages'))
BEGIN
    ALTER TABLE packages DROP COLUMN image_url;
    PRINT 'Column "image_url" dropped from "packages" table.';
END
ELSE
BEGIN
    PRINT 'Column "image_url" does not exist in "packages" table, skipping.';
END;

-- Drop 'price' column from packages table
IF EXISTS (SELECT * FROM sys.columns WHERE Name = N'price' AND Object_ID = Object_ID(N'packages'))
BEGIN
    ALTER TABLE packages DROP COLUMN price;
    PRINT 'Column "price" dropped from "packages" table.';
END
ELSE
BEGIN
    PRINT 'Column "price" does not exist in "packages" table, skipping.';
END;

-- Drop 'price' column from sub_packages table
IF EXISTS (SELECT * FROM sys.columns WHERE Name = N'price' AND Object_ID = Object_ID(N'sub_packages'))
BEGIN
    ALTER TABLE sub_packages DROP COLUMN price;
    PRINT 'Column "price" dropped from "sub_packages" table.';
END
ELSE
BEGIN
    PRINT 'Column "price" does not exist in "sub_packages" table, skipping.';
END;

-- Step 3: Show current table structure
PRINT '--- Step 3: Current table structure ---';

PRINT 'PACKAGES TABLE STRUCTURE:';
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'packages'
ORDER BY ORDINAL_POSITION;

PRINT 'SUB_PACKAGES TABLE STRUCTURE:';
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'sub_packages'
ORDER BY ORDINAL_POSITION;

PRINT '=== COLUMN DROPPING WITH CONSTRAINTS COMPLETE ===';
