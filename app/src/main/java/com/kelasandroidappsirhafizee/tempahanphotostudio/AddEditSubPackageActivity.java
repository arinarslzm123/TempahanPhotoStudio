package com.kelasandroidappsirhafizee.tempahanphotostudio;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.text.TextUtils;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.Toast;

import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.contract.ActivityResultContracts;
import androidx.appcompat.app.AppCompatActivity;

import com.bumptech.glide.Glide;

public class AddEditSubPackageActivity extends AppCompatActivity {
    private EditText etSubPackageName, etPrice, etDescription, etDuration;
    private Button btnSaveSubPackage, btnChooseMedia;
    private ImageView ivMediaPreview;
    private ImageButton btnBack;

    private int packageId, subPackageId;
    private String role, username, category;
    private ConnectionClass connectionClass;
    private boolean isEditMode = false;

    private String mediaPath = ""; // simpan url/path media

    // Activity Result Launcher untuk pilih media
    private final ActivityResultLauncher<Intent> pickMediaLauncher =
            registerForActivityResult(new ActivityResultContracts.StartActivityForResult(), result -> {
                if (result.getResultCode() == RESULT_OK && result.getData() != null) {
                    Uri selectedUri = result.getData().getData();
                    if (selectedUri != null) {
                        mediaPath = selectedUri.toString();

                        // Preview guna Glide
                        Glide.with(this)
                                .load(selectedUri)
                                .into(ivMediaPreview);
                    }
                }
            });

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_add_edit_sub_package);

        etSubPackageName = findViewById(R.id.etSubPackageName);
        etPrice = findViewById(R.id.etPrice);
        etDescription = findViewById(R.id.etDescription);
        etDuration = findViewById(R.id.etDuration);
        btnSaveSubPackage = findViewById(R.id.btnSaveSubPackage);
        btnChooseMedia = findViewById(R.id.btnChooseMedia);
        ivMediaPreview = findViewById(R.id.ivMediaPreview);
        btnBack = findViewById(R.id.btnBack);

        connectionClass = new ConnectionClass();

        // Get intent data
        packageId = getIntent().getIntExtra("PACKAGE_ID", -1);
        subPackageId = getIntent().getIntExtra("SUB_PACKAGE_ID", -1);
        role = getIntent().getStringExtra("ROLE");
        username = getIntent().getStringExtra("USERNAME");
        category = getIntent().getStringExtra("CATEGORY");

        if (subPackageId != -1) {
            isEditMode = true;
            loadSubPackageDetails(subPackageId);
        }

        // pilih media dari gallery
        btnChooseMedia.setOnClickListener(v -> openMediaPicker());

        btnSaveSubPackage.setOnClickListener(v -> saveSubPackage());
        
        setupBackButton();
    }

    private void openMediaPicker() {
        Intent intent = new Intent(Intent.ACTION_PICK);
        intent.setType("*/*");
        intent.putExtra(Intent.EXTRA_MIME_TYPES, new String[]{"image/*", "video/*"});
        pickMediaLauncher.launch(intent);
    }

    private void loadSubPackageDetails(int id) {
        new Thread(() -> {
            SubPackageModel subPackage = connectionClass.getSubPackageById(id);

            runOnUiThread(() -> {
                if (subPackage != null) {
                    etSubPackageName.setText(subPackage.getSubPackageName());
                    etPrice.setText(String.valueOf(subPackage.getPrice()));
                    etDescription.setText(subPackage.getDescription());
                    etDuration.setText(subPackage.getDuration());

                    // kalau ada media simpanan → preview
                    if (!TextUtils.isEmpty(subPackage.getMedia())) {
                        mediaPath = subPackage.getMedia();
                        Glide.with(this)
                                .load(Uri.parse(mediaPath))
                                .into(ivMediaPreview);
                    }
                }
            });
        }).start();
    }

    private void saveSubPackage() {
        String name = etSubPackageName.getText().toString().trim();
        String priceStr = etPrice.getText().toString().trim();
        String description = etDescription.getText().toString().trim();
        String duration = etDuration.getText().toString().trim();

        if (TextUtils.isEmpty(name) || TextUtils.isEmpty(priceStr)) {
            Toast.makeText(this, "Please fill required fields", Toast.LENGTH_SHORT).show();
            return;
        }

        double price = Double.parseDouble(priceStr);

        new Thread(() -> {
            boolean success;
            if (isEditMode) {
                success = connectionClass.updateSubPackage(
                        subPackageId, packageId, name, price, description, duration, mediaPath
                );
            } else {
                success = connectionClass.addSubPackage(
                        packageId, name, price, description, duration, mediaPath
                );
            }

            boolean finalSuccess = success;
            runOnUiThread(() -> {
                if (finalSuccess) {
                    Toast.makeText(this, "SubPackage saved successfully", Toast.LENGTH_SHORT).show();
                    finish();
                } else {
                    Toast.makeText(this, "Failed to save SubPackage", Toast.LENGTH_SHORT).show();
                }
            });
        }).start();
    }

    private void setupBackButton() {
        btnBack.setOnClickListener(v -> finish());
    }
}
