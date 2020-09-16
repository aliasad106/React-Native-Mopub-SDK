import { IAdLibSDK } from './src/AdLibSDK';
import { IRNMoPubInterstitial } from "./src/RNMoPubInterstitial";
import { IRNMoPubRewardedVideo } from "./src/RNMoPubRewardedVideo";

declare module "react-native-mopub-sdk" {
  export const AdLibSDK: IAdLibSDK;
  export const RNMoPubInterstitial: IRNMoPubInterstitial;
  export const MoPubBanner: React.ReactNode;
  export const RNMoPubRewardedVideo: IRNMoPubRewardedVideo;
  export const RNNativeAdView: React.ReactNode;
}
