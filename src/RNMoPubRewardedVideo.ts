import { NativeEventEmitter, NativeModules } from "react-native";
const { RNMoPubRewardedVideo } = NativeModules;

export interface IRNMoPubRewardedVideo {
    addEventListener: (eventType: string, listener: (args: any) => void) => void;
    initializeRewardedAd: () => void;
    loadRewardedVideoWithUnitID: (adUnitId: string) => void;
    removeAllListeners: (eventType: string) => void;
    showRewardedVideoWithUnitID: (adUnitId: string, onError: (err: any) => void) => void;
}

const emitter = new NativeEventEmitter(RNMoPubRewardedVideo);

export default {
    addEventListener: (eventType, listener)  => emitter.addListener(eventType, listener),
    initializeRewardedAd: () => RNMoPubRewardedVideo.initializeRewardedAd(),
    loadRewardedVideoWithUnitID: (adUnitId) => RNMoPubRewardedVideo.loadRewardedVideoWithUnitID(adUnitId),
    removeAllListeners: (eventType) => emitter.removeAllListeners(eventType),
    showRewardedVideoWithUnitID: (adUnitId, onError) => RNMoPubRewardedVideo.showRewardedVideoWithUnitID(adUnitId, onError)
} as IRNMoPubRewardedVideo;