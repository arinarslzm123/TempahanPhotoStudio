package com.kelasandroidappsirhafizee.tempahanphotostudio;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;

import com.google.android.material.bottomnavigation.BottomNavigationView;

public class Dashboard extends AppCompatActivity {
    private ImageView imgPhotography, imgVideography;
    private TextView tvWelcome;
    private String role, username;
    private int userId;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        EdgeToEdge.enable(this);
        setContentView(R.layout.activity_dashboard);

        // Get user data from intent
        userId = getIntent().getIntExtra("USER_ID", 1);
        role = getIntent().getStringExtra("ROLE");
        username = getIntent().getStringExtra("USERNAME");
        
        // Debug logging
        System.out.println("DEBUG Dashboard - User ID: " + userId);
        System.out.println("DEBUG Dashboard - Role: " + role);
        System.out.println("DEBUG Dashboard - Username: " + username);

        // Initialize views
        imgPhotography = findViewById(R.id.imageView3);
        imgVideography = findViewById(R.id.imageView);
        tvWelcome = findViewById(R.id.tvWelcome);

        // Set welcome message
        if (role != null && role.equals("Admin")) {
            tvWelcome.setText("Welcome Admin, " + username);
        } else {
            tvWelcome.setText("Welcome " + username);
        }

        // Set click listeners for category images
        imgPhotography.setOnClickListener(v -> {
            Intent intent = new Intent(this, ListPackageActivity.class);
            intent.putExtra("CATEGORY", "Photography");
            intent.putExtra("ROLE", role);
            intent.putExtra("USERNAME", username);
            startActivity(intent);
        });

        imgVideography.setOnClickListener(v -> {
            Intent intent = new Intent(this, ListPackageActivity.class);
            intent.putExtra("CATEGORY", "Videography");
            intent.putExtra("ROLE", role);
            intent.putExtra("USERNAME", username);
            startActivity(intent);
        });

        BottomNavigationView bottomNavigationView = findViewById(R.id.bottom_nav);

        bottomNavigationView.setOnItemSelectedListener(item -> {
            int id = item.getItemId();
            if (id == R.id.nav_home) {
                return true;
            } else if (id == R.id.nav_feedback) {
                Intent intent = new Intent(this, FeedbackActivity.class);
                intent.putExtra("USER_ID", userId);
                intent.putExtra("ROLE", role);
                intent.putExtra("USERNAME", username);
                startActivity(intent);
            } else if (id == R.id.nav_history) {
                Intent intent = new Intent(this, HistoryActivity.class);
                intent.putExtra("USER_ID", userId); // Use actual logged-in user ID
                intent.putExtra("ROLE", role);
                intent.putExtra("USERNAME", username);
                startActivity(intent);
            } else if (id == R.id.nav_profile) {
                Intent intent = new Intent(this, ProfileActivity.class);
                intent.putExtra("USER_ID", userId);
                intent.putExtra("ROLE", role);
                intent.putExtra("USERNAME", username);
                startActivity(intent);
            }
            overridePendingTransition(0, 0);
            return true;
        });
    }
}