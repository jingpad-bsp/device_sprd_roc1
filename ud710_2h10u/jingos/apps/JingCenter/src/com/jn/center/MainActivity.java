package com.jn.center;

import android.os.Bundle;
import android.util.Log;

import androidx.viewpager.widget.ViewPager;

import com.jn.center.adapter.VpAdapter;
import com.jn.center.utils.widgets.CircleView;

public class MainActivity extends BaseActivity {
    private int[] layouts = new int[]{R.layout.fragment_page1,
//            R.layout.fragment_page2, 删除此页
            R.layout.fragment_page3,
            R.layout.fragment_page4,
//            R.layout.fragment_page5z, 删除此页
//            R.layout.fragment_page5z2, 删除此页
            R.layout.fragment_page5,
            R.layout.fragment_page6,
            R.layout.fragment_page7};
    private ViewPager vp;
//    private FragmentPagerAdapter fragmentPagerAdapter;
//    private TagFragment[] mFragments = new TagFragment[layouts.length];
    private CircleView cv;
    VpAdapter vpAdapter;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_circle);
        vp = findViewById(R.id.vp);
        cv = findViewById(R.id.cv);
        cv.setCircle_count(layouts.length);
        initData();
        initVp();
    }

    private void initData() {
//        for (int i = 0; i < layouts.length; i++) {
//            mFragments[i] = TagFragment.newInstance(layouts[i]);
//        }
//        fragmentPagerAdapter = new FragmentPagerAdapter(getSupportFragmentManager()) {
//            @Override
//            public Fragment getItem(int position) {
//                return mFragments[position];
//            }
//
//            @Override
//            public int getCount() {
//                return mFragments.length;
//            }
//        };
        vpAdapter = new VpAdapter(this,layouts);
    }

    private void initVp() {
//        vp.setAdapter(fragmentPagerAdapter);
        vp.setAdapter(vpAdapter);
        vp.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {
                Log.e("Viewpager", "onPageScrolled:"
                        + "\nposition--->" + position
                        + "\npositionOffset--->" + positionOffset
                        + "\npositionOffsetPixels--->" + positionOffsetPixels);
//                cv.setCurrent_index(vp.getCurrentItem());
                if(positionOffset>0){
                    cv.setPercent(position == vp.getCurrentItem() ? positionOffset :positionOffset-1);
                }
            }

            @Override
            public void onPageSelected(int position) {
                Log.e("Viewpager", "onPageSelected:position--->" + position);
                cv.setCurrent_index(position);
            }

            @Override
            public void onPageScrollStateChanged(int state) {
                Log.e("Viewpager", "onPageScrollStateChanged:state--->" + state);
            }
        });
    }
}