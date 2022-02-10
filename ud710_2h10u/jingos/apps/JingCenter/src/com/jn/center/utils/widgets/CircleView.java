package com.jn.center.utils.widgets;

import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.util.AttributeSet;
import android.view.View;

import com.jn.center.R;

public class CircleView extends View {
    private Paint mPaint;
    private float width;
    private float height;
    private int circle_count;
    private final int def_circle_count = 0;
    private int current_index = 0;
    private float percent = 0f;
    private float r;//Todo 圆半径
    private float first_x;
    private float interval;//Todo 间隔
    private int default_color;
    private int selected_color;

    public CircleView(Context context) {
        this(context, null);
        init();
    }

    public CircleView(Context context, AttributeSet attrs) {
        this(context, attrs, 0);
        init();
    }

    public CircleView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        initAttr(context, attrs);
        init();
    }

    private void initAttr(final Context context, final AttributeSet attrs) {
        TypedArray typedArray = context.obtainStyledAttributes(attrs, R.styleable.circl_view);
        circle_count = typedArray.getInt(R.styleable.circl_view_circle_count, def_circle_count);
        typedArray.recycle();
    }

    private void init() {
        default_color = Color.parseColor("#aaaaaa");
        selected_color = Color.parseColor("#333333");
        mPaint = new Paint();
        mPaint.setAntiAlias(true);
        mPaint.setStrokeWidth(1);
        mPaint.setStyle(Paint.Style.FILL);//Todo 空心

    }

    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        super.onMeasure(widthMeasureSpec, heightMeasureSpec);
        width = getMeasuredWidth();
        height = getMeasuredHeight();
        //Todo 圆半径
//        r = 2*(width-10)/(circle_count*5-1);
        r = (width-10)/(2*(2*circle_count-1));
        interval = 2*r;
        first_x = r+5;
    }

    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        drawCircleStroke(canvas);
        drawCircleFill(canvas);
    }

    private void drawCircleStroke(Canvas canvas){
        mPaint.setColor(default_color);
        mPaint.setStyle(Paint.Style.FILL);
        canvas.save();
        for (int i = 0;i<circle_count;i++){
            float x = (i*2 +1)*r+i*interval+5;
            float y = height/2;
            canvas.drawCircle(x,y,r,mPaint);
        }
        canvas.restore();
    }
    private void drawCircleFill(Canvas canvas){
        canvas.save();
        mPaint.setStyle(Paint.Style.FILL);
        mPaint.setColor(selected_color);
        mPaint.setAlpha(200);
        canvas.drawCircle(first_x+(current_index)*(2*r+interval) +percent*(2*r+interval),height/2,r,mPaint);
//        canvas.drawCircle(5+3.5f*r,height/2,r,mPaint);
        canvas.restore();
    }

    public void setPercent(float percent){
        this.percent = percent;
        invalidate();
    }
    public void setCircle_count(int circle_count){
        this.circle_count = circle_count;
    }

    public void setCurrent_index(int current_index){
        this.current_index = current_index;
    }
}
