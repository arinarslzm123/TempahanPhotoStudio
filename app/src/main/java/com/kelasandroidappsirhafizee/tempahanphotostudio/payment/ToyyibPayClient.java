package com.kelasandroidappsirhafizee.tempahanphotostudio.payment;

import android.text.TextUtils;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import okhttp3.OkHttpClient;
import okhttp3.logging.HttpLoggingInterceptor;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

import java.util.concurrent.TimeUnit;

/**
 * Configures Retrofit client for ToyyibPay backend interaction.
 * Copied from MizrahBeauty project - DO NOT MODIFY SOURCE
 * 
 * IMPORTANT: Update BASE_URL to your Render backend URL
 */
public final class ToyyibPayClient {

    // ⚠️ UPDATE THIS TO YOUR RENDER BACKEND URL
    private static final String BASE_URL = "https://tempahanphotostudio.onrender.com/";

    private static Retrofit retrofitInstance;

    private ToyyibPayClient() {
        // no-op
    }

    public static ToyyibPayApi getApi() {
        if (retrofitInstance == null) {
            synchronized (ToyyibPayClient.class) {
                if (retrofitInstance == null) {
                    if (TextUtils.isEmpty(BASE_URL)) {
                        throw new IllegalStateException("ToyyibPayClient BASE_URL must not be empty.");
                    }

                    HttpLoggingInterceptor logging = new HttpLoggingInterceptor();
                    logging.level(HttpLoggingInterceptor.Level.BODY);

                    // Increase timeouts for Render cold start (free tier can take 30-60s)
                    OkHttpClient client = new OkHttpClient.Builder()
                            .addInterceptor(logging)
                            .connectTimeout(60, TimeUnit.SECONDS)
                            .readTimeout(60, TimeUnit.SECONDS)
                            .writeTimeout(60, TimeUnit.SECONDS)
                            .build();

                    Gson gson = new GsonBuilder()
                            .setLenient()
                            .create();

                    retrofitInstance = new Retrofit.Builder()
                            .baseUrl(BASE_URL)
                            .client(client)
                            .addConverterFactory(GsonConverterFactory.create(gson))
                            .build();
                }
            }
        }
        return retrofitInstance.create(ToyyibPayApi.class);
    }
}

