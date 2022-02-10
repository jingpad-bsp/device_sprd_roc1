package com.jn.center.adapter;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;

import androidx.viewpager.widget.PagerAdapter;


public class VpAdapter extends PagerAdapter {
    private Context mContext;
    private int[] mData;
    public VpAdapter(Context context ,int[] list) {
        mContext = context;
        mData = list;
    }
    @Override
    public int getCount() {
        return mData.length;
    }
    @Override
    public Object instantiateItem(ViewGroup container, int position) {
        View view = View.inflate(mContext, mData[position],null);

        container.addView(view);
        return view;
    }
    @Override
    public void destroyItem(ViewGroup container, int position, Object object) {
        container.removeView((View)object);
    }
    @Override
    public boolean isViewFromObject(View view, Object object) {
        return view == object;
    }
}