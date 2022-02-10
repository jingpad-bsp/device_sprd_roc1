package com.jingos.log.net;

import android.accounts.NetworkErrorException;
import android.content.Context;

import com.google.gson.Gson;
import com.jingos.log.net.listeners.IHttpBytesListener;
import com.jingos.log.net.listeners.IHttpListener;
import com.jingos.log.net.response.ResponseCall;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Iterator;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * Time:2021/11/25 10:53
 * Author:Jack
 * Email:jiangshide@jingos.com
 * Description: Jingos
 */
public class HttpUtil {
    static ExecutorService threadPool = Executors.newCachedThreadPool();
    static Gson gson = new Gson();

    /**
     * GET方法 返回数据会解析成字符串String
     *
     * @param context   上下文
     * @param urlString 请求的url
     * @param listener  回调监听
     */
    public static void doGet(final Context context, final String urlString,
                             final IHttpListener listener) {
        threadPool.execute(new Runnable() {
            @Override
            public void run() {
                URL url;
                HttpURLConnection httpURLConnection = null;
                try {
                    url = new URL(urlString);
                    httpURLConnection = (HttpURLConnection) url.openConnection();
                    httpURLConnection.setRequestMethod("GET");
                    httpURLConnection.setConnectTimeout(5000);
                    httpURLConnection.setReadTimeout(8000);
                    if (httpURLConnection.getResponseCode() == 200) {
                        InputStream is = httpURLConnection.getInputStream();
                        BufferedReader bf = new BufferedReader(new InputStreamReader(is, "UTF-8"));
                        StringBuffer buffer = new StringBuffer();
                        String line = "";
                        while ((line = bf.readLine()) != null) {
                            buffer.append(line);
                        }
                        bf.close();
                        is.close();
                        new ResponseCall(context, listener).doSuccess(buffer.toString());
                    } else {
                        new ResponseCall(context, listener).doFail(
                                new NetworkErrorException("response err code:" +
                                        httpURLConnection.getResponseCode()));
                    }
                } catch (MalformedURLException e) {
                    if (listener != null) {
                        new ResponseCall(context, listener).doFail(e);
                    }
                } catch (IOException e) {
                    if (listener != null) {
                        new ResponseCall(context, listener).doFail(e);
                    }
                } finally {
                    if (httpURLConnection != null) {
                        httpURLConnection.disconnect();
                    }
                }
            }
        });
    }

    /**
     * GET方法 返回数据会解析成byte[]数组
     *
     * @param context   上下文
     * @param urlString 请求的url
     * @param listener  回调监听
     */
    public static void doGet(final Context context, final String urlString,
                             final IHttpBytesListener listener) {
        threadPool.execute(new Runnable() {
            @Override
            public void run() {
                URL url = null;
                HttpURLConnection httpURLConnection = null;
                try {
                    url = new URL(urlString);
                    httpURLConnection = (HttpURLConnection) url.openConnection();
                    httpURLConnection.setRequestMethod("GET");
                    httpURLConnection.setConnectTimeout(5000);
                    httpURLConnection.setReadTimeout(8000);
                    if (httpURLConnection.getResponseCode() != 200) {
                        new ResponseCall(context, listener).doFail(
                                new NetworkErrorException("response err code:" +
                                        httpURLConnection.getResponseCode()));
                    } else {
                        InputStream is = httpURLConnection.getInputStream();
                        BufferedInputStream bis = new BufferedInputStream(is);
                        ByteArrayOutputStream baos = new ByteArrayOutputStream();
                        byte[] bytes = new byte[1024];
                        int len = -1;
                        while ((len = bis.read(bytes)) != -1) {
                            baos.write(bytes, 0, len);
                        }
                        bis.close();
                        is.close();
                        new ResponseCall(context, listener).doSuccess(baos.toByteArray());
                    }
                } catch (MalformedURLException e) {
                    if (listener != null) {
                        new ResponseCall(context, listener).doFail(e);
                    }
                } catch (IOException e) {
                    if (listener != null) {
                        new ResponseCall(context, listener).doFail(e);
                    }
                } finally {
                    if (httpURLConnection != null) {
                        httpURLConnection.disconnect();
                    }
                }
            }
        });
    }

    /**
     * GET方法 返回数据会解析成cls对象
     *
     * @param context   上下文
     * @param urlString 请求路径
     * @param listener  回调监听
     * @param cls       返回的对象
     * @param <T>       监听的泛型
     */
    public static <T> void doGet(final Context context,
                                 final String urlString,
                                 final IHttpListener listener, final Class<T> cls) {
        threadPool.execute(new Runnable() {
            @Override
            public void run() {
                URL url;
                HttpURLConnection httpURLConnection = null;
                try {
                    url = new URL(urlString);
                    httpURLConnection = (HttpURLConnection) url.openConnection();
                    httpURLConnection.setRequestMethod("GET");
                    httpURLConnection.setConnectTimeout(5000);
                    httpURLConnection.setReadTimeout(8000);
                    if (httpURLConnection.getResponseCode() == 200) {
                        InputStream is = httpURLConnection.getInputStream();
                        BufferedReader bf = new BufferedReader(new InputStreamReader(is, "UTF-8"));
                        StringBuffer buffer = new StringBuffer();
                        String line = "";
                        while ((line = bf.readLine()) != null) {
                            buffer.append(line);
                        }
                        bf.close();
                        is.close();
                        new ResponseCall(context, listener).doSuccess(gson.fromJson(buffer.toString(), cls));
                    } else {
                        if (listener != null) {
                            new ResponseCall(context, listener).doFail(
                                    new NetworkErrorException("response err code:" +
                                            httpURLConnection.getResponseCode()));
                        }
                    }
                } catch (MalformedURLException e) {
                    if (listener != null) {
                        new ResponseCall(context, listener).doFail(e);
                    }
                } catch (IOException e) {
                    if (listener != null) {
                        new ResponseCall(context, listener).doFail(e);
                    }
                } finally {
                    if (httpURLConnection != null) {
                        httpURLConnection.disconnect();
                    }
                }
            }
        });
    }

    /**
     * GET方法 返回数据会解析成字符串 String
     *
     * @param context   上下文
     * @param urlString 请求的路径
     * @param listener  回调监听
     * @param params    参数列表
     */
    public static void doPost(final Context context,
                              final String urlString, final IHttpListener listener, final Map<String, Object> params) {
        final StringBuffer out = new StringBuffer();
        for (String key : params.keySet()) {
            if (out.length() != 0) {
                out.append("&");
            }
            out.append(key).append("=").append(params.get(key));
        }
        doPost(context, urlString, listener, out.toString());
    }

    /**
     * GET方法 返回数据会解析成字符串 String
     *
     * @param context   上下文
     * @param urlString 请求的路径
     * @param listener  回调监听
     * @param body      参数列表
     */
    public static void doPost(final Context context,
                              final String urlString, final IHttpListener listener,
                              String body) {

        threadPool.execute(new Runnable() {
            @Override
            public void run() {
                URL url;
                HttpURLConnection httpURLConnection = null;
                try {
                    url = new URL(urlString);
                    httpURLConnection = (HttpURLConnection) url.openConnection();
                    httpURLConnection.setRequestProperty("Accept", "application/json");
                    httpURLConnection.setRequestProperty("connection", "Keep-Alive");
                    httpURLConnection.setRequestProperty("Content-Type", "application/json");
                    httpURLConnection.setRequestProperty("Content-Length", String
                            .valueOf(body.length()));
                    httpURLConnection.setRequestMethod("POST");

                    httpURLConnection.setConnectTimeout(5000);
                    httpURLConnection.setReadTimeout(8000);

                    httpURLConnection.setDoInput(true);
                    httpURLConnection.setDoOutput(true);

                    PrintWriter printWriter = new PrintWriter(httpURLConnection.getOutputStream());
                    printWriter.write(body);
                    printWriter.flush();
                    printWriter.close();

                    if (httpURLConnection.getResponseCode() == 200) {
                        InputStream is = httpURLConnection.getInputStream();
                        BufferedReader bf = new BufferedReader(new InputStreamReader(is, "UTF-8"));
                        StringBuffer buffer = new StringBuffer();
                        String line = "";
                        while ((line = bf.readLine()) != null) {
                            buffer.append(line);
                        }
                        bf.close();
                        is.close();
                        new ResponseCall(context, listener).doSuccess(buffer.toString());
                    } else {
                        new ResponseCall(context, listener).doFail(
                                new NetworkErrorException("response err code:" +
                                        httpURLConnection.getResponseCode()));
                    }
                } catch (MalformedURLException e) {
                    if (listener != null) {
                        new ResponseCall(context, listener).doFail(e);
                    }
                } catch (IOException e) {
                    if (listener != null) {
                        new ResponseCall(context, listener).doFail(e);
                    }
                } finally {
                    if (httpURLConnection != null) {
                        httpURLConnection.disconnect();
                    }
                }
            }
        });
    }


    /**
     * GET方法 返回数据会解析成Byte[]数组
     *
     * @param context   上下文
     * @param urlString 请求的路径
     * @param listener  回调监听
     * @param params    参数列表
     */
    public static void doPost(final Context context,
                              final String urlString, final IHttpBytesListener listener,
                              final Map<String, Object> params) {
        final StringBuffer out = new StringBuffer();
        for (String key : params.keySet()) {
            if (out.length() != 0) {
                out.append("&");
            }
            out.append(key).append("=").append(params.get(key));
        }
        threadPool.execute(new Runnable() {
            @Override
            public void run() {
                URL url;
                HttpURLConnection httpURLConnection = null;
                try {
                    url = new URL(urlString);
                    httpURLConnection = (HttpURLConnection) url.openConnection();
                    httpURLConnection.setRequestProperty("accept", "*/*");
                    httpURLConnection.setRequestProperty("connection", "Keep-Alive");
                    httpURLConnection.setRequestProperty("Content-Length", String
                            .valueOf(out.length()));
                    httpURLConnection.setRequestMethod("POST");

                    httpURLConnection.setConnectTimeout(5000);
                    httpURLConnection.setReadTimeout(8000);

                    httpURLConnection.setDoInput(true);
                    httpURLConnection.setDoOutput(true);

                    PrintWriter printWriter = new PrintWriter(httpURLConnection.getOutputStream());
                    printWriter.write(out.toString());
                    printWriter.flush();
                    printWriter.close();

                    if (httpURLConnection.getResponseCode() == 200) {
                        InputStream is = httpURLConnection.getInputStream();
                        BufferedInputStream bis = new BufferedInputStream(is);
                        ByteArrayOutputStream baos = new ByteArrayOutputStream();
                        byte[] bytes = new byte[1024];
                        int len = -1;
                        while ((len = bis.read(bytes)) != -1) {
                            baos.write(bytes, 0, len);
                        }
                        bis.close();
                        is.close();
                        new ResponseCall(context, listener).doSuccess(baos.toByteArray());
                    } else {
                        new ResponseCall(context, listener).doFail(
                                new NetworkErrorException("response err code:" +
                                        httpURLConnection.getResponseCode()));
                    }
                } catch (MalformedURLException e) {
                    if (listener != null) {
                        new ResponseCall(context, listener).doFail(e);
                    }
                } catch (IOException e) {
                    if (listener != null) {
                        new ResponseCall(context, listener).doFail(e);
                    }
                } finally {
                    if (httpURLConnection != null) {
                        httpURLConnection.disconnect();
                    }
                }
            }
        });
    }


    /**
     * /**
     * GET方法 返回数据会解析成cls对象
     *
     * @param context   上下文
     * @param urlString 请求的路径
     * @param listener  回调监听
     * @param params    参数列表
     * @param cls       对象
     * @param <T>       监听泛型
     */
    public static <T> void doPost(final Context context,
                                  final String urlString, final IHttpListener listener,
                                  final Map<String, Object> params, final Class<T> cls) {
        final StringBuffer paramsStr = new StringBuffer();
        Iterator it = params.entrySet().iterator();
        while (it.hasNext()) {
            Map.Entry element = (Map.Entry) it.next();
            paramsStr.append(element.getKey());
            paramsStr.append("=");
            paramsStr.append(element.getValue());
            paramsStr.append("&");
        }
        if (paramsStr.length() > 0) {
            paramsStr.deleteCharAt(paramsStr.length() - 1);
        }
        threadPool.execute(new Runnable() {
            @Override
            public void run() {
                URL url;
                HttpURLConnection httpURLConnection = null;
                try {
                    url = new URL(urlString);
                    httpURLConnection = (HttpURLConnection) url.openConnection();

                    httpURLConnection.setRequestMethod("POST");

                    httpURLConnection.setConnectTimeout(5000);
                    httpURLConnection.setReadTimeout(8000);
                    httpURLConnection.setDoInput(true);
                    httpURLConnection.setDoOutput(true);

                    PrintWriter printWriter = new PrintWriter(httpURLConnection.getOutputStream());
                    printWriter.write(paramsStr.toString());
                    printWriter.flush();
                    printWriter.close();

                    if (httpURLConnection.getResponseCode() == 200) {
                        InputStream is = httpURLConnection.getInputStream();
                        BufferedReader bf = new BufferedReader(new InputStreamReader(is, "UTF-8"));
                        StringBuffer buffer = new StringBuffer();
                        String line = "";
                        while ((line = bf.readLine()) != null) {
                            buffer.append(line);
                        }
                        bf.close();
                        is.close();
                        new ResponseCall(context, listener).doSuccess(gson.fromJson(buffer.toString(), cls));
                    } else {
                        new ResponseCall(context, listener).doFail(
                                new NetworkErrorException("response err code:" +
                                        httpURLConnection.getResponseCode()));
                    }
                } catch (MalformedURLException e) {
                    if (listener != null) {
                        new ResponseCall(context, listener).doFail(e);
                    }
                } catch (IOException e) {
                    if (listener != null) {
                        new ResponseCall(context, listener).doFail(e);
                    }
                } finally {
                    if (httpURLConnection != null) {
                        httpURLConnection.disconnect();
                    }
                }
            }
        });
    }
}
