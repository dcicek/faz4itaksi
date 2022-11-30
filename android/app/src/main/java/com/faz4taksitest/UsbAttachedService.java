package com.faz4taksitest;

import android.app.Service;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.IBinder;

public class UsbAttachedService extends Service {
    CallReceiver receiver=new CallReceiver();
    CallReceiver receiver2=new CallReceiver();
    public void CallService() {
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        registerReceiver(receiver2,new IntentFilter("android.hardware.usb.action.USB_DEVICE_ATTACHED"));
        return START_STICKY;
    }
}
