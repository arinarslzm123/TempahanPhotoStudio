package com.kelasandroidappsirhafizee.tempahanphotostudio;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import java.util.ArrayList;

public class UserBookingHistoryActivity extends AppCompatActivity {
    private RecyclerView recyclerViewBookings;
    private Spinner spinnerStatusFilter;
    private TextView tvEmptyMessage;
    private Button btnRefresh;
    private ImageButton btnBack;
    private ConnectionClass connectionClass;
    private ArrayList<BookingDetailsModel> allBookings;
    private ArrayList<BookingDetailsModel> filteredBookings;
    private UserBookingAdapter adapter;
    private int currentUserId = 1; // In real app, get from logged-in user

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_user_booking_history);

        // Initialize views
        recyclerViewBookings = findViewById(R.id.recyclerViewBookings);
        spinnerStatusFilter = findViewById(R.id.spinnerStatusFilter);
        tvEmptyMessage = findViewById(R.id.tvEmptyMessage);
        btnRefresh = findViewById(R.id.btnRefresh);
        btnBack = findViewById(R.id.btnBack);

        // Initialize connection
        connectionClass = new ConnectionClass();
        allBookings = new ArrayList<>();
        filteredBookings = new ArrayList<>();

        // ✅ Run migration from old status to Paid/Unpaid (one-time operation)
        runStatusMigration();

        // Setup RecyclerView
        setupRecyclerView();

        // Setup status filter spinner
        setupStatusFilter();

        // Load user bookings
        loadUserBookings();

        // Setup refresh button
        btnRefresh.setOnClickListener(v -> loadUserBookings());

        // Setup back button
        btnBack.setOnClickListener(v -> {
            System.out.println("DEBUG - Back button clicked in UserBookingHistoryActivity");
            Toast.makeText(this, "Kembali ke halaman sebelumnya", Toast.LENGTH_SHORT).show();
            finish();
        });
    }

    @Override
    public void onBackPressed() {
        System.out.println("DEBUG - onBackPressed called in UserBookingHistoryActivity");
        Toast.makeText(this, "Kembali ke halaman sebelumnya", Toast.LENGTH_SHORT).show();
        super.onBackPressed();
    }

    private void runStatusMigration() {
        // Run migration in background thread
        new Thread(() -> {
            try {
                System.out.println("DEBUG - Starting status migration (Pending/Confirmed → Unpaid/Paid)");
                int updatedCount = connectionClass.migrateBookingStatusesToPaidUnpaid();
                
                runOnUiThread(() -> {
                    if (updatedCount > 0) {
                        System.out.println("DEBUG - Migration success: " + updatedCount + " bookings updated");
                        Toast.makeText(this, 
                            "Status dikemaskini: " + updatedCount + " tempahan (Pending→Unpaid, Confirmed→Paid)", 
                            Toast.LENGTH_SHORT).show();
                    } else {
                        System.out.println("DEBUG - Migration: No bookings needed updating");
                    }
                });
            } catch (Exception e) {
                e.printStackTrace();
                runOnUiThread(() -> {
                    System.out.println("DEBUG - Migration error: " + e.getMessage());
                });
            }
        }).start();
    }

    private void setupRecyclerView() {
        recyclerViewBookings.setLayoutManager(new LinearLayoutManager(this));
        recyclerViewBookings.setHasFixedSize(true);
    }

    private void setupStatusFilter() {
        String[] statusOptions = {"Semua", "Paid", "Unpaid"};
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

    private void loadUserBookings() {
        new Thread(() -> {
            try {
                ArrayList<BookingDetailsModel> bookings = new ArrayList<>();
                
                // Get user bookings from database
                ArrayList<BookingModel> basicBookings = connectionClass.getBookingsByUserId(currentUserId);
                
                // Convert to detailed bookings
                for (BookingModel booking : basicBookings) {
                    BookingDetailsModel details = connectionClass.getBookingDetails(booking.getId());
                    if (details != null) {
                        bookings.add(details);
                    }
                }
                
                runOnUiThread(() -> {
                    allBookings.clear();
                    allBookings.addAll(bookings);
                    filterBookings();
                    
                    if (bookings.isEmpty()) {
                        Toast.makeText(this, "Tiada tempahan ditemui", Toast.LENGTH_SHORT).show();
                    } else {
                        Toast.makeText(this, "Dimuatkan " + bookings.size() + " tempahan", Toast.LENGTH_SHORT).show();
                    }
                });
            } catch (Exception e) {
                runOnUiThread(() -> {
                    Toast.makeText(this, "Ralat memuatkan tempahan: " + e.getMessage(), Toast.LENGTH_LONG).show();
                });
            }
        }).start();
    }

    private void filterBookings() {
        String selectedStatus = spinnerStatusFilter.getSelectedItem().toString();
        
        filteredBookings.clear();
        
        if ("Semua".equals(selectedStatus)) {
            filteredBookings.addAll(allBookings);
        } else {
            // Filter based on booking status (Paid/Unpaid)
            for (BookingDetailsModel booking : allBookings) {
                String bookingStatus = booking.getStatus();
                
                if (selectedStatus.equalsIgnoreCase(bookingStatus)) {
                    filteredBookings.add(booking);
                }
            }
        }
        
        updateAdapter();
    }

    private void updateAdapter() {
        if (filteredBookings.isEmpty()) {
            recyclerViewBookings.setVisibility(View.GONE);
            tvEmptyMessage.setVisibility(View.VISIBLE);
            tvEmptyMessage.setText("Tiada tempahan ditemui");
        } else {
            recyclerViewBookings.setVisibility(View.VISIBLE);
            tvEmptyMessage.setVisibility(View.GONE);
            
            adapter = new UserBookingAdapter(this, filteredBookings, this::onBookingAction);
            recyclerViewBookings.setAdapter(adapter);
        }
    }

    private void onBookingAction(BookingDetailsModel booking, String action) {
        switch (action) {
            case "cancel":
                cancelBooking(booking);
                break;
            case "view":
                showBookingDetailsDialog(booking);
                break;
        }
    }

    private void cancelBooking(BookingDetailsModel booking) {
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
                                loadUserBookings(); // Refresh list
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
}
