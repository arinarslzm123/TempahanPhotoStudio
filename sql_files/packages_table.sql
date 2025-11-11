-- =============================================
-- PACKAGES TABLE QUERY
-- =============================================

USE TempahanPhotoStudio;
GO

-- Create Packages Table
CREATE TABLE packages (
    id INT IDENTITY(1,1) PRIMARY KEY,
    package_name NVARCHAR(100) NOT NULL,
    event NVARCHAR(50) NOT NULL,
    duration NVARCHAR(50) NOT NULL,
    category NVARCHAR(50) NOT NULL,
    description NVARCHAR(500),
    image_url NVARCHAR(255),
    is_active BIT DEFAULT 1,
    created_at DATETIME DEFAULT GETDATE()
);
GO

-- Insert Videography Packages
INSERT INTO packages (package_name, event, duration, category, description) VALUES 
('PV1 - Akad Nikah', 'Wedding', '6-7 Hours Per Day', 'Videography', 'Basic wedding videography package'),
('PV2 - Akad Nikah', 'Wedding', '6-7 Hours Per Day', 'Videography', 'Advanced wedding videography package'),
('PV3 - Akad Nikah', 'Wedding', '6-7 Hours Per Day', 'Videography', 'Premium wedding videography package'),
('PV4 - Akad Nikah', 'Wedding', '6-7 Hours Per Day', 'Videography', 'Ultimate wedding videography package'),
('PV5 - Akad Nikah', 'Wedding', '6-7 Hours Per Day', 'Videography', 'Luxury wedding videography package'),
('Akad Nikah & Sanding', 'Wedding', '8-10 hours', 'Videography', 'Complete wedding ceremony coverage'),
('Tunang', 'Engagement', '4-6 hours', 'Videography', 'Engagement ceremony videography'),
('Corporate Event', 'Corporate', '6-8 hours', 'Videography', 'Corporate event videography'),
('Birthday Party', 'Birthday', '4-6 hours', 'Videography', 'Birthday party videography');
GO

-- Insert Photography Packages
INSERT INTO packages (package_name, event, duration, category, description) VALUES 
('Wedding Photography - Full Day', 'Wedding', '8-10 hours', 'Photography', 'Complete wedding photography coverage'),
('Engagement Photography', 'Engagement', '4-6 hours', 'Photography', 'Engagement photo session'),
('Portrait Photography', 'Portrait', '2-3 hours', 'Photography', 'Professional portrait session'),
('Event Photography', 'Corporate Event', '6-8 hours', 'Photography', 'Corporate event coverage');
GO

-- Verify Packages Table
SELECT * FROM packages ORDER BY category, package_name;
GO
