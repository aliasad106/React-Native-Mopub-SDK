package com.reactlibrary;

import android.view.View;
import android.view.ViewGroup;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.LifecycleEventListener;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.uimanager.events.RCTEventEmitter;
import com.mopub.common.util.Dips;
import com.mopub.mobileads.MoPubErrorCode;
import com.mopub.mobileads.MoPubView;

/**
 * Created by usamaazam on 29/03/2019.
 */

public class RNMoPubBanner extends MoPubView implements MoPubView.BannerAdListener, LifecycleEventListener {
    public static final String EVENT_LOADED = "onLoaded";
    public static final String EVENT_FAILED = "onFailed";
    public static final String EVENT_CLICKED = "onClicked";
    public static final String EVENT_EXPANDED = "onExpanded";
    public static final String EVENT_COLLAPSED = "onCollapsed";

    ReactContext mContext;
    public RNMoPubBanner(ReactContext context) {
        super(context);
        mContext = context;
        this.setBannerAdListener(this);
        context.addLifecycleEventListener(this);
    }

    @Override
    public void onViewAdded(View child) {
        //React-Native cannot autosize RNWebViews, so you have to manually specify style.height
        //or do some trickery
        //Turns out this is also true for all other WebViews, which are added internally inside this banner
        //So we just size them manually
        //Width and Height must be set in RN style
        super.onViewAdded(child);
        int width = Dips.asIntPixels(getAdWidth(), getContext());
        int height = Dips.asIntPixels(getAdHeight(), getContext());
        child.measure(width, height);
        child.layout(0, 0, width, height);

        View webView = ((ViewGroup) child).getChildAt(0);
        if (webView != null) {
            webView.measure(width, height);
            webView.layout(0, 0, width, height);
        }


    }

    @Override
    public void onBannerLoaded(MoPubView banner) {
        int width = Dips.asIntPixels(banner.getAdWidth(), this.getContext());
        int height = Dips.asIntPixels(banner.getAdHeight(), this.getContext());

        int left = banner.getLeft();
        int top = banner.getTop();
        banner.measure(width, height);
        banner.layout(left, top, left + width, top + height);

        ReactContext reactContext = (ReactContext) getContext();
        reactContext.getJSModule(RCTEventEmitter.class).receiveEvent(this.getId(), EVENT_LOADED, null);
    }

    @Override
    public void onBannerFailed(MoPubView banner, MoPubErrorCode errorCode) {
        WritableMap event = Arguments.createMap();
        event.putString("message", errorCode.toString());
        ReactContext reactContext = (ReactContext) getContext();
        reactContext.getJSModule(RCTEventEmitter.class).receiveEvent(this.getId(), EVENT_FAILED, event);
    }

    @Override
    public void onBannerClicked(MoPubView banner) {
        ReactContext reactContext = (ReactContext) getContext();
        reactContext.getJSModule(RCTEventEmitter.class).receiveEvent(this.getId(), EVENT_CLICKED, null);
    }

    @Override
    public void onBannerExpanded(MoPubView banner) {
        ReactContext reactContext = (ReactContext) getContext();
        reactContext.getJSModule(RCTEventEmitter.class).receiveEvent(this.getId(), EVENT_EXPANDED, null);
    }

    @Override
    public void onBannerCollapsed(MoPubView banner) {
        ReactContext reactContext = (ReactContext) getContext();
        reactContext.getJSModule(RCTEventEmitter.class).receiveEvent(this.getId(), EVENT_COLLAPSED, null);
    }

    @Override
    public void onHostResume() {

    }

    @Override
    public void onHostPause() {

    }

    @Override
    public void onHostDestroy() {
        this.destroy();
    }
}
