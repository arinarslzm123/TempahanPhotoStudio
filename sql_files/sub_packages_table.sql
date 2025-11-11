-- =============================================
-- SUB_PACKAGES TABLE QUERY
-- =============================================

USE TempahanPhotoStudio;
GO

-- Create Sub_Packages Table
CREATE TABLE sub_packages (
    id INT IDENTITY(1,1) PRIMARY KEY,
    package_id INT NOT NULL,
    package_class NVARCHAR(20) NOT NULL,
    details NVARCHAR(500) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    description NVARCHAR(500),
    is_active BIT DEFAULT 1,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (package_id) REFERENCES packages(id) ON DELETE CASCADE
);
GO

-- Get Package IDs
DECLARE @pv1_id INT = (SELECT id FROM packages WHERE package_name = 'PV1 - Akad Nikah');
DECLARE @pv2_id INT = (SELECT id FROM packages WHERE package_name = 'PV2 - Akad Nikah');
DECLARE @pv3_id INT = (SELECT id FROM packages WHERE package_name = 'PV3 - Akad Nikah');
DECLARE @pv4_id INT = (SELECT id FROM packages WHERE package_name = 'PV4 - Akad Nikah');
DECLARE @pv5_id INT = (SELECT id FROM packages WHERE package_name = 'PV5 - Akad Nikah');
DECLARE @akad_sanding_id INT = (SELECT id FROM packages WHERE package_name = 'Akad Nikah & Sanding');
DECLARE @tunang_id INT = (SELECT id FROM packages WHERE package_name = 'Tunang');
DECLARE @wedding_photo_id INT = (SELECT id FROM packages WHERE package_name = 'Wedding Photography - Full Day');

-- Insert Sub-packages for PV1-PV5
INSERT INTO sub_packages (package_id, package_class, details, price, description) VALUES 
(@pv1_id, 'Regular', '1 Event 1 Video | Akad Nikah / Sanding (1 Day 1 Event) | 6-7 Hours Per Day | 1 x Full Showreel | 4-6 Minute Highlight Video | 1 x Exclusive Pendrive 16 GB & Case', 1200.00, 'Basic videography package'),

(@pv2_id, 'Advance', '1 Event 1 Video | Akad Nikah / Sanding (1 Day 1 Event) | 6-7 Hours Per Day | 1 x Full Showreel | 4-6 Minute Highlight Video | 1 x Exclusive Pendrive 16 GB & Case | Drone 1/Per Day RM500', 1800.00, 'Advanced videography package'),

(@pv3_id, 'Premium', '1 Event 1 Video | Akad Nikah / Sanding (1 Day 1 Event) | 6-7 Hours Per Day | 1 x Full Showreel | 4-6 Minute Highlight Video | 1 x Exclusive Pendrive 16 GB & Case | Drone 1/Per Day RM500 | +1 Videographer Per Day RM500', 2500.00, 'Premium videography package'),

(@pv4_id, 'Ultimate', '1 Event 1 Video | Akad Nikah / Sanding (1 Day 1 Event) | 6-7 Hours Per Day | 1 x Full Showreel | 4-6 Minute Highlight Video | 1 x Exclusive Pendrive 16 GB & Case | Drone 1/Per Day RM500 | +1 Videographer Per Day RM500 | Raw Footage + 64GB RM150', 3200.00, 'Ultimate videography package'),

(@pv5_id, 'Luxury', '1 Event 1 Video | Akad Nikah / Sanding (1 Day 1 Event) | 6-7 Hours Per Day | 1 x Full Showreel | 4-6 Minute Highlight Video | 1 x Exclusive Pendrive 16 GB & Case | Drone 1/Per Day RM500 | +1 Videographer Per Day RM500 | Raw Footage + 64GB RM150 | Makeup Per Hour RM100 | Termasuk Kos Pengangkutan | Penginapan', 4000.00, 'Luxury videography package');

-- Insert Sub-packages for Akad Nikah & Sanding
INSERT INTO sub_packages (package_id, package_class, details, price, description) VALUES 
(@akad_sanding_id, 'Basic', 'Akad Nikah & Sanding (1 Day 1 Event) | 8-10 Hours Per Day | 1 x Full Showreel | 6-8 Minute Highlight Video | 1 x Exclusive Pendrive 32 GB & Case', 2000.00, 'Basic wedding ceremony package'),

(@akad_sanding_id, 'Premium', 'Akad Nikah & Sanding (1 Day 1 Event) | 8-10 Hours Per Day | 1 x Full Showreel | 6-8 Minute Highlight Video | 1 x Exclusive Pendrive 32 GB & Case | Drone Coverage | +1 Videographer', 3000.00, 'Premium wedding ceremony package');

-- Insert Sub-packages for Tunang
INSERT INTO sub_packages (package_id, package_class, details, price, description) VALUES 
(@tunang_id, 'Standard', 'Tunang Ceremony (1 Day 1 Event) | 4-6 Hours Per Day | 1 x Full Showreel | 3-5 Minute Highlight Video | 1 x Exclusive Pendrive 16 GB & Case', 800.00, 'Standard engagement package'),

(@tunang_id, 'Deluxe', 'Tunang Ceremony (1 Day 1 Event) | 4-6 Hours Per Day | 1 x Full Showreel | 3-5 Minute Highlight Video | 1 x Exclusive Pendrive 16 GB & Case | Drone Coverage', 1200.00, 'Deluxe engagement package');

-- Insert Sub-packages for Wedding Photography
INSERT INTO sub_packages (package_id, package_class, details, price, description) VALUES 
(@wedding_photo_id, 'Regular', '100 edited photos, basic editing', 500.00, 'Basic wedding package'),

(@wedding_photo_id, 'Advance', '200 edited photos, advanced editing, album', 800.00, 'Advanced wedding package'),

(@wedding_photo_id, 'Premium', '300 edited photos, premium editing, album, video', 1200.00, 'Premium wedding package');
GO

-- Verify Sub-packages Table
SELECT 
    p.package_name,
    sp.package_class,
    sp.price,
    sp.details
FROM sub_packages sp
JOIN packages p ON sp.package_id = p.id
ORDER BY p.package_name, sp.package_class;
GO
