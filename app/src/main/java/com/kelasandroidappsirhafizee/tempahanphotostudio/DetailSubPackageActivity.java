package com.kelasandroidappsirhafizee.tempahanphotostudio;

import android.content.Intent;
import android.os.Bundle;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.bumptech.glide.Glide;

public class DetailSubPackageActivity extends AppCompatActivity {

    TextView tvPackageName, tvCategory, tvSubPackageName, tvPrice, tvDuration, tvDescription;
    ImageView ivMedia;
    Button btnBooking, btnBack;
    ConnectionClass connectionClass;

    int subPackageId;
    int userId;
    String userRole;
    String username;
    
    // Store sub-package data for passing to BookingActivity
    SubPackageModel currentSubPackage;
    PackageModel currentPackage;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_detail_sub_package);

        tvPackageName = findViewById(R.id.tvPackageName);
        tvCategory = findViewById(R.id.tvCategory);
        tvSubPackageName = findViewById(R.id.tvSubPackageName);
        tvPrice = findViewById(R.id.tvPrice);
        tvDuration = findViewById(R.id.tvDuration);
        tvDescription = findViewById(R.id.tvDescription);
        ivMedia = findViewById(R.id.ivMedia);

        btnBooking = findViewById(R.id.btnBooking);
        btnBack = findViewById(R.id.btnBack);

        connectionClass = new ConnectionClass();

        // ✅ Get user info from intent first (priority), then fallback to session
        Intent receivedIntent = getIntent();
        if (receivedIntent.hasExtra("USER_ID") && receivedIntent.hasExtra("ROLE") && receivedIntent.hasExtra("USERNAME")) {
            // Use data from intent (passed from SubPackageAdapter or other activity)
            userId = receivedIntent.getIntExtra("USER_ID", -1);
            userRole = receivedIntent.getStringExtra("ROLE");
            username = receivedIntent.getStringExtra("USERNAME");
            System.out.println("DEBUG - DetailSubPackageActivity using user data from intent: ID=" + userId + ", Role=" + userRole + ", Username=" + username);
        } else {
            // Fallback to session manager
            UserSessionManager sessionManager = new UserSessionManager(this);
            if (sessionManager.isLoggedIn()) {
                userId = sessionManager.getUserId();
                userRole = sessionManager.getRole();
                username = sessionManager.getUsername();
                System.out.println("DEBUG - DetailSubPackageActivity using user data from session: ID=" + userId + ", Role=" + userRole + ", Username=" + username);
            } else {
                Toast.makeText(this, "Sila log masuk terlebih dahulu", Toast.LENGTH_SHORT).show();
                Intent intent = new Intent(this, Login.class);
                startActivity(intent);
                finish();
                return;
            }
        }
        
        System.out.println("DEBUG - DetailSubPackageActivity user info: ID=" + userId + ", Role=" + userRole + ", Username=" + username);

        // Ambil sub_package_id dari Intent
        subPackageId = getIntent().getIntExtra("SUB_PACKAGE_ID", -1);

        if (subPackageId != -1) {
            loadSubPackageFromDb(subPackageId);
        } else {
            Toast.makeText(this, "Invalid SubPackage ID", Toast.LENGTH_SHORT).show();
            finish();
        }

        // Booking button
        btnBooking.setOnClickListener(v -> {
            if (currentSubPackage != null && currentPackage != null) {
                System.out.println("DEBUG - ========== DETAIL SUB PACKAGE BOOKING BUTTON CLICKED ==========");
                System.out.println("DEBUG - Package: " + currentPackage.getPackageName() + " (ID: " + currentPackage.getId() + ")");
                System.out.println("DEBUG - Package Event: " + currentPackage.getEvent());
                System.out.println("DEBUG - Package Category: " + currentPackage.getCategory());
                System.out.println("DEBUG - Sub-package: " + currentSubPackage.getSubPackageName() + " (ID: " + currentSubPackage.getId() + ")");
                System.out.println("DEBUG - Sub-package Price: " + currentSubPackage.getPrice());
                
                Intent intent = new Intent(DetailSubPackageActivity.this, BookingActivity.class);
                
                // Pass sub-package data
                intent.putExtra("SUB_PACKAGE_ID", currentSubPackage.getId());
                intent.putExtra("SUB_PACKAGE_NAME", currentSubPackage.getSubPackageName());
                intent.putExtra("SUB_PACKAGE_PRICE", currentSubPackage.getPrice());
                intent.putExtra("SUB_PACKAGE_DESCRIPTION", currentSubPackage.getDescription());
                intent.putExtra("SUB_PACKAGE_DURATION", currentSubPackage.getDuration());
                intent.putExtra("SUB_PACKAGE_MEDIA", currentSubPackage.getMedia());
                intent.putExtra("PARENT_PACKAGE_ID", currentSubPackage.getPackageId());
                
                // Pass package data
                intent.putExtra("PACKAGE_ID", currentPackage.getId());
                intent.putExtra("PACKAGE_NAME", currentPackage.getPackageName());
                intent.putExtra("PACKAGE_EVENT", currentPackage.getEvent());
                intent.putExtra("PACKAGE_DURATION", currentPackage.getDuration());
                intent.putExtra("PACKAGE_CATEGORY", currentPackage.getCategory());
                intent.putExtra("PACKAGE_DESCRIPTION", currentPackage.getDescription());
                intent.putExtra("PACKAGE_PRICE", currentPackage.getPrice());
                
                // Pass user data
                intent.putExtra("USER_ID", userId);
                intent.putExtra("ROLE", userRole);
                intent.putExtra("USERNAME", username);
                
                System.out.println("DEBUG - Starting BookingActivity with intent data");
                startActivity(intent);
            } else {
                System.out.println("DEBUG - ERROR: Sub-package or package data is null!");
                System.out.println("DEBUG - currentSubPackage: " + (currentSubPackage != null ? "NOT NULL" : "NULL"));
                System.out.println("DEBUG - currentPackage: " + (currentPackage != null ? "NOT NULL" : "NULL"));
                Toast.makeText(this, "Sub-package data not loaded yet", Toast.LENGTH_SHORT).show();
            }
        });

        // Back button
        btnBack.setOnClickListener(v -> {
            Intent intent = new Intent(DetailSubPackageActivity.this, ListSubPackageActivity.class);
            intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_SINGLE_TOP);
            startActivity(intent);
            finish();
        });
    }

    private void loadSubPackageFromDb(int id) {
        System.out.println("DEBUG - ========== LOADING SUB PACKAGE FROM DATABASE ==========");
        System.out.println("DEBUG - Sub-package ID: " + id);
        
        new Thread(() -> {
            SubPackageModel subPackage = connectionClass.getSubPackageById(id);
            System.out.println("DEBUG - Sub-package loaded: " + (subPackage != null ? subPackage.getSubPackageName() : "NULL"));
            
            PackageModel packageModel = null;
            if (subPackage != null) {
                System.out.println("DEBUG - Sub-package details: " + subPackage.getSubPackageName() + ", Package ID: " + subPackage.getPackageId());
                packageModel = connectionClass.getPackageById(subPackage.getPackageId());
                System.out.println("DEBUG - Package loaded: " + (packageModel != null ? packageModel.getPackageName() : "NULL"));
                
                if (packageModel != null) {
                    System.out.println("DEBUG - Package details: " + packageModel.getPackageName() + ", Event: " + packageModel.getEvent() + ", Category: " + packageModel.getCategory());
                    System.out.println("DEBUG - Package ID: " + packageModel.getId() + ", Package ID String: " + packageModel.getPackageId());
                } else {
                    System.out.println("DEBUG - ERROR: Package model is NULL for package ID: " + subPackage.getPackageId());
                }
            }

            final PackageModel finalPackageModel = packageModel;
            runOnUiThread(() -> {
                if (subPackage != null && finalPackageModel != null) {
                    // Store data for passing to BookingActivity
                    currentSubPackage = subPackage;
                    currentPackage = finalPackageModel;
                    
                    System.out.println("DEBUG - Data stored for BookingActivity:");
                    System.out.println("DEBUG - Package: " + finalPackageModel.getPackageName() + " (Event: " + finalPackageModel.getEvent() + ", Category: " + finalPackageModel.getCategory() + ")");
                    System.out.println("DEBUG - Sub-package: " + subPackage.getSubPackageName() + " (Price: " + subPackage.getPrice() + ")");
                    
                    tvPackageName.setText(finalPackageModel.getPackageName());
                    tvCategory.setText(finalPackageModel.getCategory());
                    tvSubPackageName.setText(subPackage.getSubPackageName());
                    tvPrice.setText("RM " + subPackage.getPrice());
                    tvDuration.setText(subPackage.getDuration());
                    tvDescription.setText(subPackage.getDescription());

                    if (subPackage.getMedia() != null && !subPackage.getMedia().isEmpty()) {
                        Glide.with(this)
                                .load(subPackage.getMedia())
                                .placeholder(R.drawable.placeholder)
                                .into(ivMedia);
                    } else {
                        ivMedia.setImageResource(R.drawable.placeholder);
                    }
                } else {
                    System.out.println("DEBUG - ERROR: Failed to load sub-package or package data");
                    Toast.makeText(this, "SubPackage not found", Toast.LENGTH_SHORT).show();
                    finish();
                }
            });
        }).start();
    }
}
