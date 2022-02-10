package com.jingos.log;

import android.annotation.SuppressLint;
import android.app.Application;
import android.content.pm.PackageManager;

/**
 * Time:2021/08/16 下午1:15
 * Author:Jack
 * Email:jiangshide@jingos.com
 * Description: Jingos
 */
public class AppUtil {

    @SuppressLint("StaticFieldLeak")
    private static volatile Application sApplication;

    public static Application getApplicationContext() {
        if (sApplication == null) {
            synchronized (AppUtil.class) {
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

    public static String getPackageName(String path) {
        return getApplicationContext().getPackageManager()
                .getPackageArchiveInfo(path,
                        PackageManager.GET_ACTIVITIES | PackageManager.GET_SERVICES).packageName;
    }

}
