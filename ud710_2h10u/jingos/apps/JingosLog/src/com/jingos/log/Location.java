package com.jingos.log;

import android.app.Service;
import android.content.Context;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.net.ConnectivityManager;
import android.net.Network;
import android.net.NetworkCapabilities;
import android.net.NetworkRequest;
import android.os.Build;
import android.telephony.TelephonyManager;
import android.text.TextUtils;
import android.util.Log;

import com.google.gson.Gson;
import com.google.gson.annotations.Expose;
import com.jingos.log.net.HttpUtil;
import com.jingos.log.net.NetBroadcast;
import com.jingos.log.net.listeners.IHttpListener;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.util.Enumeration;

//import okhttp3.Call;
//import okhttp3.Callback;
//import okhttp3.FormBody;
//import okhttp3.OkHttpClient;
//import okhttp3.Request;
//import okhttp3.RequestBody;
//import okhttp3.Response;

/**
 * Time:2021/11/19 14:24
 * Author:Jack
 * Email:jiangshide@jingos.com
 * Description: Jingos
 */
//public class Location implements AMapLocationListener, Runnable, Callback {
public class Location extends ConnectivityManager.NetworkCallback implements Runnable, IHttpListener, TimeUtil.OnTimeListener {
    private final String TAG = "Location##jsd##";

    private volatile static Location instance;

    private Location() {
    }

    public static Location getInstance() {
        if (instance == null) {
            synchronized (Location.class) {
                if (instance == null) {
                    instance = new Location();
                }
            }
        }
        return instance;
    }

    private Context mContext;

//    private AMapLocationClient mAMapLocationClient;
//    private AMapLocationClientOption mAMapLocationClientOption;

    private ILocation mILocation;

    private int mTimeOut = 30000;
    private int mInterval = 5000;
    private boolean mOnce = false;

    private boolean mAutoUpload = true;
    private String mUrl = "https://om-cn.jingos.com/api/device-android/report";

    private volatile LocationData mLocationData;

    private IHttpListener mIHttpListener;
    private volatile int mRetryNum = 0;
    private volatile int mMaxRetryNum = 10;

    private final String LOCATION_DATA = "locationData";
    private final String SERIAL = "sn";
    private final String COUNTRY = "country";
    private final String PROVINCE = "province";
    private final String CITY = "city";
    private final String DISTRICT = "district";
    private final String STREET = "street";
    private final String SPLIT_AND = "&";

    private boolean mEnableLocation = false;

    private final String IS_UPLOADED = "is_uploaded";
    private final String REQUEST_RESULT_MSG = "requestResultMsg";

    private final String UNKNOW = "unknow";

    private NetBroadcast mNetBroadcast;

    public boolean isRegisterRealNet = false;

    public Location setDefaultPrivacy(Context context) {
//        MapsInitializer.updatePrivacyShow(context, true, true);
//        MapsInitializer.updatePrivacyAgree(context, true);
        return instance;
    }

    public boolean initLocation(Context context) {
        return initLocation(context, null);
    }

    public boolean initLocation(Context context, ILocation iLocation) {
        return initLocation(context, true, iLocation);
    }

    public boolean initLocation(Context context, boolean isPrivacy, ILocation iLocation) {
        this.mContext = context.getApplicationContext();
        if (isPrivacy) {
            setDefaultPrivacy(context);
        }
        this.mILocation = iLocation;
//        if (mAMapLocationClient == null && mEnableLocation) {
//            try {
//                mAMapLocationClient = new AMapLocationClient(context);
//                mAMapLocationClientOption = getDefaultOption();
//                mAMapLocationClient.setLocationOption(mAMapLocationClientOption);
//                mAMapLocationClient.setLocationListener(this);
//                Log.i(TAG, "init success");
//                return true;
//            } catch (Exception e) {
//                e.printStackTrace();
//                return false;
//            }
//        } else {
//            return true;
//        }
        registerRealNet(context);
        return true;
    }

    /**
     * the location default params
     *
     * @return
     */
//    private AMapLocationClientOption getDefaultOption() {
//        AMapLocationClientOption mOption = new AMapLocationClientOption();
//        mOption.setLocationMode(AMapLocationClientOption.AMapLocationMode.Hight_Accuracy);
//        mOption.setGpsFirst(false);
//        mOption.setHttpTimeOut(this.mTimeOut);
//        mOption.setInterval(this.mInterval);
//        mOption.setNeedAddress(true);
//        mOption.setOnceLocation(this.mOnce);
//        mOption.setOnceLocationLatest(false);
//        AMapLocationClientOption.setLocationProtocol(AMapLocationClientOption.AMapLocationProtocol.HTTP);
//        mOption.setSensorEnable(false);
//        mOption.setWifiScan(true);
//        mOption.setLocationCacheEnable(true);
//        return mOption;
//    }
    public Location registerRealNet(Context context) {
        return registerRealNet(context, null);
    }

    public Location registerRealNet(Context context, ConnectivityManager.NetworkCallback callback) {
        ConnectivityManager connectivityManager = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
        if (connectivityManager == null) {
            try {
                NetworkRequest.Builder builder = new NetworkRequest.Builder();
                NetworkRequest networkRequest = builder.build();
                connectivityManager.registerNetworkCallback(networkRequest, callback != null ? callback : this);
                isRegisterRealNet = true;
                Log.i(TAG, "registerRealNet~success");
            } catch (Exception e) {
                Log.e(TAG, "registerRealNet~exception:" + e.getMessage());
                isRegisterRealNet = false;
            }
        }
        if (mNetBroadcast == null) {
            mNetBroadcast = new NetBroadcast(callback != null ? callback : this);
            IntentFilter intentFilter = new IntentFilter(ConnectivityManager.CONNECTIVITY_ACTION);
            context.registerReceiver(mNetBroadcast, intentFilter);
            isRegisterRealNet = true;
        }
        return this;
    }

    @Override
    public void onCapabilitiesChanged(Network network,NetworkCapabilities networkCapabilities) {
        super.onCapabilitiesChanged(network, networkCapabilities);
        stopLocation();
        if (network != null) {
            TimeUtil.getInstance().destroy();
            startLocation();
        }
    }

    public Location setTimeOut(int time) {
        this.mTimeOut = time;
        return this;
    }

    public Location setInterval(int interval) {
        this.mInterval = interval;
        return this;
    }

    public Location setOnce(boolean once) {
        this.mOnce = once;
        return this;
    }

    public Location setUrl(String url) {
        this.mUrl = url;
        return this;
    }

    public Location setEnableUpload(boolean autoUpload) {
        this.mAutoUpload = autoUpload;
        return this;
    }

    public Location setRequestCallback(IHttpListener listener) {
        this.mIHttpListener = listener;
        return this;
    }

    public Location setRetryNum(int retryNum) {
        this.mRetryNum = retryNum;
        return this;
    }

    public Location enableLocation(boolean enableLocation) {
        this.mEnableLocation = enableLocation;
        return this;
    }

    public LocationData getLocationData() {
        return this.mLocationData;
    }

    public void startLocation() {
        startLocation(false);
    }

    public void startLocation(boolean forceStart) {
//        if (mAMapLocationClient == null && mEnableLocation) return;
        boolean isUpload = getBoolean(IS_UPLOADED, false);
        if (isUpload && !forceStart) {
            return;
        }

        if (needUploadData() && !forceStart) {
            this.run();
            return;
        }
        if (!mEnableLocation && !forceStart) {
            setData();
            return;
        }
//        try {
//            mAMapLocationClient.setLocationOption(mAMapLocationClientOption);
//            mAMapLocationClient.startLocation();
//            Log.i(TAG, "startLocation");
//        } catch (Exception e) {
//            Log.e(TAG, "startLocation~e:" + e.getMessage());
//        }
    }


    public void stopLocation() {
//        if (mAMapLocationClient == null) return;
//        try {
//            mAMapLocationClient.stopLocation();
//        } catch (Exception e) {
//            Log.e(TAG, "stopLocation~e:" + e.getMessage());
//        }
        TimeUtil.getInstance().destroy();
    }

    public void destoryLocation(Context context) {
//        if (mAMapLocationClient != null) {
//            mAMapLocationClient.onDestroy();
//            mAMapLocationClient = null;
////            mAMapLocationClientOption = null;
//        }
        if (mNetBroadcast != null) {
            context.unregisterReceiver(mNetBroadcast);
        }
    }

//    @Override
//    public void onLocationChanged(AMapLocation location) {
//        if (location == null) {
//            Log.w(TAG, "location is null");
//            return;
//        }
//        if (mILocation == null) {
//            Log.w(TAG, "iLocation is null");
//            return;
//        }
//        if (location.getErrorCode() != AMapLocation.LOCATION_SUCCESS) {
//            Log.e(TAG, "location is err:" + location.getErrorInfo());
//            this.mILocation.onLocationFail(location.getErrorCode(), location.getErrorInfo());
//            return;
//        }
//        setData(location);
//        stopLocation();
//    }

    private void setData() {
        this.mLocationData = new LocationData();
        if (mILocation != null) {
            this.mILocation.onLocation(this.mLocationData);
        }
        if (this.mAutoUpload) {
            this.run();
        }
    }

//    private void setData(AMapLocation location) {
//        this.mLocationData = new LocationData();
//        this.mLocationData.setLocation(location);
//        this.mILocation.onLocation(this.mLocationData);
//        if (this.mAutoUpload) {
//            this.run();
//        }
//    }

    public void uploadData(LocationData locationData) {
        if (locationData == null || locationData.requestBody == null) return;
//        OkHttpClient okHttpClient = new OkHttpClient().newBuilder().build();
//        Request request = new Request.Builder().url(this.mUrl).post(locationData.requestBody).build();
//        okHttpClient.newCall(request).enqueue(this);
        HttpUtil.doPost(mContext, this.mUrl, this, locationData.requestBody);
    }

    private boolean needUploadData() {
        mLocationData = get(LOCATION_DATA, LocationData.class);
        if (mLocationData != null) {
            mLocationData.setBody();
            return true;
        }
        return false;
    }

    @Override
    public void run() {
        Log.e(TAG, "run");
        uploadData(this.mLocationData);
    }

    @Override
    public void onFail(Exception e) {
        Log.e(TAG, "onFailure~e:" + e.getMessage());
        response(e.getMessage());
        if (mIHttpListener != null) {
            mIHttpListener.onFail(e);
        }
        if (this.mRetryNum < mMaxRetryNum) {
            this.mRetryNum++;
            TimeUtil.getInstance().setListener(this).setSecond(this.mRetryNum << this.mRetryNum).start(TimeUtil.Mode.COUNTDOWNSECOND);
            return;
        }
    }

    @Override
    public void onSuccess(String response) {
        Log.i(TAG, "onResponse~response:" + response);
        if (TextUtils.isEmpty(response)) {
            response(new ResponseMsg(-1000, "response is null").toJson());
            return;
        }
        try {
            ResponseMsg responseMsg = new Gson().fromJson(response, ResponseMsg.class);
            if (responseMsg == null) {
                response(new ResponseMsg(-1002, "the parse json to responseMsg is null").toJson());
                return;
            }
            if(responseMsg.statusCode == 200){
                putBoolean(IS_UPLOADED, true);
                stopLocation();
            }
            response(response);
        } catch (Exception e) {
            response(new ResponseMsg(-1001, e.getMessage()).toJson());
        }
    }

    private void response(String response) {
        putString(REQUEST_RESULT_MSG, "response:" + response);
        if (mIHttpListener != null) {
            mIHttpListener.onSuccess(response);
        }
    }

    @Override
    public void format(String time) {

    }

    @Override
    public void stop() {
        this.run();
    }

    public class LocationData {
        public String action;
        public String sn;

        // @Expose
        // public String imei;

        public String mac;

//        public String location;
//        public String country;
//        public String province;
//        public String city;
//        public String district;
//        public String street;

        public String model;
        public String arch;
        public String jingVersion;
        public String jingVersionInt;
        public String androidVersion;
        public String androidVersionInt;

//        @Expose
//        private Map<String, Object> requestBody;

        @Expose
        private String requestBody;

        public LocationData() {
            action = "activation";
            initData();
        }

        public LocationData(String action) {
            this.action = action;
            initData();
        }

//        public void setLocation(AMapLocation location) {
//            initData();
//        }

        private void initData() {
            this.sn = getSerial();
            // this.imei = getIMEI(mContext);
            this.mac = getLocalMacAddress();

//            if (location != null) {
////                this.location = location.getLongitude() + COMMA + location.getLatitude();
////                this.country = location.getCountry();
////                this.province = location.getProvince();
////                this.city = location.getCity();
////                this.district = location.getDistrict();
////                this.street = location.getStreet();
//            }

            this.model = Build.MODEL;
            this.arch = getCpuAbi();
            this.jingVersion = "JingOS 1.0";
            this.jingVersionInt = Build.DISPLAY;
            this.androidVersion = Build.VERSION.RELEASE;
            this.androidVersionInt = Build.VERSION.SDK_INT + "";

            put(LOCATION_DATA, this);//cache to local
            setBody();
        }

        public void setBody() {
            if (TextUtils.isEmpty(this.mac)) {
                this.mac = getLocalMacAddress();
            }
            requestBody = new Gson().toJson(this);
            Log.i(TAG, "body:" + toString());
        }

        @Override
        public String toString() {
            return "LocationData{" +
                    "action='" + action + '\'' +
                    ", sn='" + sn + '\'' +
                    // ", imei='" + imei + '\'' +
                    ", mac='" + mac + '\'' +
//                    ", location='" + location + '\'' +
//                    ", country='" + country + '\'' +
//                    ", province='" + province + '\'' +
//                    ", city='" + city + '\'' +
                    ", model='" + model + '\'' +
                    ", arch='" + arch + '\'' +
                    ", jingVersion='" + jingVersion + '\'' +
                    ", jingVersionInt='" + jingVersionInt + '\'' +
                    ", androidVersion='" + androidVersion + '\'' +
                    ", androidVersionInt='" + androidVersionInt + '\'' +
//                    ", district='" + district + '\'' +
//                    ", street='" + street + '\'' +
                    '}';
        }

        private String getCpuAbi() {
            try {
                String osCpuAbi = new BufferedReader(new InputStreamReader(Runtime.getRuntime().exec("getprop ro.product.cpu.abi").getInputStream())).readLine();
                if (osCpuAbi.contains("x86")) {
                    return "x86";
                } else if (osCpuAbi.contains("armeabi-v7a") || osCpuAbi.contains("arm64-v8a")) {
                    return "armeabi-v7a";
                } else {
                    return "armeabi";
                }
            } catch (Exception e) {
                return "armeabi";
            }
        }

        private String getIMEI(Context context) {
            try {
                TelephonyManager tm = (TelephonyManager) context.getSystemService(Service.TELEPHONY_SERVICE);
                String imei = tm.getImei();
                if (TextUtils.isEmpty(imei)) {
                    imei = UNKNOW;
                }
                return imei;
            } catch (Exception e) {
            }
            return UNKNOW;
        }

        private String getSerial() {
            try {
                String sn = Build.getSerial();
                if (TextUtils.isEmpty(sn)) {
                    sn = UNKNOW;
                }
                return sn;
            } catch (Exception e) {
                return UNKNOW;
            }
        }

        private String getLocalMacAddress() {
            String macAddress = null;
            try {
                InetAddress ip = getLocalInetAddress();
                byte[] b = NetworkInterface.getByInetAddress(ip).getHardwareAddress();
                StringBuffer buffer = new StringBuffer();
                for (int i = 0; i < b.length; i++) {
                    if (i != 0) {
                        buffer.append(':');
                    }
                    String str = Integer.toHexString(b[i] & 0xFF);
                    buffer.append(str.length() == 1 ? 0 + str : str);
                }
                macAddress = buffer.toString().toUpperCase();
            } catch (Exception e) {
            }
            if (TextUtils.isEmpty(macAddress)) {
                macAddress = UNKNOW;
            }
            return macAddress;
        }

        private InetAddress getLocalInetAddress() {
            InetAddress ip = null;
            try {
                Enumeration<NetworkInterface> en_netInterface = NetworkInterface.getNetworkInterfaces();
                while (en_netInterface.hasMoreElements()) {
                    NetworkInterface ni = (NetworkInterface) en_netInterface.nextElement();
                    Enumeration<InetAddress> en_ip = ni.getInetAddresses();
                    while (en_ip.hasMoreElements()) {
                        ip = en_ip.nextElement();
                        if (!ip.isLoopbackAddress() && ip.getHostAddress().indexOf(":") == -1)
                            break;
                        else
                            ip = null;
                    }
                    if (ip != null) {
                        break;
                    }
                }
            } catch (SocketException e) {
                e.printStackTrace();
            }
            return ip;
        }
    }

    public SharedPreferences getSharedPreferences() {
        return AppUtil.getApplicationContext()
                .getSharedPreferences(AppUtil.getPackageName(), Context.MODE_PRIVATE);
    }

    public SharedPreferences.Editor getEdit() {
        SharedPreferences sharedPreferences = AppUtil.getApplicationContext()
                .getSharedPreferences(AppUtil.getPackageName(), Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = sharedPreferences.edit();
        return editor;
    }

    public boolean putBoolean(String key, boolean value) {
        return getEdit().putBoolean(key, value).commit();
    }

    public boolean putString(String key, String value) {
        Log.e(TAG, "key:" + key + " | value:" + value);
        return getEdit().putString(key, value).commit();
    }

    public boolean put(Object clazz) {
        return put(null, clazz);
    }

    public boolean put(String key, Object clazz) {
        try {
            putString(TextUtils.isEmpty(key) ? clazz.getClass().getSimpleName() : key,
                    new Gson().toJson(clazz));
        } catch (Exception e) {
            Log.e(TAG, "e:" + e.getMessage());
        }
        return false;
    }

    public boolean getBoolean(String key, Boolean defaultValue) {
        return getSharedPreferences().getBoolean(key, defaultValue);
    }

    public String getString(String key) {
        String value = getSharedPreferences().getString(key, "");
        return value;
    }

    public <T> T get(Class<T> clazz) {
        return get(null, clazz);
    }

    public <T> T get(String key, Class<T> clazz) {
        String json = getString(TextUtils.isEmpty(key) ? clazz.getSimpleName() : key);
        if (TextUtils.isEmpty(json)) return null;
        try {
            return new Gson().fromJson(json, clazz);
        } catch (Exception e) {
            Log.e(TAG, e.getMessage());
        }
        return null;
    }

    public interface ILocation {
        void onLocation(LocationData locationData);

        void onLocationFail(int code, String info);
    }
}