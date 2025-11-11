-- Test database connection and fix Photography packages issue
-- Run this step by step

-- Step 1: Check if packages table exists
SELECT 'STEP 1: Checking packages table...' as Status;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'packages')
BEGIN
    SELECT '✅ packages table exists' as Result;
    
    -- Check table structure
    SELECT COLUMN_NAME, DATA_TYPE 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'packages'
    ORDER BY ORDINAL_POSITION;
END
ELSE
BEGIN
    SELECT '❌ packages table does NOT exist' as Result;
END

-- Step 2: Check current data
SELECT 'STEP 2: Checking current data...' as Status;
SELECT COUNT(*) as total_packages FROM packages;
SELECT DISTINCT category FROM packages;

-- Step 3: Add Photography packages if missing
SELECT 'STEP 3: Adding Photography packages...' as Status;

-- Delete existing Photography packages first (to avoid duplicates)
DELETE FROM packages WHERE category = 'Photography';

-- Add new Photography packages
INSERT INTO packages (package_name, category, duration, price, description) VALUES
('Basic Photography Package', 'Photography', '2 hours', 800.00, 'Basic photography session with 50 edited photos'),
('Standard Photography Package', 'Photography', '3 hours', 1200.00, 'Standard photography session with 100 edited photos'),
('Premium Photography Package', 'Photography', '4 hours', 1800.00, 'Premium photography session with 150 edited photos'),
('Wedding Photography Package', 'Photography', '8 hours', 3000.00, 'Full wedding photography coverage with 300+ edited photos'),
('Event Photography Package', 'Photography', '6 hours', 2200.00, 'Event photography coverage with 200+ edited photos'),
('Portrait Photography Package', 'Photography', '1 hour', 500.00, 'Professional portrait session with 20 edited photos'),
('Family Photography Package', 'Photography', '2 hours', 1000.00, 'Family photography session with 80 edited photos'),
('Corporate Photography Package', 'Photography', '4 hours', 1500.00, 'Corporate event photography with 120 edited photos');

-- Step 4: Verify the fix
SELECT 'STEP 4: Verification...' as Status;
SELECT COUNT(*) as photography_packages FROM packages WHERE category = 'Photography';
SELECT id, package_name, category, price FROM packages WHERE category = 'Photography' ORDER BY id;

SELECT '✅ Photography packages added successfully!' as Final_Result;
