package com.kelasandroidappsirhafizee.tempahanphotostudio;

import android.content.Intent;
import android.os.Bundle;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

public class AddEditPackageActivity extends AppCompatActivity {

    private EditText edtPackageName, edtEvent, edtDuration, edtCategory;
    private Button btnSave, btnDelete;
    private ImageButton btnBack;

    private ConnectionClass connectionClass;
    private int packageId = -1; // default untuk Add Mode

    private String role, username, category;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_add_edit_package);

        // Init DB connection
        connectionClass = new ConnectionClass();

        // Get views
        edtPackageName = findViewById(R.id.edtPackageName);
        edtEvent = findViewById(R.id.edtEvent);
        edtDuration = findViewById(R.id.edtDuration);
        edtCategory = findViewById(R.id.edtCategory);

        btnSave = findViewById(R.id.btnSave);
        btnDelete = findViewById(R.id.btnDelete);
        btnBack = findViewById(R.id.btnBack);
        
        System.out.println("DEBUG - Back button found in AddEditPackageActivity: " + (btnBack != null));
        if (btnBack != null) {
            System.out.println("DEBUG - Back button is clickable: " + btnBack.isClickable());
            System.out.println("DEBUG - Back button is enabled: " + btnBack.isEnabled());
        }

        // Get intent extras
        Intent intent = getIntent();
        if (intent != null) {
            packageId = intent.getIntExtra("PACKAGE_ID", -1);
            role = intent.getStringExtra("ROLE");
            username = intent.getStringExtra("USERNAME");
            category = intent.getStringExtra("CATEGORY");
        }

        // If Edit mode → load package
        if (packageId != -1) {
            loadPackageData(packageId);
        } else {
            btnDelete.setEnabled(false); // disable delete untuk Add mode
            // Set category if provided from intent
            if (category != null && !category.isEmpty()) {
                edtCategory.setText(category);
                edtCategory.setEnabled(false); // Disable editing category when adding from specific category
            }
        }

        // Save button
        btnSave.setOnClickListener(v -> savePackage());

        // Delete button
        btnDelete.setOnClickListener(v -> deletePackage());
    }

    private void loadPackageData(int packageId) {
        PackageModel pkg = connectionClass.getPackageById(packageId);
        if (pkg != null) {
            edtPackageName.setText(pkg.getPackageName());
            edtEvent.setText(pkg.getEvent());
            edtDuration.setText(pkg.getDuration());
            edtCategory.setText(pkg.getCategory());
        } else {
            Toast.makeText(this, "Failed to load package data", Toast.LENGTH_SHORT).show();
        }
        
        // Setup click listeners
        setupClickListeners();
    }

    private void savePackage() {
        String name = edtPackageName.getText().toString().trim();
        String event = edtEvent.getText().toString().trim();
        String duration = edtDuration.getText().toString().trim();
        String cat = edtCategory.getText().toString().trim();

        if (name.isEmpty() || event.isEmpty() || duration.isEmpty() || cat.isEmpty()) {
            Toast.makeText(this, "Please fill in required fields", Toast.LENGTH_SHORT).show();
            return;
        }

        PackageModel pkg = new PackageModel(packageId, "PKG-" + packageId, name, event, duration, cat, null, null, 0.0);

        boolean success;
        if (packageId == -1) {
            // Add new package
            success = connectionClass .addPackage(pkg);
            if (success) {
                Toast.makeText(this, "Package added successfully", Toast.LENGTH_SHORT).show();
                finish();
            } else {
                Toast.makeText(this, "Failed to add package", Toast.LENGTH_SHORT).show();
            }
        } else {
            // Update package
            success = connectionClass.updatePackage(pkg);
            if (success) {
                Toast.makeText(this, "Package updated successfully", Toast.LENGTH_SHORT).show();
                finish();
            } else {
                Toast.makeText(this, "Failed to update package", Toast.LENGTH_SHORT).show();
            }
        }
    }

    private void deletePackage() {
        if (packageId == -1) return;

        boolean success = connectionClass.deletePackage(packageId);
        if (success) {
            Toast.makeText(this, "Package deleted successfully", Toast.LENGTH_SHORT).show();
            finish();
        } else {
            Toast.makeText(this, "Failed to delete package", Toast.LENGTH_SHORT).show();
        }
    }

    @Override
    public void onBackPressed() {
        System.out.println("DEBUG - onBackPressed called in AddEditPackageActivity");
        Toast.makeText(this, "Kembali ke halaman sebelumnya", Toast.LENGTH_SHORT).show();
        super.onBackPressed();
    }

    private void setupClickListeners() {
        btnBack.setOnClickListener(v -> {
            System.out.println("DEBUG - Back button clicked in AddEditPackageActivity");
            Toast.makeText(this, "Kembali ke halaman sebelumnya", Toast.LENGTH_SHORT).show();
            finish();
        });
    }
}
