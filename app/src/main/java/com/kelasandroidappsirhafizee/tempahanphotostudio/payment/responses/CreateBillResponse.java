package com.kelasandroidappsirhafizee.tempahanphotostudio.payment.responses;

import com.google.gson.annotations.SerializedName;

/**
 * Response from backend after creating ToyyibPay bill
 * Copied from MizrahBeauty project - DO NOT MODIFY SOURCE
 */
public class CreateBillResponse {

    @SerializedName("billCode")
    private String billCode;

    @SerializedName("paymentUrl")
    private String paymentUrl;

    @SerializedName("status")
    private String status;

    public String getBillCode() {
        return billCode;
    }

    public String getPaymentUrl() {
        return paymentUrl;
    }

    public String getStatus() {
        return status;
    }
}

