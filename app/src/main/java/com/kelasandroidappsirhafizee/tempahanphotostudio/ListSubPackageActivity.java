package com.kelasandroidappsirhafizee.tempahanphotostudio;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import java.util.ArrayList;

public class ListSubPackageActivity extends AppCompatActivity {
    private RecyclerView recyclerViewSubPackages;
    private Button btnAddSubPackage;
    private TextView tvSubPackageTitle;
    private ImageButton btnBack;
    private String category, role, username, packageName;
    private int packageId, userId;
    private ConnectionClass connectionClass;
    private ArrayList<SubPackageModel> subPackageList;
    private SubPackageAdapter adapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_list_sub_package);

        // ✅ Get data from intent first, then fallback to session for user info
        Intent receivedIntent = getIntent();
        packageId = receivedIntent.getIntExtra("PACKAGE_ID", -1);
        packageName = receivedIntent.getStringExtra("PACKAGE_NAME");
        category = receivedIntent.getStringExtra("CATEGORY");
        
        // Get user info from intent or session
        if (receivedIntent.hasExtra("USER_ID") && receivedIntent.hasExtra("ROLE") && receivedIntent.hasExtra("USERNAME")) {
            userId = receivedIntent.getIntExtra("USER_ID", -1);
            role = receivedIntent.getStringExtra("ROLE");
            username = receivedIntent.getStringExtra("USERNAME");
            System.out.println("DEBUG - ListSubPackageActivity using user data from intent");
        } else {
            // Fallback to session manager
            UserSessionManager sessionManager = new UserSessionManager(this);
            if (sessionManager.isLoggedIn()) {
                userId = sessionManager.getUserId();
                role = sessionManager.getRole();
                username = sessionManager.getUsername();
                System.out.println("DEBUG - ListSubPackageActivity using user data from session");
            } else {
                Toast.makeText(this, "Sila log masuk terlebih dahulu", Toast.LENGTH_SHORT).show();
                Intent intent = new Intent(this, Login.class);
                startActivity(intent);
                finish();
                return;
            }
        }
        
        System.out.println("DEBUG - ========== LIST SUB PACKAGE ACTIVITY RECEIVED DATA ==========");
        System.out.println("DEBUG - Package ID: " + packageId);
        System.out.println("DEBUG - Package Name: " + packageName);
        System.out.println("DEBUG - Category: " + category);
        System.out.println("DEBUG - Role: " + role);
        System.out.println("DEBUG - Username: " + username);
        System.out.println("DEBUG - User ID: " + userId);

        recyclerViewSubPackages = findViewById(R.id.recyclerViewSubPackages);
        btnAddSubPackage = findViewById(R.id.btnAddSubPackage);
        tvSubPackageTitle = findViewById(R.id.tvSubPackageTitle);
        btnBack = findViewById(R.id.btnBack);

        connectionClass = new ConnectionClass();
        tvSubPackageTitle.setText("Sub-Packages for " + packageName);

        // Hanya Admin boleh tambah sub package
        if ("Admin".equals(role)) {
            btnAddSubPackage.setVisibility(View.VISIBLE);
            btnAddSubPackage.setOnClickListener(v -> {
                Intent intent = new Intent(this, AddEditSubPackageActivity.class);
                intent.putExtra("PACKAGE_ID", packageId);
                intent.putExtra("CATEGORY", category);
                intent.putExtra("ROLE", role);
                intent.putExtra("USERNAME", username);
                intent.putExtra("USER_ID", userId);
                startActivity(intent);
            });
        } else {
            btnAddSubPackage.setVisibility(View.GONE);
        }

        // Setup RecyclerView only once
        if (recyclerViewSubPackages.getLayoutManager() == null) {
            recyclerViewSubPackages.setLayoutManager(new LinearLayoutManager(this));
        }

        subPackageList = new ArrayList<>();

        // ✅ Guna anonymous class untuk handle edit & delete
        adapter = new SubPackageAdapter(subPackageList, role, new SubPackageAdapter.OnSubPackageActionListener() {
            @Override
            public void onEdit(SubPackageModel selectedSubPackage) {
                if ("Admin".equals(role)) {
                    Intent intent = new Intent(ListSubPackageActivity.this, AddEditSubPackageActivity.class);
                    intent.putExtra("SUB_PACKAGE_ID", selectedSubPackage.getId());
                    intent.putExtra("PACKAGE_ID", packageId);
                    intent.putExtra("CATEGORY", category);
                    intent.putExtra("ROLE", role);
                    intent.putExtra("USERNAME", username);
                    intent.putExtra("USER_ID", userId);
                    startActivity(intent);
                }
            }

            @Override
            public void onDelete(SubPackageModel selectedSubPackage) {
                if ("Admin".equals(role)) {
                    new Thread(() -> {
                        boolean success = connectionClass.deleteSubPackage(selectedSubPackage.getId());
                        runOnUiThread(() -> {
                            if (success) {
                                Toast.makeText(ListSubPackageActivity.this, "Sub-package deleted", Toast.LENGTH_SHORT).show();
                                loadSubPackages(); // refresh list selepas delete
                            } else {
                                Toast.makeText(ListSubPackageActivity.this, "Failed to delete sub-package", Toast.LENGTH_SHORT).show();
                            }
                        });
                    }).start();
                }
            }
        }, userId, username);

        // Set adapter only once (check if already set)
        if (recyclerViewSubPackages.getAdapter() == null) {
            recyclerViewSubPackages.setAdapter(adapter);
        } else {
            // Update existing adapter
            recyclerViewSubPackages.setAdapter(adapter);
        }

        // Setup back button (only once in onCreate)
        btnBack.setOnClickListener(v -> {
            System.out.println("DEBUG - Back button clicked in ListSubPackageActivity");
            Toast.makeText(this, "Kembali ke halaman sebelumnya", Toast.LENGTH_SHORT).show();
            finish();
        });

        loadSubPackages();
    }

    private void loadSubPackages() {
        new Thread(() -> {
            ArrayList<SubPackageModel> result = connectionClass.getSubPackagesByPackageId(packageId);

            runOnUiThread(() -> {
                if (result == null) {
                    Toast.makeText(this, "Error loading sub-packages", Toast.LENGTH_SHORT).show();
                    return;
                }

                // Clear existing data to prevent duplicates
                subPackageList.clear();
                
                // Remove duplicates before adding (based on ID) - use HashSet for better performance
                java.util.Set<Integer> seenIds = new java.util.HashSet<>();
                ArrayList<SubPackageModel> uniqueResult = new ArrayList<>();
                
                for (SubPackageModel subPackage : result) {
                    int id = subPackage.getId();
                    if (!seenIds.contains(id)) {
                        seenIds.add(id);
                        uniqueResult.add(subPackage);
                    } else {
                        System.out.println("DEBUG - Skipping duplicate sub-package ID: " + id + " - " + subPackage.getSubPackageName());
                    }
                }
                
                // Clear and add unique items
                subPackageList.clear();
                subPackageList.addAll(uniqueResult);
                
                // Notify adapter of data change
                if (adapter != null) {
                    adapter.notifyDataSetChanged();
                }

                System.out.println("DEBUG - Loaded " + subPackageList.size() + " unique sub-packages (from " + result.size() + " total)");

                if (subPackageList.isEmpty()) {
                    Toast.makeText(this, "No sub-packages found for " + packageName, Toast.LENGTH_SHORT).show();
                }
            });
        }).start();
    }

    @Override
    public void onBackPressed() {
        System.out.println("DEBUG - onBackPressed called in ListSubPackageActivity");
        Toast.makeText(this, "Kembali ke halaman sebelumnya", Toast.LENGTH_SHORT).show();
        super.onBackPressed();
    }

    @Override
    protected void onResume() {
        super.onResume();
        // Only reload if activity was already created (prevent double load on first create)
        if (subPackageList != null) {
            loadSubPackages();
        }
    }
}
