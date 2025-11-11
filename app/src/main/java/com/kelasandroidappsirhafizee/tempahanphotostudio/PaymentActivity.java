package com.kelasandroidappsirhafizee.tempahanphotostudio;

import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Patterns;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;
import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.contract.ActivityResultContracts;

import com.kelasandroidappsirhafizee.tempahanphotostudio.payment.ToyyibPayRepository;
import com.kelasandroidappsirhafizee.tempahanphotostudio.payment.requests.CreateBillRequest;
import com.kelasandroidappsirhafizee.tempahanphotostudio.payment.responses.CreateBillResponse;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.UUID;

/**
 * Payment confirmation and ToyyibPay integration activity
 * Copied and adapted from MizrahBeauty project
 */
public class PaymentActivity extends AppCompatActivity {
    
    // UI Components
    private TextView tvPackageName, tvSubPackage, tvEventDate, tvTotalAmount;
    private EditText etCustomerName, etCustomerEmail, etCustomerPhone;
    private Button btnContinue;
    private ImageButton btnBack;
    private ProgressBar progressBar;
    
    // Data
    private BookingDetailsModel bookingDetails;
    private String userRole, username;
    private int userId;
    private ConnectionClass connectionClass;
    private ToyyibPayRepository toyyibPayRepository;
    
    // Payment configuration
    private static final String TOYYIB_RETURN_URL = "tempahanphotostudio://payment/result";
    private static final String TOYYIB_CALLBACK_URL = "https://tempahanphotostudio.onrender.com/toyyibpay/callback";
    
    private String currentBillCode;
    private ActivityResultLauncher<Intent> paymentLauncher;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_payment);

        // Get data from intent
        bookingDetails = (BookingDetailsModel) getIntent().getSerializableExtra("BOOKING_DETAILS");
        userRole = getIntent().getStringExtra("ROLE");
        username = getIntent().getStringExtra("USERNAME");
        userId = getIntent().getIntExtra("USER_ID", 1);
        
        // Initialize connection class and repository
        connectionClass = new ConnectionClass();
        toyyibPayRepository = new ToyyibPayRepository();
        
        // Setup payment result launcher
        setupPaymentLauncher();

        // Initialize views
        initializeViews();
        
        // Setup payment summary and customer info
        setupPaymentSummary();
        populateCustomerInfo();
        
        // Setup click listeners
        setupClickListeners();
    }
    
    private void setupPaymentLauncher() {
        paymentLauncher = registerForActivityResult(
            new ActivityResultContracts.StartActivityForResult(),
            result -> {
                android.util.Log.d("ToyyibPay", "Payment WebView returned with result code: " + result.getResultCode());
                
                if (result.getResultCode() == RESULT_OK && result.getData() != null) {
                    Intent data = result.getData();
                    String status = data.getStringExtra(PaymentWebViewActivity.RESULT_EXTRA_STATUS);
                    String billCode = data.getStringExtra(PaymentWebViewActivity.RESULT_EXTRA_BILL_CODE);
                    String statusId = data.getStringExtra("status_id");
                    String msg = data.getStringExtra("msg");
                    String reason = data.getStringExtra("reason");
                    String transactionId = data.getStringExtra("transaction_id");
                    
                    android.util.Log.d("ToyyibPay", "Payment result - Status: " + status + ", BillCode: " + billCode);
                    
                    if ("SUCCESS".equals(status)) {
                        // Payment successful - save booking and navigate to invoice
                        Toast.makeText(this, "Payment successful!", Toast.LENGTH_SHORT).show();
                        saveBookingToDatabase("ToyyibPay", "Paid", billCode, transactionId);
                        
                        // ===== SUPABASE INTEGRATION (COMMENTED OUT AS REQUESTED) =====
                        // TODO: Save payment transaction to Supabase
                        // savePaymentToSupabase(billCode, transactionId, statusId, msg, reason, status);
                        // ============================================================
                        
                    } else if ("PENDING".equals(status)) {
                        Toast.makeText(this, "Payment pending. Please wait for confirmation.", Toast.LENGTH_SHORT).show();
                        saveBookingToDatabase("ToyyibPay", "Pending", billCode, transactionId);
                    } else {
                        Toast.makeText(this, "Payment " + status.toLowerCase() + ": " + (reason != null ? reason : msg), Toast.LENGTH_LONG).show();
                    }
                } else if (result.getResultCode() == RESULT_CANCELED) {
                    android.util.Log.d("ToyyibPay", "Payment cancelled by user");
                    Toast.makeText(this, "Payment cancelled", Toast.LENGTH_SHORT).show();
                }
            }
        );
    }

    private void initializeViews() {
        tvPackageName = findViewById(R.id.tvPackageName);
        tvSubPackage = findViewById(R.id.tvSubPackage);
        tvEventDate = findViewById(R.id.tvEventDate);
        tvTotalAmount = findViewById(R.id.tvTotalAmount);
        
        etCustomerName = findViewById(R.id.etCustomerName);
        etCustomerEmail = findViewById(R.id.etCustomerEmail);
        etCustomerPhone = findViewById(R.id.etCustomerPhone);
        
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
            // Validate form and initiate payment
            if (validateCustomerInfo()) {
                initiateToyyibPayFlow();
            }
        });
    }

    private void setupPaymentSummary() {
        if (bookingDetails != null) {
            tvPackageName.setText(bookingDetails.getPackageName());
            tvSubPackage.setText(bookingDetails.getSubPackageName());
            tvEventDate.setText(bookingDetails.getEventDate() + " " + bookingDetails.getEventTime());
            tvTotalAmount.setText("RM " + String.format("%.2f", bookingDetails.getPrice()));
        }
    }
    
    private void populateCustomerInfo() {
        // Get user info from session if available
        UserSessionManager sessionManager = new UserSessionManager(this);
        if (sessionManager.isLoggedIn()) {
            String sessionUsername = sessionManager.getUsername();
            String sessionEmail = sessionManager.getUserEmail();
            String sessionPhone = sessionManager.getPhone();
            
            if (!TextUtils.isEmpty(sessionUsername)) {
                etCustomerName.setText(sessionUsername);
            }
            if (!TextUtils.isEmpty(sessionEmail)) {
                etCustomerEmail.setText(sessionEmail);
            }
            if (!TextUtils.isEmpty(sessionPhone)) {
                etCustomerPhone.setText(sessionPhone);
            }
        }
    }
    
    private boolean validateCustomerInfo() {
        String name = etCustomerName.getText().toString().trim();
        String email = etCustomerEmail.getText().toString().trim();
        String phone = etCustomerPhone.getText().toString().trim();
        
        if (TextUtils.isEmpty(name)) {
            etCustomerName.setError("Name is required");
            etCustomerName.requestFocus();
            return false;
        }
        
        if (TextUtils.isEmpty(email)) {
            etCustomerEmail.setError("Email is required");
            etCustomerEmail.requestFocus();
            return false;
        }
        
        if (!Patterns.EMAIL_ADDRESS.matcher(email).matches()) {
            etCustomerEmail.setError("Please enter a valid email");
            etCustomerEmail.requestFocus();
            return false;
        }
        
        if (TextUtils.isEmpty(phone)) {
            etCustomerPhone.setError("Phone number is required");
            etCustomerPhone.requestFocus();
            return false;
        }
        
        return true;
    }
    
    private void initiateToyyibPayFlow() {
        if (bookingDetails == null) {
            Toast.makeText(this, "Booking details not found", Toast.LENGTH_SHORT).show();
            return;
        }
        
        String customerName = etCustomerName.getText().toString().trim();
        String customerEmail = etCustomerEmail.getText().toString().trim();
        String customerPhone = etCustomerPhone.getText().toString().trim();
        double amount = bookingDetails.getPrice();
        
        String description = "Booking: " + bookingDetails.getPackageName() + 
                           " - " + bookingDetails.getSubPackageName() + 
                           " on " + bookingDetails.getEventDate();
        
        String referenceId = UUID.randomUUID().toString();
        
        btnContinue.setEnabled(false);
        btnContinue.setText("Creating payment...");
        
        CreateBillRequest request = new CreateBillRequest(
                amount,
                description,
                customerName,
                customerEmail,
                customerPhone,
                referenceId,
                TOYYIB_RETURN_URL,
                TOYYIB_CALLBACK_URL
        );
        
        android.util.Log.d("ToyyibPay", "Creating bill with amount: RM " + amount);
        
        toyyibPayRepository.createBill(request, new ToyyibPayRepository.CreateBillCallback() {
            @Override
            public void onSuccess(CreateBillResponse response) {
                btnContinue.setEnabled(true);
                btnContinue.setText("Proceed to Payment");
                
                currentBillCode = response.getBillCode();
                android.util.Log.d("ToyyibPay", "Bill created successfully: " + currentBillCode);
                android.util.Log.d("ToyyibPay", "Payment URL: " + response.getPaymentUrl());
                
                if (!TextUtils.isEmpty(response.getPaymentUrl())) {
                    // Launch WebView for payment
                    Intent intent = new Intent(PaymentActivity.this, PaymentWebViewActivity.class);
                    intent.putExtra(PaymentWebViewActivity.EXTRA_PAYMENT_URL, response.getPaymentUrl());
                    intent.putExtra(PaymentWebViewActivity.EXTRA_RETURN_URL, TOYYIB_RETURN_URL);
                    intent.putExtra(PaymentWebViewActivity.EXTRA_BILL_CODE, currentBillCode);
                    paymentLauncher.launch(intent);
                } else {
                    Toast.makeText(PaymentActivity.this, "Payment URL not available", Toast.LENGTH_SHORT).show();
                }
            }

            @Override
            public void onError(Throwable t) {
                btnContinue.setEnabled(true);
                btnContinue.setText("Proceed to Payment");
                
                android.util.Log.e("ToyyibPay", "Error creating bill", t);
                Toast.makeText(PaymentActivity.this, 
                    "Error creating payment: " + t.getMessage() + 
                    "\n\nPlease ensure backend service is running at: " + TOYYIB_CALLBACK_URL, 
                    Toast.LENGTH_LONG).show();
            }
        });
    }

    private void saveBookingToDatabase(String paymentMethod, String paymentStatus, String billCode, String transactionId) {
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
                booking.setStatus(paymentStatus);
                booking.setPrice(bookingDetails.getPrice());
                booking.setPaymentMethod(paymentMethod + " (Bill: " + billCode + ")");
                booking.setPaymentStatus(paymentStatus);
                booking.setNotes("ToyyibPay Transaction ID: " + transactionId + " - " + bookingDetails.getPackageClass());
                booking.setCreatedAt(new Date());

                // Debug logging
                System.out.println("DEBUG PaymentActivity - Saving booking:");
                System.out.println("User ID: " + userId);
                System.out.println("Package ID: " + packageModel.getId());
                System.out.println("Sub-Package ID: " + subPackageModel.getId());
                System.out.println("Event Date: " + formattedEventDate);
                System.out.println("Payment Status: " + paymentStatus);
                System.out.println("Bill Code: " + billCode);

                // Save to database
                String result = connectionClass.addBooking(booking);
                
                runOnUiThread(() -> {
                    if ("success".equals(result) || result.contains("successfully")) {
                        // Update booking details
                        bookingDetails.setPaymentMethod(paymentMethod);
                        bookingDetails.setPaymentStatus(paymentStatus);
                        bookingDetails.setStatus(paymentStatus);
                        bookingDetails.setBookingDate(booking.getBookingDate());
                        bookingDetails.setCreatedAt(new Date());
                        
                        // Navigate to invoice
                        Intent intent = new Intent(PaymentActivity.this, InvoiceActivity.class);
                        intent.putExtra("BOOKING_DETAILS", bookingDetails);
                        intent.putExtra("USER_ID", userId);
                        intent.putExtra("ROLE", userRole);
                        intent.putExtra("USERNAME", username);
                        intent.putExtra("BILL_CODE", billCode);
                        intent.putExtra("TRANSACTION_ID", transactionId);
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
    
    // ===== SUPABASE INTEGRATION METHOD (COMMENTED OUT AS REQUESTED) =====
    /*
    private void savePaymentToSupabase(String billCode, String transactionId, 
                                       String statusId, String msg, String reason, String status) {
        // TODO: Implement Supabase payment transaction saving
        // This should save to the payment_transactions table you created in Supabase
        
        // Example structure:
        // PaymentTransaction transaction = new PaymentTransaction();
        // transaction.setBillCode(billCode);
        // transaction.setTransactionId(transactionId);
        // transaction.setOrderId(bookingDetails reference);
        // transaction.setPaymentStatus(status);
        // transaction.setAmount(bookingDetails.getPrice());
        // transaction.setCustomerName(etCustomerName.getText().toString());
        // transaction.setCustomerEmail(etCustomerEmail.getText().toString());
        // transaction.setCustomerPhone(etCustomerPhone.getText().toString());
        // transaction.setServiceName(bookingDetails.getPackageName() + " - " + bookingDetails.getSubPackageName());
        // transaction.setTransactionTime(new Date());
        
        // SupabaseClient.savePaymentTransaction(transaction, callback);
        
        android.util.Log.d("ToyyibPay", "Supabase integration not implemented yet");
    }
    */
    // ====================================================================
    
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
