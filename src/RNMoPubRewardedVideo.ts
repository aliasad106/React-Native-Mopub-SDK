import { NativeEventEmitter, NativeModules } from "react-native";
const { RNMoPubRewardedVideo } = NativeModules;

export interface IRNMoPubRewardedVideo {
    addEventListener: (eventType: string, listener: (args: any) => void) => void;
    availableRewardsForAdUnitID: (adUnitId:string, promise:(args: any)=>{}) => void;
    hasAdAvailableForAdUnitID: (adUnitId:string, promise:(args: any)=>{}) => void;
    initializeRewardedAd: () => void;
    loadRewardedVideoWithUnitID: (adUnitId: string) => void;
    presentRewardedVideoAdForAdUnitID: (adUnitId: string, currencyType:string, amount: number, promise:(args: any)=>{}) => void;
    removeAllListeners: (eventType: string) => void;
    showRewardedVideoWithUnitID: (adUnitId: string, onError: (err: any) => void) => void;
}

const emitter = new NativeEventEmitter(RNMoPubRewardedVideo);

export default {
    addEventListener: (eventType, listener)  => emitter.addListener(eventType, listener),
    availableRewardsForAdUnitID: (adUnitId, promise) => RNMoPubRewardedVideo.availableRewardsForAdUnitID(adUnitId,promise),
    hasAdAvailableForAdUnitID:(adUnitId, promise) =>RNMoPubRewardedVideo.hasAdAvailableForAdUnitID(adUnitId,promise) ,
    initializeRewardedAd: () => RNMoPubRewardedVideo.initializeRewardedAd(),
    loadRewardedVideoWithUnitID: (adUnitId) => RNMoPubRewardedVideo.loadRewardedVideoWithUnitID(adUnitId),
    presentRewardedVideoAdForAdUnitID: (adUnitId, currencyType, amount, promise) => RNMoPubRewardedVideo.presentRewardedVideoAdForAdUnitID(adUnitId, currencyType, amount, promise),
    removeAllListeners: (eventType) => emitter.removeAllListeners(eventType),
    showRewardedVideoWithUnitID: (adUnitId, onError) => RNMoPubRewardedVideo.showRewardedVideoWithUnitID(adUnitId, onError)
} as IRNMoPubRewardedVideo;