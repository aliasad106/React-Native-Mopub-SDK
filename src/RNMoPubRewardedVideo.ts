import { NativeEventEmitter, NativeModules } from "react-native";
const { RNMoPubRewardedVideo } = NativeModules;

export interface IRNMoPubRewardedVideo {
    initializeSdkForRewardedVideoAd: (adUnitId: string) => void;
    loadRewardedVideoAdWithAdUnitID: (adUnitId: string) => void;
    presentRewardedVideoAdForAdUnitID: (adUnitId: string, currencyType:string, amount: number, promise:()=>{}) => void;
    availableRewardsForAdUnitID: (adUnitId:string, promise:()=>{}) => void;
    hasAdAvailableForAdUnitID: (adUnitId:string, promise:()=>{}) => void;
    addEventListener: (eventType: string, listener: () => void) => void;
    removeAllListeners: (eventType: string) => void;
}

const emitter = new NativeEventEmitter(RNMoPubRewardedVideo);

export default {
    addEventListener: (eventType: string, listener: () => void)  => emitter.addListener(eventType, listener),
    availableRewardsForAdUnitID: (adUnitId:string, promise:()=>{}) => RNMoPubRewardedVideo.availableRewardsForAdUnitID(adUnitId,promise),
    hasAdAvailableForAdUnitID:(adUnitId:string, promise:()=>{}) =>RNMoPubRewardedVideo.hasAdAvailableForAdUnitID(adUnitId,promise) ,
    initializeSdkForRewardedVideoAd: (adUnitId:string) => RNMoPubRewardedVideo.initializeSdkForRewardedVideoAd(adUnitId),
    loadRewardedVideoAdWithAdUnitID: (adUnitId: string) => RNMoPubRewardedVideo.loadRewardedVideoAdWithAdUnitID(adUnitId),
    presentRewardedVideoAdForAdUnitID: (adUnitId: string, currencyType:string, amount: number, promise:()=>{}) => RNMoPubRewardedVideo.presentRewardedVideoAdForAdUnitID(adUnitId, currencyType, amount, promise),
    removeAllListeners: (eventType: string) => emitter.removeAllListeners(eventType)
} as IRNMoPubRewardedVideo;