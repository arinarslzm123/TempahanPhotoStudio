// =============================================
// TEST SIMPLE BOOKING CREATION
// =============================================

// Add this method to BookingActivity for testing
public void testSimpleBooking() {
    new Thread(() -> {
        try {
            // Test with minimal data
            BookingModel testBooking = new BookingModel();
            testBooking.setUserId(1);
            testBooking.setPackageId(1);
            testBooking.setSubPackageId(1);
            testBooking.setBookingDate("2025-01-10");
            testBooking.setEventDate("2025-10-13"); // Use YYYY-MM-DD format directly
            testBooking.setEventTime("22:00");
            testBooking.setStatus("Pending");
            testBooking.setTotalAmount(1200.00);
            testBooking.setPaymentMethod("Cash");
            testBooking.setPaymentStatus("Pending");
            testBooking.setNotes("Simple test booking");
            testBooking.setCreatedAt(new Date());

            System.out.println("=== SIMPLE BOOKING TEST ===");
            System.out.println("User ID: " + testBooking.getUserId());
            System.out.println("Package ID: " + testBooking.getPackageId());
            System.out.println("Sub Package ID: " + testBooking.getSubPackageId());
            System.out.println("Booking Date: " + testBooking.getBookingDate());
            System.out.println("Event Date: " + testBooking.getEventDate());
            System.out.println("Event Time: " + testBooking.getEventTime());
            System.out.println("Status: " + testBooking.getStatus());
            System.out.println("Total Amount: " + testBooking.getTotalAmount());
            System.out.println("Payment Method: " + testBooking.getPaymentMethod());
            System.out.println("Payment Status: " + testBooking.getPaymentStatus());
            System.out.println("Notes: " + testBooking.getNotes());
            System.out.println("Created At: " + testBooking.getCreatedAt());

            // Test database connection first
            String connectionTest = connectionClass.testConnection();
            System.out.println("Connection Test: " + connectionTest);

            // Test table creation
            boolean tableCreated = connectionClass.createBookingsTableIfNotExists();
            System.out.println("Table Created: " + tableCreated);

            // Test booking creation
            String result = connectionClass.addBooking(testBooking);
            System.out.println("Booking Creation Result: " + result);

            runOnUiThread(() -> {
                Toast.makeText(this, "Test Result: " + result, Toast.LENGTH_LONG).show();
            });

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Test Error: " + e.getMessage());
            runOnUiThread(() -> {
                Toast.makeText(this, "Test Error: " + e.getMessage(), Toast.LENGTH_LONG).show();
            });
        }
    }).start();
}

// Method to test with hardcoded values (bypass date picker)
public void testHardcodedBooking() {
    // Use the exact values from the screenshot
    String hardcodedEventDate = "2025-10-13"; // Already in correct format
    String hardcodedEventTime = "22:00";
    
    // Get first package from database
    new Thread(() -> {
        try {
            ArrayList<PackageModel> packages = connectionClass.getAllPackages();
            if (packages != null && !packages.isEmpty()) {
                PackageModel selectedPackage = packages.get(0);
                System.out.println("Using package: " + selectedPackage.getPackageName());
                createBooking(selectedPackage, hardcodedEventDate, hardcodedEventTime);
            } else {
                runOnUiThread(() -> {
                    Toast.makeText(this, "No packages found in database", Toast.LENGTH_LONG).show();
                });
            }
        } catch (Exception e) {
            e.printStackTrace();
            runOnUiThread(() -> {
                Toast.makeText(this, "Error: " + e.getMessage(), Toast.LENGTH_LONG).show();
            });
        }
    }).start();
}
