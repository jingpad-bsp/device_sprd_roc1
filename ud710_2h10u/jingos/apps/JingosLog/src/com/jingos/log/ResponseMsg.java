package com.jingos.log;

import com.google.gson.Gson;

/**
 * Time:2021/12/02 15:38
 * Author:Jack
 * Email:jiangshide@jingos.com
 * Description: Jingos
 */
public class ResponseMsg {
    public int statusCode;
    public String statusMsg;

    public ResponseMsg(int code, String msg) {
        this.statusCode = code;
        this.statusMsg = msg;
    }

    public String toJson() {
        return new Gson().toJson(this);
    }
}
