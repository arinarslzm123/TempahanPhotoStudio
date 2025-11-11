package com.kelasandroidappsirhafizee.tempahanphotostudio;

public class SubPackageModel {
    private int id;
    private int packageId;
    private String subPackageName;
    private double price;
    private String description;
    private String duration;
    private String media; // simpan image/video url

    public SubPackageModel(int id, int packageId, String subPackageName, double price, String description, String duration, String media) {
        this.id = id;
        this.packageId = packageId;
        this.subPackageName = subPackageName;
        this.price = price;
        this.description = description;
        this.duration = duration;
        this.media = media;
    }

    // Getter & Setter
    public int getId() {
        return id;
    }

    public int getPackageId() {
        return packageId;
    }

    public String getSubPackageName() {
        return subPackageName;
    }

    public double getPrice() {
        return price;
    }

    public String getDescription() {
        return description;
    }

    public String getDuration() {
        return duration;
    }

    public String getMedia() {
        return media;
    }

    public void setMedia(String media) {
        this.media = media;
    }
}
