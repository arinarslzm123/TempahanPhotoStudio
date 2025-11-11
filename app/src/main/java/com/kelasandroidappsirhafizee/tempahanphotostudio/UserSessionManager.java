package com.kelasandroidappsirhafizee.tempahanphotostudio;

import android.content.Context;
import android.content.SharedPreferences;

public class UserSessionManager {
    private static final String PREF_NAME = "UserSession";
    private static final String KEY_USER_ID = "USER_ID";
    private static final String KEY_USERNAME = "USERNAME";
    private static final String KEY_ROLE = "ROLE";
    private static final String KEY_EMAIL = "EMAIL";
    private static final String KEY_PHONE = "PHONE";

    private SharedPreferences sharedPreferences;
    private SharedPreferences.Editor editor;

    public UserSessionManager(Context context) {
        sharedPreferences = context.getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE);
        editor = sharedPreferences.edit();
    }

    // Save user login data (original method for backward compatibility)
    public void saveUserSession(int userId, String username, String role) {
        editor.putInt(KEY_USER_ID, userId);
        editor.putString(KEY_USERNAME, username);
        editor.putString(KEY_ROLE, role);
        editor.apply();
    }
    
    // Save user login data with email and phone
    public void saveUserSession(int userId, String username, String role, String email, String phone) {
        editor.putInt(KEY_USER_ID, userId);
        editor.putString(KEY_USERNAME, username);
        editor.putString(KEY_ROLE, role);
        editor.putString(KEY_EMAIL, email != null ? email : "");
        editor.putString(KEY_PHONE, phone != null ? phone : "");
        editor.apply();
    }

    // Getters
    public int getUserId() {
        return sharedPreferences.getInt(KEY_USER_ID, -1);
    }

    public String getUsername() {
        return sharedPreferences.getString(KEY_USERNAME, "Guest");
    }

    public String getRole() {
        return sharedPreferences.getString(KEY_ROLE, "Customer");
    }
    
    public String getUserEmail() {
        return sharedPreferences.getString(KEY_EMAIL, "");
    }
    
    public String getPhone() {
        return sharedPreferences.getString(KEY_PHONE, "");
    }

    // Check if user is logged in
    public boolean isLoggedIn() {
        return getUserId() != -1;
    }

    // Clear session (logout)
    public void clearSession() {
        editor.clear();
        editor.apply();
    }
}
