package com.jingos.log.net;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.text.TextUtils;
import android.util.Log;

import com.jingos.log.Constants;

/**
 * Time:2021/12/02 11:37
 * Author:Jack
 * Email:jiangshide@jingos.com
 * Description: Jingos
 */
public class NetBroadcast extends BroadcastReceiver {

    private final String TAG = "NetBroadcast##jsd##";

    public static final String NET_ACTION = "android.net.conn.CONNECTIVITY_CHANGE";

    private ConnectivityManager.NetworkCallback mNetworkCallback;

    public NetBroadcast(ConnectivityManager.NetworkCallback networkCallback) {
        this.mNetworkCallback = networkCallback;
    }

    @Override
    public void onReceive(Context context, Intent intent) {
        if (intent == null || TextUtils.isEmpty(intent.getAction())) {
            return;
        }
        Log.e(TAG, "onReceive~action:" + intent.getAction());
        if (intent.getAction().equals(NET_ACTION)) {
            if (mNetworkCallback != null) {
                mNetworkCallback.onCapabilitiesChanged(Constants.getNetwork(context), null);
            }
        }
    }
}
