package com.kelasandroidappsirhafizee.tempahanphotostudio;

import android.content.Intent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageButton;
import android.widget.TextView;

import androidx.recyclerview.widget.RecyclerView;

import java.util.ArrayList;

public class SubPackageAdapter extends RecyclerView.Adapter<SubPackageAdapter.ViewHolder> {
    private ArrayList<SubPackageModel> subPackageList;
    private String role;
    private OnSubPackageActionListener listener;
    private int userId;
    private String username;

    public interface OnSubPackageActionListener {
        void onEdit(SubPackageModel subPackage);
        void onDelete(SubPackageModel subPackage);
    }

    public SubPackageAdapter(ArrayList<SubPackageModel> subPackageList, String role, OnSubPackageActionListener listener) {
        this.subPackageList = subPackageList;
        this.role = role;
        this.listener = listener;
    }
    
    public SubPackageAdapter(ArrayList<SubPackageModel> subPackageList, String role, OnSubPackageActionListener listener, int userId, String username) {
        this.subPackageList = subPackageList;
        this.role = role;
        this.listener = listener;
        this.userId = userId;
        this.username = username;
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_sub_package, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(ViewHolder holder, int position) {
        SubPackageModel subPackage = subPackageList.get(position);
        holder.tvSubPackageName.setText(subPackage.getSubPackageName());
        holder.tvPrice.setText("RM " + subPackage.getPrice());
        holder.tvDuration.setText(subPackage.getDuration());

        // Hanya Admin nampak butang Edit/Delete
        if ("Admin".equals(role)) {
            holder.btnEdit.setVisibility(View.VISIBLE);
            holder.btnDelete.setVisibility(View.VISIBLE);

            holder.btnEdit.setOnClickListener(v -> listener.onEdit(subPackage));
            holder.btnDelete.setOnClickListener(v -> listener.onDelete(subPackage));
        } else {
            holder.btnEdit.setVisibility(View.GONE);
            holder.btnDelete.setVisibility(View.GONE);
        }

        // ✅ Klik item buka DetailSubPackageActivity
        holder.itemView.setOnClickListener(v -> {
            Intent intent = new Intent(v.getContext(), DetailSubPackageActivity.class);
            intent.putExtra("SUB_PACKAGE_ID", subPackage.getId());
            intent.putExtra("USER_ID", userId);
            intent.putExtra("ROLE", role);
            intent.putExtra("USERNAME", username);
            v.getContext().startActivity(intent);
        });

    }

    @Override
    public int getItemCount() {
        return subPackageList.size();
    }

    public static class ViewHolder extends RecyclerView.ViewHolder {
        TextView tvSubPackageName, tvPrice, tvDuration;
        ImageButton btnEdit, btnDelete;

        public ViewHolder(View itemView) {
            super(itemView);
            tvSubPackageName = itemView.findViewById(R.id.tvSubPackageName);
            tvPrice = itemView.findViewById(R.id.tvPrice);
            tvDuration = itemView.findViewById(R.id.tvDuration);
            btnEdit = itemView.findViewById(R.id.btnEdit);
            btnDelete = itemView.findViewById(R.id.btnDelete);
        }
    }
}
