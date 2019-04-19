package com.reactlibrary;

import android.graphics.Color;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.facebook.react.common.MapBuilder;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.ViewGroupManager;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.mopub.common.MoPub;

import java.util.Map;

/**
 * Created by usamaazam on 03/04/2019.
 */

public class RNNativeAdViewManager extends ViewGroupManager<RNNativeAdView> {

    public static final String REACT_CLASS = "RNNativeAdView";
    RNNativeAdView rnNativeAdView;

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @Override
    protected RNNativeAdView createViewInstance(final ThemedReactContext reactContext) {
        rnNativeAdView = new RNNativeAdView(reactContext);
        return rnNativeAdView;
    }

    @ReactProp(name = "adUnitId")
    public void setUnitID(RNNativeAdView view, String adUnitId) {
        if (!MoPub.isSdkInitialized()) {
            AdLibSDK.initializeAdSDK(null, adUnitId, rnNativeAdView.mContext.getCurrentActivity());
        }
        view.initializeMopubNativeAd(adUnitId);
    }

    public Map getExportedCustomBubblingEventTypeConstants() {

        MapBuilder.Builder<String, Object> builder = MapBuilder.builder();
        builder.put("onNativeAdLoaded", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onNativeAdLoaded")));
        builder.put("onNativeAdFailed", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onNativeAdFailed")));

        return builder.build();
    }

}
