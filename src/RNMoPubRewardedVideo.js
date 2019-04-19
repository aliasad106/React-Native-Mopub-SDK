import {NativeModules, NativeEventEmitter} from 'react-native';
const { RNMoPubRewardedVideo } = NativeModules;


const emitter = new NativeEventEmitter(RNMoPubRewardedVideo);

module.exports = {
    initializeSdkForRewardedVideoAd: (adUnitId:string) => RNMoPubRewardedVideo.initializeSdkForRewardedVideoAd(adUnitId),
    loadRewardedVideoAdWithAdUnitID: (adUnitId: string) => RNMoPubRewardedVideo.loadRewardedVideoAdWithAdUnitID(adUnitId),
    presentRewardedVideoAdForAdUnitID: (adUnitId: string, currencyType:string, amount: number, promise:()=>{}) => RNMoPubRewardedVideo.presentRewardedVideoAdForAdUnitID(adUnitId, currencyType, amount, promise),
    availableRewardsForAdUnitID: (adUnitId:string, promise:()=>{}) => RNMoPubRewardedVideo.availableRewardsForAdUnitID(adUnitId,promise),
    hasAdAvailableForAdUnitID:(adUnitId:string, promise:()=>{}) =>RNMoPubRewardedVideo.hasAdAvailableForAdUnitID(adUnitId,promise) ,
    addEventListener: (eventType: string, listener: Function)  => emitter.addListener(eventType, listener),
    removeAllListeners: (eventType: string) => emitter.removeAllListeners(eventType)
};