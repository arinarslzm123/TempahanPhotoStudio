package com.kelasandroidappsirhafizee.tempahanphotostudio;

import android.content.Context;
import android.content.Intent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import java.util.List;

public class VideographyPackageAdapter extends RecyclerView.Adapter<VideographyPackageAdapter.PackageViewHolder> {
    private Context context;
    private List<PackageModel> packageList;
    private String role;
    private String username;

    public VideographyPackageAdapter(Context context, List<PackageModel> packageList, String role, String username) {
        this.context = context;
        this.packageList = packageList;
        this.role = role;
        this.username = username;
    }

    @NonNull
    @Override
    public PackageViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(context).inflate(R.layout.item_videography_package, parent, false);
        return new PackageViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull PackageViewHolder holder, int position) {
        PackageModel packageModel = packageList.get(position);
        
        // Set package code (using ID)
        holder.tvPackageCode.setText("VID-" + String.format("%03d", packageModel.getId()));
        
        // Set package name
        holder.tvPackageName.setText(packageModel.getPackageName());
        
        // Set event and duration
        holder.tvEventDuration.setText(packageModel.getEvent() + " | " + packageModel.getDuration());

        // Set click listener
        holder.itemView.setOnClickListener(v -> {
            Intent intent;
            if (role != null && role.equals("Admin")) {
                // Admin can edit/delete packages
                intent = new Intent(context, AddEditPackageActivity.class);
                intent.putExtra("PACKAGE_ID", packageModel.getId());
            } else {
                // User can view sub-packages
                intent = new Intent(context, ListSubPackageActivity.class);
                intent.putExtra("PACKAGE_ID", packageModel.getId());
                intent.putExtra("PACKAGE_NAME", packageModel.getPackageName());
                intent.putExtra("PACKAGE_EVENT", packageModel.getEvent());
                intent.putExtra("PACKAGE_DURATION", packageModel.getDuration());
            }
            intent.putExtra("CATEGORY", "Videography");
            intent.putExtra("ROLE", role);
            intent.putExtra("USERNAME", username);
            context.startActivity(intent);
        });
    }

    @Override
    public int getItemCount() {
        return packageList.size();
    }

    public static class PackageViewHolder extends RecyclerView.ViewHolder {
        TextView tvPackageCode;
        TextView tvPackageName;
        TextView tvEventDuration;

        public PackageViewHolder(@NonNull View itemView) {
            super(itemView);
            tvPackageCode = itemView.findViewById(R.id.tvPackageCode);
            tvPackageName = itemView.findViewById(R.id.tvPackageName);
            tvEventDuration = itemView.findViewById(R.id.tvEventDuration);
        }
    }
}
