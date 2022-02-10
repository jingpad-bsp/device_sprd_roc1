//package com.jn.center.fragments;
//
//
//import android.os.Bundle;
//import android.view.LayoutInflater;
//import android.view.View;
//import android.view.ViewGroup;
//
//import androidx.fragment.app.Fragment;
//
//
//public class TagFragment extends Fragment {
//    public static final String LAYOUT = "layout";
//    private int layout_res;
//
//    @Override
//    public void onCreate(Bundle savedInstanceState) {
//        super.onCreate(savedInstanceState);
//        if (getArguments() != null) {
//            layout_res = getArguments().getInt(LAYOUT);
//        }
//    }
//
//    @Override
//    public View onCreateView(LayoutInflater inflater, ViewGroup container,
//                             Bundle savedInstanceState) {
//        View view = inflater.inflate(layout_res, container, false);
//        return view;
//
//    }
//
//    public static TagFragment newInstance(int layout) {
//        TagFragment tabFragment = new TagFragment();
//        Bundle bundle = new Bundle();
//        bundle.putInt(LAYOUT, layout);
//        tabFragment.setArguments(bundle);
//        return tabFragment;
//    }
//
//}
