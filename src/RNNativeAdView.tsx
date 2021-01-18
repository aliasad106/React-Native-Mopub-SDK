import React, { useCallback, useRef } from "react";
import { 
    findNodeHandle, 
    LayoutChangeEvent, 
    NativeSyntheticEvent,
    Platform,
    requireNativeComponent, 
    UIManager, 
    View 
} from "react-native";

const NativeAdView = requireNativeComponent("RNNativeAdView");

export interface INativeAdConfig {
    callToActionText: string;
    iconImageSource: string;
    mainImageSource: string;
    mainText: string;
    privacyIconImageSource: string;
    title: string;
}

interface INativeAdError {
    error: string;
}

interface INativeAdMessage {
    message: string;
}

interface IImpressionData {
    impressionData: any
}

export interface IRNNativeAdViewProps {
    adUnitId: string,
    children?: React.ReactNode,
    onAdLoaded: (config: INativeAdConfig) => void,
    onAdFailed?: (error: INativeAdError) => void,
    onAdOpen?: (message: INativeAdMessage) => void,
    onAdClose?: (message: INativeAdMessage) => void,
    onImpressionData: (jsonImpressionData: any) => void
}

export const RNNativeAdView = ({ 
    adUnitId,
    children,
    onAdLoaded,
    onAdFailed = () => {},
    onAdOpen,
    onAdClose,
    onImpressionData,
}: IRNNativeAdViewProps) => {
    const nativeAdViewRef = useRef(null);

    const updateBounds = useCallback((width: string, height: string) => {
        // @ts-ignore
        UIManager.dispatchViewManagerCommand(
            findNodeHandle(nativeAdViewRef.current),
            // @ts-ignore
            UIManager.getViewManagerConfig("RNNativeAdView").Commands
              .updateBounds,
            [width, height]
          );
    }, []);

    const onLayout = useCallback((event: LayoutChangeEvent) => {
        const { height, width } = event.nativeEvent.layout;

        if (Platform.OS === "ios") {
            updateBounds(Math.round(width).toString(), Math.round(height).toString());
        }
    }, [])

    return (
        <View onLayout={onLayout}>
            <NativeAdView
                ref={nativeAdViewRef}
                adUnitId={adUnitId}
                onNativeAdLoaded={(event: NativeSyntheticEvent<INativeAdConfig>) => onAdLoaded(event.nativeEvent)}
                onNativeAdFailed={(event: NativeSyntheticEvent<INativeAdError>) => onAdFailed(event.nativeEvent)}
                onWillPresentModalForNativeAd={onAdOpen}
                onDidDismissModalForNativeAd={onAdClose}
                onImpressionData={(event: NativeSyntheticEvent<IImpressionData>) => onImpressionData(event.nativeEvent.impressionData)}
            >
                {children}
            </NativeAdView>
        </View>
    );
}
