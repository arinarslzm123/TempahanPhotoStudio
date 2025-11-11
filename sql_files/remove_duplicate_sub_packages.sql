-- =============================================
-- REMOVE DUPLICATE SUB-PACKAGES FROM DATABASE
-- =============================================

USE TempahanPhotoStudio;
GO

-- Step 1: Check for duplicate sub-packages
PRINT '========================================';
PRINT 'STEP 1: CHECKING FOR DUPLICATE SUB-PACKAGES';
PRINT '========================================';

SELECT 
    package_id,
    sub_package_name,
    price,
    duration,
    COUNT(*) as duplicate_count,
    STRING_AGG(CAST(id AS VARCHAR), ', ') as sub_package_ids,
    MIN(id) as keep_this_id
FROM sub_packages
GROUP BY package_id, sub_package_name, price, duration
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC, package_id;
GO

-- Step 2: Show details of duplicate entries
PRINT '';
PRINT '========================================';
PRINT 'STEP 2: DUPLICATE ENTRIES DETAILS';
PRINT '========================================';

SELECT 
    sp1.id,
    sp1.package_id,
    p.package_name,
    sp1.sub_package_name,
    sp1.price,
    sp1.duration,
    CASE 
        WHEN EXISTS (
            SELECT 1 FROM sub_packages sp2 
            WHERE sp2.package_id = sp1.package_id 
            AND sp2.sub_package_name = sp1.sub_package_name
            AND sp2.price = sp1.price
            AND sp2.id < sp1.id
        ) THEN 'DUPLICATE - Will Delete'
        ELSE 'KEEP - First Entry'
    END as action
FROM sub_packages sp1
LEFT JOIN packages p ON sp1.package_id = p.id
WHERE EXISTS (
    SELECT 1 FROM sub_packages sp2 
    WHERE sp2.package_id = sp1.package_id 
    AND sp2.sub_package_name = sp1.sub_package_name
    AND sp2.price = sp1.price
    AND (
        (sp2.id < sp1.id) OR 
        (sp2.id = sp1.id AND (SELECT COUNT(*) FROM sub_packages sp3 
                             WHERE sp3.package_id = sp1.package_id 
                             AND sp3.sub_package_name = sp1.sub_package_name 
                             AND sp3.price = sp1.price) > 1)
    )
)
ORDER BY sp1.package_id, sp1.sub_package_name, sp1.id;
GO

-- Step 3: DELETE DUPLICATES (Keep the one with lowest ID)
PRINT '';
PRINT '========================================';
PRINT 'STEP 3: REMOVING DUPLICATES';
PRINT '========================================';
PRINT 'This will keep the sub-package with the lowest ID for each duplicate group';
PRINT 'and delete all other duplicates.';
PRINT '';
PRINT 'Review the duplicates above, then uncomment the DELETE statement below to execute.';
GO

-- UNCOMMENT BELOW TO EXECUTE DELETION
/*
-- Check if there are any foreign key references before deleting
-- If bookings reference these sub-packages, we need to handle that first

-- Delete duplicate sub-packages (keep the one with lowest ID)
DELETE FROM sub_packages
WHERE id NOT IN (
    SELECT MIN(id)
    FROM sub_packages
    GROUP BY package_id, sub_package_name, price, duration
);

PRINT 'Duplicate sub-packages removed.';
PRINT 'First entry (lowest ID) kept for each duplicate group.';
*/

-- Step 4: Verify no more duplicates
PRINT '';
PRINT '========================================';
PRINT 'STEP 4: VERIFYING NO MORE DUPLICATES';
PRINT '========================================';

SELECT 
    package_id,
    sub_package_name,
    price,
    COUNT(*) as count
FROM sub_packages
GROUP BY package_id, sub_package_name, price
HAVING COUNT(*) > 1;
GO

IF @@ROWCOUNT = 0
    PRINT 'SUCCESS: No duplicates found!';
ELSE
    PRINT 'WARNING: Still have duplicates. Review data above.';
GO

-- Step 5: View all sub-packages (final state)
PRINT '';
PRINT '========================================';
PRINT 'STEP 5: ALL SUB-PACKAGES';
PRINT '========================================';

SELECT 
    sp.id,
    sp.package_id,
    p.package_name,
    sp.sub_package_name,
    sp.price,
    sp.duration,
    sp.description
FROM sub_packages sp
LEFT JOIN packages p ON sp.package_id = p.id
ORDER BY sp.package_id, sp.id;
GO

PRINT '';
PRINT 'Script completed. Review results above.';
PRINT 'To remove duplicates, uncomment Step 3 in the script.';

