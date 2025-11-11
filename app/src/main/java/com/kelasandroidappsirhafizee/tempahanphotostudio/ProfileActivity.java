package com.kelasandroidappsirhafizee.tempahanphotostudio;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.core.content.FileProvider;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.Date;

public class ProfileActivity extends AppCompatActivity {

    private ImageView imgProfile;
    private EditText edtName, edtEmail, edtPhone;
    private LinearLayout layoutMyBooking;
    private Button btnLogout;
    private ImageButton btnBack;
    private ConnectionClass connectionClass;
    private int userId;
    private String userRole, username;
    
    // Image picker constants
    private static final int REQUEST_IMAGE_CAPTURE = 1;
    private static final int REQUEST_IMAGE_PICK = 2;
    private static final int REQUEST_PERMISSIONS = 3;
    private String currentPhotoPath;
    private Uri photoURI;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_profile);

        // Get user data from intent
        userId = getIntent().getIntExtra("USER_ID", 1);
        userRole = getIntent().getStringExtra("ROLE");
        username = getIntent().getStringExtra("USERNAME");

        // Initialize Views
        imgProfile = findViewById(R.id.imgProfile);
        edtName = findViewById(R.id.edtName);
        edtEmail = findViewById(R.id.edtEmail);
        edtPhone = findViewById(R.id.edtPhone);
        layoutMyBooking = findViewById(R.id.layoutMyBooking);
        btnLogout = findViewById(R.id.btnLogout);
        btnBack = findViewById(R.id.btnBack);

        // Initialize connection
        connectionClass = new ConnectionClass();

        // Set up click listeners
        setupClickListeners();
        
        // Load user data
        loadUserData();
    }

    private void loadUserData() {
        new Thread(() -> {
            try {
                System.out.println("DEBUG - ========== LOADING USER DATA ==========");
                System.out.println("DEBUG - userId from intent: " + userId);
                System.out.println("DEBUG - username from intent: " + username);
                System.out.println("DEBUG - userRole from intent: " + userRole);
                
                // First, let's check if we can get any users from database
                System.out.println("DEBUG - Testing database access...");
                String connectionTest = connectionClass.testConnection();
                System.out.println("DEBUG - Connection test result: " + connectionTest);
                
                // Get user data from database
                System.out.println("DEBUG - Calling getUserById(" + userId + ")...");
                UserModel user = connectionClass.getUserById(userId);
                
                runOnUiThread(() -> {
                    if (user != null) {
                        System.out.println("DEBUG - User found in database!");
                        System.out.println("DEBUG - User ID: " + user.getId());
                        System.out.println("DEBUG - Username: '" + user.getUsername() + "'");
                        System.out.println("DEBUG - FullName: '" + user.getFullName() + "'");
                        System.out.println("DEBUG - Email: '" + user.getEmail() + "'");
                        System.out.println("DEBUG - Role: '" + user.getRole() + "'");
                        System.out.println("DEBUG - Phone: '" + user.getPhoneNumber() + "'");
                        
                        // Use fullName if available, otherwise use username
                        String fullName = user.getFullName();
                        String username = user.getUsername();
                        
                        System.out.println("DEBUG - Raw fullName: '" + fullName + "'");
                        System.out.println("DEBUG - Raw username: '" + username + "'");
                        System.out.println("DEBUG - fullName is null: " + (fullName == null));
                        System.out.println("DEBUG - username is null: " + (username == null));
                        
                        String displayName;
                        if (fullName != null && !fullName.trim().isEmpty()) {
                            displayName = fullName.trim();
                            System.out.println("DEBUG - Using fullName: '" + displayName + "'");
                        } else if (username != null && !username.trim().isEmpty()) {
                            displayName = username.trim();
                            System.out.println("DEBUG - Using username: '" + displayName + "'");
                        } else {
                            displayName = "Unknown User";
                            System.out.println("DEBUG - Both fullName and username are null/empty, using fallback");
                        }
                        
                        System.out.println("DEBUG - Final display name: '" + displayName + "'");
                        edtName.setText(displayName);
                        
                        // Make name field non-editable
                        edtName.setEnabled(false);
                        edtName.setFocusable(false);
                        edtName.setClickable(false);
                        edtName.setCursorVisible(false);
                        
                        edtEmail.setText(user.getEmail());
                        
                        // Make email field non-editable
                        edtEmail.setEnabled(false);
                        edtEmail.setFocusable(false);
                        edtEmail.setClickable(false);
                        edtEmail.setCursorVisible(false);
                        
                        edtPhone.setText(user.getPhoneNumber() != null ? user.getPhoneNumber() : "");
                        
                        // Force UI update
                        edtName.invalidate();
                        edtEmail.invalidate();
                        edtPhone.invalidate();
                        edtName.requestLayout();
                        edtEmail.requestLayout();
                        edtPhone.requestLayout();
                        
                        Toast.makeText(this, "Welcome, " + displayName + "!", Toast.LENGTH_LONG).show();
                        
                        // Load profile image
                        loadProfileImage();
                    } else {
                        System.out.println("DEBUG - User is NULL - not found in database");
                        System.out.println("DEBUG - Using fallback data...");
                        
                        // Fallback to intent data if database fails
                        String fallbackName = username != null ? username : "User";
                        edtName.setText(fallbackName);
                        
                        // Make name field non-editable
                        edtName.setEnabled(false);
                        edtName.setFocusable(false);
                        edtName.setClickable(false);
                        edtName.setCursorVisible(false);
                        
                        edtEmail.setText("user@example.com");
                        
                        // Make email field non-editable
                        edtEmail.setEnabled(false);
                        edtEmail.setFocusable(false);
                        edtEmail.setClickable(false);
                        edtEmail.setCursorVisible(false);
                        
                        edtPhone.setText("");
                        
                        System.out.println("DEBUG - Fallback name set to: " + fallbackName);
                        Toast.makeText(this, "Using fallback data: " + fallbackName, Toast.LENGTH_LONG).show();
                    }
                });
            } catch (Exception e) {
                e.printStackTrace();
                System.out.println("DEBUG - Exception in loadUserData: " + e.getMessage());
                runOnUiThread(() -> {
                    // Fallback to intent data
                    String fallbackName = username != null ? username : "User";
                    edtName.setText(fallbackName);
                    
                    // Make name field non-editable
                    edtName.setEnabled(false);
                    edtName.setFocusable(false);
                    edtName.setClickable(false);
                    edtName.setCursorVisible(false);
                    
                    edtEmail.setText("user@example.com");
                    
                    // Make email field non-editable
                    edtEmail.setEnabled(false);
                    edtEmail.setFocusable(false);
                    edtEmail.setClickable(false);
                    edtEmail.setCursorVisible(false);
                    
                    edtPhone.setText("");
                    Toast.makeText(this, "Error loading user data, using: " + fallbackName, Toast.LENGTH_LONG).show();
                });
            }
        }).start();
    }

    @Override
    public void onBackPressed() {
        System.out.println("DEBUG - onBackPressed called in ProfileActivity");
        Toast.makeText(this, "Kembali ke halaman sebelumnya", Toast.LENGTH_SHORT).show();
        super.onBackPressed();
    }

    private void setupClickListeners() {
        // Profile image click listener
        imgProfile.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                showImagePickerDialog();
            }
        });

        // My Booking click listener
        layoutMyBooking.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(ProfileActivity.this, HistoryActivity.class);
                intent.putExtra("USER_ID", userId);
                intent.putExtra("ROLE", userRole);
                intent.putExtra("USERNAME", username);
                startActivity(intent);
            }
        });


        // Logout click listener
        btnLogout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Toast.makeText(ProfileActivity.this, "Logged out", Toast.LENGTH_SHORT).show();
                Intent intent = new Intent(ProfileActivity.this, Login.class);
                intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
                startActivity(intent);
            }
        });

        btnBack.setOnClickListener(v -> {
            System.out.println("DEBUG - Back button clicked in ProfileActivity");
            Toast.makeText(this, "Kembali ke halaman sebelumnya", Toast.LENGTH_SHORT).show();
            finish();
        });
    }

    private void showImagePickerDialog() {
        String[] options = {"Take Photo", "Choose from Gallery", "Cancel"};
        androidx.appcompat.app.AlertDialog.Builder builder = new androidx.appcompat.app.AlertDialog.Builder(this);
        builder.setTitle("Select Profile Picture");
        builder.setItems(options, (dialog, which) -> {
            switch (which) {
                case 0:
                    if (checkPermissions()) {
                        takePicture();
                    }
                    break;
                case 1:
                    if (checkPermissions()) {
                        pickImageFromGallery();
                    }
                    break;
                case 2:
                    dialog.dismiss();
                    break;
            }
        });
        builder.show();
    }

    private boolean checkPermissions() {
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED ||
            ContextCompat.checkSelfPermission(this, Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED ||
            ContextCompat.checkSelfPermission(this, Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
            
            ActivityCompat.requestPermissions(this, new String[]{
                Manifest.permission.CAMERA,
                Manifest.permission.READ_EXTERNAL_STORAGE,
                Manifest.permission.WRITE_EXTERNAL_STORAGE
            }, REQUEST_PERMISSIONS);
            return false;
        }
        return true;
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == REQUEST_PERMISSIONS) {
            if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                Toast.makeText(this, "Permissions granted", Toast.LENGTH_SHORT).show();
            } else {
                Toast.makeText(this, "Permissions denied", Toast.LENGTH_SHORT).show();
            }
        }
    }

    private void takePicture() {
        Intent takePictureIntent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        if (takePictureIntent.resolveActivity(getPackageManager()) != null) {
            File photoFile = null;
            try {
                photoFile = createImageFile();
            } catch (IOException ex) {
                Toast.makeText(this, "Error creating image file", Toast.LENGTH_SHORT).show();
            }
            
            if (photoFile != null) {
                photoURI = FileProvider.getUriForFile(this,
                    "com.kelasandroidappsirhafizee.tempahanphotostudio.fileprovider",
                    photoFile);
                takePictureIntent.putExtra(MediaStore.EXTRA_OUTPUT, photoURI);
                startActivityForResult(takePictureIntent, REQUEST_IMAGE_CAPTURE);
            }
        }
    }

    private void pickImageFromGallery() {
        Intent intent = new Intent(Intent.ACTION_PICK, MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
        startActivityForResult(intent, REQUEST_IMAGE_PICK);
    }

    private File createImageFile() throws IOException {
        String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
        String imageFileName = "JPEG_" + timeStamp + "_";
        File storageDir = getExternalFilesDir(Environment.DIRECTORY_PICTURES);
        File image = File.createTempFile(imageFileName, ".jpg", storageDir);
        currentPhotoPath = image.getAbsolutePath();
        return image;
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        
        if (resultCode == Activity.RESULT_OK) {
            if (requestCode == REQUEST_IMAGE_CAPTURE) {
                // Image captured from camera
                if (currentPhotoPath != null) {
                    Bitmap bitmap = BitmapFactory.decodeFile(currentPhotoPath);
                    imgProfile.setImageBitmap(bitmap);
                    saveImageToInternalStorage(bitmap);
                }
            } else if (requestCode == REQUEST_IMAGE_PICK) {
                // Image selected from gallery
                if (data != null && data.getData() != null) {
                    Uri imageUri = data.getData();
                    try {
                        InputStream inputStream = getContentResolver().openInputStream(imageUri);
                        Bitmap bitmap = BitmapFactory.decodeStream(inputStream);
                        imgProfile.setImageBitmap(bitmap);
                        saveImageToInternalStorage(bitmap);
                    } catch (IOException e) {
                        Toast.makeText(this, "Error loading image", Toast.LENGTH_SHORT).show();
                    }
                }
            }
        }
    }

    private void saveImageToInternalStorage(Bitmap bitmap) {
        try {
            String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
            String fileName = "profile_" + userId + "_" + timeStamp + ".jpg";
            
            File file = new File(getFilesDir(), fileName);
            FileOutputStream fos = new FileOutputStream(file);
            bitmap.compress(Bitmap.CompressFormat.JPEG, 90, fos);
            fos.close();
            
            // Update database with new image path
            new Thread(() -> {
                boolean success = connectionClass.updateUserProfileImage(userId, fileName);
                runOnUiThread(() -> {
                    if (success) {
                        Toast.makeText(this, "Profile picture updated successfully", Toast.LENGTH_SHORT).show();
                    } else {
                        Toast.makeText(this, "Failed to update profile picture", Toast.LENGTH_SHORT).show();
                    }
                });
            }).start();
            
        } catch (IOException e) {
            Toast.makeText(this, "Error saving image", Toast.LENGTH_SHORT).show();
        }
    }

    private void loadProfileImage() {
        new Thread(() -> {
            UserModel user = connectionClass.getUserById(userId);
            if (user != null && user.getProfileImage() != null && !user.getProfileImage().isEmpty()) {
                runOnUiThread(() -> {
                    try {
                        File imageFile = new File(getFilesDir(), user.getProfileImage());
                        if (imageFile.exists()) {
                            Bitmap bitmap = BitmapFactory.decodeFile(imageFile.getAbsolutePath());
                            imgProfile.setImageBitmap(bitmap);
                        }
                    } catch (Exception e) {
                        System.out.println("Error loading profile image: " + e.getMessage());
                    }
                });
            }
        }).start();
    }
}
