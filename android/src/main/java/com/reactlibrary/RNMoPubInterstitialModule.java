package com.reactlibrary;

import android.app.Activity;
import android.os.Handler;
import android.util.Log;
import androidx.annotation.NonNull;
import javax.annotation.Nullable;
import org.json.JSONException;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.LifecycleEventListener;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;

import com.mopub.common.logging.MoPubLog;
import com.mopub.common.MoPub;
import com.mopub.common.SdkConfiguration;
import com.mopub.common.SdkInitializationListener;
import com.mopub.mobileads.MoPubErrorCode;
import com.mopub.mobileads.MoPubInterstitial;
import com.mopub.network.ImpressionData;
import com.mopub.network.ImpressionsEmitter;
import com.mopub.network.ImpressionListener;

/**
 * Created by usamaazam on 29/03/2019.
 */

public class RNMoPubInterstitialModule extends ReactContextBaseJavaModule implements MoPubInterstitial.InterstitialAdListener, LifecycleEventListener {

    public static final String EVENT_LOADED = "onLoaded";
    public static final String EVENT_FAILED = "onFailed";
    public static final String EVENT_CLICKED = "onClicked";
    public static final String EVENT_SHOWN = "onShown";
    public static final String EVENT_DISMISSED = "onDismissed";
    public static final String EVENT_TRACK_IMPRESSION_DATA = "onTrackImpressionData";
    public static final String EVENT_SDK_INITIALIZED = "onSDKInitialized";

    private MoPubInterstitial mInterstitial;
    private ImpressionListener mImpressionListener;

    ReactApplicationContext mReactContext;

    public RNMoPubInterstitialModule(ReactApplicationContext reactContext) {
        super(reactContext);
        mReactContext = reactContext;
    }

    @Override
    public String getName() {
        return "RNMoPubInterstitial";
    }

    public void initializeInterstitial(final String adUnitId) {
        Log.i("Mopub SDK", "Initializing interstitial");

        mInterstitial = new MoPubInterstitial(getCurrentActivity(), adUnitId);
        mInterstitial.setInterstitialAdListener(this);

        mImpressionListener = new ImpressionListener() {
            @Override
            public void onImpression(@NonNull final String adUnitId, @Nullable final ImpressionData impressionData) {
                Log.i("ILRD", "impression for adUnitId= " + adUnitId);
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
                sendEvent(EVENT_TRACK_IMPRESSION_DATA, event);
            }
        };

        // subscribe to start listening for impression data
        ImpressionsEmitter.addListener(mImpressionListener);
    }

    @ReactMethod
    public void initializeInterstitialAd(final String adUnitId) {
        Log.i("Mopub SDK", "Initialization...");

        Handler mainHandler = new Handler(getCurrentActivity().getMainLooper());

        Runnable myRunnable = new Runnable() {
            @Override
            public void run() {

                SdkConfiguration sdkConfiguration = new SdkConfiguration.Builder(adUnitId)
                        .withLogLevel(MoPubLog.LogLevel.DEBUG)
                        .build();

                MoPub.initializeSdk(getCurrentActivity(), sdkConfiguration, initSdkListener());

            }

            private SdkInitializationListener initSdkListener() {
                Log.i("Mopub SDK", "Initialization listener");
        
                return new SdkInitializationListener() {
                    @Override
                    public void onInitializationFinished() {
                        Log.i("Mopub SDK", "Initialization finished");
                        initializeInterstitial(adUnitId);
                        sendEvent(EVENT_SDK_INITIALIZED, null);
                    }
                };
            }
        };
        mainHandler.post(myRunnable);
    }

    @ReactMethod
    public void setKeywords(String keywords) {
        if (mInterstitial != null)
            mInterstitial.setKeywords(keywords);
    }

    @ReactMethod
    public void isReady(Promise promise) {
        if (mInterstitial == null) {
            promise.resolve(false);
        } else {
            promise.resolve(mInterstitial.isReady());
        }
    }

    @ReactMethod
    public void loadAd() {
        if (mInterstitial != null) {
            mInterstitial.load();
        }
    }

    @ReactMethod
    public void show() {
        final Activity activity = getCurrentActivity();

        activity.runOnUiThread(new Runnable() {
            @Override public void run() {
                if (mInterstitial != null) {
                    mInterstitial.show();
                }
            }
        });
    }

    @ReactMethod
    public void forceRefresh() {
        if (mInterstitial != null) {
            mInterstitial.forceRefresh();
        }
    }

    private void sendEvent(String eventName, @Nullable WritableMap params) {
        getReactApplicationContext().getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(eventName, params);
    }

    @Override
    public void onInterstitialLoaded(MoPubInterstitial interstitial) {
        sendEvent(EVENT_LOADED, null);
    }

    @Override
    public void onInterstitialFailed(MoPubInterstitial interstitial, MoPubErrorCode errorCode) {
        WritableMap event = Arguments.createMap();
        event.putString("message", errorCode.toString());
        sendEvent(EVENT_FAILED, event);
    }

    @Override
    public void onInterstitialShown(MoPubInterstitial interstitial) {
        sendEvent(EVENT_SHOWN, null);
    }

    @Override
    public void onInterstitialClicked(MoPubInterstitial interstitial) {
        sendEvent(EVENT_CLICKED, null);
    }

    @Override
    public void onInterstitialDismissed(MoPubInterstitial interstitial) {
        sendEvent(EVENT_DISMISSED, null);
    }

    @Override
    public void onHostResume() {

    }

    @Override
    public void onHostPause() {

    }

    @Override
    public void onHostDestroy() {
        if (mImpressionListener != null) {
            ImpressionsEmitter.removeListener(mImpressionListener);
            mImpressionListener = null;
        }
        if (mInterstitial != null)
            mInterstitial.destroy();
    }
}
