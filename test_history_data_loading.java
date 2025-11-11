// =============================================
// TEST HISTORY DATA LOADING
// =============================================

// Add this method to HistoryActivity for testing
public void testHistoryDataLoading() {
    new Thread(() -> {
        try {
            System.out.println("=== TESTING HISTORY DATA LOADING ===");
            
            // Test 1: Check database connection
            String connectionTest = connectionClass.testConnection();
            System.out.println("1. Connection Test: " + connectionTest);
            
            // Test 2: Check if we have any bookings in database
            ArrayList<BookingModel> allBookings = connectionClass.getAllBookings();
            System.out.println("2. Total bookings in database: " + (allBookings != null ? allBookings.size() : "NULL"));
            
            if (allBookings != null && !allBookings.isEmpty()) {
                for (BookingModel booking : allBookings) {
                    System.out.println("   - Booking ID: " + booking.getId() + ", User ID: " + booking.getUserId() + 
                                     ", Event Date: " + booking.getEventDate() + ", Status: " + booking.getStatus());
                }
            }
            
            // Test 3: Check user-specific bookings
            ArrayList<BookingModel> userBookings = connectionClass.getBookingsByUserId(userId);
            System.out.println("3. User bookings for ID " + userId + ": " + (userBookings != null ? userBookings.size() : "NULL"));
            
            if (userBookings != null && !userBookings.isEmpty()) {
                for (BookingModel booking : userBookings) {
                    System.out.println("   - User Booking ID: " + booking.getId() + ", Event Date: " + booking.getEventDate());
                }
            }
            
            // Test 4: Check booking details
            if (userBookings != null && !userBookings.isEmpty()) {
                BookingModel firstBooking = userBookings.get(0);
                BookingDetailsModel details = connectionClass.getBookingDetails(firstBooking.getId());
                System.out.println("4. Booking details for ID " + firstBooking.getId() + ": " + (details != null ? "Found" : "NULL"));
                
                if (details != null) {
                    System.out.println("   - Package Name: " + details.getPackageName());
                    System.out.println("   - Category: " + details.getCategory());
                    System.out.println("   - Event Date: " + details.getEventDate());
                }
            }
            
            runOnUiThread(() -> {
                Toast.makeText(this, "History test completed - check Logcat", Toast.LENGTH_LONG).show();
            });
            
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("History test error: " + e.getMessage());
            runOnUiThread(() -> {
                Toast.makeText(this, "History test error: " + e.getMessage(), Toast.LENGTH_LONG).show();
            });
        }
    }).start();
}
