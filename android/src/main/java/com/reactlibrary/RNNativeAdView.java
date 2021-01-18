package com.reactlibrary;

import android.app.Activity;
import android.graphics.Color;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import androidx.annotation.NonNull;
import javax.annotation.Nullable;
import org.json.JSONException;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.uimanager.events.RCTEventEmitter;
import com.facebook.react.views.view.ReactViewGroup;

import com.mopub.nativeads.GooglePlayServicesAdRenderer;
import com.mopub.nativeads.GooglePlayServicesViewBinder;
import com.mopub.nativeads.AdapterHelper;
import com.mopub.nativeads.BaseNativeAd;
import com.mopub.nativeads.MoPubNative;
import com.mopub.nativeads.MoPubStaticNativeAdRenderer;
import com.mopub.nativeads.NativeAd;
import com.mopub.nativeads.NativeAd.MoPubNativeEventListener;
import com.mopub.nativeads.NativeErrorCode;
import com.mopub.nativeads.RequestParameters;
import com.mopub.nativeads.StaticNativeAd;
import com.mopub.nativeads.ViewBinder;
import com.mopub.network.ImpressionData;
import com.mopub.network.ImpressionsEmitter;
import com.mopub.network.ImpressionListener;


import java.util.EnumSet;

/**
 * Created by usamaazam on 03/04/2019.
 */

public class RNNativeAdView extends FrameLayout implements MoPubNative.MoPubNativeNetworkListener {

    ReactContext mContext;

    private ImpressionListener mImpressionListener;
    private MoPubNativeEventListener moPubNativeEventListener;


    public RNNativeAdView(ReactContext context) {
        super(context);
        mContext = context;
    }

    public void updateBounds(int width, int height) {
        int factor = (int) mContext.getResources().getDisplayMetrics().density;
        FrameLayout layout = findViewById(R.id.native_ad_view);
        FrameLayout.LayoutParams params = new FrameLayout.LayoutParams(width * factor, height * factor);
        layout.setLayoutParams(params);
    }

    @Override
    public void requestLayout() {
        super.requestLayout();

        post(measureAndLayout);
    }

    private final Runnable measureAndLayout = new Runnable() {
    @Override
        public void run() {
            measure(MeasureSpec.makeMeasureSpec(getWidth(), MeasureSpec.EXACTLY),
                    MeasureSpec.makeMeasureSpec(getHeight(), MeasureSpec.EXACTLY));
            layout(getLeft(), getTop(), getRight(), getBottom());
        }
    };

    public void initializeMopubNativeAd(String adUnitId) {
        MoPubNative moPubNative = new MoPubNative(mContext, adUnitId, this);

        mImpressionListener = new ImpressionListener() {
            @Override
            public void onImpression(@NonNull final String adUnitId, @Nullable final ImpressionData impressionData) {
                WritableMap event = Arguments.createMap();

                if (impressionData == null) {
                    // impression data is not available, write warning to LogCat
                    Log.w("ILRD", "impression data not available for adUnitId= " + adUnitId);
                    event.putString("impressionData", "");
                } else {
                    try {
                        // impression data is available, process it here
                        Log.i("ILRD", "impression data adUnitId= " + adUnitId + "data=\n" + impressionData.getJsonRepresentation().toString(2));
                        
                        event.putString("impressionData", impressionData.getJsonRepresentation().toString(2));
                    } catch (JSONException e) {
                        Log.e("ILRD", "Can't format impression data. e=" + e.toString() );
                        event.putString("error", "Can't format impression data: "+ e.toString());
                        event.putString("impressionData", "");
                    }
                }
                ReactContext reactContext = (ReactContext) getContext();
                reactContext.getJSModule(RCTEventEmitter.class).receiveEvent(
                getId(),
                "onImpressionData",
                event);
            }
        };

        // subscribe to start listening for impression data
        ImpressionsEmitter.addListener(mImpressionListener);
        
        // Mopub rendered
        MoPubStaticNativeAdRenderer moPubStaticNativeAdRenderer = new MoPubStaticNativeAdRenderer(
            new ViewBinder.Builder(R.layout.native_ads)
            .build());
        // Google rendered
        final GooglePlayServicesAdRenderer googlePlayServicesAdRenderer = new GooglePlayServicesAdRenderer(
            new GooglePlayServicesViewBinder.Builder(R.layout.native_ads)
            .build());

        // Mopub has to be last
        moPubNative.registerAdRenderer(googlePlayServicesAdRenderer);
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

        if (privacyIconImageSource == null) {
            privacyIconImageSource = "asset:/images/mopub_privacy_icon.png";
        }

        WritableMap event = Arguments.createMap();
        event.putString("title", title);
        event.putString("mainText", mainText);
        event.putString("callToActionText", callToActionText);
        event.putString("mainImageSource", mainImageSource);
        event.putString("iconImageSource", iconImageSource);
        event.putString("privacyIconImageSource", privacyIconImageSource);

        AdapterHelper adapterHelper = new AdapterHelper(mContext.getCurrentActivity(), 0, 3);
        // Retrieve the pre-built ad view that AdapterHelper prepared for us.
        View v = adapterHelper.getAdView(null, this, nativeAd, new ViewBinder.Builder(0).build());
        // Set the native event listeners (onImpression, and onClick).
        nativeAd.setMoPubNativeEventListener(moPubNativeEventListener);

        // Add the ad view to our view hierarchy
        super.addView(v);

        ReactContext reactContext = (ReactContext) getContext();
        reactContext.getJSModule(RCTEventEmitter.class).receiveEvent(
                getId(),
                "onNativeAdLoaded",
                event);
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
    }
}