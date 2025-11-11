-- Quick script to add Photography packages
-- Run this to fix "No packages found for Photography" issue

-- Add Photography packages if they don't exist
INSERT INTO packages (package_name, category, duration, price, description) 
SELECT * FROM (
    SELECT 'Basic Photography Package' as package_name, 'Photography' as category, '2 hours' as duration, 800.00 as price, 'Basic photography session with 50 edited photos' as description
    UNION ALL
    SELECT 'Standard Photography Package', 'Photography', '3 hours', 1200.00, 'Standard photography session with 100 edited photos'
    UNION ALL
    SELECT 'Premium Photography Package', 'Photography', '4 hours', 1800.00, 'Premium photography session with 150 edited photos'
    UNION ALL
    SELECT 'Wedding Photography Package', 'Photography', '8 hours', 3000.00, 'Full wedding photography coverage with 300+ edited photos'
    UNION ALL
    SELECT 'Event Photography Package', 'Photography', '6 hours', 2200.00, 'Event photography coverage with 200+ edited photos'
    UNION ALL
    SELECT 'Portrait Photography Package', 'Photography', '1 hour', 500.00, 'Professional portrait session with 20 edited photos'
    UNION ALL
    SELECT 'Family Photography Package', 'Photography', '2 hours', 1000.00, 'Family photography session with 80 edited photos'
    UNION ALL
    SELECT 'Corporate Photography Package', 'Photography', '4 hours', 1500.00, 'Corporate event photography with 120 edited photos'
) AS new_packages
WHERE NOT EXISTS (
    SELECT 1 FROM packages 
    WHERE package_name = new_packages.package_name 
    AND category = 'Photography'
);

-- Show the Photography packages
SELECT id, package_name, category, duration, price 
FROM packages 
WHERE category = 'Photography'
ORDER BY id;
