// =============================================
// TEST ANDROID DATE CONVERSION LOGIC
// =============================================

// Add this method to BookingActivity for testing
public void testDateConversion() {
    // Test cases
    String[] testDates = {
        "13/10/2025",    // From screenshot
        "15/10/2025",    // Another test
        "1/1/2026",      // Single digit day/month
        "25/12/2025",    // Christmas
        "5/3/2025"       // Single digit month
    };
    
    System.out.println("=== DATE CONVERSION TEST ===");
    for (String testDate : testDates) {
        String converted = convertDateFormat(testDate);
        System.out.println("Input: " + testDate + " -> Output: " + converted);
    }
    System.out.println("=== END TEST ===");
}

// Test method for manual testing
public void testBookingCreation() {
    // Simulate the exact data from screenshot
    String eventDate = "13/10/2025";
    String eventTime = "22:00";
    
    System.out.println("=== BOOKING CREATION TEST ===");
    System.out.println("Original eventDate: " + eventDate);
    System.out.println("Original eventTime: " + eventTime);
    
    String formattedEventDate = convertDateFormat(eventDate);
    System.out.println("Formatted eventDate: " + formattedEventDate);
    
    // Test if this would work in database
    System.out.println("Expected SQL format: YYYY-MM-DD");
    System.out.println("Actual format: " + formattedEventDate);
    System.out.println("Match: " + formattedEventDate.matches("\\d{4}-\\d{2}-\\d{2}"));
    System.out.println("=== END TEST ===");
}
