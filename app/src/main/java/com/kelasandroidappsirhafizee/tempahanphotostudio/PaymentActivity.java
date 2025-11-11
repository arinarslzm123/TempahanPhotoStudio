package com.kelasandroidappsirhafizee.tempahanphotostudio;

import android.content.Intent;
import android.os.Bundle;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

public class PaymentActivity extends AppCompatActivity {
    
    private TextView tvPackageName, tvSubPackage, tvEventDate, tvTotalAmount;
    private Button btnContinue;
    private String selectedPaymentMethod = "";
    private ImageButton btnBack;
    
    private BookingDetailsModel bookingDetails;
    private String userRole, username;
    private int userId;
    private ConnectionClass connectionClass;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_payment);

        // Get data from intent
        bookingDetails = (BookingDetailsModel) getIntent().getSerializableExtra("BOOKING_DETAILS");
        userRole = getIntent().getStringExtra("ROLE");
        username = getIntent().getStringExtra("USERNAME");
        userId = getIntent().getIntExtra("USER_ID", 1);
        
        // Initialize connection class
        connectionClass = new ConnectionClass();

        // Initialize views
        initializeViews();
        
        // ✅ Set default payment method to ToyyibPay (no user selection needed)
        selectedPaymentMethod = "ToyyibPay";

        System.out.println("DEBUG - PaymentActivity: Using ToyyibPay as default payment method");
        
        // Setup payment summary
        setupPaymentSummary();
        
        // Setup click listeners (only for back button and continue button)
        setupClickListeners();
    }

    private void initializeViews() {
        tvPackageName = findViewById(R.id.tvPackageName);
        tvSubPackage = findViewById(R.id.tvSubPackage);
        tvEventDate = findViewById(R.id.tvEventDate);
        tvTotalAmount = findViewById(R.id.tvTotalAmount);
        btnContinue = findViewById(R.id.btnContinue);
        btnBack = findViewById(R.id.btnBack);
    }

    @Override
    public void onBackPressed() {
        System.out.println("DEBUG - onBackPressed called in PaymentActivity");
        Toast.makeText(this, "Kembali ke halaman sebelumnya", Toast.LENGTH_SHORT).show();
        super.onBackPressed();
    }

    private void setupClickListeners() {
        btnBack.setOnClickListener(v -> {
            System.out.println("DEBUG - Back button clicked in PaymentActivity");
            Toast.makeText(this, "Kembali ke halaman sebelumnya", Toast.LENGTH_SHORT).show();
            finish();
        });

        btnContinue.setOnClickListener(v -> {
            // Payment method already set to ToyyibPay - no validation needed
            System.out.println("DEBUG - PaymentActivity: Continue button clicked, processing with ToyyibPay");
            
            if (bookingDetails == null) {
                Toast.makeText(this, "Booking details not found", Toast.LENGTH_SHORT).show();
                return;
            }
            
            // Process payment with ToyyibPay
            processPayment();
        });
    }

    private void setupPaymentSummary() {
        if (bookingDetails != null) {
            tvPackageName.setText(bookingDetails.getPackageName());
            tvSubPackage.setText(bookingDetails.getSubPackageName());
            tvEventDate.setText(bookingDetails.getEventDate());
            tvTotalAmount.setText("RM " + String.format("%.2f", bookingDetails.getPrice()));
        }
    }


    private void processPayment() {
        // Payment method is ToyyibPay
        String paymentInfo = "ToyyibPay";
        
        System.out.println("DEBUG - PaymentActivity processPayment: " + paymentInfo);
        Toast.makeText(this, "Memproses pembayaran melalui ToyyibPay...", Toast.LENGTH_SHORT).show();
        
        // Save booking to database
        if (bookingDetails != null) {
            saveBookingToDatabase(paymentInfo);
        } else {
            Toast.makeText(this, "Booking details not found", Toast.LENGTH_SHORT).show();
            finish(); // Close activity if no booking details
        }
    }
    
    private void saveBookingToDatabase(String paymentMethod) {
        new Thread(() -> {
            try {
                // Ensure bookings table exists
                boolean tableCreated = connectionClass.createBookingsTableIfNotExists();
                if (!tableCreated) {
                    runOnUiThread(() -> {
                        Toast.makeText(PaymentActivity.this, 
                                "Ralat: Gagal membuat table bookings", Toast.LENGTH_LONG).show();
                    });
                    return;
                }

                // Get package and sub-package IDs from booking details
                // We need to find the IDs based on the names
                PackageModel packageModel = connectionClass.getPackageByName(bookingDetails.getPackageName());
                SubPackageModel subPackageModel = connectionClass.getSubPackageByName(bookingDetails.getPackageClass());
                
                if (packageModel == null || subPackageModel == null) {
                    runOnUiThread(() -> {
                        Toast.makeText(PaymentActivity.this, 
                                "Ralat: Package atau sub-package tidak ditemui", Toast.LENGTH_LONG).show();
                    });
                    return;
                }

                // Create booking model
                BookingModel booking = new BookingModel();
                booking.setUserId(userId);
                booking.setPackageId(packageModel.getId());
                booking.setSubPackageId(subPackageModel.getId());
                booking.setBookingDate(new SimpleDateFormat("yyyy-MM-dd", Locale.getDefault()).format(new Date()));
                
                // Convert event date from DD/MM/YYYY to YYYY-MM-DD format
                String formattedEventDate = convertDateFormat(bookingDetails.getEventDate());
                booking.setEventDate(formattedEventDate);
                
                booking.setEventTime(bookingDetails.getEventTime());
                booking.setStatus("Unpaid"); // ✅ Set status to Unpaid (belum bayar)
                booking.setPrice(bookingDetails.getPrice());
                booking.setPaymentMethod(paymentMethod);
                booking.setPaymentStatus("Unpaid"); // ✅ Set payment status to Unpaid
                booking.setNotes("Tempahan dibuat melalui aplikasi - " + bookingDetails.getPackageClass());
                booking.setCreatedAt(new Date());

                // Debug logging
                System.out.println("DEBUG PaymentActivity - Saving booking:");
                System.out.println("User ID: " + userId);
                System.out.println("Package ID: " + packageModel.getId());
                System.out.println("Sub-Package ID: " + subPackageModel.getId());
                System.out.println("Event Date: " + formattedEventDate);
                System.out.println("Event Time: " + bookingDetails.getEventTime());
                System.out.println("Total Amount: " + bookingDetails.getPrice());
                System.out.println("Payment Method: " + paymentMethod);

                // Double-check for overlapping bookings before saving (safety measure)
                System.out.println("DEBUG PaymentActivity - Double-checking for overlapping bookings before save");
                System.out.println("DEBUG PaymentActivity - User ID: " + userId);
                System.out.println("DEBUG PaymentActivity - Event Date: " + formattedEventDate);
                System.out.println("DEBUG PaymentActivity - Event Time: " + bookingDetails.getEventTime());
                
                boolean hasOverlap = connectionClass.checkOverlappingBooking(userId, formattedEventDate, bookingDetails.getEventTime());
                if (hasOverlap) {
                    System.out.println("DEBUG PaymentActivity - OVERLAP DETECTED! Preventing save.");
                    runOnUiThread(() -> {
                        Toast.makeText(PaymentActivity.this, 
                                "Tempahan pada tarikh dan masa ini sudah wujud. Anda tidak boleh membuat tempahan bertindih pada tarikh dan masa yang sama. Sila pilih tarikh atau masa lain.", 
                                Toast.LENGTH_LONG).show();
                    });
                    return;
                }
                
                System.out.println("DEBUG PaymentActivity - No overlap detected, proceeding with save.");

                // Save to database (this will also check for overlaps internally)
                String result = connectionClass.addBooking(booking);
                
                runOnUiThread(() -> {
                    // Check if result contains error about overlapping
                    if (result != null && result.contains("Error:") && result.contains("tarikh dan masa")) {
                        Toast.makeText(PaymentActivity.this, result.replace("Error: ", ""), Toast.LENGTH_LONG).show();
                        return;
                    }
                    
                    if ("success".equals(result) || result.contains("successfully")) {
                        Toast.makeText(PaymentActivity.this, 
                                "Tempahan berjaya dibuat!\nPakej: " + bookingDetails.getPackageName() + 
                                "\nSub Package: " + bookingDetails.getPackageClass() + 
                                "\nHarga: RM " + String.format("%.2f", bookingDetails.getPrice()) +
                                "\nTarikh: " + bookingDetails.getEventDate() + "\nMasa: " + bookingDetails.getEventTime() +
                                "\n\nStatus: Unpaid - Sila buat pembayaran", 
                                Toast.LENGTH_LONG).show();
                        
                        // Update booking details with payment method and booking date
                        bookingDetails.setPaymentMethod(paymentMethod);
                        bookingDetails.setPaymentStatus("Unpaid"); // ✅ Set to Unpaid
                        bookingDetails.setStatus("Unpaid"); // ✅ Set to Unpaid
                        
                        // Set booking date (today's date when booking is made)
                        bookingDetails.setBookingDate(booking.getBookingDate());
                        bookingDetails.setCreatedAt(new Date()); // Also set createdAt for InvoiceActivity
                        
                        // Navigate to invoice
                        Intent intent = new Intent(PaymentActivity.this, InvoiceActivity.class);
                        intent.putExtra("BOOKING_DETAILS", bookingDetails);
                        intent.putExtra("USER_ID", userId);
                        intent.putExtra("ROLE", userRole);
                        intent.putExtra("USERNAME", username);
                        startActivity(intent);
                        finish();
                    } else {
                        Toast.makeText(PaymentActivity.this, 
                                "Gagal menyimpan tempahan: " + result, Toast.LENGTH_LONG).show();
                    }
                });
            } catch (Exception e) {
                e.printStackTrace();
                runOnUiThread(() -> {
                    Toast.makeText(PaymentActivity.this, 
                            "Ralat menyimpan tempahan: " + e.getMessage(), Toast.LENGTH_LONG).show();
                });
            }
        }).start();
    }
    
    private String convertDateFormat(String inputDate) {
        try {
            // Input format: DD/MM/YYYY (e.g., "13/10/2025")
            // Output format: YYYY-MM-DD (e.g., "2025-10-13")
            String[] parts = inputDate.split("/");
            if (parts.length == 3) {
                String day = parts[0].trim();
                String month = parts[1].trim();
                String year = parts[2].trim();
                
                // Pad with zeros if needed
                if (day.length() == 1) day = "0" + day;
                if (month.length() == 1) month = "0" + month;
                
                String result = year + "-" + month + "-" + day;
                System.out.println("DEBUG PaymentActivity convertDateFormat - Input: " + inputDate + " -> Output: " + result);
                return result;
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("DEBUG PaymentActivity convertDateFormat - Error converting: " + inputDate + " - " + e.getMessage());
        }
        // Return original date if conversion fails
        System.out.println("DEBUG PaymentActivity convertDateFormat - Conversion failed, returning original: " + inputDate);
        return inputDate;
    }
}