package com.kelasandroidappsirhafizee.tempahanphotostudio;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import java.util.ArrayList;
import java.util.List;

public class VideographyPackageActivity extends AppCompatActivity {
    private RecyclerView recyclerViewPackages;
    private Button btnAddPackage;
    private TextView tvCategoryTitle;
    private ImageButton btnBack;
    private String category, role, username;
    private ConnectionClass connectionClass;
    private List<PackageModel> packageList;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_videography_package);

        // Get intent data
        category = getIntent().getStringExtra("CATEGORY");
        role = getIntent().getStringExtra("ROLE");
        username = getIntent().getStringExtra("USERNAME");

        // Initialize views
        recyclerViewPackages = findViewById(R.id.recyclerViewVideographyPackages);
        btnAddPackage = findViewById(R.id.btnAddVideographyPackage);
        tvCategoryTitle = findViewById(R.id.tvVideographyTitle);
        btnBack = findViewById(R.id.btnBack);

        // Initialize connection class
        connectionClass = new ConnectionClass();

        // Set category title
        tvCategoryTitle.setText("Videography Packages");

        // Show/hide add button based on role
        if (role != null && role.equals("Admin")) {
            btnAddPackage.setVisibility(View.VISIBLE);
            btnAddPackage.setOnClickListener(v -> {
                Intent intent = new Intent(this, AddEditPackageActivity.class);
                intent.putExtra("CATEGORY", "Videography");
                intent.putExtra("ROLE", role);
                intent.putExtra("USERNAME", username);
                startActivity(intent);
            });
        } else {
            btnAddPackage.setVisibility(View.GONE);
        }

        // Setup RecyclerView
        setupRecyclerView();

        // Load packages
        loadVideographyPackages();

        // Setup back button
        btnBack.setOnClickListener(v -> finish());
    }

    private void setupRecyclerView() {
        recyclerViewPackages.setLayoutManager(new LinearLayoutManager(this));
        recyclerViewPackages.setHasFixedSize(true);
    }

    private void loadVideographyPackages() {
        new Thread(() -> {
            try {
                packageList = connectionClass.getPackagesByCategory("Videography");
                
                runOnUiThread(() -> {
                    if (packageList == null) {
                        Toast.makeText(this, "Database connection failed", Toast.LENGTH_SHORT).show();
                        showEmptyState();
                        return;
                    }
                    
                    if (packageList.isEmpty()) {
                        Toast.makeText(this, "No videography packages found. Admin can add packages.", Toast.LENGTH_LONG).show();
                        showEmptyState();
                        return;
                    }

                    // Create adapter for RecyclerView
                    VideographyPackageAdapter adapter = new VideographyPackageAdapter(VideographyPackageActivity.this, packageList, role, username);
                    recyclerViewPackages.setAdapter(adapter);
                    
                    Toast.makeText(this, "Loaded " + packageList.size() + " videography packages", Toast.LENGTH_SHORT).show();
                });
            } catch (Exception e) {
                runOnUiThread(() -> {
                    Toast.makeText(this, "Error loading packages: " + e.getMessage(), Toast.LENGTH_LONG).show();
                    showEmptyState();
                });
            }
        }).start();
    }


    private void showEmptyState() {
        // You can add empty state UI here if needed
        Toast.makeText(this, "No packages available. Admin can add packages.", Toast.LENGTH_LONG).show();
    }

    @Override
    protected void onResume() {
        super.onResume();
        loadVideographyPackages(); // Refresh the list when returning from other activities
    }
}
