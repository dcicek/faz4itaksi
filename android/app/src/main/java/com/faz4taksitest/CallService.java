package com.faz4taksitest;

import android.app.Service;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.IBinder;
import android.widget.Toast;

public class CallService extends Service {
    CallReceiver receiver=new CallReceiver();
    CallReceiver receiver2=new CallReceiver();
    public CallService() {
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        registerReceiver(receiver2,new IntentFilter("android.intent.action.BOOT_COMPLETED"));
        return START_STICKY;
    }
}