-- Add profile_image column to users table
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'users'
ORDER BY ORDINAL_POSITION;

-- Add profile_image column if it doesn't exist
IF NOT EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'users' AND COLUMN_NAME = 'profile_image'
)
BEGIN
    ALTER TABLE users
    ADD profile_image VARCHAR(255) NULL;

    PRINT 'profile_image column added successfully to users table';
END
ELSE
BEGIN
    PRINT 'profile_image column already exists in users table';
END

-- Update existing users with default profile image path
UPDATE users
SET profile_image = 'default_profile.png'
WHERE profile_image IS NULL;

-- Show updated table structure
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'users'
ORDER BY ORDINAL_POSITION;

-- Show sample data
SELECT id, name, email, phone_number, profile_image, role FROM users ORDER BY id;
