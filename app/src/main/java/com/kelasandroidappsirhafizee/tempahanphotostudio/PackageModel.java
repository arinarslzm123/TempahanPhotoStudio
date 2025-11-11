package com.kelasandroidappsirhafizee.tempahanphotostudio;

public class PackageModel {
    private int id;
    private String packageId;
    private String packageName;
    private String event;
    private String duration;
    private String category;
    private String description;
    private String imageUrl;
    private double price;

    // Empty constructor
    public PackageModel() {}

    // Full constructor
    public PackageModel(int id, String packageId, String packageName, String event, String duration,
                        String category, String description, String imageUrl, double price) {
        this.id = id;
        this.packageId = packageId;
        this.packageName = packageName;
        this.event = event;
        this.duration = duration;
        this.category = category;
        this.description = description;
        this.imageUrl = imageUrl;
        this.price = price;
    }

    // Constructor for PhotographyPackageActivity
    public PackageModel(int id, String packageId, String packageName, String category, String duration, double price, String description) {
        this.id = id;
        this.packageId = packageId;
        this.packageName = packageName;
        this.category = category;
        this.duration = duration;
        this.price = price;
        this.description = description;
        this.event = category; // Use category as event for compatibility
    }

    // Getters
    public int getId() { return id; }
    public String getPackageId() { return packageId; }
    public String getPackageName() { return packageName; }
    public String getEvent() { return event; }
    public String getDuration() { return duration; }
    public String getCategory() { return category; }
    public String getDescription() { return description; }
    public String getImageUrl() { return imageUrl; }
    public double getPrice() { return price; }

    // Setters
    public void setId(int id) { this.id = id; }
    public void setPackageId(String packageId) { this.packageId = packageId; }
    public void setPackageName(String packageName) { this.packageName = packageName; }
    public void setEvent(String event) { this.event = event; }
    public void setDuration(String duration) { this.duration = duration; }
    public void setCategory(String category) { this.category = category; }
    public void setDescription(String description) { this.description = description; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    public void setPrice(double price) { this.price = price; }
}
