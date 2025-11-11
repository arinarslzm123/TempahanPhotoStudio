-- =============================================
-- CHECK FOR DUPLICATE SUB-PACKAGES
-- =============================================

USE TempahanPhotoStudio;
GO

-- Check for duplicate sub-packages (same package_id, same name, same price)
SELECT 
    package_id,
    sub_package_name,
    price,
    COUNT(*) as duplicate_count,
    STRING_AGG(CAST(id AS VARCHAR), ', ') as sub_package_ids
FROM sub_packages
GROUP BY package_id, sub_package_name, price
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC, package_id;
GO

-- View all sub-packages to check for duplicates
SELECT 
    id,
    package_id,
    sub_package_name,
    price,
    duration,
    description
FROM sub_packages
ORDER BY package_id, id;
GO

-- Remove duplicates (keep the one with lowest ID)
-- UNCOMMENT BELOW TO EXECUTE DELETION
/*
DELETE FROM sub_packages
WHERE id NOT IN (
    SELECT MIN(id)
    FROM sub_packages
    GROUP BY package_id, sub_package_name, price
);
GO

PRINT 'Duplicate sub-packages removed.';
*/

PRINT 'Script completed. Review results above.';
PRINT 'To remove duplicates, uncomment the deletion section in the script.';

