import React, { useCallback, useRef } from "react";
import { 
    findNodeHandle, 
    LayoutChangeEvent, 
    NativeSyntheticEvent, 
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

export interface INativeAdError {
    error: string;
}

export interface INativeAdMessage {
    message: string;
}

export interface IRNNativeAdViewProps {
    adUnitId: string,
    children?: React.ReactNode,
    onAdLoaded: (config: INativeAdConfig) => void,
    onAdFailed?: (error: INativeAdError) => void,
    onAdOpen?: (message: INativeAdMessage) => void,
    onAdClose?: (message: INativeAdMessage) => void,
}

export const RNNativeAdView = ({ 
    adUnitId,
    children,
    onAdLoaded,
    onAdFailed = () => {},
    onAdOpen,
    onAdClose 
}: IRNNativeAdViewProps) => {
    const nativeAdViewRef = useRef(null);

    const childrenWithProps = React.Children.map(children, (child) => {
        if (React.isValidElement(child)) {
            return React.cloneElement(child, {
                updateBounds,
            });
        }
        return child
    });

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
        updateBounds(width.toString(), height.toString());
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
        >
            {childrenWithProps}
        </NativeAdView>
        </View>
    );
}
