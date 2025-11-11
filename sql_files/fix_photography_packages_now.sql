-- IMMEDIATE FIX for "No packages found for Photography"
-- Run this script to add Photography packages to your database

-- First, check if packages table exists and has data
SELECT 'CHECKING PACKAGES TABLE:' as Status;
SELECT COUNT(*) as total_packages FROM packages;

-- Check if Photography category exists
SELECT 'CHECKING PHOTOGRAPHY CATEGORY:' as Status;
SELECT COUNT(*) as photography_packages FROM packages WHERE category = 'Photography';

-- If no Photography packages, add them immediately
IF NOT EXISTS (SELECT 1 FROM packages WHERE category = 'Photography')
BEGIN
    PRINT 'Adding Photography packages...';
    
    INSERT INTO packages (package_name, category, duration, price, description) VALUES
    ('Basic Photography Package', 'Photography', '2 hours', 800.00, 'Basic photography session with 50 edited photos'),
    ('Standard Photography Package', 'Photography', '3 hours', 1200.00, 'Standard photography session with 100 edited photos'),
    ('Premium Photography Package', 'Photography', '4 hours', 1800.00, 'Premium photography session with 150 edited photos'),
    ('Wedding Photography Package', 'Photography', '8 hours', 3000.00, 'Full wedding photography coverage with 300+ edited photos'),
    ('Event Photography Package', 'Photography', '6 hours', 2200.00, 'Event photography coverage with 200+ edited photos'),
    ('Portrait Photography Package', 'Photography', '1 hour', 500.00, 'Professional portrait session with 20 edited photos'),
    ('Family Photography Package', 'Photography', '2 hours', 1000.00, 'Family photography session with 80 edited photos'),
    ('Corporate Photography Package', 'Photography', '4 hours', 1500.00, 'Corporate event photography with 120 edited photos');
    
    PRINT 'Photography packages added successfully!';
END
ELSE
BEGIN
    PRINT 'Photography packages already exist.';
END

-- Verify the packages were added
SELECT 'VERIFICATION - PHOTOGRAPHY PACKAGES:' as Status;
SELECT id, package_name, category, duration, price 
FROM packages 
WHERE category = 'Photography'
ORDER BY id;

-- Show total count
SELECT 'FINAL COUNT:' as Status;
SELECT COUNT(*) as photography_packages FROM packages WHERE category = 'Photography';
