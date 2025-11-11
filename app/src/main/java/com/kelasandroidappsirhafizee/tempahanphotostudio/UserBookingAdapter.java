package com.kelasandroidappsirhafizee.tempahanphotostudio;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import java.util.ArrayList;

public class UserBookingAdapter extends RecyclerView.Adapter<UserBookingAdapter.BookingViewHolder> {
    private Context context;
    private ArrayList<BookingDetailsModel> bookings;
    private OnBookingActionListener listener;

    public interface OnBookingActionListener {
        void onBookingAction(BookingDetailsModel booking, String action);
    }

    public UserBookingAdapter(Context context, ArrayList<BookingDetailsModel> bookings, OnBookingActionListener listener) {
        this.context = context;
        this.bookings = bookings;
        this.listener = listener;
    }

    @NonNull
    @Override
    public BookingViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(context).inflate(R.layout.item_user_booking, parent, false);
        return new BookingViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull BookingViewHolder holder, int position) {
        BookingDetailsModel booking = bookings.get(position);

        holder.tvBookingId.setText(booking.getBookingId());
        holder.tvPackageName.setText(booking.getPackageName());
        holder.tvEventDate.setText("Tarikh Acara: " + booking.getEventDate());
        holder.tvTotalAmount.setText("RM " + String.format("%.2f", booking.getPrice()));

        // ✅ Display booking status directly (Paid/Unpaid)
        String bookingStatus = booking.getStatus();
        String displayStatus = (bookingStatus != null && !bookingStatus.isEmpty()) ? bookingStatus : "Unpaid";
        
        holder.tvStatus.setText(displayStatus);
        
        // Set status color
        int statusColor = getStatusColor(displayStatus);
        holder.tvStatus.setTextColor(statusColor);

        // Set click listener for "Batalkan" button
        holder.btnViewDetails.setOnClickListener(v -> {
            if (listener != null) {
                listener.onBookingAction(booking, "cancel");
            }
        });
    }

    @Override
    public int getItemCount() {
        return bookings.size();
    }

    private int getStatusColor(String status) {
        switch (status) {
            case "Paid":
                return 0xFF4CAF50; // Green
            case "Unpaid":
                return 0xFFFF9800; // Orange
            default:
                return 0xFF666666; // Gray
        }
    }

    public static class BookingViewHolder extends RecyclerView.ViewHolder {
        TextView tvBookingId;
        TextView tvPackageName;
        TextView tvEventDate;
        TextView tvStatus;
        TextView tvTotalAmount;
        Button btnViewDetails; // Repurposed as "Batalkan" button

        public BookingViewHolder(@NonNull View itemView) {
            super(itemView);
            tvBookingId = itemView.findViewById(R.id.tvBookingId);
            tvPackageName = itemView.findViewById(R.id.tvPackageName);
            tvEventDate = itemView.findViewById(R.id.tvEventDate);
            tvStatus = itemView.findViewById(R.id.tvStatus);
            tvTotalAmount = itemView.findViewById(R.id.tvTotalAmount);
            btnViewDetails = itemView.findViewById(R.id.btnViewDetails);
        }
    }
}
