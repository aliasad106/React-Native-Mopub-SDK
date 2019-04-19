package com.reactlibrary;

import android.content.Context;

import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableNativeMap;
import com.facebook.react.common.MapBuilder;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.mopub.common.MoPub;

import java.util.Map;

import javax.annotation.Nullable;

/**
 * Created by usamaazam on 29/03/2019.
 */

public class MoPubBannerManager extends SimpleViewManager<RNMoPubBanner> {
    public static final String REACT_CLASS = "RNMoPubBanner";


    RNMoPubBanner rnMoPubBanner;
    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @Override
    protected RNMoPubBanner createViewInstance(final ThemedReactContext reactContext) {
        rnMoPubBanner = new RNMoPubBanner(reactContext);
        return rnMoPubBanner;
    }

    @ReactProp(name = "adUnitId")
    public void setAdUnitId(RNMoPubBanner view, String adUnitId) {

        if(MoPub.isSdkInitialized()) {
            view.setAdUnitId(adUnitId);
            view.loadAd();
        } else {
            AdLibSDK.initializeAdSDK(view, adUnitId, rnMoPubBanner.mContext.getCurrentActivity());
        }

    }

    @ReactProp(name = "testing", defaultBoolean = false)
    public void setTesting(RNMoPubBanner view, Boolean testing) {
        view.setTesting(testing);
    }

    @ReactProp(name = "autoRefresh", defaultBoolean = true)
    public void setAutoRefresh(RNMoPubBanner view, Boolean autoRefresh) {
        view.setAutorefreshEnabled(autoRefresh);
    }

    @ReactProp(name = "localExtras")
    public void setLocalExtras(RNMoPubBanner view, @Nullable ReadableMap localExtras) {
        view.setLocalExtras(localExtras.toHashMap());
    }

    @ReactProp(name = "keywords")
    public void setKeywords(RNMoPubBanner view, @Nullable String keywords) {
        view.setKeywords(keywords);
    }

    @Nullable
    @Override
    public Map<String, Object> getExportedCustomDirectEventTypeConstants() {
        MapBuilder.Builder<String, Object> builder = MapBuilder.builder();
        builder.put(RNMoPubBanner.EVENT_LOADED, MapBuilder.of("registrationName", RNMoPubBanner.EVENT_LOADED));
        builder.put(RNMoPubBanner.EVENT_FAILED, MapBuilder.of("registrationName", RNMoPubBanner.EVENT_FAILED));
        builder.put(RNMoPubBanner.EVENT_CLICKED, MapBuilder.of("registrationName", RNMoPubBanner.EVENT_CLICKED));
        builder.put(RNMoPubBanner.EVENT_EXPANDED, MapBuilder.of("registrationName", RNMoPubBanner.EVENT_EXPANDED));
        builder.put(RNMoPubBanner.EVENT_COLLAPSED, MapBuilder.of("registrationName", RNMoPubBanner.EVENT_COLLAPSED));
        return builder.build();
    }
}