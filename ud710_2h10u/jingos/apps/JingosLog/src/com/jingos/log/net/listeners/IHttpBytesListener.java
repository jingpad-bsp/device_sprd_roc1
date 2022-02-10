package com.jingos.log.net.listeners;

/**
 * Time:2021/11/25 11:03
 * Author:Jack
 * Email:jiangshide@jingos.com
 * Description: Jingos
 */
public interface IHttpBytesListener {
    void onFinish(byte[] response);
    void onError(Exception e);
}
