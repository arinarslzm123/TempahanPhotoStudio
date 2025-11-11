package com.kelasandroidappsirhafizee.tempahanphotostudio;

import android.app.DatePickerDialog;
import android.app.TimePickerDialog;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.Spinner;
import android.widget.TimePicker;
import android.widget.Toast;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;

public class BookingActivity extends AppCompatActivity {

    Spinner spinnerPakej, spinnerSubPakej;
    EditText etDate, etTime;
    Button btnSendOrder;
    ImageButton btnBack;
    ConnectionClass connectionClass;
    ArrayList<PackageModel> packageList;
    ArrayList<SubPackageModel> subPackageList;
    ArrayAdapter<String> packageAdapter;
    ArrayAdapter<String> subPackageAdapter;
    
    // User information
    int userId;
    String userRole;
    String username;
    
    // Track if package/sub-package is pre-selected from intent
    boolean isPackagePreSelected = false;
    boolean isSubPackagePreSelected = false;
    
    // Track if date/time is selected
    boolean isDateSelected = false;
    boolean isTimeSelected = false;
    
    // Store booked dates with times
    HashMap<String, ArrayList<String>> bookedDatesWithTimes = new HashMap<>();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        EdgeToEdge.enable(this);
        setContentView(R.layout.activity_booking);

        spinnerPakej = findViewById(R.id.spinnerPakej);
        spinnerSubPakej = findViewById(R.id.spinnerSubPakej);
        etDate = findViewById(R.id.etDate);
        etTime = findViewById(R.id.etTime);
        btnSendOrder = findViewById(R.id.btnSendOrder);
        btnBack = findViewById(R.id.btnBack); // May be null if not in layout

        // ✅ Get user info from intent first (priority), then fallback to session
        Intent receivedIntent = getIntent();
        if (receivedIntent.hasExtra("USER_ID") && receivedIntent.hasExtra("ROLE") && receivedIntent.hasExtra("USERNAME")) {
            // Use data from intent (passed from DetailSubPackageActivity or other activity)
            userId = receivedIntent.getIntExtra("USER_ID", -1);
            userRole = receivedIntent.getStringExtra("ROLE");
            username = receivedIntent.getStringExtra("USERNAME");
            System.out.println("DEBUG - Using user data from intent: ID=" + userId + ", Role=" + userRole + ", Username=" + username);
        } else {
            // Fallback to session manager
        UserSessionManager sessionManager = new UserSessionManager(this);
        if (sessionManager.isLoggedIn()) {
            userId = sessionManager.getUserId();
            userRole = sessionManager.getRole();
            username = sessionManager.getUsername();
                System.out.println("DEBUG - Using user data from session: ID=" + userId + ", Role=" + userRole + ", Username=" + username);
        } else {
            Toast.makeText(this, "Sila log masuk terlebih dahulu", Toast.LENGTH_SHORT).show();
            Intent intent = new Intent(this, Login.class);
            startActivity(intent);
            finish();
            return;
        }
        }


        
        System.out.println("DEBUG - BookingActivity user info: ID=" + userId + ", Role=" + userRole + ", Username=" + username);

        // Initialize connection and package list
        connectionClass = new ConnectionClass();
        packageList = new ArrayList<>();
        subPackageList = new ArrayList<>();
        
        // Check if package data is passed from intent FIRST (before loading from database)
        Intent intent = getIntent();
        boolean hasIntentPackage = intent.hasExtra("PACKAGE_ID");
        
        // Only load packages from database if no package is pre-selected from intent
        if (!hasIntentPackage) {
            // Load packages from database only if no package is pre-selected
            loadPackagesFromDatabase();
        }
        
        // Setup sub package spinner
        setupSubPackageSpinner();
        
        // Handle package data from intent (will override database loading if package is pre-selected)
        handlePackageDataFromIntent();
        
        // Setup click listeners
        setupClickListeners();
        
        // Load booked dates when activity starts
        loadBookedDates();
    }
    
    @Override
    protected void onResume() {
        super.onResume();
        // Reload booked dates when activity resumes (in case new bookings were made)
        loadBookedDates();
    }
    
    private void handlePackageDataFromIntent() {
        Intent intent = getIntent();
        
        System.out.println("DEBUG - ========== HANDLING INTENT DATA ==========");
        System.out.println("DEBUG - Intent extras:");
        System.out.println("DEBUG - PACKAGE_ID: " + intent.hasExtra("PACKAGE_ID"));
        System.out.println("DEBUG - SUB_PACKAGE_ID: " + intent.hasExtra("SUB_PACKAGE_ID"));
        System.out.println("DEBUG - USER_ID: " + intent.hasExtra("USER_ID"));
        System.out.println("DEBUG - ROLE: " + intent.hasExtra("ROLE"));
        System.out.println("DEBUG - USERNAME: " + intent.hasExtra("USERNAME"));
        
        // Log all intent extras
        Bundle extras = intent.getExtras();
        if (extras != null) {
            System.out.println("DEBUG - All intent extras:");
            for (String key : extras.keySet()) {
                System.out.println("DEBUG - " + key + ": " + extras.get(key));
            }
        }
        
        // Check if package data is passed from PhotographyPackageActivity
        if (intent.hasExtra("PACKAGE_ID")) {
            System.out.println("DEBUG - Package data received from intent");
            isPackagePreSelected = true;
            
            int packageId = intent.getIntExtra("PACKAGE_ID", -1);
            String packageName = intent.getStringExtra("PACKAGE_NAME");
            String packageEvent = intent.getStringExtra("PACKAGE_EVENT");
            String packageDuration = intent.getStringExtra("PACKAGE_DURATION");
            String packageCategory = intent.getStringExtra("PACKAGE_CATEGORY");
            String packageDescription = intent.getStringExtra("PACKAGE_DESCRIPTION");
            double packagePrice = intent.getDoubleExtra("PACKAGE_PRICE", 0.0);
            String role = intent.getStringExtra("ROLE");
            boolean isAdminBooking = intent.getBooleanExtra("ADMIN_BOOKING", false);
            
            System.out.println("DEBUG - Package: " + packageName + ", Price: " + packagePrice + ", Admin Booking: " + isAdminBooking);
            
            // Create PackageModel from intent data
            PackageModel selectedPackage = new PackageModel(
                packageId,
                "PKG-" + packageId,
                packageName,
                packageEvent,
                packageDuration,
                packageCategory,
                packageDescription,
                null, // imageUrl
                packagePrice
            );
            
            // Set as selected package in spinner (this will handle adding to packageList)
            setupPackageSpinnerWithSelected(selectedPackage);
            
            // Don't load sub-packages here - will be handled after sub-package processing
        }
        
        // Check if sub-package data is passed from DetailSubPackageActivity
        if (intent.hasExtra("SUB_PACKAGE_ID")) {
            System.out.println("DEBUG - Sub-package data received from intent");
            isSubPackagePreSelected = true;
            
            int subPackageId = intent.getIntExtra("SUB_PACKAGE_ID", -1);
            String subPackageName = intent.getStringExtra("SUB_PACKAGE_NAME");
            double subPackagePrice = intent.getDoubleExtra("SUB_PACKAGE_PRICE", 0.0);
            String subPackageDescription = intent.getStringExtra("SUB_PACKAGE_DESCRIPTION");
            String subPackageDuration = intent.getStringExtra("SUB_PACKAGE_DURATION");
            String subPackageMedia = intent.getStringExtra("SUB_PACKAGE_MEDIA");
            int parentPackageId = intent.getIntExtra("PARENT_PACKAGE_ID", -1);
            
            System.out.println("DEBUG - Sub-package: " + subPackageName + ", Price: " + subPackagePrice + ", Parent Package ID: " + parentPackageId);
            
            // Create SubPackageModel from intent data
            SubPackageModel selectedSubPackage = new SubPackageModel(
                subPackageId,
                parentPackageId,
                subPackageName,
                subPackagePrice,
                subPackageDescription,
                subPackageDuration,
                subPackageMedia
            );
            
            // Set as selected sub-package in spinner (this will handle adding to subPackageList)
            setupSubPackageSpinnerWithSelected(selectedSubPackage);
        } else {
            // If no sub-package is pre-selected, load sub-packages for the selected package
            if (intent.hasExtra("PACKAGE_ID")) {
                int packageId = intent.getIntExtra("PACKAGE_ID", -1);
                System.out.println("DEBUG - No sub-package pre-selected, loading sub-packages for package ID: " + packageId);
                loadSubPackagesForPackage(packageId);
            }
        }
        
        System.out.println("DEBUG - ========== INTENT DATA HANDLING COMPLETE ==========");
    }
    
    private void setupPackageSpinnerWithSelected(PackageModel selectedPackage) {
        System.out.println("DEBUG - ========== SETTING UP PACKAGE SPINNER ==========");
        System.out.println("DEBUG - Selected package: " + selectedPackage.getPackageName());
        
        // Clear existing package list and add selected package
        packageList.clear();
        packageList.add(selectedPackage);
        
        // Create adapter with selected package
        ArrayList<String> packageNames = new ArrayList<>();
        packageNames.add(selectedPackage.getPackageName());
        
        packageAdapter = new ArrayAdapter<>(this, android.R.layout.simple_spinner_item, packageNames);
        packageAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinnerPakej.setAdapter(packageAdapter);
        
        // Select the first (and only) item
        spinnerPakej.setSelection(0);
        
        // Disable spinner if package is pre-selected from intent
        if (isPackagePreSelected) {
            spinnerPakej.setEnabled(false);
            spinnerPakej.setFocusable(false);
            spinnerPakej.setClickable(false);
            spinnerPakej.setAlpha(0.6f);
            System.out.println("DEBUG - Package spinner disabled (pre-selected from intent)");
            System.out.println("DEBUG - Package spinner enabled: " + spinnerPakej.isEnabled());
            System.out.println("DEBUG - Package spinner focusable: " + spinnerPakej.isFocusable());
            System.out.println("DEBUG - Package spinner clickable: " + spinnerPakej.isClickable());
            System.out.println("DEBUG - Package spinner alpha: " + spinnerPakej.getAlpha());
        } else {
            System.out.println("DEBUG - Package spinner enabled (not pre-selected)");
        }
        
        System.out.println("DEBUG - Package spinner set with: " + selectedPackage.getPackageName());
        System.out.println("DEBUG - Package spinner adapter count: " + packageAdapter.getCount());
        System.out.println("DEBUG - Package spinner selection: " + spinnerPakej.getSelectedItemPosition());
        System.out.println("DEBUG - Package list size: " + packageList.size());
        System.out.println("DEBUG - ========== PACKAGE SPINNER SETUP COMPLETE ==========");
    }
    
    private void setupSubPackageSpinnerWithSelected(SubPackageModel selectedSubPackage) {
        System.out.println("DEBUG - ========== SETTING UP SUB-PACKAGE SPINNER ==========");
        System.out.println("DEBUG - Selected sub-package: " + selectedSubPackage.getSubPackageName());
        
        // Clear existing sub-package list and add selected sub-package
        subPackageList.clear();
        subPackageList.add(selectedSubPackage);
        
        // Create adapter with selected sub-package
        ArrayList<String> subPackageNames = new ArrayList<>();
        String displayText = selectedSubPackage.getSubPackageName() + " - RM " + String.format("%.2f", selectedSubPackage.getPrice());
        subPackageNames.add(displayText);
        
        subPackageAdapter = new ArrayAdapter<>(this, android.R.layout.simple_spinner_item, subPackageNames);
        subPackageAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinnerSubPakej.setAdapter(subPackageAdapter);
        
        // Select the first (and only) item
        spinnerSubPakej.setSelection(0);
        
        // Disable spinner if sub-package is pre-selected from intent
        if (isSubPackagePreSelected) {
            spinnerSubPakej.setEnabled(false);
            spinnerSubPakej.setFocusable(false);
            spinnerSubPakej.setClickable(false);
            spinnerSubPakej.setAlpha(0.6f);
            System.out.println("DEBUG - Sub-package spinner disabled (pre-selected from intent)");
            System.out.println("DEBUG - Sub-package spinner enabled: " + spinnerSubPakej.isEnabled());
            System.out.println("DEBUG - Sub-package spinner focusable: " + spinnerSubPakej.isFocusable());
            System.out.println("DEBUG - Sub-package spinner clickable: " + spinnerSubPakej.isClickable());
            System.out.println("DEBUG - Sub-package spinner alpha: " + spinnerSubPakej.getAlpha());
        } else {
            System.out.println("DEBUG - Sub-package spinner enabled (not pre-selected)");
        }
        
        System.out.println("DEBUG - Sub-package spinner set with: " + selectedSubPackage.getSubPackageName());
        System.out.println("DEBUG - Sub-package spinner adapter count: " + subPackageAdapter.getCount());
        System.out.println("DEBUG - Sub-package spinner selection: " + spinnerSubPakej.getSelectedItemPosition());
        System.out.println("DEBUG - Sub-package list size: " + subPackageList.size());
        System.out.println("DEBUG - ========== SUB-PACKAGE SPINNER SETUP COMPLETE ==========");
    }

    @Override
    public void onBackPressed() {
        System.out.println("DEBUG - onBackPressed called in BookingActivity");
        Toast.makeText(this, "Kembali ke halaman sebelumnya", Toast.LENGTH_SHORT).show();
        super.onBackPressed();
    }

    private void setupClickListeners() {
        // Pilih Tarikh
        etDate.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View v) {
                final Calendar calendar = Calendar.getInstance();
                int year = calendar.get(Calendar.YEAR);
                int month = calendar.get(Calendar.MONTH);
                int day = calendar.get(Calendar.DAY_OF_MONTH);

                DatePickerDialog datePickerDialog = new DatePickerDialog(BookingActivity.this,
                        new DatePickerDialog.OnDateSetListener() {
                            @Override
                            public void onDateSet(DatePicker view, int year, int month, int dayOfMonth) {
                                // Format selected date to YYYY-MM-DD for comparison
                                String selectedDateStr = String.format(Locale.getDefault(), "%04d-%02d-%02d", year, month + 1, dayOfMonth);
                                String selectedDateDisplay = dayOfMonth + "/" + (month + 1) + "/" + year;
                                
                                // ❌ BLOCK if this date has ANY booking (regardless of time)
                                if (bookedDatesWithTimes.containsKey(selectedDateStr)) {
                                    ArrayList<String> bookedTimes = bookedDatesWithTimes.get(selectedDateStr);
                                    String timesList = "";
                                    if (bookedTimes != null && !bookedTimes.isEmpty()) {
                                        timesList = String.join(", ", bookedTimes);
                                    }
                                    
                                    // ❌ BLOCK: Show error and clear date field
                                    Toast.makeText(BookingActivity.this, 
                                            "❌ TIDAK BOLEH TEMPAH!\n\nTarikh " + selectedDateDisplay + " SUDAH ADA TEMPAHAN pada masa:\n" + timesList + "\n\nSila pilih TARIKH LAIN yang tiada tempahan.", 
                                            Toast.LENGTH_LONG).show();
                                    System.out.println("DEBUG - ❌ BLOCKED: Date " + selectedDateStr + " already has bookings at: " + timesList);
                                    
                                    // Clear date field - force user to choose different date
                                    etDate.setText("");
                                    isDateSelected = false;
                                    return; // Don't proceed with date selection
                                }
                                
                                // ✅ Date is completely available (no bookings at all)
                                etDate.setText(selectedDateDisplay);
                                isDateSelected = true;
                                
                                System.out.println("DEBUG - ✅ Date is available (no bookings): " + etDate.getText().toString());
                                Toast.makeText(BookingActivity.this, "✅ Tarikh tersedia dan telah dipilih", Toast.LENGTH_SHORT).show();
                            }
                        }, year, month, day);
                
                datePickerDialog.show();
            }
        });

        // Pilih Masa
        etTime.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                // Check if date is selected first
                String dateStr = etDate.getText().toString();
                if (dateStr.isEmpty()) {
                    Toast.makeText(BookingActivity.this, "Sila pilih tarikh terlebih dahulu", Toast.LENGTH_SHORT).show();
                    return;
                }
                
                final Calendar calendar = Calendar.getInstance();
                int hour = calendar.get(Calendar.HOUR_OF_DAY);
                int minute = calendar.get(Calendar.MINUTE);

                TimePickerDialog timePickerDialog = new TimePickerDialog(BookingActivity.this,
                        new TimePickerDialog.OnTimeSetListener() {
                            @Override
                            public void onTimeSet(TimePicker view, int hourOfDay, int minute) {
                                String selectedTime = String.format("%02d:%02d", hourOfDay, minute);
                                String dateStr = etDate.getText().toString();
                                
                                // Convert date to YYYY-MM-DD format for comparison
                                String formattedDate = convertDateToDatabaseFormat(dateStr);
                                
                                // ✅ BLOCK if this specific date+time is already booked
                                if (bookedDatesWithTimes.containsKey(formattedDate)) {
                                    ArrayList<String> bookedTimes = bookedDatesWithTimes.get(formattedDate);
                                    if (bookedTimes != null) {
                                        // Check for time match (handle different formats: HH:mm, HHmm)
                                        boolean timeConflict = false;
                                        String conflictingTime = null;
                                        
                                        for (String bookedTime : bookedTimes) {
                                            // Normalize both times for comparison
                                            String normalizedBookedTime = bookedTime.replace(":", "").trim();
                                            String normalizedSelectedTime = selectedTime.replace(":", "").trim();
                                            
                                            // Also check with colon format
                                            if (bookedTime.equals(selectedTime) || 
                                                normalizedBookedTime.equals(normalizedSelectedTime) ||
                                                bookedTime.equals(normalizedSelectedTime) ||
                                                normalizedBookedTime.equals(selectedTime)) {
                                                timeConflict = true;
                                                conflictingTime = bookedTime;
                                                break;
                                            }
                                        }
                                        
                                        if (timeConflict) {
                                            // ❌ BLOCK: Clear time field and prevent selection
                                            Toast.makeText(BookingActivity.this, 
                                                    "❌ TIDAK BOLEH TEMPAH!\n\nTarikh " + dateStr + " pada masa " + selectedTime + " SUDAH DITEMPAH oleh user lain.\n\nSila pilih MASA LAIN.", 
                                                    Toast.LENGTH_LONG).show();
                                            System.out.println("DEBUG - ❌ BLOCKED: Time " + selectedTime + " on " + formattedDate + " conflicts with: " + conflictingTime);
                                            
                                            // Clear time field - force user to choose different time
                                            etTime.setText("");
                                            isTimeSelected = false;
                                            return; // Don't proceed with time selection
                                        }
                                    }
                                }
                                
                                // ✅ Time is available - proceed with selection
                                etTime.setText(selectedTime);
                                isTimeSelected = true;
                                
                                System.out.println("DEBUG - ✅ Time available and selected: " + etTime.getText().toString());
                                Toast.makeText(BookingActivity.this, "✅ Masa tersedia dan telah dipilih", Toast.LENGTH_SHORT).show();
                            }
                        }, hour, minute, true);
                timePickerDialog.show();
            }
        });

        // Back button (only if it exists in layout)
        if (btnBack != null) {
        btnBack.setOnClickListener(v -> {
            System.out.println("DEBUG - Back button clicked in BookingActivity");
            Toast.makeText(this, "Kembali ke halaman sebelumnya", Toast.LENGTH_SHORT).show();
            finish();
        });
        } else {
            System.out.println("DEBUG - btnBack not found in layout (this is OK)");
        }
        
        // Long press on date field to reset (for admin or special cases)
        etDate.setOnLongClickListener(v -> {
            if ("Admin".equals(userRole)) {
                resetDateTimeFields();
                Toast.makeText(this, "Date dan time fields telah direset", Toast.LENGTH_SHORT).show();
                return true;
            }
            return false;
        });
        
        // Long press on time field to reset (for admin or special cases)
        etTime.setOnLongClickListener(v -> {
            if ("Admin".equals(userRole)) {
                resetDateTimeFields();
                Toast.makeText(this, "Date dan time fields telah direset", Toast.LENGTH_SHORT).show();
                return true;
            }
            return false;
        });

        // Test button
        // Test button removed - no longer needed

        // Butang Hantar
        btnSendOrder.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String date = etDate.getText().toString();
                String time = etTime.getText().toString();

                if (date.isEmpty() || time.isEmpty()) {
                    Toast.makeText(BookingActivity.this,
                            "Sila isi semua maklumat", Toast.LENGTH_SHORT).show();
                } else {
                    // Get selected package details from spinner position
                    int selectedPosition = spinnerPakej.getSelectedItemPosition();
                    int selectedSubPosition = spinnerSubPakej.getSelectedItemPosition();
                    
                    // Verify package is selected and exists in packageList
                    if (selectedPosition < 0 || selectedPosition >= packageList.size()) {
                        Toast.makeText(BookingActivity.this,
                                "Ralat: Pakej tidak ditemui", Toast.LENGTH_SHORT).show();
                        System.out.println("DEBUG - ERROR: Selected position " + selectedPosition + " out of bounds. Package list size: " + packageList.size());
                        return;
                    }
                    
                    PackageModel selectedPackage = packageList.get(selectedPosition);
                    
                    // Verify the package name matches what's displayed in spinner
                    String spinnerPackageName = spinnerPakej.getSelectedItem().toString();
                    if (!selectedPackage.getPackageName().equals(spinnerPackageName)) {
                        System.out.println("DEBUG - WARNING: Package name mismatch!");
                        System.out.println("DEBUG - Spinner shows: " + spinnerPackageName);
                        System.out.println("DEBUG - packageList has: " + selectedPackage.getPackageName());
                        // Use the package from packageList (more reliable)
                    }
                    
                    System.out.println("DEBUG - Selected package for booking: " + selectedPackage.getPackageName() + " (ID: " + selectedPackage.getId() + ")");
                    
                    // Check if sub package is selected
                    // Note: If sub-package is pre-selected, position will be 0 (valid)
                    // If loaded from database, position 0 is "Pilih Sub Package" placeholder
                    if (isSubPackagePreSelected) {
                        // Pre-selected: position 0 is valid (first and only item)
                        if (selectedSubPosition < 0 || selectedSubPosition >= subPackageList.size()) {
                            Toast.makeText(BookingActivity.this,
                                    "Ralat: Sub package tidak ditemui", Toast.LENGTH_SHORT).show();
                            System.out.println("DEBUG - ERROR: Sub-package position " + selectedSubPosition + " out of bounds. List size: " + subPackageList.size());
                            return;
                        }
                    } else {
                        // Loaded from database: position 0 is placeholder, need position > 0
                        if (selectedSubPosition <= 0 || selectedSubPosition > subPackageList.size()) {
                            Toast.makeText(BookingActivity.this,
                                    "Sila pilih sub package", Toast.LENGTH_SHORT).show();
                            return;
                        }
                    }
                    
                    // Get selected sub-package
                    SubPackageModel selectedSubPackage;
                    if (isSubPackagePreSelected) {
                        selectedSubPackage = subPackageList.get(selectedSubPosition);
                    } else {
                        selectedSubPackage = subPackageList.get(selectedSubPosition - 1); // -1 because position 0 is placeholder
                    }
                    
                    // Verify sub-package belongs to selected package
                    if (selectedSubPackage.getPackageId() != selectedPackage.getId()) {
                        System.out.println("DEBUG - WARNING: Sub-package package ID (" + selectedSubPackage.getPackageId() + 
                                ") doesn't match selected package ID (" + selectedPackage.getId() + ")");
                    }
                    
                    System.out.println("DEBUG - Selected sub-package for booking: " + selectedSubPackage.getSubPackageName() + 
                            " (ID: " + selectedSubPackage.getId() + ", Price: " + selectedSubPackage.getPrice() + ")");
                    
                    System.out.println("DEBUG - ========== STARTING OVERLAPPING CHECK ==========");
                    System.out.println("DEBUG - User ID: " + userId);
                    System.out.println("DEBUG - Event Date (UI format): " + date);
                    System.out.println("DEBUG - Event Time (UI format): " + time);
                    
                    // Check for overlapping bookings before proceeding
                    // This will prevent user from booking the same date/time (including same user)
                    checkOverlappingBooking(selectedPackage, selectedSubPackage, date, time);
                }
            }
        });
    }

    private void loadPackagesFromDatabase() {
        // Don't load from database if package is already pre-selected from intent
        if (isPackagePreSelected) {
            System.out.println("DEBUG - Skipping loadPackagesFromDatabase: Package already pre-selected from intent");
            return;
        }
        
        new Thread(() -> {
            try {
                // Load all packages from database
                ArrayList<PackageModel> allPackages = connectionClass.getAllPackages();
                
                // Update UI on main thread
                runOnUiThread(() -> {
                    // Double-check: Don't overwrite if package was set from intent while we were loading
                    if (isPackagePreSelected) {
                        System.out.println("DEBUG - Package was set from intent while loading database, skipping database load");
                        return;
                    }
                    
                    if (allPackages.isEmpty()) {
                        // Fallback to hardcoded packages if database is empty
                        String[] fallbackPackages = {"PV 1", "PV 2", "PV 3", "PV 4", "PV 5"};
                        packageAdapter = new ArrayAdapter<>(BookingActivity.this,
                                android.R.layout.simple_spinner_dropdown_item, fallbackPackages);
                        spinnerPakej.setAdapter(packageAdapter);
                        Toast.makeText(BookingActivity.this, 
                                "Database kosong, menggunakan pakej default", Toast.LENGTH_SHORT).show();
                    } else {
                        // Create package display list
                        List<String> packageNames = new ArrayList<>();
                        packageList.clear();
                        packageList.addAll(allPackages);
                        
                        for (PackageModel pkg : allPackages) {
                            packageNames.add(pkg.getPackageName());
                        }
                        
                        // Set up spinner adapter
                        packageAdapter = new ArrayAdapter<>(BookingActivity.this,
                                android.R.layout.simple_spinner_dropdown_item, packageNames);
                        spinnerPakej.setAdapter(packageAdapter);
                        
                        Toast.makeText(BookingActivity.this, 
                                "Dimuatkan " + allPackages.size() + " pakej dari database", Toast.LENGTH_SHORT).show();
                    }
                });
            } catch (Exception e) {
                runOnUiThread(() -> {
                    // Don't overwrite if package was set from intent
                    if (isPackagePreSelected) {
                        System.out.println("DEBUG - Package was set from intent, skipping error fallback");
                        return;
                    }
                    
                    // Fallback to hardcoded packages on error
                    String[] fallbackPackages = {"PV 1", "PV 2", "PV 3", "PV 4", "PV 5"};
                    packageAdapter = new ArrayAdapter<>(BookingActivity.this,
                            android.R.layout.simple_spinner_dropdown_item, fallbackPackages);
                    spinnerPakej.setAdapter(packageAdapter);
                    Toast.makeText(BookingActivity.this, 
                            "Ralat memuatkan pakej dari database: " + e.getMessage(), Toast.LENGTH_LONG).show();
                });
            }
        }).start();
    }

    private void setupSubPackageSpinner() {
        // Initialize sub package adapter
        subPackageAdapter = new ArrayAdapter<>(this, android.R.layout.simple_spinner_item, new ArrayList<String>());
        subPackageAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinnerSubPakej.setAdapter(subPackageAdapter);
        
        // Listen for package selection changes (only if not pre-selected)
        if (!isPackagePreSelected) {
            spinnerPakej.setOnItemSelectedListener(new android.widget.AdapterView.OnItemSelectedListener() {
                @Override
                public void onItemSelected(android.widget.AdapterView<?> parent, View view, int position, long id) {
                    if (position >= 0 && position < packageList.size()) {
                        PackageModel selectedPackage = packageList.get(position);
                        loadSubPackagesForPackage(selectedPackage.getId());
                    } else {
                        // Clear sub packages if no package selected
                        subPackageList.clear();
                        subPackageAdapter.clear();
                        subPackageAdapter.notifyDataSetChanged();
                    }
                }

                @Override
                public void onNothingSelected(android.widget.AdapterView<?> parent) {
                    subPackageList.clear();
                    subPackageAdapter.clear();
                    subPackageAdapter.notifyDataSetChanged();
                }
            });
        } else {
            System.out.println("DEBUG - Package selection listener disabled (pre-selected from intent)");
        }
        
        // Setup sub-package selection listener (only if not pre-selected)
        setupSubPackageSelectionListener();
    }
    
    private void setupSubPackageSelectionListener() {
        if (!isSubPackagePreSelected) {
            spinnerSubPakej.setOnItemSelectedListener(new android.widget.AdapterView.OnItemSelectedListener() {
                @Override
                public void onItemSelected(android.widget.AdapterView<?> parent, View view, int position, long id) {
                    // Handle sub-package selection if needed
                    System.out.println("DEBUG - Sub-package selected at position: " + position);
                }

                @Override
                public void onNothingSelected(android.widget.AdapterView<?> parent) {
                    System.out.println("DEBUG - No sub-package selected");
                }
            });
        } else {
            System.out.println("DEBUG - Sub-package selection listener disabled (pre-selected from intent)");
        }
    }
    
    // Method to reset date and time fields (for admin or special cases)
    private void resetDateTimeFields() {
        isDateSelected = false;
        isTimeSelected = false;
        
        etDate.setEnabled(true);
        etDate.setAlpha(1.0f);
        etDate.setFocusable(true);
        etDate.setClickable(true);
        etDate.setText("");
        
        etTime.setEnabled(true);
        etTime.setAlpha(1.0f);
        etTime.setFocusable(true);
        etTime.setClickable(true);
        etTime.setText("");
        
        System.out.println("DEBUG - Date and time fields reset");
    }
    
    // Load booked dates from database
    private void loadBookedDates() {
        new Thread(() -> {
            try {
                HashMap<String, ArrayList<String>> bookedDates = connectionClass.getBookedDatesWithTimes();
                
                runOnUiThread(() -> {
                    bookedDatesWithTimes.clear();
                    bookedDatesWithTimes.putAll(bookedDates);
                    
                    System.out.println("DEBUG - Loaded " + bookedDatesWithTimes.size() + " booked dates");
                    // Log some booked dates for debugging
                    int count = 0;
                    for (String date : bookedDatesWithTimes.keySet()) {
                        if (count < 5) { // Log first 5
                            System.out.println("DEBUG - Booked date: " + date + ", Times: " + bookedDatesWithTimes.get(date));
                            count++;
                        }
                    }
                });
            } catch (Exception e) {
                e.printStackTrace();
                System.out.println("DEBUG - Error loading booked dates: " + e.getMessage());
            }
        }).start();
    }

    private void loadSubPackagesForPackage(int packageId) {
        System.out.println("DEBUG - ========== LOADING SUB-PACKAGES FOR PACKAGE ==========");
        System.out.println("DEBUG - Package ID: " + packageId);
        System.out.println("DEBUG - isSubPackagePreSelected: " + isSubPackagePreSelected);
        
        new Thread(() -> {
            try {
                System.out.println("DEBUG - Loading sub packages for package ID: " + packageId);
                ArrayList<SubPackageModel> subPackages = connectionClass.getSubPackagesByPackageId(packageId);
                
                System.out.println("DEBUG - getSubPackagesByPackageId returned: " + (subPackages != null ? subPackages.size() : "null") + " sub-packages");
                
                if (subPackages != null && !subPackages.isEmpty()) {
                    System.out.println("DEBUG - Found " + subPackages.size() + " sub-packages");
                    
                    // Only clear and add if no sub-package is pre-selected
                    if (!isSubPackagePreSelected) {
                        subPackageList.clear();
                        subPackageList.addAll(subPackages);
                        
                        // Create adapter with sub package names and prices
                        List<String> subPackageNames = new ArrayList<>();
                        subPackageNames.add("Pilih Sub Package"); // Default option
                        
                        for (SubPackageModel subPkg : subPackages) {
                            String displayText = subPkg.getSubPackageName() + " - RM " + String.format("%.2f", subPkg.getPrice());
                            subPackageNames.add(displayText);
                            System.out.println("DEBUG - Added sub-package: " + displayText);
                        }
                        
                        runOnUiThread(() -> {
                            System.out.println("DEBUG - Updating sub-package spinner with " + subPackageNames.size() + " items");
                            subPackageAdapter.clear();
                            subPackageAdapter.addAll(subPackageNames);
                            subPackageAdapter.notifyDataSetChanged();
                            
                            // Disable spinner if sub-package is pre-selected from intent
                            if (isSubPackagePreSelected) {
                                spinnerSubPakej.setEnabled(false);
                                spinnerSubPakej.setAlpha(0.6f);
                                System.out.println("DEBUG - Sub-package spinner disabled (pre-selected from intent) in loadSubPackagesForPackage");
                                System.out.println("DEBUG - Sub-package spinner enabled: " + spinnerSubPakej.isEnabled());
                                System.out.println("DEBUG - Sub-package spinner alpha: " + spinnerSubPakej.getAlpha());
                            } else {
                                System.out.println("DEBUG - Sub-package spinner enabled (not pre-selected) in loadSubPackagesForPackage");
                            }
                            
                            System.out.println("DEBUG - Sub-package spinner updated, current selection: " + spinnerSubPakej.getSelectedItemPosition());
                            System.out.println("DEBUG - Loaded " + subPackages.size() + " sub packages");
                        });
                    } else {
                        System.out.println("DEBUG - Sub-package already pre-selected, skipping loading sub-packages");
                    }
                } else {
                    System.out.println("DEBUG - No sub-packages found for package ID: " + packageId);
                    runOnUiThread(() -> {
                        subPackageAdapter.clear();
                        subPackageAdapter.add("Tiada sub package tersedia");
                        subPackageAdapter.notifyDataSetChanged();
                    });
                }
            } catch (Exception e) {
                e.printStackTrace();
                System.out.println("DEBUG - Error loading sub-packages: " + e.getMessage());
                runOnUiThread(() -> {
                    subPackageAdapter.clear();
                    subPackageAdapter.add("Ralat loading sub package");
                    subPackageAdapter.notifyDataSetChanged();
                });
            }
        }).start();
        
        System.out.println("DEBUG - ========== SUB-PACKAGE LOADING COMPLETE ==========");
    }

    private void checkOverlappingBooking(PackageModel selectedPackage, SubPackageModel selectedSubPackage, String eventDate, String eventTime) {
        new Thread(() -> {
            try {
                // Convert date format from DD/MM/YYYY (UI format) to YYYY-MM-DD (database format)
                String formattedEventDate = convertDateToDatabaseFormat(eventDate);
                
                System.out.println("DEBUG - Checking overlapping booking:");
                System.out.println("DEBUG - Original date (UI): " + eventDate);
                System.out.println("DEBUG - Formatted date (DB): " + formattedEventDate);
                System.out.println("DEBUG - Time: " + eventTime);
                
                // Check if there's an overlapping booking from ANY user (not just current user)
                // This prevents multiple users from booking the same date and time slot
                boolean hasOverlap = connectionClass.checkOverlappingBooking(userId, formattedEventDate, eventTime);
                
                runOnUiThread(() -> {
                    if (hasOverlap) {
                        Toast.makeText(this, 
                                "Tempahan pada tarikh dan masa ini sudah diambil oleh user lain. Sila pilih tarikh atau masa lain.", 
                                Toast.LENGTH_LONG).show();
                        System.out.println("DEBUG - Overlapping booking detected - tarikh dan masa sudah diambil oleh user lain. Preventing navigation to payment");
                    } else {
                        // No overlap, proceed to payment
                        System.out.println("DEBUG - No overlapping booking found, proceeding to payment");
                        navigateToPayment(selectedPackage, selectedSubPackage, eventDate, eventTime);
                    }
                });
            } catch (Exception e) {
                e.printStackTrace();
                runOnUiThread(() -> {
                    Toast.makeText(this, "Ralat semasa menyemak tempahan bertindih", Toast.LENGTH_SHORT).show();
                });
            }
        }).start();
    }
    
    // Convert date from DD/MM/YYYY to YYYY-MM-DD format
    private String convertDateToDatabaseFormat(String inputDate) {
        try {
            // Input format: DD/MM/YYYY (e.g., "31/10/2025")
            // Output format: YYYY-MM-DD (e.g., "2025-10-31")
            String[] parts = inputDate.split("/");
            if (parts.length == 3) {
                String day = parts[0].trim();
                String month = parts[1].trim();
                String year = parts[2].trim();
                
                // Pad with zeros if needed
                if (day.length() == 1) day = "0" + day;
                if (month.length() == 1) month = "0" + month;
                
                String result = year + "-" + month + "-" + day;
                System.out.println("DEBUG - Date conversion: " + inputDate + " -> " + result);
                return result;
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("DEBUG - Error converting date format: " + inputDate + " - " + e.getMessage());
        }
        // Return original date if conversion fails
        System.out.println("DEBUG - Date conversion failed, using original: " + inputDate);
        return inputDate;
    }

    private void navigateToPayment(PackageModel selectedPackage, SubPackageModel selectedSubPackage, String eventDate, String eventTime) {
        // Create booking details for payment page
        BookingDetailsModel bookingDetails = new BookingDetailsModel();
        bookingDetails.setPackageName(selectedPackage.getPackageName());
        bookingDetails.setPackageClass(selectedSubPackage.getSubPackageName());
        bookingDetails.setSubPackageName(selectedSubPackage.getSubPackageName()); // ✅ Set sub package name for display
        bookingDetails.setPrice(selectedSubPackage.getPrice());
        bookingDetails.setEventDate(eventDate);
        bookingDetails.setEventTime(eventTime);
        bookingDetails.setStatus("Pending Payment");
        bookingDetails.setPaymentMethod("Online Banking");
        bookingDetails.setPaymentStatus("Pending");
        
        // Set booking date (today's date when booking is created)
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd", Locale.getDefault());
        String bookingDate = dateFormat.format(new Date());
        bookingDetails.setBookingDate(bookingDate);
        bookingDetails.setCreatedAt(new Date()); // Also set createdAt for InvoiceActivity
        
        // Navigate to payment page
        Intent intent = new Intent(this, PaymentActivity.class);
        intent.putExtra("BOOKING_DETAILS", bookingDetails);
        intent.putExtra("USER_ID", userId);
        intent.putExtra("ROLE", userRole);
        intent.putExtra("USERNAME", username);
        startActivity(intent);
    }

}
