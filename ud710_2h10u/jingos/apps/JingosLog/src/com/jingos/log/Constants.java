package com.jingos.log;

import android.annotation.SuppressLint;
import android.app.Application;
import android.content.Context;
import android.util.Log;
import android.os.Build;
import android.text.TextUtils;
import android.content.SharedPreferences;
import android.os.Build;

import com.umeng.analytics.MobclickAgent;
import com.umeng.commonsdk.UMConfigure;

import android.net.ConnectivityManager;
import android.net.Network;
import java.net.Inet6Address;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Enumeration;
import java.util.UUID;
import java.lang.reflect.Method;

public class Constants {

    /**
     * the umeng appkey
     */
    public static final String UMENG_APPKEY="610a483a26e9627944b5c74e";

    /**
     * the channel name
     */
    public static final String CHANNEL = "UMENG";


    /**
     * the umeng is init
     */
    private static volatile boolean mIsInit = false;

    /**
     * the cus event
     */
    public static String FLAG = "JingOS";

    /**
     * the wait with register
     */
    private static volatile boolean mIsWait = false;

    /**
     * device id
     */
    private static String KEY_UUID = "jingos_uuid";

    private static Context mContext;

    @SuppressLint("StaticFieldLeak")
    private static volatile Application sApplication;

    public static Application getApplicationContext() {
        if (sApplication == null) {
            synchronized (Constants.class) {
                if (sApplication == null) {
                    try {
                        sApplication = (Application) Class.forName("android.app.ActivityThread")
                                .getMethod("currentApplication")
                                .invoke(null, (Object[]) null);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }
        }
        return sApplication;
    }

    /**
     * Return the application's package name.
     *
     * @return the application's package name
     */
    public static String getPackageName() {
        return getApplicationContext().getPackageName();
    }

    public static void registerUM(Context context,String tag) {
        mContext = context;
        if ((UMConfigure.getInitStatus() && UMConfigure.isInit) || (mContext == null)) return;
        
        UMConfigure.preInit(mContext, Constants.UMENG_APPKEY, Constants.CHANNEL);
        UMConfigure.init(mContext, Constants.UMENG_APPKEY, Constants.CHANNEL, UMConfigure.DEVICE_TYPE_PHONE, null);
        UMConfigure.setLogEnabled(true);
        MobclickAgent.setPageCollectionMode(MobclickAgent.PageMode.AUTO);
        MobclickAgent.setSessionContinueMillis(30);
        Location.getInstance().setDefaultPrivacy(context).initLocation(context);
        if (!mIsWait) {
            waitRegisterUM(context, tag);
        }
    }

    private static void waitRegisterUM(Context context, final String tag) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                while (!mIsInit) {
                    try {
                        Thread.sleep(15000);
                        Boolean initStatus = UMConfigure.getInitStatus();
                        UMConfigure.needSendZcfgEnv(context);
                        Boolean isInit = UMConfigure.isInit;
                        String display = Build.DISPLAY;
                        StringBuilder stringBuilder = new StringBuilder(display);
                        String hostIp = getHostIP();
                        if (!TextUtils.isEmpty(hostIp)) {
                            stringBuilder.append("-").append(hostIp);
                        } else {
                            stringBuilder.append("-").append(getMacFromHardware());
                        }
                        String deviceId = stringBuilder.toString();
                        boolean isNetworkAvailable = isNetworkAvailable(context);
                        Log.i("--jsd--", "log~initStatus:" + initStatus + " | isInit:" + isInit + " | tag:" + tag+" | deviceId:"+deviceId+" | isNetworkAvailable:"+isNetworkAvailable);
                        if(isNetworkAvailable){
                            if(!Location.getInstance().isRegisterRealNet){
                                Location.getInstance().startLocation();
                            }
                            if (!initStatus || !isInit) {
                                registerUM(mContext, tag);
                            } else {
    //                            mIsInit = true;
                                mIsWait = true;
                                MobclickAgent.onResume(context);
                                MobclickAgent.onPause(context);
                                MobclickAgent.onEvent(context, deviceId);
                            }  
                        }
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                        Log.i("--jsd--", "log~e:" + e.getMessage() + " | tag:" + tag);
                    }
                }
            }
        }).start();
    }


    public static boolean isNetworkAvailable(Context context) {
        ConnectivityManager connectivityManager = context.getSystemService(ConnectivityManager.class);
        if (connectivityManager != null) {
            Network network = connectivityManager.getActiveNetwork();
            return network != null;
        }
        return false;
    }

    public static Network getNetwork(Context context) {
        ConnectivityManager connectivityManager = context.getSystemService(ConnectivityManager.class);
        if (connectivityManager != null) {
            return connectivityManager.getActiveNetwork();
        }
        return null;
    }


    /**
     * get MAC
     *
     * @return
     */
    public static String getMacFromHardware() {
        try {
            ArrayList<NetworkInterface> networkInterfaces = Collections.list(NetworkInterface.getNetworkInterfaces());
            for (NetworkInterface networkInterface : networkInterfaces) {
                if (networkInterface.getName().toLowerCase().equals("wlan0")) continue;
                byte[] macBytes = networkInterface.getHardwareAddress();
                if (macBytes == null) return "";
                StringBuilder stringBuilder = new StringBuilder();
                for (byte b : macBytes) {
                    stringBuilder.append(b);
                }
                if (stringBuilder.length() > 0) {
                    stringBuilder.deleteCharAt(stringBuilder.length() - 1);
                }
                return stringBuilder.toString();
            }
        } catch (Exception e) {
        }
        String uuid = getString(KEY_UUID);
        if (TextUtils.isEmpty(uuid)) {
            uuid = UUID.randomUUID().toString();
            putString(KEY_UUID, uuid);
        }
        return uuid;
    }

    /**
     * get Ip
     *
     * @return
     */
    private static String getHostIP() {
        String hostIp = "";
        try {
            Enumeration nis = NetworkInterface.getNetworkInterfaces();
            InetAddress ia;
            while (nis.hasMoreElements()) {
                NetworkInterface ni = (NetworkInterface) nis.nextElement();
                Enumeration<InetAddress> ias = ni.getInetAddresses();
                while (ias.hasMoreElements()) {
                    ia = ias.nextElement();
                    if (ia instanceof Inet6Address) {
                        continue;// skip ipv6
                    }
                    String ip = ia.getHostAddress();
                    if (!"127.0.0.1".equals(ip)) {
                        hostIp = ia.getHostAddress();
                        break;
                    }
                }
            }
        } catch (SocketException e) {
            Log.i("--jsd--", "log~e:" + e.getMessage());
        }
        return hostIp;
    }

    public static boolean putString(String key, String value) {
        return getEdit().putString(key, value).commit();
    }

    public static String getString(String key) {
        String value = getSharedPreferences().getString(key, "");
        return value;
    }

    public static SharedPreferences.Editor getEdit() {
        SharedPreferences sharedPreferences = getApplicationContext()
                .getSharedPreferences(getPackageName(), Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = sharedPreferences.edit();
        return editor;
    }

    public static SharedPreferences getSharedPreferences() {
        return getApplicationContext()
                .getSharedPreferences(getPackageName(), Context.MODE_PRIVATE);
    }

}
