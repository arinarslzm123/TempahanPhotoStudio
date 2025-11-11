package com.kelasandroidappsirhafizee.tempahanphotostudio;

import android.app.AlertDialog;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import java.sql.Connection;
import java.util.ArrayList;
import java.util.Date;

public class HistoryActivity extends AppCompatActivity {
    private Button btnUpcoming, btnPast, btnRefresh;
    private RecyclerView recyclerViewBookings;
    private LinearLayout layoutEmptyState;
    private Spinner spinnerStatusFilter;
    private TextView tvEmptyMessage;
    private ConnectionClass connectionClass;
    private ArrayList<BookingDetailsModel> allBookings;
    private ArrayList<BookingDetailsModel> upcomingBookings;
    private ArrayList<BookingDetailsModel> pastBookings;
    private ArrayList<BookingDetailsModel> filteredBookings;
    private BookingHistoryAdapter adapter;
    private String currentTab = "upcoming";
    private int userId;
    private String userRole;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_history);

        // Get user ID and role from intent
        userId = getIntent().getIntExtra("USER_ID", 1); // Default to 1 if not provided
        userRole = getIntent().getStringExtra("ROLE"); // Get user role
        
        // Validate user ID and role
        if (userId <= 0) {
            Toast.makeText(this, "ID pengguna tidak sah", Toast.LENGTH_LONG).show();
            finish();
            return;
        }
        
        if (userRole == null || userRole.trim().isEmpty()) {
            Toast.makeText(this, "Peranan pengguna tidak sah", Toast.LENGTH_LONG).show();
            finish();
            return;
        }
        
        // Debug logging
        System.out.println("DEBUG HistoryActivity - Received User ID: " + userId);
        System.out.println("DEBUG HistoryActivity - Received Role: '" + userRole + "'");
        System.out.println("DEBUG HistoryActivity - Received Username: " + getIntent().getStringExtra("USERNAME"));
        System.out.println("DEBUG HistoryActivity - Role is null: " + (userRole == null));
        System.out.println("DEBUG HistoryActivity - Role length: " + (userRole != null ? userRole.length() : "null"));
        System.out.println("DEBUG HistoryActivity - Role equals 'Admin': " + "Admin".equals(userRole));
        System.out.println("DEBUG HistoryActivity - Role equals 'User': " + "User".equals(userRole));
        System.out.println("DEBUG HistoryActivity - Intent has USER_ID extra: " + getIntent().hasExtra("USER_ID"));
        System.out.println("DEBUG HistoryActivity - Intent has ROLE extra: " + getIntent().hasExtra("ROLE"));
        System.out.println("DEBUG HistoryActivity - Intent has USERNAME extra: " + getIntent().hasExtra("USERNAME"));

        // Initialize views
        btnUpcoming = findViewById(R.id.btnUpcoming);
        btnPast = findViewById(R.id.btnPast);
        btnRefresh = findViewById(R.id.btnRefresh);
        recyclerViewBookings = findViewById(R.id.recyclerViewBookings);
        layoutEmptyState = findViewById(R.id.layoutEmptyState);
        spinnerStatusFilter = findViewById(R.id.spinnerStatusFilter);
        tvEmptyMessage = findViewById(R.id.tvEmptyMessage);

        // Initialize connection class
        connectionClass = new ConnectionClass();

        // Setup RecyclerView
        recyclerViewBookings.setLayoutManager(new LinearLayoutManager(this));

        // Setup status filter
        setupStatusFilter();

        // Setup click listeners
        btnUpcoming.setOnClickListener(v -> switchTab("upcoming"));
        btnPast.setOnClickListener(v -> switchTab("past"));
        btnRefresh.setOnClickListener(v -> loadBookings());
        

        // Setup back button
        findViewById(R.id.btnBack).setOnClickListener(v -> finish());

        // Initialize arrays
        allBookings = new ArrayList<>();
        upcomingBookings = new ArrayList<>();
        pastBookings = new ArrayList<>();
        filteredBookings = new ArrayList<>();

        // Load bookings
        loadBookings();
    }

    private void setupStatusFilter() {
        // ✅ Updated to use Paid/Unpaid/Cancelled statuses
        String[] statusOptions = {"Semua", "Unpaid", "Paid", "Cancelled"};
        ArrayAdapter<String> adapter = new ArrayAdapter<>(this, 
            android.R.layout.simple_spinner_item, statusOptions);
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinnerStatusFilter.setAdapter(adapter);

        spinnerStatusFilter.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                filterBookings();
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {}
        });
    }

    private void loadBookings() {
        new Thread(() -> {
            try {
                System.out.println("=== LOADING BOOKINGS (USER-SPECIFIC) ===");
                System.out.println("User ID: " + userId);
                System.out.println("User Role: " + userRole);
                System.out.println("DEBUG - Current user trying to load bookings: " + userId);
                
                // Test database connection first
                System.out.println("Testing database connection...");
                Connection testConn = connectionClass.CONN();
                if (testConn == null) {
                    System.out.println("ERROR: Database connection failed!");
            runOnUiThread(() -> {
                    showEmptyState();
                        Toast.makeText(this, "Sambungan database gagal", Toast.LENGTH_LONG).show();
                    });
                    return;
                } else {
                    System.out.println("Database connection successful!");
                    try { testConn.close(); } catch (Exception e) {}
                }
                
                // Load bookings based on user role
                ArrayList<BookingModel> allBookingsFromDB;
                System.out.println("DEBUG - Checking user role: '" + userRole + "'");
                System.out.println("DEBUG - Role comparison 'Admin'.equals(userRole): " + "Admin".equals(userRole));
                System.out.println("DEBUG - Role comparison userRole.equals('Admin'): " + (userRole != null && userRole.equals("Admin")));
                
                if ("Admin".equals(userRole)) {
                    // Admin can see all bookings
                    System.out.println("DEBUG - Loading ALL bookings for Admin");
                    allBookingsFromDB = connectionClass.getAllBookings();
                    System.out.println("Admin view - Total bookings in database: " + (allBookingsFromDB != null ? allBookingsFromDB.size() : "NULL"));
                } else {
                    // Regular users can only see their own bookings
                    System.out.println("DEBUG - Loading USER-SPECIFIC bookings for User ID: " + userId);
                    allBookingsFromDB = connectionClass.getBookingsByUserId(userId);
                    System.out.println("User view - User's bookings: " + (allBookingsFromDB != null ? allBookingsFromDB.size() : "NULL"));
                    
                    // Additional debug: Check if user exists in database
                    System.out.println("DEBUG - Checking if user exists in database...");
                    if (connectionClass.getUserById(userId) != null) {
                        System.out.println("DEBUG - User found in database");
                    } else {
                        System.out.println("DEBUG - User NOT found in database");
                    }
                }
                
                if (allBookingsFromDB != null && !allBookingsFromDB.isEmpty()) {
                    System.out.println("Converting database bookings to display format...");
                    
                    // Convert to BookingDetailsModel
                    ArrayList<BookingDetailsModel> convertedBookings = new ArrayList<>();
                    for (BookingModel booking : allBookingsFromDB) {
                        BookingDetailsModel details = new BookingDetailsModel();
                        details.setBookingId(booking.getId());
                        details.setUserId(booking.getUserId());
                        details.setPackageId(booking.getPackageId());
                        details.setEventDate(booking.getEventDate());
                        details.setStatus(booking.getStatus());
                        details.setPrice(booking.getPrice());
                        details.setPaymentMethod(booking.getPaymentMethod());
                        details.setPaymentStatus(booking.getPaymentStatus());
                        details.setNotes(booking.getNotes());
                        details.setCreatedAt(booking.getCreatedAt());
                        
                        // Set default values for missing fields
                        details.setPackageName("Package " + booking.getPackageId());
                        details.setCategory("Videography");
                        details.setEvent("Wedding");
                        details.setDuration("8 hours");
                        details.setPackageClass("Regular");
                        details.setPrice(1200.00);
                        
                        convertedBookings.add(details);
                    }
                    
                    runOnUiThread(() -> {
                        allBookings.clear();
                        allBookings.addAll(convertedBookings);
                        
                separateBookings();
                        filterBookings();
                        showFilteredBookings();
                        
                        Toast.makeText(this, "Dimuatkan " + convertedBookings.size() + " tempahan dari database", Toast.LENGTH_LONG).show();
                    });
                    
                } else {
                    System.out.println("No bookings found in database");
                    
                    // Additional debug: Check total bookings in database
                    System.out.println("DEBUG - Checking total bookings in database...");
                    ArrayList<BookingModel> allBookingsInDB = connectionClass.getAllBookings();
                    System.out.println("DEBUG - Total bookings in database: " + (allBookingsInDB != null ? allBookingsInDB.size() : "NULL"));
                    
                    if (allBookingsInDB != null && !allBookingsInDB.isEmpty()) {
                        System.out.println("DEBUG - Database has bookings but user-specific query returned empty");
                        for (BookingModel booking : allBookingsInDB) {
                            System.out.println("DEBUG - Booking ID: " + booking.getId() + ", User ID: " + booking.getUserId() + ", Status: " + booking.getStatus());
                        }
                    } else {
                        System.out.println("DEBUG - Database is completely empty");
                    }
                    
                    runOnUiThread(() -> {
                        showEmptyState();
                        Toast.makeText(this, "Tiada tempahan dijumpai", Toast.LENGTH_LONG).show();
                    });
                }
                
            } catch (Exception e) {
                e.printStackTrace();
                System.out.println("Error loading bookings: " + e.getMessage());
                runOnUiThread(() -> {
                    showEmptyState();
                    Toast.makeText(this, "Ralat database: " + e.getMessage(), Toast.LENGTH_LONG).show();
                });
            }
        }).start();
    }

    private void separateBookings() {
        upcomingBookings = new ArrayList<>();
        pastBookings = new ArrayList<>();
        
        for (BookingDetailsModel booking : allBookings) {
            // ✅ Upcoming = Unpaid (belum bayar)
            // ✅ Past = Paid (sudah bayar)
            String status = booking.getStatus();
            
            if (status != null && status.equalsIgnoreCase("Unpaid")) {
                // Unpaid bookings go to Upcoming
                    upcomingBookings.add(booking);
                System.out.println("DEBUG - Booking ID " + booking.getBookingId() + " added to Upcoming (Unpaid)");
            } else if (status != null && status.equalsIgnoreCase("Paid")) {
                // Paid bookings go to Past
                pastBookings.add(booking);
                System.out.println("DEBUG - Booking ID " + booking.getBookingId() + " added to Past (Paid)");
            } else if (status != null && status.equalsIgnoreCase("Cancelled")) {
                // Cancelled bookings go to Past
                pastBookings.add(booking);
                System.out.println("DEBUG - Booking ID " + booking.getBookingId() + " added to Past (Cancelled)");
            } else {
                // Default: unknown status goes to Upcoming
                upcomingBookings.add(booking);
                System.out.println("DEBUG - Booking ID " + booking.getBookingId() + " added to Upcoming (default, status=" + status + ")");
            }
        }
        
        System.out.println("DEBUG - separateBookings: Upcoming=" + upcomingBookings.size() + ", Past=" + pastBookings.size());
    }

    private void filterBookings() {
        String selectedStatus = spinnerStatusFilter.getSelectedItem().toString();
        ArrayList<BookingDetailsModel> sourceList;
        
        if (currentTab.equals("upcoming")) {
            sourceList = upcomingBookings;
        } else {
            sourceList = pastBookings;
        }
        
        filteredBookings.clear();
        
        if ("Semua".equals(selectedStatus)) {
            filteredBookings.addAll(sourceList);
        } else {
            for (BookingDetailsModel booking : sourceList) {
                if (selectedStatus.equals(booking.getStatus())) {
                    filteredBookings.add(booking);
                }
            }
        }
        
        showFilteredBookings();
    }

    private void switchTab(String tab) {
        currentTab = tab;
        
        // Update button states
        if (tab.equals("upcoming")) {
            btnUpcoming.setSelected(true);
            btnPast.setSelected(false);
        } else {
            btnUpcoming.setSelected(false);
            btnPast.setSelected(true);
        }
        
        // Apply current filter
        filterBookings();
    }

    private void showFilteredBookings() {
        if (filteredBookings == null || filteredBookings.isEmpty()) {
            showEmptyState();
        } else {
            hideEmptyState();
            adapter = new BookingHistoryAdapter(filteredBookings, this::onBookingClick, this::onBookingAction, userRole);
            recyclerViewBookings.setAdapter(adapter);
        }
    }

    private void showEmptyState() {
        layoutEmptyState.setVisibility(View.VISIBLE);
        recyclerViewBookings.setVisibility(View.GONE);
    }

    private void hideEmptyState() {
        layoutEmptyState.setVisibility(View.GONE);
        recyclerViewBookings.setVisibility(View.VISIBLE);
    }

    private void onBookingClick(BookingDetailsModel booking) {
        // Navigate to invoice activity
        Intent intent = new Intent(this, InvoiceActivity.class);
        intent.putExtra("BOOKING_DETAILS", booking);
        intent.putExtra("USER_ID", userId);
        intent.putExtra("ROLE", userRole);
        intent.putExtra("USERNAME", getIntent().getStringExtra("USERNAME"));
        startActivity(intent);
    }

    private void onBookingAction(BookingDetailsModel booking, String action) {
        switch (action) {
            case "confirm":
                confirmBooking(booking);
                break;
            case "cancel":
                cancelBooking(booking);
                break;
            case "view":
                showBookingDetailsDialog(booking);
                break;
        }
    }

    private void confirmBooking(BookingDetailsModel booking) {
        // Only admin can confirm bookings
        if (!"Admin".equals(userRole)) {
            Toast.makeText(this, "Hanya admin boleh mengesahkan tempahan", Toast.LENGTH_SHORT).show();
            return;
        }
        
        new AlertDialog.Builder(this)
                .setTitle("Sahkan Tempahan")
                .setMessage("Adakah anda pasti mahu sahkan tempahan ini?\n\n" +
                           "Tempahan ID: " + booking.getBookingId() + "\n" +
                           "Pakej: " + booking.getPackageName() + "\n" +
                           "Tarikh Acara: " + booking.getEventDate() + "\n\n" +
                           "Nota: Tempahan yang disahkan akan berubah status kepada 'Confirmed'.")
                .setPositiveButton("Ya, Sahkan", (dialog, which) -> {
                    new Thread(() -> {
                        boolean success = connectionClass.confirmBooking(booking.getBookingId());
                        runOnUiThread(() -> {
                            if (success) {
                                Toast.makeText(this, "Tempahan berjaya disahkan", Toast.LENGTH_SHORT).show();
                                loadBookings(); // Refresh list
                            } else {
                                Toast.makeText(this, "Gagal mengesahkan tempahan", Toast.LENGTH_SHORT).show();
                            }
                        });
                    }).start();
                })
                .setNegativeButton("Batal", null)
                .show();
    }

    private void cancelBooking(BookingDetailsModel booking) {
        // Check if user can cancel this booking
        if ("Pending".equals(booking.getStatus())) {
            // Both admin and user can cancel pending bookings
            // No additional check needed
        } else if ("Confirmed".equals(booking.getStatus())) {
            // Cannot cancel confirmed bookings (already confirmed by admin)
            Toast.makeText(this, "Tempahan yang telah disahkan tidak boleh dibatalkan", Toast.LENGTH_SHORT).show();
            return;
        } else {
            // Cannot cancel completed or already cancelled bookings
            Toast.makeText(this, "Tempahan ini tidak boleh dibatalkan", Toast.LENGTH_SHORT).show();
            return;
        }
        
        new AlertDialog.Builder(this)
                .setTitle("Batalkan Tempahan")
                .setMessage("Adakah anda pasti mahu batalkan tempahan ini?\n\n" +
                           "Tempahan ID: " + booking.getBookingId() + "\n" +
                           "Pakej: " + booking.getPackageName() + "\n" +
                           "Tarikh Acara: " + booking.getEventDate() + "\n\n" +
                           "Nota: Tempahan yang dibatalkan tidak boleh dipulihkan.")
                .setPositiveButton("Ya, Batalkan", (dialog, which) -> {
                    new Thread(() -> {
                        boolean success = connectionClass.cancelBooking(booking.getBookingId());
                        runOnUiThread(() -> {
                            if (success) {
                                Toast.makeText(this, "Tempahan berjaya dibatalkan", Toast.LENGTH_SHORT).show();
                                loadBookings(); // Refresh list
                            } else {
                                Toast.makeText(this, "Gagal membatalkan tempahan", Toast.LENGTH_SHORT).show();
                            }
                        });
                    }).start();
                })
                .setNegativeButton("Batal", null)
                .show();
    }

    private void showBookingDetailsDialog(BookingDetailsModel booking) {
        String details = "ID Tempahan: " + booking.getBookingId() + "\n" +
                        "Pakej: " + booking.getPackageName() + "\n" +
                        "Kategori: " + booking.getCategory() + "\n" +
                        "Acara: " + booking.getEvent() + "\n" +
                        "Tempoh: " + booking.getDuration() + "\n" +
                        "Kelas Pakej: " + booking.getPackageClass() + "\n" +
                        "Tarikh Tempahan: " + booking.getBookingDate() + "\n" +
                        "Tarikh Acara: " + booking.getEventDate() + "\n" +
                        "Status: " + booking.getStatus() + "\n" +
                        "Jumlah: RM " + String.format("%.2f", booking.getPrice()) + "\n" +
                        "Kaedah Bayaran: " + booking.getPaymentMethod() + "\n" +
                        "Status Bayaran: " + booking.getPaymentStatus() + "\n" +
                        "Nota: " + (booking.getNotes() != null ? booking.getNotes() : "Tiada nota");

        new AlertDialog.Builder(this)
                .setTitle("Butiran Tempahan Saya")
                .setMessage(details)
                .setPositiveButton("OK", null)
                .show();
    }

    @Override
    protected void onResume() {
        super.onResume();
        // Refresh bookings when returning to this activity
        loadBookings();
    }

    @Override
    protected void onStart() {
        super.onStart();
        // Force load data when activity starts
        System.out.println("HistoryActivity onStart - Force loading data");
        loadBookings();
    }

}