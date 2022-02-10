package com.jingos.log.service;

import android.app.Service;
import android.content.Intent;
import android.os.IBinder;

import com.jingos.log.Constants;
import com.umeng.commonsdk.UMConfigure;

public class LogService extends Service {

    @Override
    public void onCreate() {
        super.onCreate();
        //todo
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        if(!UMConfigure.isInit || !UMConfigure.getInitStatus()){
            Constants.registerUM(this,"service");
        }
        return super.onStartCommand(intent, flags, startId);
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }
}
