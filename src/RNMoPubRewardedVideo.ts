import { NativeEventEmitter, NativeModules } from "react-native";
const { RNMoPubRewardedVideo } = NativeModules;

export interface IRNMoPubRewardedVideo {
    initializeSdkForRewardedVideoAd: (adUnitId: string) => void;
    loadRewardedVideoAdWithAdUnitID: (adUnitId: string) => void;
    presentRewardedVideoAdForAdUnitID: (adUnitId: string, currencyType:string, amount: number, promise:(args: any)=>{}) => void;
    availableRewardsForAdUnitID: (adUnitId:string, promise:(args: any)=>{}) => void;
    hasAdAvailableForAdUnitID: (adUnitId:string, promise:(args: any)=>{}) => void;
    addEventListener: (eventType: string, listener: (args: any) => void) => void;
    removeAllListeners: (eventType: string) => void;
}

const emitter = new NativeEventEmitter(RNMoPubRewardedVideo);

export default {
    addEventListener: (eventType, listener)  => emitter.addListener(eventType, listener),
    availableRewardsForAdUnitID: (adUnitId, promise) => RNMoPubRewardedVideo.availableRewardsForAdUnitID(adUnitId,promise),
    hasAdAvailableForAdUnitID:(adUnitId, promise) =>RNMoPubRewardedVideo.hasAdAvailableForAdUnitID(adUnitId,promise) ,
    initializeSdkForRewardedVideoAd: (adUnitId) => RNMoPubRewardedVideo.initializeSdkForRewardedVideoAd(adUnitId),
    loadRewardedVideoAdWithAdUnitID: (adUnitId) => RNMoPubRewardedVideo.loadRewardedVideoAdWithAdUnitID(adUnitId),
    presentRewardedVideoAdForAdUnitID: (adUnitId, currencyType, amount, promise) => RNMoPubRewardedVideo.presentRewardedVideoAdForAdUnitID(adUnitId, currencyType, amount, promise),
    removeAllListeners: (eventType) => emitter.removeAllListeners(eventType)
} as IRNMoPubRewardedVideo;