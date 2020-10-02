package com.reactlibrary;

import android.app.Activity;
import android.util.Log;
import androidx.annotation.NonNull;
import org.json.JSONException;
import org.json.JSONObject;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.mopub.common.MoPubReward;
import com.mopub.mobileads.MoPubErrorCode;
import com.mopub.mobileads.MoPubRewardedVideoListener;
import com.mopub.mobileads.MoPubRewardedVideos;
import com.mopub.network.ImpressionData;
import com.mopub.network.ImpressionsEmitter;
import com.mopub.network.ImpressionListener;


import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import javax.annotation.Nullable;

/**
 * Created by usamaazam on 30/03/2019.
 */

public class RNMoPubRewardedVideo extends ReactContextBaseJavaModule implements MoPubRewardedVideoListener {

    ReactApplicationContext mReactContext;

    public RNMoPubRewardedVideo(ReactApplicationContext reactContext) {
        super(reactContext);
        mReactContext = reactContext;
    }

    public static final String ON_REWARDED_VIDEO_LOAD_SUCCESS = "onRewardedVideoLoadSuccess";
    public static final String ON_REWARDED_VIDEO_LOAD_FAILURE = "onRewardedVideoLoadFailure";
    public static final String ON_REWARDED_VIDEO_STARTED = "onRewardedVideoStarted";
    public static final String ON_REWARDED_VIDEO_PLAYBACK_ERROR = "onRewardedVideoPlaybackError";
    public static final String ON_REWARDED_VIDEO_CLOSED = "onRewardedVideoClosed";
    public static final String ON_REWARDED_VIDEO_COMPLETED = "onRewardedVideoCompleted";
    public static final String ON_REWARDED_VIDEO_CLICKED = "onRewardedVideoClicked";
    public static final String EVENT_TRACK_IMPRESSION_DATA = "onRewardedTrackImpressionData";

    private ImpressionListener mImpressionListener;

    @Override
    public String getName() {
        return "RNMoPubRewardedVideo";
    }

    private void sendEvent(String eventName, @Nullable WritableMap params) {
        getReactApplicationContext().getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(eventName, params);
    }

    @ReactMethod
    public void initializeRewardedAd() {
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
    public void loadRewardedVideoWithUnitID(final String unitID) {
        final Activity activity = getCurrentActivity();
        final MoPubRewardedVideoListener listener = this;

        activity.runOnUiThread(new Runnable() {
            @Override public void run() {
                MoPubRewardedVideos.loadRewardedVideo(unitID);
                MoPubRewardedVideos.setRewardedVideoListener(listener);
            }
        });
    }

    @ReactMethod
    public void showRewardedVideoWithUnitID(String unitID, Callback onError) {
        Boolean hasRewarded = MoPubRewardedVideos.hasRewardedVideo(unitID);
        try {
            JSONObject dictionary = new JSONObject();	

            if (hasRewarded) {
                MoPubRewardedVideos.showRewardedVideo(unitID);
                dictionary.put("error", false);
            } else {
                dictionary.put("error", "Ad not found for this unit ID");
            }
            onError.invoke(dictionary.toString());
        
        } catch (Exception ex) {	
            onError.invoke("Error with onError");	
        }
    }

    @Override
    public void onRewardedVideoLoadSuccess(String adUnitId) {
        sendEvent(ON_REWARDED_VIDEO_LOAD_SUCCESS, null);
    }

    @Override
    public void onRewardedVideoLoadFailure(String adUnitId, MoPubErrorCode errorCode) {

        HashMap<String, String> hm = new HashMap<>();
        hm.put("error", errorCode.toString());

        WritableMap map = new WritableNativeMap();
        for (Map.Entry<String, String> entry : hm.entrySet()) {
            map.putString(entry.getKey(), entry.getValue());
        }

        sendEvent(ON_REWARDED_VIDEO_LOAD_FAILURE, map);
    }

    @Override
    public void onRewardedVideoClosed(String adUnitId) {
        sendEvent(ON_REWARDED_VIDEO_CLOSED, null);

    }

    @Override
    public void onRewardedVideoCompleted(Set<String> adUnitIds, MoPubReward reward) {
        HashMap<String, String> hm = new HashMap<>();
        hm.put("amount", String.valueOf(reward.getAmount()));
        hm.put("currencyType", String.valueOf(reward.getLabel()));

        WritableMap map = new WritableNativeMap();
        for (Map.Entry<String, String> entry : hm.entrySet()) {
            map.putString(entry.getKey(), entry.getValue());
        }
        sendEvent(ON_REWARDED_VIDEO_COMPLETED, map);
    }

    @Override
    public void onRewardedVideoStarted(String adUnitId) {
        sendEvent(ON_REWARDED_VIDEO_STARTED, null);
    }

    @Override
    public void onRewardedVideoPlaybackError(String adUnitId, MoPubErrorCode errorCode) {
        HashMap<String, String> hm = new HashMap<>();
        hm.put("error", errorCode.toString());

        WritableMap map = new WritableNativeMap();
        for (Map.Entry<String, String> entry : hm.entrySet()) {
            map.putString(entry.getKey(), entry.getValue());
        }

        sendEvent(ON_REWARDED_VIDEO_PLAYBACK_ERROR, null);
    }

    @Override
    public void onRewardedVideoClicked(@NonNull String adUnitId) {
        sendEvent(ON_REWARDED_VIDEO_CLICKED, null);
    }
}
