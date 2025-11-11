package com.kelasandroidappsirhafizee.tempahanphotostudio;

import android.os.StrictMode;
import android.util.Log;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class ConnectionClass {

    // Ganti ikut server/database anda
    String ip = "10.0.2.2";
    String db = "TempahanPhotoStudio";
    String username = "sa";
    String password = "12345";
    String port = "1433";

    // Buat connection ke SQL Server
    public Connection CONN() {
        Connection conn = null;
        StrictMode.ThreadPolicy policy = new StrictMode.ThreadPolicy.Builder().permitAll().build();
        StrictMode.setThreadPolicy(policy);

        try {
            System.out.println("Loading JDBC driver...");
            Class.forName("net.sourceforge.jtds.jdbc.Driver");
            
            String connUrl = "jdbc:jtds:sqlserver://" + ip + ":" + port +
                    ";databaseName=" + db + ";user=" + username + ";password=" + password + ";";
            System.out.println("Connection URL: " + connUrl);
            System.out.println("Attempting to connect to database...");
            
            conn = DriverManager.getConnection(connUrl);
            System.out.println("Database connection established successfully!");
        } catch (Exception e) {
            System.out.println("Database connection failed: " + e.getMessage());
            Log.e("SQL Connection", e.getMessage());
            e.printStackTrace();
        }
        return conn;
    }

    // ===================== PACKAGE =====================

    // Add Package (alias for insertPackage)
    public boolean addPackage(PackageModel packageModel) {
        return insertPackage(packageModel);
    }

    // Insert Package
    public boolean insertPackage(PackageModel packageModel) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean isSuccess = false;
        try {
            conn = CONN();
            if (conn == null) return false;

            String query = "INSERT INTO packages (package_name, event, duration, category) " +
                    "VALUES (?, ?, ?, ?)";
            stmt = conn.prepareStatement(query);
            stmt.setString(1, packageModel.getPackageName());
            stmt.setString(2, packageModel.getEvent());
            stmt.setString(3, packageModel.getDuration());
            stmt.setString(4, packageModel.getCategory());
            
            System.out.println("DEBUG - Inserting package: " + packageModel.getPackageName() + 
                             ", Event: " + packageModel.getEvent() + 
                             ", Category: " + packageModel.getCategory());

            int rowsAffected = stmt.executeUpdate();
            isSuccess = rowsAffected > 0;
            
            if (isSuccess) {
                System.out.println("DEBUG - Package inserted successfully, rows affected: " + rowsAffected);
            } else {
                System.out.println("DEBUG - Package insertion failed, no rows affected");
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("DEBUG - Error inserting package: " + e.getMessage());
        } finally {
            closeResources(null, stmt, conn);
        }
        return isSuccess;
    }

    // Update Package
    public boolean updatePackage(PackageModel packageModel) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean isSuccess = false;
        try {
            conn = CONN();
            if (conn == null) return false;

            String query = "UPDATE packages SET package_name=?, event=?, duration=?, category=? " +
                    "WHERE id=?";
            stmt = conn.prepareStatement(query);
            stmt.setString(1, packageModel.getPackageName());
            stmt.setString(2, packageModel.getEvent());
            stmt.setString(3, packageModel.getDuration());
            stmt.setString(4, packageModel.getCategory());
            stmt.setInt(5, packageModel.getId());

            isSuccess = stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(null, stmt, conn);
        }
        return isSuccess;
    }

    // Delete Package
    public boolean deletePackage(int packageId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean isSuccess = false;
        try {
            conn = CONN();
            if (conn == null) return false;

            String query = "DELETE FROM packages WHERE id=?";
            stmt = conn.prepareStatement(query);
            stmt.setInt(1, packageId);

            isSuccess = stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(null, stmt, conn);
        }
        return isSuccess;
    }

    // Get Package by ID
    public PackageModel getPackageById(int packageId) {
        PackageModel pkg = null;
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = CONN();
            if (conn == null) return null;

            String query = "SELECT * FROM packages WHERE id = ?";
            stmt = conn.prepareStatement(query);
            stmt.setInt(1, packageId);
            rs = stmt.executeQuery();

            System.out.println("DEBUG - getPackageById: Looking for package ID: " + packageId);

            if (rs.next()) {
                String packageName = rs.getString("package_name");
                String event = rs.getString("event");
                String category = rs.getString("category");
                
                System.out.println("DEBUG - getPackageById: Found package - Name: " + packageName + ", Event: " + event + ", Category: " + category);
                
                pkg = new PackageModel(
                        rs.getInt("id"),
                        "PKG-" + rs.getInt("id"), // Generate packageId
                        packageName,
                        event,
                        rs.getString("duration"),
                        category,
                        null, // description
                        null, // imageUrl
                        0.0   // price
                );
            } else {
                System.out.println("DEBUG - getPackageById: No package found with ID: " + packageId);
            }
        } catch (Exception e) {
            System.out.println("DEBUG - getPackageById: Error - " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }

        return pkg;
    }

    // Add SubPackage with media
    public boolean addSubPackage(int packageId, String name, double price, String desc, String duration, String media) {
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = CONN();
            if (conn == null) return false;

            String query = "INSERT INTO sub_packages (package_id, sub_package_name, price, description, duration, media) VALUES (?,?,?,?,?,?)";
            stmt = conn.prepareStatement(query);
            stmt.setInt(1, packageId);
            stmt.setString(2, name);
            stmt.setDouble(3, price);
            stmt.setString(4, desc);
            stmt.setString(5, duration);
            stmt.setString(6, media);

            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            try { if (stmt != null) stmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }

    // Update SubPackage with media
    public boolean updateSubPackage(int id, int packageId, String name, double price, String desc, String duration, String media) {
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = CONN();
            if (conn == null) return false;

            String query = "UPDATE sub_packages SET package_id=?, sub_package_name=?, price=?, description=?, duration=?, media=? WHERE id=?";
            stmt = conn.prepareStatement(query);
            stmt.setInt(1, packageId);
            stmt.setString(2, name);
            stmt.setDouble(3, price);
            stmt.setString(4, desc);
            stmt.setString(5, duration);
            stmt.setString(6, media);
            stmt.setInt(7, id);

            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            try { if (stmt != null) stmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }

    // Get SubPackage by ID (include media)
    public SubPackageModel getSubPackageById(int id) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = CONN();
            if (conn == null) return null;

            String query = "SELECT * FROM sub_packages WHERE id=?";
            stmt = conn.prepareStatement(query);
            stmt.setInt(1, id);
            rs = stmt.executeQuery();

            if (rs.next()) {
                // Get price from database with error handling
                double price = 0.0;
                try {
                    price = rs.getDouble("price");
                    System.out.println("DEBUG - Price found in getSubPackageById: " + price);
                } catch (Exception e) {
                    System.out.println("DEBUG - Price column not found in getSubPackageById, using default 0.0");
                    System.out.println("DEBUG - Error: " + e.getMessage());
                    price = 0.0;
                }
                
                return new SubPackageModel(
                        rs.getInt("id"),
                        rs.getInt("package_id"),
                        rs.getString("sub_package_name"),
                        price,
                        rs.getString("description"),
                        rs.getString("duration"),
                        rs.getString("media")   // ✅ include media
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (stmt != null) stmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
        return null;
    }


    public boolean deleteSubPackage(int subPackageId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = CONN();
            if (conn == null) return false;

            String query = "DELETE FROM sub_packages WHERE id = ?";
            stmt = conn.prepareStatement(query);
            stmt.setInt(1, subPackageId);

            int rows = stmt.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            try { if (stmt != null) stmt.close(); } catch (Exception ignored) {}
            try { if (conn != null) conn.close(); } catch (Exception ignored) {}
        }
    }



    // Get All Packages
    public ArrayList<PackageModel> getAllPackages() {
        ArrayList<PackageModel> packages = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = CONN();
            if (conn == null) return packages;

            String query = "SELECT * FROM packages ORDER BY category, package_name";
            stmt = conn.prepareStatement(query);
            rs = stmt.executeQuery();

            while (rs.next()) {
                PackageModel packageModel = new PackageModel(
                        rs.getInt("id"),
                        "PKG-" + rs.getInt("id"), // Generate packageId
                        rs.getString("package_name"),
                        rs.getString("event"),
                        rs.getString("duration"),
                        rs.getString("category"),
                        null, // description
                        null, // imageUrl
                        0.0   // price
                );
                packages.add(packageModel);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }

        return packages;
    }

    // Get Packages by Category
    public ArrayList<PackageModel> getPackagesByCategory(String category) {
        ArrayList<PackageModel> packages = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = CONN();
            if (conn == null) return packages;

            String query = "SELECT * FROM packages WHERE category = ? ORDER BY package_name";
            stmt = conn.prepareStatement(query);
            stmt.setString(1, category);
            rs = stmt.executeQuery();

            while (rs.next()) {
                PackageModel packageModel = new PackageModel(
                        rs.getInt("id"),
                        "PKG-" + rs.getInt("id"), // Generate packageId
                        rs.getString("package_name"),
                        rs.getString("event"),
                        rs.getString("duration"),
                        rs.getString("category"),
                        null, // description
                        null, // imageUrl
                        0.0   // price
                );
                packages.add(packageModel);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }

        return packages;
    }

    // Get SubPackages by PackageId
    public ArrayList<SubPackageModel> getSubPackagesByPackageId(int packageId) {
        ArrayList<SubPackageModel> subPackages = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        System.out.println("DEBUG - ========== getSubPackagesByPackageId START ==========");
        System.out.println("DEBUG - Looking for sub-packages with package_id: " + packageId);

        try {
            conn = CONN();
            if (conn == null) {
                System.out.println("DEBUG - Database connection is NULL");
                return subPackages;
            }
            System.out.println("DEBUG - Database connection successful");

            // Use DISTINCT to prevent duplicates and order by ID
            String query = "SELECT DISTINCT id, package_id, sub_package_name, price, description, duration, media " +
                          "FROM sub_packages WHERE package_id = ? ORDER BY id";
            System.out.println("DEBUG - Executing query: " + query);
            stmt = conn.prepareStatement(query);
            stmt.setInt(1, packageId);
            rs = stmt.executeQuery();

            int count = 0;
            // Track IDs to prevent duplicates even if DISTINCT fails
            java.util.Set<Integer> seenIds = new java.util.HashSet<>();
            while (rs.next()) {
                int id = rs.getInt("id");
                
                // Skip if we've already seen this ID (prevent duplicates)
                if (seenIds.contains(id)) {
                    System.out.println("DEBUG - Skipping duplicate sub-package ID: " + id);
                    continue;
                }
                seenIds.add(id);
                count++;
                int pkgId = rs.getInt("package_id");
                String name = rs.getString("sub_package_name");
                
                System.out.println("DEBUG - Found sub-package #" + count + ":");
                System.out.println("DEBUG -   ID: " + id);
                System.out.println("DEBUG -   Package ID: " + pkgId);
                System.out.println("DEBUG -   Name: " + name);
                
                String desc = rs.getString("description");
                String duration = rs.getString("duration");
                String media = rs.getString("media");
                
                // Get price from database
                double price = 0.0;
                try {
                    price = rs.getDouble("price");
                    System.out.println("DEBUG -   Price: " + price);
                } catch (Exception e) {
                    System.out.println("DEBUG -   Price column not found, using default 0.0");
                    price = 0.0;
                }
                
                System.out.println("DEBUG -   Description: " + desc);
                System.out.println("DEBUG -   Duration: " + duration);
                System.out.println("DEBUG -   Media: " + media);

                subPackages.add(new SubPackageModel(id, pkgId, name, price, desc, duration, media));
            }
            
            System.out.println("DEBUG - Total sub-packages found: " + count);
            if (count == 0) {
                System.out.println("DEBUG - WARNING: No sub-packages found for package_id: " + packageId);
                
                // Let's also check if the package exists
                String checkPackageQuery = "SELECT id, package_name FROM packages WHERE id = ?";
                PreparedStatement checkStmt = conn.prepareStatement(checkPackageQuery);
                checkStmt.setInt(1, packageId);
                ResultSet checkRs = checkStmt.executeQuery();
                
                if (checkRs.next()) {
                    System.out.println("DEBUG - Package exists: ID=" + checkRs.getInt("id") + ", Name=" + checkRs.getString("package_name"));
                } else {
                    System.out.println("DEBUG - ERROR: Package with ID " + packageId + " does not exist!");
                }
                checkRs.close();
                checkStmt.close();
            }
            
        } catch (Exception e) {
            System.out.println("DEBUG - ERROR in getSubPackagesByPackageId: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (stmt != null) stmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
        
        System.out.println("DEBUG - Returning " + subPackages.size() + " sub-packages");
        System.out.println("DEBUG - ========== getSubPackagesByPackageId END ==========");
        return subPackages;
    }


    // ===================== BOOKING =====================

    // Add Booking
    // Get package by name
    public PackageModel getPackageByName(String packageName) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        PackageModel packageModel = null;
        
        try {
            conn = CONN();
            if (conn == null) return null;
            
            String query = "SELECT * FROM packages WHERE package_name = ?";
            stmt = conn.prepareStatement(query);
            stmt.setString(1, packageName);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                packageModel = new PackageModel(
                    rs.getInt("id"),
                    "PKG-" + rs.getInt("id"),
                    rs.getString("package_name"),
                    rs.getString("event"),
                    rs.getString("duration"),
                    rs.getString("category"),
                    null, // description
                    null, // imageUrl
                    0.0   // price
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }
        
        return packageModel;
    }
    
    // Get sub-package by name
    public SubPackageModel getSubPackageByName(String subPackageName) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        SubPackageModel subPackageModel = null;
        
        try {
            conn = CONN();
            if (conn == null) return null;
            
            String query = "SELECT * FROM sub_packages WHERE sub_package_name = ?";
            stmt = conn.prepareStatement(query);
            stmt.setString(1, subPackageName);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                subPackageModel = new SubPackageModel(
                    rs.getInt("id"),
                    rs.getInt("package_id"),
                    rs.getString("sub_package_name"),
                    rs.getDouble("price"),
                    rs.getString("description"),
                    rs.getString("duration"),
                    rs.getString("media") // Add media field
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }
        
        return subPackageModel;
    }

    public String addBooking(BookingModel booking) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean isSuccess = false;
        
        try {
            conn = CONN();
            if (conn == null) return "Database connection failed";

            // CRITICAL: Check for overlapping bookings BEFORE inserting
            // This is the final safety check at database level
            System.out.println("DEBUG ConnectionClass addBooking - Checking for overlaps BEFORE insert");
            System.out.println("DEBUG ConnectionClass addBooking - User ID: " + booking.getUserId());
            System.out.println("DEBUG ConnectionClass addBooking - Event Date: " + booking.getEventDate());
            System.out.println("DEBUG ConnectionClass addBooking - Event Time: " + booking.getEventTime());
            
            boolean hasOverlap = checkOverlappingBooking(booking.getUserId(), booking.getEventDate(), booking.getEventTime());
            
            if (hasOverlap) {
                System.out.println("DEBUG ConnectionClass addBooking - OVERLAP DETECTED! Tarikh dan masa ini sudah diambil oleh user lain. Rejecting insert.");
                return "Error: Tempahan pada tarikh dan masa ini sudah diambil oleh user lain. Sila pilih tarikh atau masa lain.";
            }
            
            System.out.println("DEBUG ConnectionClass addBooking - No overlap detected, proceeding with insert");

            // CRITICAL: Double-check for overlaps right before insert using SAME connection
            // This prevents race conditions where another booking was inserted between checks
            // Use inline query with same connection to ensure atomicity
            String normalizedDateDDMM = "";
            String normalizedDateDDMMNoPad = "";
            try {
                String[] parts = booking.getEventDate().split("-");
                if (parts.length == 3) {
                    String day = parts[2];
                    String month = parts[1];
                    String year = parts[0];
                    normalizedDateDDMM = day + "/" + month + "/" + year;
                    int dayInt = Integer.parseInt(day);
                    int monthInt = Integer.parseInt(month);
                    normalizedDateDDMMNoPad = dayInt + "/" + monthInt + "/" + year;
                }
            } catch (Exception e) {
                System.out.println("DEBUG - Error normalizing date in final check: " + e.getMessage());
            }
            
            String normalizedTime = booking.getEventTime();
            if (booking.getEventTime() != null && booking.getEventTime().length() == 4 && !booking.getEventTime().contains(":")) {
                normalizedTime = booking.getEventTime().substring(0, 2) + ":" + booking.getEventTime().substring(2);
            }
            String timeWithoutColon = booking.getEventTime() != null ? booking.getEventTime().replace(":", "").trim() : "";
            
            String finalCheckQuery = "SELECT COUNT(*) FROM bookings WHERE " +
                          "(" +
                          "  (LTRIM(RTRIM(event_date)) = ? OR LTRIM(RTRIM(event_date)) = ? OR LTRIM(RTRIM(event_date)) = ?) " +
                          "  AND " +
                          "  (LTRIM(RTRIM(event_time)) = ? OR LTRIM(RTRIM(event_time)) = ? OR LTRIM(RTRIM(event_time)) = ?) " +
                          ") " +
                          "AND LTRIM(RTRIM(status)) NOT IN ('Cancelled', 'Completed')";
            PreparedStatement finalCheckStmt = conn.prepareStatement(finalCheckQuery);
            finalCheckStmt.setString(1, booking.getEventDate().trim());
            finalCheckStmt.setString(2, normalizedDateDDMM.trim());
            finalCheckStmt.setString(3, normalizedDateDDMMNoPad.trim());
            finalCheckStmt.setString(4, booking.getEventTime() != null ? booking.getEventTime().trim() : "");
            finalCheckStmt.setString(5, normalizedTime != null ? normalizedTime.trim() : "");
            finalCheckStmt.setString(6, timeWithoutColon);
            
            ResultSet finalCheckRs = finalCheckStmt.executeQuery();
            int finalCheckCount = 0;
            if (finalCheckRs.next()) {
                finalCheckCount = finalCheckRs.getInt(1);
            }
            finalCheckRs.close();
            finalCheckStmt.close();
            
            if (finalCheckCount > 0) {
                System.out.println("DEBUG ConnectionClass addBooking - FINAL CHECK (same connection): Found " + finalCheckCount + " overlapping bookings from ANY user! Rejecting insert.");
                return "Error: Tempahan pada tarikh dan masa ini sudah diambil oleh user lain. Sila pilih tarikh atau masa lain.";
            }
            
            System.out.println("DEBUG ConnectionClass addBooking - FINAL CHECK (same connection) passed, executing INSERT");

            String query = "INSERT INTO bookings (user_id, package_id, sub_package_id, booking_date, event_date, event_time, status, total_amount, payment_method, payment_status, notes, created_at) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(query);
            stmt.setInt(1, booking.getUserId());
            stmt.setInt(2, booking.getPackageId());
            stmt.setInt(3, booking.getSubPackageId());
            // Normalize and trim all string values before inserting
            stmt.setString(4, booking.getBookingDate() != null ? booking.getBookingDate().trim() : null);
            stmt.setString(5, booking.getEventDate() != null ? booking.getEventDate().trim() : null);
            stmt.setString(6, booking.getEventTime() != null ? booking.getEventTime().trim() : null);
            stmt.setString(7, booking.getStatus() != null ? booking.getStatus().trim() : null);
            
            // Debug logging
            System.out.println("DEBUG ConnectionClass - BookingDate: " + booking.getBookingDate());
            System.out.println("DEBUG ConnectionClass - EventDate: " + booking.getEventDate());
            System.out.println("DEBUG ConnectionClass - EventTime: " + booking.getEventTime());
            stmt.setDouble(8, booking.getPrice());
            stmt.setString(9, booking.getPaymentMethod());
            stmt.setString(10, booking.getPaymentStatus());
            stmt.setString(11, booking.getNotes());
            // Set created_at as DATETIME, not string
            // If created_at is null, let database use DEFAULT GETDATE()
            if (booking.getCreatedAt() != null) {
                stmt.setTimestamp(12, new java.sql.Timestamp(booking.getCreatedAt().getTime()));
            } else {
                stmt.setNull(12, java.sql.Types.TIMESTAMP);
            }

            isSuccess = stmt.executeUpdate() > 0;
            
            if (isSuccess) {
                return "success";
            } else {
                return "Failed to add booking";
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "Error: " + e.getMessage();
        } finally {
            closeResources(null, stmt, conn);
        }
    }

    // Get Bookings by User ID
    public ArrayList<BookingModel> getBookingsByUserId(int userId) {
        ArrayList<BookingModel> bookings = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            System.out.println("DEBUG getBookingsByUserId - User ID: " + userId);
            conn = CONN();
            if (conn == null) {
                System.out.println("DEBUG getBookingsByUserId - Connection failed");
                return bookings;
            }

            String query = "SELECT * FROM bookings WHERE user_id = ? ORDER BY created_at DESC";
            System.out.println("DEBUG getBookingsByUserId - Query: " + query);
            System.out.println("DEBUG getBookingsByUserId - User ID parameter: " + userId);
            stmt = conn.prepareStatement(query);
            stmt.setInt(1, userId);
            System.out.println("DEBUG getBookingsByUserId - Parameter set to: " + userId);
            rs = stmt.executeQuery();

            while (rs.next()) {
                BookingModel booking = new BookingModel(
                        rs.getInt("id"),
                        rs.getInt("user_id"),
                        rs.getInt("package_id"),
                        rs.getInt("sub_package_id"),
                        rs.getString("booking_date"),
                        rs.getString("event_date"),
                        rs.getString("event_time"), // Add event_time parameter
                        rs.getString("status"),
                        rs.getDouble("total_amount"),
                        rs.getString("payment_method"),
                        rs.getString("payment_status"),
                        rs.getString("notes"),
                        rs.getTimestamp("created_at") != null ? new java.util.Date(rs.getTimestamp("created_at").getTime()) : new java.util.Date() // Convert to java.util.Date with null check
                );
                bookings.add(booking);
                System.out.println("DEBUG getBookingsByUserId - Found booking: ID=" + booking.getId() + ", UserID=" + booking.getUserId() + ", Status=" + booking.getStatus());
            }
            
            System.out.println("DEBUG getBookingsByUserId - Total bookings found for user " + userId + ": " + bookings.size());
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }

        return bookings;
    }

    // Get Booking by ID
    public BookingModel getBookingById(int bookingId) {
        BookingModel booking = null;
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = CONN();
            if (conn == null) return null;

            String query = "SELECT * FROM bookings WHERE id = ?";
            stmt = conn.prepareStatement(query);
            stmt.setInt(1, bookingId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                booking = new BookingModel(
                        rs.getInt("id"),
                        rs.getInt("user_id"),
                        rs.getInt("package_id"),
                        rs.getInt("sub_package_id"),
                        rs.getString("booking_date"),
                        rs.getString("event_date"),
                        rs.getString("event_time"), // Add event_time parameter
                        rs.getString("status"),
                        rs.getDouble("total_amount"),
                        rs.getString("payment_method"),
                        rs.getString("payment_status"),
                        rs.getString("notes"),
                        new java.util.Date(rs.getTimestamp("created_at").getTime()) // Convert to java.util.Date
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }

        return booking;
    }

    // Update Booking Status
    public boolean updateBookingStatus(int bookingId, String status) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean isSuccess = false;

        try {
            conn = CONN();
            if (conn == null) return false;

            String query = "UPDATE bookings SET status = ? WHERE id = ?";
            stmt = conn.prepareStatement(query);
            stmt.setString(1, status);
            stmt.setInt(2, bookingId);

            isSuccess = stmt.executeUpdate() > 0;
            
            if (isSuccess) {
                System.out.println("DEBUG - Booking status updated successfully: ID=" + bookingId + ", Status=" + status);
            } else {
                System.out.println("DEBUG - Failed to update booking status: ID=" + bookingId + ", Status=" + status);
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("DEBUG - Error updating booking status: " + e.getMessage());
        } finally {
            closeResources(null, stmt, conn);
        }

        return isSuccess;
    }

    // Confirm Booking (Admin function) - Now sets to "Paid"
    public boolean confirmBooking(int bookingId) {
        // Update both status and payment_status to "Paid"
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean isSuccess = false;

        try {
            conn = CONN();
            if (conn == null) return false;

            String query = "UPDATE bookings SET status = 'Paid', payment_status = 'Paid' WHERE id = ?";
            stmt = conn.prepareStatement(query);
            stmt.setInt(1, bookingId);

            isSuccess = stmt.executeUpdate() > 0;
            
            if (isSuccess) {
                System.out.println("DEBUG - Booking confirmed (set to Paid): ID=" + bookingId);
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("DEBUG - Error confirming booking: " + e.getMessage());
        } finally {
            closeResources(null, stmt, conn);
        }

        return isSuccess;
    }

    // Cancel Booking (User function)
    public boolean cancelBooking(int bookingId) {
        return updateBookingStatus(bookingId, "Cancelled");
    }

    // ✅ Migrate old status values to new Paid/Unpaid system
    public int migrateBookingStatusesToPaidUnpaid() {
        Connection conn = null;
        PreparedStatement stmt = null;
        int totalUpdated = 0;

        try {
            conn = CONN();
            if (conn == null) {
                System.out.println("DEBUG - Migration failed: No database connection");
                return 0;
            }

            // Update "Pending" → "Unpaid"
            // Update "Confirmed" → "Paid" (assuming confirmed bookings have been paid)
            // Update "Completed" → "Paid"
            String query = "UPDATE bookings SET status = CASE " +
                          "WHEN status = 'Pending' THEN 'Unpaid' " +
                          "WHEN status = 'Confirmed' THEN 'Paid' " +
                          "WHEN status = 'Completed' THEN 'Paid' " +
                          "ELSE status END, " +
                          "payment_status = CASE " +
                          "WHEN payment_status = 'Pending' THEN 'Unpaid' " +
                          "WHEN payment_status = 'Confirmed' THEN 'Paid' " +
                          "WHEN payment_status = 'Completed' THEN 'Paid' " +
                          "WHEN payment_status = 'Success' THEN 'Paid' " +
                          "ELSE payment_status END " +
                          "WHERE status IN ('Pending', 'Confirmed', 'Completed') " +
                          "OR payment_status IN ('Pending', 'Confirmed', 'Completed', 'Success')";

            stmt = conn.prepareStatement(query);
            totalUpdated = stmt.executeUpdate();

            System.out.println("DEBUG - Migration completed: " + totalUpdated + " bookings updated");
            System.out.println("DEBUG - Migration rules:");
            System.out.println("  - 'Pending' → 'Unpaid'");
            System.out.println("  - 'Confirmed' → 'Paid'");
            System.out.println("  - 'Completed' → 'Paid'");

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("DEBUG - Error during migration: " + e.getMessage());
        } finally {
            closeResources(null, stmt, conn);
        }

        return totalUpdated;
    }

    // Get All Bookings (Admin function)
    public ArrayList<BookingModel> getAllBookings() {
        ArrayList<BookingModel> bookings = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = CONN();
            if (conn == null) return bookings;

            String query = "SELECT * FROM bookings ORDER BY created_at DESC";
            stmt = conn.prepareStatement(query);
            rs = stmt.executeQuery();

            while (rs.next()) {
                BookingModel booking = new BookingModel(
                        rs.getInt("id"),
                        rs.getInt("user_id"),
                        rs.getInt("package_id"),
                        rs.getInt("sub_package_id"),
                        rs.getString("booking_date"),
                        rs.getString("event_date"),
                        rs.getString("event_time"), // Add event_time parameter
                        rs.getString("status"),
                        rs.getDouble("total_amount"),
                        rs.getString("payment_method"),
                        rs.getString("payment_status"),
                        rs.getString("notes"),
                        rs.getTimestamp("created_at") != null ? new java.util.Date(rs.getTimestamp("created_at").getTime()) : new java.util.Date() // Convert to java.util.Date with null check
                );
                bookings.add(booking);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }

        return bookings;
    }

    // Get Booking Details with Package Information
    public BookingDetailsModel getBookingDetails(int bookingId) {
        BookingDetailsModel bookingDetails = null;
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = CONN();
            if (conn == null) return null;

            String query = "SELECT b.*, p.package_name, p.category, p.event, p.duration, " +
                          "sp.sub_package_name, sp.description, sp.price, sp.duration as sub_duration, " +
                          "u.name as user_name, u.email " +
                          "FROM bookings b " +
                          "LEFT JOIN packages p ON b.package_id = p.id " +
                          "LEFT JOIN sub_packages sp ON b.sub_package_id = sp.id " +
                          "LEFT JOIN users u ON b.user_id = u.id " +
                          "WHERE b.id = ?";
            stmt = conn.prepareStatement(query);
            stmt.setInt(1, bookingId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                bookingDetails = new BookingDetailsModel();
                bookingDetails.setBookingId(rs.getInt("id"));
                bookingDetails.setUserId(rs.getInt("user_id"));
                bookingDetails.setPackageId(rs.getInt("package_id"));
                bookingDetails.setSubPackageId(rs.getInt("sub_package_id"));
                bookingDetails.setPackageName(rs.getString("package_name"));
                bookingDetails.setSubPackageName(rs.getString("sub_package_name"));
                bookingDetails.setCategory(rs.getString("category"));
                bookingDetails.setEvent(rs.getString("event"));
                bookingDetails.setDuration(rs.getString("duration"));
                bookingDetails.setPackageClass(rs.getString("sub_package_name"));
                bookingDetails.setDetails(rs.getString("description"));
                bookingDetails.setPrice(rs.getDouble("price"));
                bookingDetails.setBookingDate(rs.getString("booking_date"));
                bookingDetails.setEventDate(rs.getString("event_date"));
                bookingDetails.setEventTime(rs.getString("event_time"));
                bookingDetails.setStatus(rs.getString("status"));
                bookingDetails.setPrice(rs.getDouble("total_amount"));
                bookingDetails.setPaymentMethod(rs.getString("payment_method"));
                bookingDetails.setPaymentStatus(rs.getString("payment_status"));
                bookingDetails.setNotes(rs.getString("notes"));
                bookingDetails.setUserName(rs.getString("user_name"));
                bookingDetails.setUserEmail(rs.getString("email"));
                bookingDetails.setCreatedAt(rs.getDate("created_at"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }

        return bookingDetails;
    }

    // ===================== USER AUTHENTICATION =====================

    // Validate User Login
    public String validateUser(String email, String password) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = CONN();
            if (conn == null) return "Database connection failed";

            String query = "SELECT * FROM users WHERE email = ? AND password = ?";
            stmt = conn.prepareStatement(query);
            stmt.setString(1, email);
            stmt.setString(2, password);
            rs = stmt.executeQuery();

            boolean isValid = rs.next();
            
            System.out.println("validateUser - Email: " + email + ", Password: " + password + ", Valid: " + isValid);
            
            if (isValid) {
                return "success";
            } else {
                return "Invalid email or password";
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("validateUser - Error: " + e.getMessage());
            return "Error: " + e.getMessage();
        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    // Get User by Email
    public UserModel getUserByEmail(String email) {
        UserModel user = null;
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = CONN();
            if (conn == null) return null;

            String query = "SELECT * FROM users WHERE email = ?";
            stmt = conn.prepareStatement(query);
            stmt.setString(1, email);
            rs = stmt.executeQuery();

            if (rs.next()) {
                user = new UserModel();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("email")); // Use email as username
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                
                // Get role from database, default to "User" if null
                String role = rs.getString("role");
                user.setRole(role != null ? role : "User");
                
                user.setFullName(rs.getString("name"));
                user.setPhoneNumber(rs.getString("phone_number")); // Get phone number from database
                user.setProfileImage(rs.getString("profile_image")); // Get profile image from database
                
                System.out.println("getUserByEmail - Role from database: " + role + ", Final role: " + user.getRole());
            }
            
            System.out.println("getUserByEmail - Email: " + email + ", User found: " + (user != null));
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("getUserByEmail - Error: " + e.getMessage());
        } finally {
            closeResources(rs, stmt, conn);
        }

        return user;
    }

    // Register User
    public String registerUser(String name, String email, String phone, String password) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean isSuccess = false;

        try {
            System.out.println("DEBUG - registerUser called with name: " + name + ", email: " + email + ", phone: " + phone);
            
            conn = CONN();
            if (conn == null) {
                System.out.println("DEBUG - Database connection failed");
                return "Database connection failed";
            }
            System.out.println("DEBUG - Database connection successful");

            // Check if user already exists
            String checkQuery = "SELECT COUNT(*) FROM users WHERE email = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkQuery);
            checkStmt.setString(1, email);
            ResultSet rs = checkStmt.executeQuery();
            
            if (rs.next() && rs.getInt(1) > 0) {
                System.out.println("DEBUG - User already exists with email: " + email);
                return "User with this email already exists";
            }
            System.out.println("DEBUG - Email is available, proceeding with registration");

            // Insert new user with name, email, phone, password
            String query = "INSERT INTO users (name, email, phone_number, password) VALUES (?, ?, ?, ?)";
            stmt = conn.prepareStatement(query);
            stmt.setString(1, name);
            stmt.setString(2, email);
            stmt.setString(3, phone);
            stmt.setString(4, password);

            System.out.println("DEBUG - Executing insert query with name: " + name + ", email: " + email + ", phone: " + phone);
            isSuccess = stmt.executeUpdate() > 0;
            System.out.println("DEBUG - Insert result: " + isSuccess);
            
            if (isSuccess) {
                return "User registered successfully";
            } else {
                return "Failed to register user";
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "Error: " + e.getMessage();
        } finally {
            closeResources(null, stmt, conn);
        }
    }

    // Test Database Connection
    public String testConnection() {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = CONN();
            if (conn == null) return "Database connection failed";

            String query = "SELECT COUNT(*) FROM users";
            stmt = conn.prepareStatement(query);
            rs = stmt.executeQuery();

            if (rs.next()) {
                int userCount = rs.getInt(1);
                return "Connection successful! Users table exists with " + userCount + " records.";
            } else {
                return "Connection successful but users table is empty.";
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "Connection failed: " + e.getMessage();
        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    // Create Bookings Table if not exists
    public boolean createBookingsTableIfNotExists() {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean isSuccess = false;

        try {
            conn = CONN();
            if (conn == null) return false;

            // Check if bookings table exists
            String checkQuery = "SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'bookings'";
            stmt = conn.prepareStatement(checkQuery);
            ResultSet rs = stmt.executeQuery();
            
            boolean tableExists = false;
            if (rs.next()) {
                tableExists = rs.getInt(1) > 0;
            }
            rs.close();
            stmt.close();

            if (!tableExists) {
                // Create bookings table
                String createQuery = "CREATE TABLE bookings (" +
                        "id INT IDENTITY(1,1) PRIMARY KEY, " +
                        "user_id INT NOT NULL, " +
                        "package_id INT NOT NULL, " +
                        "sub_package_id INT NOT NULL, " +
                        "booking_date NVARCHAR(20) NOT NULL, " +
                        "event_date NVARCHAR(20) NOT NULL, " +
                        "status NVARCHAR(20) NOT NULL DEFAULT 'Pending', " +
                        "total_amount DECIMAL(10,2) NOT NULL, " +
                        "payment_method NVARCHAR(50) NOT NULL, " +
                        "payment_status NVARCHAR(20) NOT NULL DEFAULT 'Pending', " +
                        "notes NVARCHAR(500), " +
                        "created_at NVARCHAR(50) NOT NULL" +
                        ")";
                
                stmt = conn.prepareStatement(createQuery);
                stmt.executeUpdate();
                stmt.close();
                
                // Add foreign key constraints if tables exist
                try {
                    String fkQuery1 = "ALTER TABLE bookings ADD CONSTRAINT FK_bookings_user FOREIGN KEY (user_id) REFERENCES users(id)";
                    stmt = conn.prepareStatement(fkQuery1);
                    stmt.executeUpdate();
                    stmt.close();
                } catch (Exception e) {
                    // Foreign key might already exist or users table might not exist
                }
                
                try {
                    String fkQuery2 = "ALTER TABLE bookings ADD CONSTRAINT FK_bookings_package FOREIGN KEY (package_id) REFERENCES packages(id)";
                    stmt = conn.prepareStatement(fkQuery2);
                    stmt.executeUpdate();
                    stmt.close();
                } catch (Exception e) {
                    // Foreign key might already exist or packages table might not exist
                }
                
                try {
                    String fkQuery3 = "ALTER TABLE bookings ADD CONSTRAINT FK_bookings_subpackage FOREIGN KEY (sub_package_id) REFERENCES sub_packages(id)";
                    stmt = conn.prepareStatement(fkQuery3);
                    stmt.executeUpdate();
                    stmt.close();
                } catch (Exception e) {
                    // Foreign key might already exist or sub_packages table might not exist
                }
                
                isSuccess = true;
            } else {
                isSuccess = true; // Table already exists
            }
        } catch (Exception e) {
            e.printStackTrace();
            isSuccess = false;
        } finally {
            closeResources(null, stmt, conn);
        }

        return isSuccess;
    }

    // Check if user exists
    public boolean userExists(String email) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        boolean exists = false;

        try {
            conn = CONN();
            if (conn == null) return false;

            String query = "SELECT COUNT(*) FROM users WHERE email = ?";
            stmt = conn.prepareStatement(query);
            stmt.setString(1, email);
            rs = stmt.executeQuery();

            if (rs.next()) {
                exists = rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }

        return exists;
    }

    // Check for overlapping bookings (any user, same date and time)
    // This prevents multiple users from booking the same date and time slot
    public boolean checkOverlappingBooking(int userId, String eventDate, String eventTime) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        boolean hasOverlap = false;

        try {
            conn = CONN();
            if (conn == null) {
                System.out.println("DEBUG - checkOverlappingBooking: Database connection failed - BLOCKING booking for safety");
                // Fail closed: If we can't check, block the booking to prevent duplicates
                return true; // Return true to block booking when connection fails
            }

            System.out.println("DEBUG - checkOverlappingBooking: Checking for overlaps");
            System.out.println("DEBUG - Event Date (YYYY-MM-DD): " + eventDate);
            System.out.println("DEBUG - Event Time: " + eventTime);
            
            // Normalize date format for comparison
            // Try to match both YYYY-MM-DD and DD/MM/YYYY formats that might exist in database
            // Convert input date (YYYY-MM-DD) to DD/MM/YYYY for comparison
            String normalizedDateDDMM = "";
            String normalizedDateDDMMNoPad = ""; // For dates without zero padding (D/M/YYYY)
            try {
                String[] parts = eventDate.split("-");
                if (parts.length == 3) {
                    String day = parts[2];
                    String month = parts[1];
                    String year = parts[0];
                    
                    // DD/MM/YYYY format (with zero padding)
                    normalizedDateDDMM = day + "/" + month + "/" + year;
                    
                    // D/M/YYYY format (without zero padding)
                    int dayInt = Integer.parseInt(day);
                    int monthInt = Integer.parseInt(month);
                    normalizedDateDDMMNoPad = dayInt + "/" + monthInt + "/" + year;
                }
            } catch (Exception e) {
                System.out.println("DEBUG - Error normalizing date: " + e.getMessage());
            }
            
            // Normalize time format (ensure HH:mm format)
            String normalizedTime = eventTime;
            if (eventTime != null && eventTime.length() == 4 && !eventTime.contains(":")) {
                // Handle time format like "0930" -> "09:30"
                normalizedTime = eventTime.substring(0, 2) + ":" + eventTime.substring(2);
            }
            
            System.out.println("DEBUG - Normalized dates for comparison:");
            System.out.println("  YYYY-MM-DD: " + eventDate);
            System.out.println("  DD/MM/YYYY: " + normalizedDateDDMM);
            System.out.println("  D/M/YYYY: " + normalizedDateDDMMNoPad);
            System.out.println("  Time: " + normalizedTime);
            
            // Check if there's any booking (from ANY user, including same user) with same date and time
            // Handle multiple date formats: YYYY-MM-DD, DD/MM/YYYY, D/M/YYYY
            // Handle multiple time formats: HH:mm, HHmm
            // Exclude cancelled and completed bookings
            // IMPORTANT: This prevents the SAME user from booking the same date/time twice
            // Use TRIM to handle any whitespace and normalize comparisons
            String query = "SELECT COUNT(*) as booking_count, " +
                          "SUM(CASE WHEN user_id = ? THEN 1 ELSE 0 END) as same_user_count " +
                          "FROM bookings WHERE " +
                          "(" +
                          "  (LTRIM(RTRIM(event_date)) = ? OR LTRIM(RTRIM(event_date)) = ? OR LTRIM(RTRIM(event_date)) = ?) " +
                          "  AND " +
                          "  (LTRIM(RTRIM(event_time)) = ? OR LTRIM(RTRIM(event_time)) = ? OR LTRIM(RTRIM(event_time)) = ?) " +
                          ") " +
                          "AND LTRIM(RTRIM(status)) NOT IN ('Cancelled', 'Completed')";
            stmt = conn.prepareStatement(query);
            stmt.setInt(1, userId); // Check for same user
            stmt.setString(2, eventDate.trim()); // YYYY-MM-DD format
            stmt.setString(3, normalizedDateDDMM.trim()); // DD/MM/YYYY format
            stmt.setString(4, normalizedDateDDMMNoPad.trim()); // D/M/YYYY format
            stmt.setString(5, eventTime != null ? eventTime.trim() : ""); // Original time format
            stmt.setString(6, normalizedTime != null ? normalizedTime.trim() : ""); // Normalized time format
            // Also check time without colon (if original has colon)
            String timeWithoutColon = eventTime != null ? eventTime.replace(":", "").trim() : "";
            stmt.setString(7, timeWithoutColon);
            
            System.out.println("DEBUG - Query: " + query);
            System.out.println("DEBUG - User ID to check: " + userId);
            System.out.println("DEBUG - Date params:");
            System.out.println("  Param 2 (YYYY-MM-DD): " + eventDate);
            System.out.println("  Param 3 (DD/MM/YYYY): " + normalizedDateDDMM);
            System.out.println("  Param 4 (D/M/YYYY): " + normalizedDateDDMMNoPad);
            System.out.println("DEBUG - Time params:");
            System.out.println("  Param 5 (Original): " + eventTime);
            System.out.println("  Param 6 (Normalized): " + normalizedTime);
            System.out.println("  Param 7 (No Colon): " + timeWithoutColon);
            
            rs = stmt.executeQuery();

            if (rs.next()) {
                int totalCount = rs.getInt("booking_count");
                int sameUserCount = rs.getInt("same_user_count");
                hasOverlap = totalCount > 0;
                
                System.out.println("DEBUG - checkOverlappingBooking: Found " + totalCount + " overlapping bookings " +
                                  "(from any user) on " + eventDate + " at " + eventTime);
                System.out.println("DEBUG - Same user bookings: " + sameUserCount);
                System.out.println("DEBUG - Has overlap: " + hasOverlap);
                
                // Additional debug: Check what's actually in database for this date/time
                String debugQuery = "SELECT id, user_id, event_date, event_time, status, LEN(event_date) as date_len, LEN(event_time) as time_len " +
                                   "FROM bookings " +
                                   "WHERE status NOT IN ('Cancelled', 'Completed') " +
                                   "ORDER BY id DESC";
                PreparedStatement debugStmt = conn.prepareStatement(debugQuery);
                ResultSet debugRs = debugStmt.executeQuery();
                
                System.out.println("DEBUG - All active bookings in database:");
                int bookingNum = 0;
                while (debugRs.next() && bookingNum < 10) { // Limit to 10 for performance
                    String dbDate = debugRs.getString("event_date");
                    String dbTime = debugRs.getString("event_time");
                    boolean dateMatches = dbDate != null && (
                        dbDate.trim().equals(eventDate.trim()) || 
                        dbDate.trim().equals(normalizedDateDDMM.trim()) || 
                        dbDate.trim().equals(normalizedDateDDMMNoPad.trim())
                    );
                    boolean timeMatches = dbTime != null && (
                        dbTime.trim().equals(eventTime != null ? eventTime.trim() : "") ||
                        dbTime.trim().equals(normalizedTime != null ? normalizedTime.trim() : "") ||
                        dbTime.trim().equals(timeWithoutColon)
                    );
                    
                    System.out.println("DEBUG -   Booking ID: " + debugRs.getInt("id") + 
                                      ", User ID: " + debugRs.getInt("user_id") +
                                      ", Event Date: [" + dbDate + "] (len:" + debugRs.getInt("date_len") + ")" +
                                      ", Event Time: [" + dbTime + "] (len:" + debugRs.getInt("time_len") + ")" +
                                      ", Date Match: " + dateMatches +
                                      ", Time Match: " + timeMatches +
                                      ", Status: " + debugRs.getString("status"));
                    bookingNum++;
                }
                debugRs.close();
                debugStmt.close();
                
                // If overlap found, get user info for debugging (optional - don't fail if this errors)
                if (hasOverlap) {
                    try {
                        String userQuery = "SELECT b.id, b.user_id, u.name, b.event_date, b.event_time, b.status " +
                                          "FROM bookings b " +
                                          "LEFT JOIN users u ON b.user_id = u.id " +
                                          "WHERE (" +
                                          "  (LTRIM(RTRIM(b.event_date)) = ? OR LTRIM(RTRIM(b.event_date)) = ? OR LTRIM(RTRIM(b.event_date)) = ?) " +
                                          "  AND " +
                                          "  (LTRIM(RTRIM(b.event_time)) = ? OR LTRIM(RTRIM(b.event_time)) = ? OR LTRIM(RTRIM(b.event_time)) = ?) " +
                                          ") " +
                                          "AND LTRIM(RTRIM(b.status)) NOT IN ('Cancelled', 'Completed') " +
                                          "ORDER BY b.id DESC";
                        PreparedStatement userStmt = conn.prepareStatement(userQuery);
                        userStmt.setString(1, eventDate.trim());
                        userStmt.setString(2, normalizedDateDDMM.trim());
                        userStmt.setString(3, normalizedDateDDMMNoPad.trim());
                        userStmt.setString(4, eventTime != null ? eventTime.trim() : "");
                        userStmt.setString(5, normalizedTime != null ? normalizedTime.trim() : "");
                        userStmt.setString(6, timeWithoutColon);
                        ResultSet userRs = userStmt.executeQuery();
                        
                        System.out.println("DEBUG - Existing bookings on this date/time:");
                        while (userRs.next()) {
                            int existingUserId = userRs.getInt("user_id");
                            boolean isSameUser = (existingUserId == userId);
                            System.out.println("DEBUG -   Booking ID: " + userRs.getInt("id") +
                                              ", User ID: " + existingUserId + 
                                              (isSameUser ? " (SAME USER)" : "") +
                                              ", Name: " + userRs.getString("name") +
                                              ", Event Date: " + userRs.getString("event_date") +
                                              ", Event Time: " + userRs.getString("event_time") +
                                              ", Status: " + userRs.getString("status"));
                        }
                        userRs.close();
                        userStmt.close();
                    } catch (Exception userInfoError) {
                        // Don't fail if user info query fails - overlap was already detected
                        System.out.println("DEBUG - Error getting user info (non-critical): " + userInfoError.getMessage());
                    }
                }
            } else {
                System.out.println("DEBUG - checkOverlappingBooking: No overlapping bookings found");
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("DEBUG - checkOverlappingBooking error: " + e.getMessage());
            System.out.println("DEBUG - Stack trace:");
            e.printStackTrace();
            // CRITICAL: On error during overlap check, BLOCK booking (fail closed) for safety
            // Better to block a valid booking than allow duplicate
            System.out.println("DEBUG - ERROR during overlap check - BLOCKING booking for safety");
            return true; // Return true (has overlap) to block booking
        } finally {
            closeResources(rs, stmt, conn);
        }

        return hasOverlap;
    }

    // Get all booked dates with times (for date picker)
    // Returns HashMap with date as key (YYYY-MM-DD format) and list of times as value
    public java.util.HashMap<String, java.util.ArrayList<String>> getBookedDatesWithTimes() {
        java.util.HashMap<String, java.util.ArrayList<String>> bookedDates = new java.util.HashMap<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = CONN();
            if (conn == null) return bookedDates;

            // Get all active bookings with their event dates and times
            String query = "SELECT DISTINCT LTRIM(RTRIM(event_date)) as event_date, LTRIM(RTRIM(event_time)) as event_time " +
                          "FROM bookings " +
                          "WHERE LTRIM(RTRIM(status)) NOT IN ('Cancelled', 'Completed') " +
                          "AND event_date IS NOT NULL AND event_time IS NOT NULL " +
                          "ORDER BY event_date, event_time";
            stmt = conn.prepareStatement(query);
            rs = stmt.executeQuery();

            while (rs.next()) {
                String eventDate = rs.getString("event_date");
                String eventTime = rs.getString("event_time");
                
                if (eventDate != null && eventTime != null) {
                    eventDate = eventDate.trim();
                    eventTime = eventTime.trim();
                    
                    // Normalize date format to YYYY-MM-DD
                    String normalizedDate = normalizeDateToYYYYMMDD(eventDate);
                    
                    if (!normalizedDate.isEmpty()) {
                        if (!bookedDates.containsKey(normalizedDate)) {
                            bookedDates.put(normalizedDate, new java.util.ArrayList<String>());
                        }
                        bookedDates.get(normalizedDate).add(eventTime);
                    }
                }
            }
            
            System.out.println("DEBUG - getBookedDatesWithTimes: Found " + bookedDates.size() + " booked dates");
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("DEBUG - getBookedDatesWithTimes error: " + e.getMessage());
        } finally {
            closeResources(rs, stmt, conn);
        }

        return bookedDates;
    }
    
    // Normalize date format to YYYY-MM-DD
    private String normalizeDateToYYYYMMDD(String dateStr) {
        if (dateStr == null || dateStr.trim().isEmpty()) return "";
        
        dateStr = dateStr.trim();
        
        // If already YYYY-MM-DD format
        if (dateStr.matches("\\d{4}-\\d{2}-\\d{2}")) {
            return dateStr;
        }
        
        // If DD/MM/YYYY format
        if (dateStr.matches("\\d{1,2}/\\d{1,2}/\\d{4}")) {
            try {
                String[] parts = dateStr.split("/");
                String day = parts[0].trim();
                String month = parts[1].trim();
                String year = parts[2].trim();
                
                // Pad with zeros
                if (day.length() == 1) day = "0" + day;
                if (month.length() == 1) month = "0" + month;
                
                return year + "-" + month + "-" + day;
            } catch (Exception e) {
                System.out.println("DEBUG - Error normalizing date: " + dateStr);
            }
        }
        
        return "";
    }

    // ===================== FEEDBACK METHODS =====================

    // Get all feedback from database (visible to all users)
    public ArrayList<FeedbackModel> getAllFeedback() {
        ArrayList<FeedbackModel> feedbackList = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = CONN();
            if (conn == null) return feedbackList;

            // Get all feedback ordered by most recent first
            // All users can see all feedback
            // Use DISTINCT to prevent duplicates
            String query = "SELECT DISTINCT f.id, f.user_id, f.name, f.comment, f.rating, f.created_at, u.name as user_name " +
                          "FROM feedback f " +
                          "LEFT JOIN users u ON f.user_id = u.id " +
                          "ORDER BY f.created_at DESC, f.id DESC";
            
            stmt = conn.prepareStatement(query);
            rs = stmt.executeQuery();

            while (rs.next()) {
                String name = rs.getString("name"); // Use name from feedback table (shows user's name who gave feedback)
                String comment = rs.getString("comment");
                float rating = (float) rs.getDouble("rating");
                
                // Format date to "dd MMMM yyyy" format
                java.sql.Timestamp createdAt = rs.getTimestamp("created_at");
                String formattedDate = "";
                if (createdAt != null) {
                    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd MMMM yyyy", java.util.Locale.getDefault());
                    formattedDate = sdf.format(new java.util.Date(createdAt.getTime()));
                } else {
                    formattedDate = "Unknown date";
                }
                
                // Assign different profile images based on feedback ID (for variety)
                int profileImageRes = R.drawable.ic_person_default;
                int feedbackId = rs.getInt("id");
                switch (feedbackId % 5) {
                    case 0:
                        profileImageRes = R.drawable.ic_person_1;
                        break;
                    case 1:
                        profileImageRes = R.drawable.ic_person_2;
                        break;
                    case 2:
                        profileImageRes = R.drawable.ic_person_3;
                        break;
                    case 3:
                        profileImageRes = R.drawable.ic_person_4;
                        break;
                    case 4:
                        profileImageRes = R.drawable.ic_person_5;
                        break;
                }
                
                FeedbackModel feedback = new FeedbackModel(name, comment, rating, formattedDate, profileImageRes);
                feedbackList.add(feedback);
            }
            
            System.out.println("DEBUG - getAllFeedback: Loaded " + feedbackList.size() + " feedback entries from database");
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("DEBUG - getAllFeedback error: " + e.getMessage());
        } finally {
            closeResources(rs, stmt, conn);
        }

        return feedbackList;
    }

    // Add new feedback to database
    public String addFeedback(int userId, String name, String comment, float rating) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean isSuccess = false;

        try {
            conn = CONN();
            if (conn == null) return "Database connection failed";

            String query = "INSERT INTO feedback (user_id, name, comment, rating, created_at) " +
                          "VALUES (?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(query);
            stmt.setInt(1, userId);
            stmt.setString(2, name);
            stmt.setString(3, comment);
            stmt.setDouble(4, rating);
            stmt.setTimestamp(5, new java.sql.Timestamp(new java.util.Date().getTime()));

            isSuccess = stmt.executeUpdate() > 0;

            if (isSuccess) {
                System.out.println("DEBUG - addFeedback: Feedback added successfully for user " + userId);
                return "success";
            } else {
                return "Failed to add feedback";
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("DEBUG - addFeedback error: " + e.getMessage());
            return "Error: " + e.getMessage();
        } finally {
            closeResources(null, stmt, conn);
        }
    }

    // ===================== UTIL =====================

    private void closeResources(ResultSet rs, PreparedStatement stmt, Connection conn) {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Get user by ID
    public UserModel getUserById(int userId) {
        UserModel user = null;
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = CONN();
            if (conn == null) return null;

            String query = "SELECT * FROM users WHERE id = ?";
            stmt = conn.prepareStatement(query);
            stmt.setInt(1, userId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                user = new UserModel();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("email")); // Use email as username
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setRole(rs.getString("role")); // Get role from database
                user.setFullName(rs.getString("name"));
                user.setPhoneNumber(rs.getString("phone_number")); // Get phone number from database
                user.setProfileImage(rs.getString("profile_image")); // Get profile image from database
                
                // Debug logging
                System.out.println("DEBUG ConnectionClass - getUserById:");
                System.out.println("ID: " + user.getId());
                System.out.println("Name: " + user.getFullName());
                System.out.println("Email: " + user.getEmail());
                System.out.println("Role: " + user.getRole());
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }

        return user;
    }

    // Update user profile image
    public boolean updateUserProfileImage(int userId, String profileImagePath) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean isSuccess = false;

        try {
            conn = CONN();
            if (conn == null) return false;

            String query = "UPDATE users SET profile_image = ? WHERE id = ?";
            stmt = conn.prepareStatement(query);
            stmt.setString(1, profileImagePath);
            stmt.setInt(2, userId);

            int rowsAffected = stmt.executeUpdate();
            isSuccess = rowsAffected > 0;

            System.out.println("updateUserProfileImage - User ID: " + userId + ", Image Path: " + profileImagePath + ", Success: " + isSuccess);
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("updateUserProfileImage - Error: " + e.getMessage());
        } finally {
            closeResources(null, stmt, conn);
        }

        return isSuccess;
    }

    // Get all users
    public java.util.List<UserModel> getAllUsers() {
        java.util.List<UserModel> users = new java.util.ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = CONN();
            if (conn == null) return users;

            String query = "SELECT * FROM users ORDER BY id";
            stmt = conn.prepareStatement(query);
            rs = stmt.executeQuery();

            while (rs.next()) {
                UserModel user = new UserModel();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("email")); // Use email as username
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setRole("User"); // Default role
                user.setFullName(rs.getString("name"));
                user.setPhoneNumber(""); // No phone number field
                users.add(user);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }

        return users;
    }
}
