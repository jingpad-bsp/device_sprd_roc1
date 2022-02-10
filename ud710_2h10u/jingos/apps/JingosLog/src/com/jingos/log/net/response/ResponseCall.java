package com.jingos.log.net.response;

import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;

import com.jingos.log.net.listeners.IHttpBytesListener;
import com.jingos.log.net.listeners.IHttpListener;

/**
 * Time:2021/11/25 10:54
 * Author:Jack
 * Email:jiangshide@jingos.com
 * Description: Jingos
 */
public class ResponseCall<T> {
    Handler mHandler;

    public ResponseCall(Context context, final IHttpBytesListener listener) {
        Looper looper = context.getMainLooper();
        mHandler = new Handler(looper) {
            @Override
            public void handleMessage(Message msg) {
                super.handleMessage(msg);
                if (msg.what == 0) {
                    listener.onFinish((byte[]) msg.obj);
                } else if (msg.what == 1) {
                    listener.onError((Exception) msg.obj);
                }
            }
        };
    }

    public ResponseCall(Context context, final IHttpListener listener) {
        Looper looper = context.getMainLooper();
        mHandler = new Handler(looper) {
            @Override
            public void handleMessage(Message msg) {
                super.handleMessage(msg);
                if (msg.what == 0) {
                    listener.onSuccess(msg.obj.toString());
                } else if (msg.what == 1) {
                    listener.onFail((Exception) msg.obj);
                }
            }
        };
    }

    public void doSuccess(T response) {
        Message message = Message.obtain();
        message.obj = response;
        message.what = 0;
        mHandler.sendMessage(message);
    }

    public void doFail(Exception e) {
        Message message = Message.obtain();
        message.obj = e;
        message.what = 1;
        mHandler.sendMessage(message);
    }
}
