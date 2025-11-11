-- Simple Delete Tables Query
-- This will delete packages and sub_packages tables

-- Delete sub_packages table first (due to foreign key constraint)
DROP TABLE IF EXISTS sub_packages;

-- Delete packages table
DROP TABLE IF EXISTS packages;

-- Verification - check if tables exist
SELECT 
    TABLE_NAME,
    TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME IN ('packages', 'sub_packages')
ORDER BY TABLE_NAME;
