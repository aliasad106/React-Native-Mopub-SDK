import { NativeEventEmitter, NativeModules } from "react-native";
const { RNMoPubInterstitial } = NativeModules;

export interface IRNMoPubInterstitial {
    addEventListener: (eventType: string, listener: () => void) => void;
    initializeInterstitialAd: (adUnitId: string) => void;
    loadAd: () => void;
    isReady: () => Promise<boolean>;
    removeAllListeners: (eventType: string) => void;
    setKeywords: (keywords: string) => void;
    show: () => void;
  }
  
const emitter = new NativeEventEmitter(RNMoPubInterstitial);

export default {
    addEventListener: (eventType: string, listener: () => void)  => emitter.addListener(eventType, listener),
    initializeInterstitialAd: (adUnitId: string) => RNMoPubInterstitial.initializeInterstitialAd(adUnitId),
    isReady: (): Promise<boolean> => RNMoPubInterstitial.isReady(),
    loadAd: () => RNMoPubInterstitial.loadAd(),
    removeAllListeners: (eventType: string) => emitter.removeAllListeners(eventType),
    setKeywords: (keywords: string) => RNMoPubInterstitial.setKeywords(keywords),
    show: () => RNMoPubInterstitial.show(),
} as IRNMoPubInterstitial;