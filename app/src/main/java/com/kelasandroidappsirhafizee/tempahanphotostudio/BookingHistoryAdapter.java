package com.kelasandroidappsirhafizee.tempahanphotostudio;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Locale;

public class BookingHistoryAdapter extends RecyclerView.Adapter<BookingHistoryAdapter.ViewHolder> {
    private ArrayList<BookingDetailsModel> bookingList;
    private OnItemClickListener listener;
    private OnActionClickListener actionListener;
    private String userRole; // Add user role to control button visibility

    public interface OnItemClickListener {
        void onBookingClick(BookingDetailsModel booking);
    }

    public interface OnActionClickListener {
        void onBookingAction(BookingDetailsModel booking, String action);
    }

    public BookingHistoryAdapter(ArrayList<BookingDetailsModel> bookingList, OnItemClickListener listener, OnActionClickListener actionListener, String userRole) {
        this.bookingList = bookingList;
        this.listener = listener;
        this.actionListener = actionListener;
        this.userRole = userRole;
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_booking_history, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, int position) {
        BookingDetailsModel booking = bookingList.get(position);
        
        // Set booking ID
        holder.tvBookingId.setText("BK-" + String.format("%03d", booking.getBookingId()));
        
        // Set status with color
        holder.tvBookingStatus.setText(booking.getStatus());
        setStatusColor(holder.tvBookingStatus, booking.getStatus());
        
        // Set package name
        holder.tvPackageName.setText(booking.getPackageName());
        
        // Set event date
        holder.tvEventDate.setText("Tarikh Acara: " + booking.getEventDate());
        
        // Set sub package
        holder.tvSubPackage.setText(booking.getPackageClass() + " Package");
        
        // Set total amount
        holder.tvTotalAmount.setText("RM " + String.format("%.2f", booking.getPrice()));
        
        // Set payment status
        holder.tvPaymentStatus.setText("Bayaran: " + booking.getPaymentStatus());
        setPaymentStatusColor(holder.tvPaymentStatus, booking.getPaymentStatus());

        // Show/hide action buttons based on status and user role
        if ("Pending".equals(booking.getStatus())) {
            // Only admin can confirm bookings
            if ("Admin".equals(userRole)) {
                holder.btnConfirm.setVisibility(View.VISIBLE);
                holder.btnConfirm.setText("Sahkan");
            } else {
                holder.btnConfirm.setVisibility(View.GONE);
            }
            // Both admin and user can cancel pending bookings
            holder.btnCancel.setVisibility(View.VISIBLE);
            holder.btnCancel.setText("Batalkan");
        } else if ("Confirmed".equals(booking.getStatus())) {
            // Hide both buttons for confirmed bookings (admin already confirmed, no need to cancel)
            holder.btnConfirm.setVisibility(View.GONE);
            holder.btnCancel.setVisibility(View.GONE);
        } else {
            // No actions for completed/cancelled bookings
            holder.btnConfirm.setVisibility(View.GONE);
            holder.btnCancel.setVisibility(View.GONE);
        }
        
        // Set click listeners
        holder.itemView.setOnClickListener(v -> {
            if (listener != null) {
                listener.onBookingClick(booking);
            }
        });

        holder.btnConfirm.setOnClickListener(v -> {
            if (actionListener != null) {
                actionListener.onBookingAction(booking, "confirm");
            }
        });

        holder.btnCancel.setOnClickListener(v -> {
            if (actionListener != null) {
                actionListener.onBookingAction(booking, "cancel");
            }
        });
    }

    @Override
    public int getItemCount() {
        return bookingList.size();
    }

    private void setStatusColor(TextView textView, String status) {
        switch (status.toLowerCase()) {
            case "confirmed":
                textView.setTextColor(textView.getContext().getResources().getColor(android.R.color.holo_green_dark));
                break;
            case "pending":
                textView.setTextColor(textView.getContext().getResources().getColor(android.R.color.holo_orange_dark));
                break;
            case "cancelled":
                textView.setTextColor(textView.getContext().getResources().getColor(android.R.color.holo_red_dark));
                break;
            default:
                textView.setTextColor(textView.getContext().getResources().getColor(android.R.color.darker_gray));
                break;
        }
    }

    private void setPaymentStatusColor(TextView textView, String paymentStatus) {
        switch (paymentStatus.toLowerCase()) {
            case "paid":
                textView.setTextColor(textView.getContext().getResources().getColor(android.R.color.holo_green_dark));
                break;
            case "pending":
                textView.setTextColor(textView.getContext().getResources().getColor(android.R.color.holo_orange_dark));
                break;
            case "refunded":
                textView.setTextColor(textView.getContext().getResources().getColor(android.R.color.holo_blue_dark));
                break;
            default:
                textView.setTextColor(textView.getContext().getResources().getColor(android.R.color.darker_gray));
                break;
        }
    }

    public static class ViewHolder extends RecyclerView.ViewHolder {
        TextView tvBookingId, tvBookingStatus, tvPackageName, tvEventDate, 
                 tvSubPackage, tvTotalAmount, tvPaymentStatus;
        Button btnConfirm, btnCancel;

        public ViewHolder(@NonNull View itemView) {
            super(itemView);
            tvBookingId = itemView.findViewById(R.id.tvBookingId);
            tvBookingStatus = itemView.findViewById(R.id.tvBookingStatus);
            tvPackageName = itemView.findViewById(R.id.tvPackageName);
            tvEventDate = itemView.findViewById(R.id.tvEventDate);
            tvSubPackage = itemView.findViewById(R.id.tvSubPackage);
            tvTotalAmount = itemView.findViewById(R.id.tvTotalAmount);
            tvPaymentStatus = itemView.findViewById(R.id.tvPaymentStatus);
            btnConfirm = itemView.findViewById(R.id.btnConfirm);
            btnCancel = itemView.findViewById(R.id.btnCancel);
        }
    }
}
