package com.kelasandroidappsirhafizee.tempahanphotostudio;

import android.app.Dialog;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.RatingBar;
import android.widget.SearchView;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

public class FeedbackActivity extends AppCompatActivity {

    private RecyclerView recyclerViewFeedback;
    private SearchView searchView;
    private Button btnAddFeedback;
    private ImageButton btnBack;
    private FeedbackAdapter feedbackAdapter;
    private List<FeedbackModel> feedbackList;
    private List<FeedbackModel> filteredList;
    private ConnectionClass connectionClass;
    private int userId;
    private String userRole, username;
    private boolean hasBookings = false;
    private boolean isLoadingFeedback = false;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_feedback);

        // Get user data from intent
        userId = getIntent().getIntExtra("USER_ID", 1);
        userRole = getIntent().getStringExtra("ROLE");
        username = getIntent().getStringExtra("USERNAME");

        // Initialize connection
        connectionClass = new ConnectionClass();

        initializeViews();
        setupRecyclerView();
        setupSearchView();
        setupAddFeedbackButton();
        setupBackButton();
        
        // Load feedback from database (visible to all users)
        loadFeedbackFromDatabase();
        
        // Check if user has bookings
        checkUserBookings();
    }

    private void initializeViews() {
        recyclerViewFeedback = findViewById(R.id.recyclerViewFeedback);
        searchView = findViewById(R.id.searchView);
        btnAddFeedback = findViewById(R.id.btnAddFeedback);
        btnBack = findViewById(R.id.btnBack);
    }

    private void setupRecyclerView() {
        feedbackList = new ArrayList<>();
        filteredList = new ArrayList<>();
        feedbackAdapter = new FeedbackAdapter(filteredList);
        recyclerViewFeedback.setLayoutManager(new LinearLayoutManager(this));
        recyclerViewFeedback.setAdapter(feedbackAdapter);
    }

    // Load feedback from database (all users can see all feedback)
    private void loadFeedbackFromDatabase() {
        // Prevent multiple simultaneous loads
        if (isLoadingFeedback) {
            System.out.println("DEBUG - Already loading feedback, skipping...");
            return;
        }
        
        isLoadingFeedback = true;
        new Thread(() -> {
            try {
                System.out.println("DEBUG - Loading feedback from database...");
                ArrayList<FeedbackModel> feedbacks = connectionClass.getAllFeedback();
                
                runOnUiThread(() -> {
                    // Clear existing data to prevent duplicates
                    feedbackList.clear();
                    filteredList.clear();
                    
                    // Add new data
                    feedbackList.addAll(feedbacks);
                    
                    // Apply current search filter if any
                    String currentQuery = searchView.getQuery().toString();
                    filterFeedback(currentQuery);
                    
                    System.out.println("DEBUG - Loaded " + feedbackList.size() + " feedback entries from database");
                    System.out.println("DEBUG - Filtered list size: " + filteredList.size());
                    
                    if (feedbackList.isEmpty()) {
                        Toast.makeText(this, "Tiada feedback untuk dipaparkan", Toast.LENGTH_SHORT).show();
                    }
                    
                    isLoadingFeedback = false;
                });
            } catch (Exception e) {
                e.printStackTrace();
                System.out.println("DEBUG - Error loading feedback from database: " + e.getMessage());
                runOnUiThread(() -> {
                    Toast.makeText(this, "Ralat memuatkan feedback", Toast.LENGTH_SHORT).show();
                    isLoadingFeedback = false;
                });
            }
        }).start();
    }
    
    @Override
    protected void onResume() {
        super.onResume();
        // Only reload if activity was already created (not on first create)
        // This prevents double loading on first launch
        if (!isLoadingFeedback && feedbackList != null) {
            // Reload feedback when activity resumes (in case new feedback was added)
            loadFeedbackFromDatabase();
        }
    }

    private void setupSearchView() {
        searchView.setOnQueryTextListener(new SearchView.OnQueryTextListener() {
            @Override
            public boolean onQueryTextSubmit(String query) {
                filterFeedback(query);
                return false;
            }

            @Override
            public boolean onQueryTextChange(String newText) {
                filterFeedback(newText);
                return false;
            }
        });
    }

    private void filterFeedback(String query) {
        filteredList.clear();
        if (TextUtils.isEmpty(query)) {
            // Add all items, but check for duplicates
            for (FeedbackModel feedback : feedbackList) {
                // Check if this feedback is already in filtered list to prevent duplicates
                boolean isDuplicate = false;
                for (FeedbackModel existing : filteredList) {
                    if (existing.getName().equals(feedback.getName()) &&
                        existing.getComment().equals(feedback.getComment()) &&
                        existing.getRating() == feedback.getRating() &&
                        existing.getDate().equals(feedback.getDate())) {
                        isDuplicate = true;
                        break;
                    }
                }
                if (!isDuplicate) {
                    filteredList.add(feedback);
                }
            }
        } else {
            for (FeedbackModel feedback : feedbackList) {
                if (feedback.getName().toLowerCase().contains(query.toLowerCase()) ||
                    feedback.getComment().toLowerCase().contains(query.toLowerCase())) {
                    // Check for duplicates in filtered list
                    boolean isDuplicate = false;
                    for (FeedbackModel existing : filteredList) {
                        if (existing.getName().equals(feedback.getName()) &&
                            existing.getComment().equals(feedback.getComment()) &&
                            existing.getRating() == feedback.getRating() &&
                            existing.getDate().equals(feedback.getDate())) {
                            isDuplicate = true;
                            break;
                        }
                    }
                    if (!isDuplicate) {
                        filteredList.add(feedback);
                    }
                }
            }
        }
        
        System.out.println("DEBUG - filterFeedback: feedbackList size=" + feedbackList.size() + ", filteredList size=" + filteredList.size());
        feedbackAdapter.notifyDataSetChanged();
    }

    private void setupAddFeedbackButton() {
        // Hide button for Admin users
        if ("Admin".equals(userRole)) {
            btnAddFeedback.setVisibility(View.GONE);
            return;
        }
        
        btnAddFeedback.setOnClickListener(v -> {
            if (hasBookings) {
                showAddFeedbackDialog();
            } else {
                showNoBookingDialog();
            }
        });
    }

    private void showAddFeedbackDialog() {
        Dialog dialog = new Dialog(this);
        dialog.setContentView(R.layout.dialog_add_feedback);
        dialog.getWindow().setBackgroundDrawableResource(android.R.color.transparent);

        EditText etName = dialog.findViewById(R.id.etName);
        EditText etComment = dialog.findViewById(R.id.etComment);
        RatingBar ratingBar = dialog.findViewById(R.id.ratingBar);
        Button btnSubmit = dialog.findViewById(R.id.btnSubmit);
        Button btnCancel = dialog.findViewById(R.id.btnCancel);

        // Pre-fill name with user's name
        if (username != null && !username.isEmpty()) {
            etName.setText(username);
            etName.setEnabled(false); // Disable editing since it's the logged-in user
        }

        btnSubmit.setOnClickListener(v -> {
            String name = etName.getText().toString().trim();
            String comment = etComment.getText().toString().trim();
            float rating = ratingBar.getRating();

            if (name.isEmpty() || comment.isEmpty()) {
                Toast.makeText(this, "Sila isi semua medan", Toast.LENGTH_SHORT).show();
                return;
            }

            if (rating == 0) {
                Toast.makeText(this, "Sila berikan rating", Toast.LENGTH_SHORT).show();
                return;
            }

            // Save feedback to database
            saveFeedbackToDatabase(name, comment, rating);
            dialog.dismiss();
        });

        btnCancel.setOnClickListener(v -> dialog.dismiss());

        dialog.show();
    }

    @Override
    public void onBackPressed() {
        System.out.println("DEBUG - onBackPressed called in FeedbackActivity");
        Toast.makeText(this, "Kembali ke halaman sebelumnya", Toast.LENGTH_SHORT).show();
        super.onBackPressed();
    }

    private void setupBackButton() {
        btnBack.setOnClickListener(v -> {
            System.out.println("DEBUG - Back button clicked in FeedbackActivity");
            Toast.makeText(this, "Kembali ke halaman sebelumnya", Toast.LENGTH_SHORT).show();
            finish();
        });
    }

    private void checkUserBookings() {
        new Thread(() -> {
            try {
                System.out.println("DEBUG - Checking bookings for user ID: " + userId);
                
                // Skip booking check for Admin (button already hidden)
                if ("Admin".equals(userRole)) {
                    hasBookings = false; // Not needed since button is hidden
                    return;
                }
                
                // Check if user has any bookings
                List<BookingModel> bookings = connectionClass.getBookingsByUserId(userId);
                hasBookings = bookings != null && !bookings.isEmpty();
                
                runOnUiThread(() -> {
                    System.out.println("DEBUG - User has bookings: " + hasBookings);
                    // Skip button setup for Admin (button already hidden)
                    if ("Admin".equals(userRole)) {
                        return;
                    }
                    
                    if (!hasBookings) {
                        // Disable add feedback button for users without bookings
                        btnAddFeedback.setEnabled(false);
                        btnAddFeedback.setAlpha(0.5f);
                        btnAddFeedback.setText("Make a booking first to give feedback");
                    }
                });
                
            } catch (Exception e) {
                e.printStackTrace();
                System.out.println("DEBUG - Error checking user bookings: " + e.getMessage());
                runOnUiThread(() -> {
                    // On error, allow feedback (fallback)
                    hasBookings = true;
                });
            }
        }).start();
    }

    private void showNoBookingDialog() {
        androidx.appcompat.app.AlertDialog.Builder builder = new androidx.appcompat.app.AlertDialog.Builder(this);
        builder.setTitle("No Bookings Found");
        builder.setMessage("You need to make at least one booking before you can give feedback. Please make a booking first and then come back to share your experience.");
        builder.setPositiveButton("Make Booking", (dialog, which) -> {
            // Navigate to booking page
            Intent intent = new Intent(this, BookingActivity.class);
            intent.putExtra("USER_ID", userId);
            intent.putExtra("ROLE", userRole);
            intent.putExtra("USERNAME", username);
            startActivity(intent);
            finish();
        });
        builder.setNegativeButton("Cancel", (dialog, which) -> dialog.dismiss());
        builder.show();
    }
    
    // Save feedback to database
    private void saveFeedbackToDatabase(String name, String comment, float rating) {
        new Thread(() -> {
            try {
                System.out.println("DEBUG - Saving feedback to database...");
                System.out.println("DEBUG - User ID: " + userId);
                System.out.println("DEBUG - Name: " + name);
                System.out.println("DEBUG - Comment: " + comment);
                System.out.println("DEBUG - Rating: " + rating);
                
                String result = connectionClass.addFeedback(userId, name, comment, rating);
                
                runOnUiThread(() -> {
                    if ("success".equals(result)) {
                        Toast.makeText(this, "Feedback berjaya ditambah!", Toast.LENGTH_SHORT).show();
                        
                        // Reload feedback from database to show new feedback
                        loadFeedbackFromDatabase();
                    } else {
                        Toast.makeText(this, "Ralat menambah feedback: " + result, Toast.LENGTH_SHORT).show();
                    }
                });
            } catch (Exception e) {
                e.printStackTrace();
                System.out.println("DEBUG - Error saving feedback: " + e.getMessage());
                runOnUiThread(() -> {
                    Toast.makeText(this, "Ralat menambah feedback", Toast.LENGTH_SHORT).show();
                });
            }
        }).start();
    }
}
