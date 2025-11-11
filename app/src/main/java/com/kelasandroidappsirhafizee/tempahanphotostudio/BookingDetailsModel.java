package com.kelasandroidappsirhafizee.tempahanphotostudio;

import java.io.Serializable;
import java.util.Date;

public class BookingDetailsModel implements Serializable {
    private int bookingId;
    private int userId;
    private int packageId;
    private int subPackageId;
    private String packageName;
    private String subPackageName;
    private String category;
    private String event;
    private String duration;
    private String packageClass;
    private String details;
    private String bookingDate;
    private String eventDate;
    private String eventTime;
    private String status;
    private double price;
    private String paymentMethod;
    private String paymentStatus;
    private String notes;
    private String userName;
    private String userEmail;
    private Date createdAt;

    public BookingDetailsModel() {}

    // Getters and Setters
    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getPackageId() { return packageId; }
    public void setPackageId(int packageId) { this.packageId = packageId; }

    public int getSubPackageId() { return subPackageId; }
    public void setSubPackageId(int subPackageId) { this.subPackageId = subPackageId; }

    public String getPackageName() { return packageName; }
    public void setPackageName(String packageName) { this.packageName = packageName; }

    public String getSubPackageName() { return subPackageName; }
    public void setSubPackageName(String subPackageName) { this.subPackageName = subPackageName; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getEvent() { return event; }
    public void setEvent(String event) { this.event = event; }

    public String getDuration() { return duration; }
    public void setDuration(String duration) { this.duration = duration; }

    public String getPackageClass() { return packageClass; }
    public void setPackageClass(String packageClass) { this.packageClass = packageClass; }

    public String getDetails() { return details; }
    public void setDetails(String details) { this.details = details; }


    public String getBookingDate() { return bookingDate; }
    public void setBookingDate(String bookingDate) { this.bookingDate = bookingDate; }

    public String getEventDate() { return eventDate; }
    public void setEventDate(String eventDate) { this.eventDate = eventDate; }

    public String getEventTime() { return eventTime; }
    public void setEventTime(String eventTime) { this.eventTime = eventTime; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getUserEmail() { return userEmail; }
    public void setUserEmail(String userEmail) { this.userEmail = userEmail; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
}
