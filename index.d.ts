import { IAdLibSDK } from './src/AdLibSDK';
import { IRNMoPubInterstitial } from "./src/RNMoPubInterstitial";
import { IRNMoPubRewardedVideo } from "./src/RNMoPubRewardedVideo";
import { INativeAdConfig as IAdConfig, IRNNativeAdViewProps } from './src/RNNativeAdView'

declare module "react-native-mopub-sdk" {
  export const AdLibSDK: IAdLibSDK;
  export type INativeAdConfig = IAdConfig;
  export const RNMoPubInterstitial: IRNMoPubInterstitial;
  export const RNMoPubRewardedVideo: IRNMoPubRewardedVideo;
  export const RNNativeAdView: React.FunctionComponent<IRNNativeAdViewProps>;
}