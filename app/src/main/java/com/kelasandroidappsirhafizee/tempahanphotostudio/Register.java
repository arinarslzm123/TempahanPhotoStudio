package com.kelasandroidappsirhafizee.tempahanphotostudio;

import android.os.Bundle;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.Toast;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class Register extends AppCompatActivity {

    EditText etname, etemail, etphone, etpassword, etconfirmPassword;
    Button signupBtn;
    ImageButton btnBack;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_register);

        etname = findViewById(R.id.name);
        etemail = findViewById(R.id.email);
        etphone = findViewById(R.id.phone);
        etpassword = findViewById(R.id.password);
        etconfirmPassword = findViewById(R.id.confirmPassword);
        signupBtn = findViewById(R.id.signupBtn);
        btnBack = findViewById(R.id.btnBack);

        signupBtn.setOnClickListener(v -> {
            registerUser();
        });

        btnBack.setOnClickListener(v -> finish());
    }

    public void registerUser() {
        String name = etname.getText().toString();
        String email = etemail.getText().toString();
        String phone = etphone.getText().toString();
        String password = etpassword.getText().toString();
        String confirmPassword = etconfirmPassword.getText().toString();

        if (name.isEmpty() || email.isEmpty() || phone.isEmpty() || password.isEmpty() || confirmPassword.isEmpty()) {
            Toast.makeText(this, "Please fill all fields", Toast.LENGTH_SHORT).show();
            return;
        }

        if (!password.equals(confirmPassword)) {
            Toast.makeText(this, "Passwords do not match", Toast.LENGTH_SHORT).show();
            return;
        }

        if (password.length() < 6) {
            Toast.makeText(this, "Password must be at least 6 characters", Toast.LENGTH_SHORT).show();
            return;
        }

        if (!android.util.Patterns.EMAIL_ADDRESS.matcher(email).matches()) {
            Toast.makeText(this, "Please enter a valid email address", Toast.LENGTH_SHORT).show();
            return;
        }

        new Thread(() -> {
            try {
                System.out.println("DEBUG - ========== REGISTRATION START ==========");
                System.out.println("DEBUG - Name: " + name);
                System.out.println("DEBUG - Email: " + email);
                System.out.println("DEBUG - Phone: " + phone);
                System.out.println("DEBUG - Password: " + password);
                
                ConnectionClass connectionClass = new ConnectionClass();
                
                // Test database connection first
                String connectionTest = connectionClass.testConnection();
                System.out.println("DEBUG - Database connection test: " + connectionTest);
                
                String result = connectionClass.registerUser(name, email, phone, password);
                System.out.println("DEBUG - Registration result: " + result);
                
                runOnUiThread(() -> {
                    if ("User registered successfully".equals(result)) {
                        Toast.makeText(this, "Register Successful - " + name, Toast.LENGTH_LONG).show();
                        
                        // Navigate to login page
                        android.content.Intent intent = new android.content.Intent(Register.this, Login.class);
                        intent.putExtra("REGISTERED_EMAIL", email);
                        intent.putExtra("REGISTERED_NAME", name);
                        startActivity(intent);
                        finish();
                    } else {
                        Toast.makeText(this, "Registration failed: " + result, Toast.LENGTH_LONG).show();
                    }
                });
            } catch (Exception e) {
                e.printStackTrace();
                System.out.println("DEBUG - Registration exception: " + e.getMessage());
                runOnUiThread(() -> {
                    Toast.makeText(this, "Registration error: " + e.getMessage(), Toast.LENGTH_LONG).show();
                });
            }
        }).start();
    }
}
