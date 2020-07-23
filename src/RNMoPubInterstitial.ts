import { NativeEventEmitter, NativeModules } from "react-native";
const { RNMoPubInterstitial } = NativeModules;

export interface IRNMoPubInterstitial {
    addEventListener: (eventType: string, listener: (arg: any) => void) => void;
    initializeInterstitialAd: (adUnitId: string) => void;
    loadAd: () => void;
    isReady: () => Promise<boolean>;
    removeAllListeners: (eventType: string) => void;
    setKeywords: (keywords: string) => void;
    show: () => void;
  }
  
const emitter = new NativeEventEmitter(RNMoPubInterstitial);

export default {
    addEventListener: (eventType, listener)  => emitter.addListener(eventType, listener),
    initializeInterstitialAd: (adUnitId) => RNMoPubInterstitial.initializeInterstitialAd(adUnitId),
    isReady: () => RNMoPubInterstitial.isReady(),
    loadAd: () => RNMoPubInterstitial.loadAd(),
    removeAllListeners: (eventType) => emitter.removeAllListeners(eventType),
    setKeywords: (keywords) => RNMoPubInterstitial.setKeywords(keywords),
    show: () => RNMoPubInterstitial.show(),
} as IRNMoPubInterstitial;