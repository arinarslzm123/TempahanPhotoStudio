package com.kelasandroidappsirhafizee.tempahanphotostudio;

public class FeedbackModel {
    private String name;
    private String comment;
    private float rating;
    private String date;
    private int profileImage;

    public FeedbackModel(String name, String comment, float rating, String date, int profileImage) {
        this.name = name;
        this.comment = comment;
        this.rating = rating;
        this.date = date;
        this.profileImage = profileImage;
    }

    // Getters and Setters
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public float getRating() {
        return rating;
    }

    public void setRating(float rating) {
        this.rating = rating;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public int getProfileImage() {
        return profileImage;
    }

    public void setProfileImage(int profileImage) {
        this.profileImage = profileImage;
    }
}
