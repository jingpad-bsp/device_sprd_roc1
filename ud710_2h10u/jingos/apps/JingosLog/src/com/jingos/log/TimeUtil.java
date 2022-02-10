package com.jingos.log;

import android.os.Handler;
import android.os.Message;
import android.widget.TextView;
import java.util.ArrayList;

/**
 * Time:2021/11/15 16:40
 * Author:Jack
 * Email:jiangshide@jingos.com
 * Description: Jingos
 */
public class TimeUtil {

    private static String TAG = "TimeUtil##jsd##";

    private static volatile TimeUtil instance;

    public TimeUtil() {
    }

    public static TimeUtil getInstance() {
        if (instance == null) {
            synchronized (TimeUtil.class) {
                if (instance == null) {
                    instance = new TimeUtil();
                }
            }
        }
        return instance;
    }

    private static int second = 0;
    private static int status = TimingEnum.STOP.val;
    private static final Handler handler = new CDHandler();
    private static final ArrayList<TextView> views = new ArrayList<>();
    private static String time = "";
    private static final int SECOND = 1000;
    private static final int MINUTE = 60;
    private static final int HOUR = 3600;
    private volatile Mode mode = Mode.NORMAL;

    private OnTimeListener listener;

    public TimeUtil setListener(OnTimeListener listener) {
        this.listener = listener;
        return instance;
    }

    public TimeUtil addView(TextView view) {
        if (!views.contains(view)) {
            views.add(view);
        }
        return instance;
    }

    public TimeUtil setSecond(int secondTime) {
        second = secondTime;
        return instance;
    }

    public TimeUtil remove(TextView view) {
        if (views.contains(view)) {
            views.remove(view);
        }
        return instance;
    }

    public void start() {
        start(Mode.NORMAL);
    }

    public void start(Mode mode) {
        this.mode = mode;
        if (status == TimingEnum.STOP.val) {
            status = TimingEnum.START.val;
            handler.sendEmptyMessageDelayed(status, SECOND);
        }
    }

    public void stop() {
        if (status == TimingEnum.START.val) {
            status = TimingEnum.STOP.val;
            handler.removeMessages(TimingEnum.START.val);
            handler.sendEmptyMessage(status);
        }
    }

    public void destroy() {
        status = TimingEnum.STOP.val;
        second = 0;
        handler.removeMessages(TimingEnum.START.val);
        views.clear();
    }

    private static class CDHandler extends Handler {
        @Override
        public void handleMessage(Message msg) {
            int status = msg.what;
            if (status == TimingEnum.START.val) {
                if (instance.mode == Mode.COUNTDOWN || instance.mode == Mode.COUNTDOWNSECOND) {
                    second -= 1;
                    if (second <= 0) {
                        instance.stop();
                        return;
                    }
                } else {
                    second += 1;
                }
                if (instance.mode == Mode.COUNTDOWNSECOND) {
                    time = "" + second;
                } else {
                    time = format(second);
                }
                if (instance.listener != null) {
                    instance.listener.format(time);
                }
                handler.sendEmptyMessageDelayed(status, SECOND);
            } else if (status == TimingEnum.STOP.val) {
                time = format(second);
                if (instance.listener != null) {
                    instance.listener.stop();
                }
            }
            showTime();
        }
    }

    public static String format(long seconds) {
        int temp;
        StringBuffer sb = new StringBuffer();
        if (seconds >= HOUR) {
            temp = (int) (seconds / HOUR);
            sb.append((seconds / HOUR) < 10 ? "0" + temp + ":" : temp + ":");
        }
        temp = (int) (seconds % HOUR / MINUTE);
        changeSecond(seconds, temp, sb);
        return sb.toString();
    }

    private static void changeSecond(long seconds, int temp, StringBuffer sb) {
        sb.append((temp < 10) ? "0" + temp + ":" : "" + temp + ":");
        temp = (int) (seconds % HOUR % MINUTE);
        sb.append((temp < 10) ? "0" + temp : "" + temp);
    }

    private static void showTime() {
        for (TextView view : views) {
            view.setText(time);
        }
    }

    public int getStatus() {
        return status;
    }

    public enum TimingEnum {
        STOP(0),
        START(1),
        CLEAR(-1);
        int val;

        TimingEnum(int val) {
            this.val = val;
        }
    }

    public enum Mode {
        NORMAL(0),
        COUNTDOWN(1),
        COUNTDOWNSECOND(2);
        int val;

        Mode(int val) {
            this.val = val;
        }
    }

    public interface OnTimeListener {
        public void format(String time);

        public void stop();
    }
}
