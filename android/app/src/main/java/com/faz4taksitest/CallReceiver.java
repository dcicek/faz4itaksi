package com.faz4taksitest;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.telephony.TelephonyManager;
import android.util.Log;
import android.widget.Toast;

public class CallReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(final Context context, Intent intent) {
        Toast.makeText(context, "Receiver çalıştı", Toast.LENGTH_LONG).show();
        Intent myIntent = new Intent(context, MainActivity.class);
        myIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        context.startActivity(myIntent);
        Toast.makeText(context, "Receiver çalıştı 2", Toast.LENGTH_LONG).show();
    }
}

/*
   String savedNumber="";
            String savedNumber2= intent.getStringExtra(TelephonyManager.EXTRA_INCOMING_NUMBER);
            savedNumber = intent.getExtras().getString("android.intent.extra.PHONE_NUMBER");
        Log.e("Saved number","Numara: "+savedNumber);
        Log.e("İt is ","İt is it");
        Log.e("Saved number 2 ",savedNumber2);
 */