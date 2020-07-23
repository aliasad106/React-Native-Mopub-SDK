import {NativeModules, NativeEventEmitter} from 'react-native';
const { RNMoPubInterstitial } = NativeModules;

export interface IRNMoPubInterstitial {
    initializeInterstitialAd: (adUnitId: string) => void;
    loadAd: () => void;
    setKeywords: (keywords: string) => void;
    isReady: () => Promise<void>;
    show: () => void;
    addEventListener: (eventType: string, listener: () => void) => void;
    removeAllListeners: (eventType: string) => void;
}

const emitter = new NativeEventEmitter(RNMoPubInterstitial);

module.exports = {
    initializeInterstitialAd: (adUnitId: string) => RNMoPubInterstitial.initializeInterstitialAd(adUnitId),
    loadAd: () => RNMoPubInterstitial.loadAd(),
    setKeywords: (keywords: string) => RNMoPubInterstitial.setKeywords(keywords),
    isReady: (): Promise => RNMoPubInterstitial.isReady(),
    show: () => RNMoPubInterstitial.show(),
    addEventListener: (eventType: string, listener: Function)  => emitter.addListener(eventType, listener),
    removeAllListeners: (eventType: string) => emitter.removeAllListeners(eventType)
};