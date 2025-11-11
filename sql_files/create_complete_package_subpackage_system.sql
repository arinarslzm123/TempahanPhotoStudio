-- Complete Package and Sub-Package System
-- This script creates a clean, organized package and sub-package structure

PRINT '=== CREATING COMPLETE PACKAGE AND SUB-PACKAGE SYSTEM ===';

-- Step 1: Clean up existing data (optional - uncomment if needed)
-- PRINT '--- Step 1: Cleaning up existing data ---';
-- DELETE FROM sub_packages;
-- DELETE FROM packages;
-- PRINT 'Existing data cleaned up';

-- Step 2: Create Photography Packages
PRINT '--- Step 2: Creating Photography Packages ---';

-- Insert Photography Packages
INSERT INTO packages (package_name, event, category, duration, price, description) VALUES
-- General Photography Packages
('Basic Photography Package', 'General', 'Photography', '2 hours', 800.00, 'Basic photography session for various events'),
('Standard Photography Package', 'General', 'Photography', '3 hours', 1200.00, 'Standard photography session with professional editing'),
('Premium Photography Package', 'General', 'Photography', '4 hours', 1800.00, 'Premium photography session with advanced editing'),
('Deluxe Photography Package', 'General', 'Photography', '6 hours', 2500.00, 'Deluxe photography session with full service'),

-- Wedding Photography Packages
('Wedding Photography - Basic', 'Wedding', 'Photography', '4 hours', 1500.00, 'Basic wedding photography coverage'),
('Wedding Photography - Standard', 'Wedding', 'Photography', '6 hours', 2200.00, 'Standard wedding photography with ceremony coverage'),
('Wedding Photography - Premium', 'Wedding', 'Photography', '8 hours', 3000.00, 'Premium wedding photography with full day coverage'),
('Wedding Photography - Deluxe', 'Wedding', 'Photography', '10 hours', 4000.00, 'Deluxe wedding photography with complete service'),

-- Event Photography Packages
('Event Photography - Basic', 'Event', 'Photography', '3 hours', 1000.00, 'Basic event photography coverage'),
('Event Photography - Standard', 'Event', 'Photography', '4 hours', 1400.00, 'Standard event photography with editing'),
('Event Photography - Premium', 'Event', 'Photography', '6 hours', 2000.00, 'Premium event photography with full service'),

-- Portrait Photography Packages
('Portrait Photography - Basic', 'Portrait', 'Photography', '1 hour', 500.00, 'Basic portrait photography session'),
('Portrait Photography - Standard', 'Portrait', 'Photography', '1.5 hours', 700.00, 'Standard portrait photography with editing'),
('Portrait Photography - Premium', 'Portrait', 'Photography', '2 hours', 1000.00, 'Premium portrait photography with professional editing'),

-- Family Photography Packages
('Family Photography - Basic', 'Family', 'Photography', '2 hours', 800.00, 'Basic family photography session'),
('Family Photography - Standard', 'Family', 'Photography', '3 hours', 1200.00, 'Standard family photography with editing'),
('Family Photography - Premium', 'Family', 'Photography', '4 hours', 1600.00, 'Premium family photography with full service'),

-- Corporate Photography Packages
('Corporate Photography - Basic', 'Corporate', 'Photography', '2 hours', 1000.00, 'Basic corporate event photography'),
('Corporate Photography - Standard', 'Corporate', 'Photography', '4 hours', 1500.00, 'Standard corporate photography with editing'),
('Corporate Photography - Premium', 'Corporate', 'Photography', '6 hours', 2200.00, 'Premium corporate photography with full service');

PRINT 'Photography packages created successfully';

-- Step 3: Create Sub-Packages for each Photography Package
PRINT '--- Step 3: Creating Sub-Packages ---';

-- Get package IDs for reference
DECLARE @basic_general_id INT, @standard_general_id INT, @premium_general_id INT, @deluxe_general_id INT;
DECLARE @basic_wedding_id INT, @standard_wedding_id INT, @premium_wedding_id INT, @deluxe_wedding_id INT;
DECLARE @basic_event_id INT, @standard_event_id INT, @premium_event_id INT;
DECLARE @basic_portrait_id INT, @standard_portrait_id INT, @premium_portrait_id INT;
DECLARE @basic_family_id INT, @standard_family_id INT, @premium_family_id INT;
DECLARE @basic_corporate_id INT, @standard_corporate_id INT, @premium_corporate_id INT;

-- Get package IDs
SELECT @basic_general_id = id FROM packages WHERE package_name = 'Basic Photography Package';
SELECT @standard_general_id = id FROM packages WHERE package_name = 'Standard Photography Package';
SELECT @premium_general_id = id FROM packages WHERE package_name = 'Premium Photography Package';
SELECT @deluxe_general_id = id FROM packages WHERE package_name = 'Deluxe Photography Package';

SELECT @basic_wedding_id = id FROM packages WHERE package_name = 'Wedding Photography - Basic';
SELECT @standard_wedding_id = id FROM packages WHERE package_name = 'Wedding Photography - Standard';
SELECT @premium_wedding_id = id FROM packages WHERE package_name = 'Wedding Photography - Premium';
SELECT @deluxe_wedding_id = id FROM packages WHERE package_name = 'Wedding Photography - Deluxe';

SELECT @basic_event_id = id FROM packages WHERE package_name = 'Event Photography - Basic';
SELECT @standard_event_id = id FROM packages WHERE package_name = 'Event Photography - Standard';
SELECT @premium_event_id = id FROM packages WHERE package_name = 'Event Photography - Premium';

SELECT @basic_portrait_id = id FROM packages WHERE package_name = 'Portrait Photography - Basic';
SELECT @standard_portrait_id = id FROM packages WHERE package_name = 'Portrait Photography - Standard';
SELECT @premium_portrait_id = id FROM packages WHERE package_name = 'Portrait Photography - Premium';

SELECT @basic_family_id = id FROM packages WHERE package_name = 'Family Photography - Basic';
SELECT @standard_family_id = id FROM packages WHERE package_name = 'Family Photography - Standard';
SELECT @premium_family_id = id FROM packages WHERE package_name = 'Family Photography - Premium';

SELECT @basic_corporate_id = id FROM packages WHERE package_name = 'Corporate Photography - Basic';
SELECT @standard_corporate_id = id FROM packages WHERE package_name = 'Corporate Photography - Standard';
SELECT @premium_corporate_id = id FROM packages WHERE package_name = 'Corporate Photography - Premium';

-- Add Sub-Packages for General Photography
INSERT INTO sub_packages (package_id, sub_package_name, price, duration, description, media) VALUES
-- Basic Photography Package sub-packages
(@basic_general_id, 'Basic - Standard', 600.00, '2 hours', 'Standard basic photography with 50 edited photos', '50 photos'),
(@basic_general_id, 'Basic - Premium', 800.00, '2 hours', 'Premium basic photography with 80 edited photos', '80 photos'),

-- Standard Photography Package sub-packages
(@standard_general_id, 'Standard - Regular', 1000.00, '3 hours', 'Regular standard photography with 100 edited photos', '100 photos'),
(@standard_general_id, 'Standard - Premium', 1200.00, '3 hours', 'Premium standard photography with 150 edited photos', '150 photos'),

-- Premium Photography Package sub-packages
(@premium_general_id, 'Premium - Standard', 1400.00, '4 hours', 'Standard premium photography with 200 edited photos', '200 photos'),
(@premium_general_id, 'Premium - Deluxe', 1800.00, '4 hours', 'Deluxe premium photography with 300 edited photos', '300 photos'),

-- Deluxe Photography Package sub-packages
(@deluxe_general_id, 'Deluxe - Standard', 2000.00, '6 hours', 'Standard deluxe photography with 400 edited photos', '400 photos'),
(@deluxe_general_id, 'Deluxe - Premium', 2500.00, '6 hours', 'Premium deluxe photography with 500 edited photos', '500 photos');

-- Add Sub-Packages for Wedding Photography
INSERT INTO sub_packages (package_id, sub_package_name, price, duration, description, media) VALUES
-- Wedding Photography - Basic sub-packages
(@basic_wedding_id, 'Wedding Basic - Ceremony Only', 1200.00, '4 hours', 'Wedding ceremony photography only', '100 photos'),
(@basic_wedding_id, 'Wedding Basic - Reception Only', 1200.00, '4 hours', 'Wedding reception photography only', '100 photos'),

-- Wedding Photography - Standard sub-packages
(@standard_wedding_id, 'Wedding Standard - Ceremony + Reception', 1800.00, '6 hours', 'Wedding ceremony and reception photography', '200 photos'),
(@standard_wedding_id, 'Wedding Standard - Full Day', 2200.00, '6 hours', 'Full day wedding photography coverage', '250 photos'),

-- Wedding Photography - Premium sub-packages
(@premium_wedding_id, 'Wedding Premium - Full Coverage', 2500.00, '8 hours', 'Full wedding day coverage with editing', '350 photos'),
(@premium_wedding_id, 'Wedding Premium - Complete Service', 3000.00, '8 hours', 'Complete wedding photography service', '400 photos'),

-- Wedding Photography - Deluxe sub-packages
(@deluxe_wedding_id, 'Wedding Deluxe - Ultimate Package', 3500.00, '10 hours', 'Ultimate wedding photography package', '500 photos'),
(@deluxe_wedding_id, 'Wedding Deluxe - VIP Service', 4000.00, '10 hours', 'VIP wedding photography service', '600 photos');

-- Add Sub-Packages for Event Photography
INSERT INTO sub_packages (package_id, sub_package_name, price, duration, description, media) VALUES
-- Event Photography sub-packages
(@basic_event_id, 'Event Basic - Standard', 800.00, '3 hours', 'Standard event photography coverage', '80 photos'),
(@basic_event_id, 'Event Basic - Premium', 1000.00, '3 hours', 'Premium event photography coverage', '100 photos'),

(@standard_event_id, 'Event Standard - Regular', 1200.00, '4 hours', 'Regular event photography with editing', '150 photos'),
(@standard_event_id, 'Event Standard - Premium', 1400.00, '4 hours', 'Premium event photography with editing', '180 photos'),

(@premium_event_id, 'Event Premium - Standard', 1600.00, '6 hours', 'Standard premium event photography', '250 photos'),
(@premium_event_id, 'Event Premium - Deluxe', 2000.00, '6 hours', 'Deluxe premium event photography', '300 photos');

-- Add Sub-Packages for Portrait Photography
INSERT INTO sub_packages (package_id, sub_package_name, price, duration, description, media) VALUES
-- Portrait Photography sub-packages
(@basic_portrait_id, 'Portrait Basic - Standard', 400.00, '1 hour', 'Standard portrait photography session', '20 photos'),
(@basic_portrait_id, 'Portrait Basic - Premium', 500.00, '1 hour', 'Premium portrait photography session', '30 photos'),

(@standard_portrait_id, 'Portrait Standard - Regular', 600.00, '1.5 hours', 'Regular portrait photography with editing', '40 photos'),
(@standard_portrait_id, 'Portrait Standard - Premium', 700.00, '1.5 hours', 'Premium portrait photography with editing', '50 photos'),

(@premium_portrait_id, 'Portrait Premium - Standard', 800.00, '2 hours', 'Standard premium portrait photography', '60 photos'),
(@premium_portrait_id, 'Portrait Premium - Deluxe', 1000.00, '2 hours', 'Deluxe premium portrait photography', '80 photos');

-- Add Sub-Packages for Family Photography
INSERT INTO sub_packages (package_id, sub_package_name, price, duration, description, media) VALUES
-- Family Photography sub-packages
(@basic_family_id, 'Family Basic - Standard', 600.00, '2 hours', 'Standard family photography session', '60 photos'),
(@basic_family_id, 'Family Basic - Premium', 800.00, '2 hours', 'Premium family photography session', '80 photos'),

(@standard_family_id, 'Family Standard - Regular', 1000.00, '3 hours', 'Regular family photography with editing', '120 photos'),
(@standard_family_id, 'Family Standard - Premium', 1200.00, '3 hours', 'Premium family photography with editing', '150 photos'),

(@premium_family_id, 'Family Premium - Standard', 1400.00, '4 hours', 'Standard premium family photography', '200 photos'),
(@premium_family_id, 'Family Premium - Deluxe', 1600.00, '4 hours', 'Deluxe premium family photography', '250 photos');

-- Add Sub-Packages for Corporate Photography
INSERT INTO sub_packages (package_id, sub_package_name, price, duration, description, media) VALUES
-- Corporate Photography sub-packages
(@basic_corporate_id, 'Corporate Basic - Standard', 800.00, '2 hours', 'Standard corporate event photography', '100 photos'),
(@basic_corporate_id, 'Corporate Basic - Premium', 1000.00, '2 hours', 'Premium corporate event photography', '120 photos'),

(@standard_corporate_id, 'Corporate Standard - Regular', 1200.00, '4 hours', 'Regular corporate photography with editing', '200 photos'),
(@standard_corporate_id, 'Corporate Standard - Premium', 1500.00, '4 hours', 'Premium corporate photography with editing', '250 photos'),

(@premium_corporate_id, 'Corporate Premium - Standard', 1800.00, '6 hours', 'Standard premium corporate photography', '350 photos'),
(@premium_corporate_id, 'Corporate Premium - Deluxe', 2200.00, '6 hours', 'Deluxe premium corporate photography', '400 photos');

PRINT 'Sub-packages created successfully';

-- Step 4: Verification
PRINT '--- Step 4: Verification ---';

-- Show all packages with their sub-packages
SELECT 
    p.id as package_id,
    p.package_name,
    p.event,
    p.category,
    p.price as package_price,
    COUNT(sp.id) as sub_package_count
FROM packages p
LEFT JOIN sub_packages sp ON p.id = sp.package_id
WHERE p.category = 'Photography'
GROUP BY p.id, p.package_name, p.event, p.category, p.price
ORDER BY p.event, p.id;

-- Show sample sub-packages
SELECT 
    sp.id as sub_package_id,
    sp.package_id,
    sp.sub_package_name,
    sp.price as sub_package_price,
    p.package_name as parent_package_name,
    p.event as parent_package_event
FROM sub_packages sp
LEFT JOIN packages p ON sp.package_id = p.id
WHERE p.category = 'Photography'
ORDER BY p.event, p.id, sp.id;

-- Summary
SELECT 'SUMMARY:' as Info;
SELECT 
    (SELECT COUNT(*) FROM packages WHERE category = 'Photography') as photography_packages,
    (SELECT COUNT(*) FROM sub_packages sp JOIN packages p ON sp.package_id = p.id WHERE p.category = 'Photography') as photography_sub_packages,
    (SELECT COUNT(DISTINCT p.event) FROM packages p WHERE p.category = 'Photography') as photography_event_types;

PRINT '=== COMPLETE PACKAGE AND SUB-PACKAGE SYSTEM CREATED ===';
