package com.reactlibrary;

import android.graphics.Color;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RelativeLayout;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.uimanager.events.RCTEventEmitter;
import com.facebook.react.views.view.ReactViewGroup;
import com.mopub.nativeads.AdapterHelper;
import com.mopub.nativeads.BaseNativeAd;
import com.mopub.nativeads.MoPubNative;
import com.mopub.nativeads.MoPubStaticNativeAdRenderer;
import com.mopub.nativeads.NativeAd;
import com.mopub.nativeads.NativeErrorCode;
import com.mopub.nativeads.RequestParameters;
import com.mopub.nativeads.StaticNativeAd;
import com.mopub.nativeads.ViewBinder;

import java.util.EnumSet;

/**
 * Created by usamaazam on 03/04/2019.
 */

public class RNNativeAdView extends ReactViewGroup implements MoPubNative.MoPubNativeNetworkListener {

    ReactContext mContext;


    private AdapterHelper adapterHelper;

    public RNNativeAdView(ReactContext context) {
        super(context);
        mContext = context;
    }

    public void initializeMopubNativeAd(String adUnitId) {

        MoPubNative moPubNative = new MoPubNative(mContext, adUnitId, this);

        ViewBinder viewBinder = new ViewBinder.Builder(this.getId())
                .build();

        MoPubStaticNativeAdRenderer moPubStaticNativeAdRenderer = new MoPubStaticNativeAdRenderer(viewBinder);
        moPubNative.registerAdRenderer(moPubStaticNativeAdRenderer);

        EnumSet<RequestParameters.NativeAdAsset> desiredAssets = EnumSet.of(
                RequestParameters.NativeAdAsset.TITLE,
                RequestParameters.NativeAdAsset.TEXT,
                RequestParameters.NativeAdAsset.CALL_TO_ACTION_TEXT,
                RequestParameters.NativeAdAsset.MAIN_IMAGE,
                RequestParameters.NativeAdAsset.ICON_IMAGE,
                RequestParameters.NativeAdAsset.STAR_RATING
        );

        RequestParameters mRequestParameters = new RequestParameters.Builder()
                .desiredAssets(desiredAssets)
                .build();

        moPubNative.makeRequest(mRequestParameters);
    }

    @Override
    public void onNativeLoad(NativeAd nativeAd) {

        StaticNativeAd staticNativeAd = (StaticNativeAd) nativeAd.getBaseNativeAd();
        String title = staticNativeAd.getTitle();
        String mainText = staticNativeAd.getText();
        String callToActionText = staticNativeAd.getCallToAction();
        String mainImageSource = staticNativeAd.getMainImageUrl();
        String iconImageSource = staticNativeAd.getIconImageUrl();
        String privacyIconImageSource = staticNativeAd.getPrivacyInformationIconImageUrl();


        WritableMap event = Arguments.createMap();
        event.putString("title", title);
        event.putString("mainText", mainText);
        event.putString("callToActionText", callToActionText);
        event.putString("mainImageSource", mainImageSource);
        event.putString("iconImageSource", iconImageSource);
        event.putString("privacyIconImageSource", privacyIconImageSource);
        event.putString("link", staticNativeAd.getClickDestinationUrl());


        ReactContext reactContext = (ReactContext) getContext();
        reactContext.getJSModule(RCTEventEmitter.class).receiveEvent(
                getId(),
                "onNativeAdLoaded",
                event);

        Log.d("message", "loaded");

    }

    @Override
    public void onNativeFail(NativeErrorCode errorCode) {
        WritableMap event = Arguments.createMap();
        event.putString("error", errorCode.toString());
        ReactContext reactContext = (ReactContext) getContext();
        reactContext.getJSModule(RCTEventEmitter.class).receiveEvent(
                getId(),
                "onNativeAdFailed",
                event);

        Log.d("message", "loaded");
    }

}

