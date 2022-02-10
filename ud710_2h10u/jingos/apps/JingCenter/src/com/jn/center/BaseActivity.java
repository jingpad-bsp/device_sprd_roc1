package com.jn.center;

import android.app.Activity;
import android.os.Bundle;
import com.jn.center.utils.StatusBarUtils;

public class BaseActivity extends Activity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setStatusBar();
    }
    protected void setStatusBar(){
        StatusBarUtils.setStatusBarTranslucent(getWindow());
    }
}
