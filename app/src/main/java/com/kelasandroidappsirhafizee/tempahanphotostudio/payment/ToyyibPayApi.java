package com.kelasandroidappsirhafizee.tempahanphotostudio.payment;

import com.kelasandroidappsirhafizee.tempahanphotostudio.payment.requests.CreateBillRequest;
import com.kelasandroidappsirhafizee.tempahanphotostudio.payment.responses.CreateBillResponse;
import com.kelasandroidappsirhafizee.tempahanphotostudio.payment.responses.PaymentStatusResponse;

import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.GET;
import retrofit2.http.POST;
import retrofit2.http.Query;

/**
 * Retrofit interface for communicating with your backend ToyyibPay proxy.
 * The backend should wrap the actual ToyyibPay APIs so that the Android app
 * never handles secret keys directly.
 * Copied from MizrahBeauty project - DO NOT MODIFY SOURCE
 */
public interface ToyyibPayApi {

    @POST("toyyibpay/payment/bill")
    Call<CreateBillResponse> createBill(@Body CreateBillRequest request);

    @GET("toyyibpay/payment/status")
    Call<PaymentStatusResponse> getPaymentStatus(@Query("billCode") String billCode);
}

