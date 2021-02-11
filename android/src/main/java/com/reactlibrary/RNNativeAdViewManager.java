package com.reactlibrary;

import android.graphics.Color;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;
import android.util.Log;
import javax.annotation.Nullable;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.common.MapBuilder;
import com.facebook.react.bridge.ReadableArray;
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
    public static final int COMMAND_UPDATE_BOUNDS = 1;

    RNNativeAdView rnNativeAdView;
    ReactApplicationContext mCallerContext;

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public RNNativeAdViewManager(ReactApplicationContext reactContext) {
        mCallerContext = reactContext;
    }

    @Override
    protected RNNativeAdView createViewInstance(final ThemedReactContext reactContext) {
        rnNativeAdView = new RNNativeAdView(reactContext);
        return rnNativeAdView;
    }

    @ReactProp(name = "adUnitId")
    public void setUnitID(RNNativeAdView view, String adUnitId) {
        if (!MoPub.isSdkInitialized()) {
            // AdLibSDK.initializeAdSDK(null, adUnitId, rnNativeAdView.mContext.getCurrentActivity());
        }
        view.initializeMopubNativeAd(adUnitId);
    }

    public Map getExportedCustomBubblingEventTypeConstants() {

        MapBuilder.Builder<String, Object> builder = MapBuilder.builder();
        builder.put("onNativeAdLoaded", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onNativeAdLoaded")));
        builder.put("onNativeAdFailed", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onNativeAdFailed")));
        builder.put("onImpressionData", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onImpressionData")));
        builder.put("onAdLayout", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onAdLayout")));

        return builder.build();
    }

    @Override
    public Map<String,Integer> getCommandsMap() {
        return MapBuilder.of(
            "updateBounds",
            COMMAND_UPDATE_BOUNDS);
    }

    @Override
    public void receiveCommand(
        RNNativeAdView view,
        int commandId,
        @Nullable ReadableArray args) {
        Log.i("CMD", "receive command " + commandId + " " + COMMAND_UPDATE_BOUNDS + " " + args);
        
        switch (commandId) {
        case COMMAND_UPDATE_BOUNDS: {
            view.updateBounds(Integer.parseInt(args.getString(0)), Integer.parseInt(args.getString(1)));
            return;
        }
        
        default:
            throw new IllegalArgumentException(String.format(
            "Unsupported command %d received by %s.",
            commandId,
            getClass().getSimpleName()));
        }
    }
}