package com.jingos.log.net.listeners;

/**
 * Time:2021/11/25 10:56
 * Author:Jack
 * Email:jiangshide@jingos.com
 * Description: Jingos
 */
public interface IHttpListener {
    void onSuccess(String response);
    void onFail(Exception e);
}
