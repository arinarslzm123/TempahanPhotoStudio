package com.kelasandroidappsirhafizee.tempahanphotostudio;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import java.text.SimpleDateFormat;
import java.util.Locale;

public class InvoiceActivity extends AppCompatActivity {
    
    private TextView tvPackageName, tvSubPackage, tvTotalAmount, 
                     tvEventDate, tvEventTime, tvPaymentMethod, tvBookingDate;
    private Button btnBackToDashboard, btnProceedToPayment;
    private ImageButton btnMenu;
    
    private BookingDetailsModel bookingDetails;
    private String userRole, username;
    private int userId;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_invoice);

        // Get data from intent
        bookingDetails = (BookingDetailsModel) getIntent().getSerializableExtra("BOOKING_DETAILS");
        userRole = getIntent().getStringExtra("ROLE");
        username = getIntent().getStringExtra("USERNAME");
        userId = getIntent().getIntExtra("USER_ID", 1);

        // Initialize views
        initializeViews();
        
        // Setup click listeners
        setupClickListeners();
        
        // Populate invoice data
        populateInvoiceData();
    }

    private void initializeViews() {
        tvPackageName = findViewById(R.id.tvPackageName);
        tvSubPackage = findViewById(R.id.tvSubPackage);
        tvTotalAmount = findViewById(R.id.tvTotalAmount);
        tvEventDate = findViewById(R.id.tvEventDate);
        tvEventTime = findViewById(R.id.tvEventTime);
        tvPaymentMethod = findViewById(R.id.tvPaymentMethod);
        tvBookingDate = findViewById(R.id.tvBookingDate);
        
        btnBackToDashboard = findViewById(R.id.btnBackToDashboard);
        btnProceedToPayment = findViewById(R.id.btnProceedToPayment);
        btnMenu = findViewById(R.id.btnMenu);
    }

    private void setupClickListeners() {
        btnBackToDashboard.setOnClickListener(v -> {
            Intent intent = new Intent(this, Dashboard.class);
            intent.putExtra("ROLE", userRole);
            intent.putExtra("USERNAME", username);
            intent.putExtra("USER_ID", userId);
            startActivity(intent);
            finish();
        });

        btnProceedToPayment.setOnClickListener(v -> {
            // Open ToyyibPay website
            String toyyibpayUrl = "https://toyyibpay.com";
            
            try {
                Intent browserIntent = new Intent(Intent.ACTION_VIEW, Uri.parse(toyyibpayUrl));
                startActivity(browserIntent);
                Toast.makeText(this, "Membuka ToyyibPay...", Toast.LENGTH_SHORT).show();
            } catch (Exception e) {
                Toast.makeText(this, "Ralat membuka ToyyibPay: " + e.getMessage(), Toast.LENGTH_LONG).show();
                e.printStackTrace();
            }
        });

        btnMenu.setOnClickListener(v -> {
            // Show menu options (optional)
            // Could add options like Print, Share, etc.
        });
    }

    private void populateInvoiceData() {
        if (bookingDetails != null) {
            // Package details
            tvPackageName.setText(bookingDetails.getPackageName() != null ? 
                bookingDetails.getPackageName() : "N/A");
            
            tvSubPackage.setText(bookingDetails.getPackageClass() != null ? 
                bookingDetails.getPackageClass() + " Package" : "N/A");
            
            // Amount
            tvTotalAmount.setText("RM " + String.format("%.2f", bookingDetails.getPrice()));
            
            // Event details
            tvEventDate.setText(bookingDetails.getEventDate() != null ? 
                bookingDetails.getEventDate() : "N/A");
            
            tvEventTime.setText(bookingDetails.getEventTime() != null ? 
                bookingDetails.getEventTime() : "N/A");
            
            // Payment details
            tvPaymentMethod.setText(bookingDetails.getPaymentMethod() != null ? 
                bookingDetails.getPaymentMethod() : "N/A");
            
            // Booking date - try multiple sources
            String bookingDateText = "N/A";
            
            // First try: Use createdAt (Date object)
            if (bookingDetails.getCreatedAt() != null) {
                SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy", Locale.getDefault());
                bookingDateText = dateFormat.format(bookingDetails.getCreatedAt());
            } 
            // Second try: Use bookingDate (String - format: yyyy-MM-dd)
            else if (bookingDetails.getBookingDate() != null && !bookingDetails.getBookingDate().isEmpty()) {
                try {
                    // Convert from yyyy-MM-dd to dd/MM/yyyy
                    String bookingDate = bookingDetails.getBookingDate();
                    String[] parts = bookingDate.split("-");
                    if (parts.length == 3) {
                        bookingDateText = parts[2] + "/" + parts[1] + "/" + parts[0];
                    } else {
                        bookingDateText = bookingDate; // Use as-is if format is different
                    }
                } catch (Exception e) {
                    bookingDateText = bookingDetails.getBookingDate(); // Use as-is if conversion fails
                }
            }
            
            tvBookingDate.setText(bookingDateText);
            
        } else {
            // Fallback data if booking details is null
            tvPackageName.setText("N/A");
            tvSubPackage.setText("N/A");
            tvTotalAmount.setText("RM 0.00");
            tvEventDate.setText("N/A");
            tvEventTime.setText("N/A");
            tvPaymentMethod.setText("N/A");
            tvBookingDate.setText("N/A");
        }
    }
}