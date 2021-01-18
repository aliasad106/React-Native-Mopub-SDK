//
//  RNNativeAdViewManager.m
//  react-native-ad-lib
//
//  Created by Usama Azam on 27/03/2019.
//

#import "RNNativeAdViewManager.h"

@implementation RNNativeAdViewManager
RCT_EXPORT_MODULE();

@synthesize bridge = _bridge;

-(UIView *)view
{
    RNNativeAdView *containerNativeView = [[RNNativeAdView alloc] init];
    return containerNativeView;
}


- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}


- (NSArray *) customDirectEventTypes
{
    return @[
             @"onMainTextLabelLoaded",
             @"onTitleLabelLoaded",
             @"onCallToActionLabelLoaded"
             ];
}


RCT_EXPORT_VIEW_PROPERTY(adUnitId, NSString);
RCT_EXPORT_VIEW_PROPERTY(onNativeAdLoaded, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onNativeAdFailed, RCTBubblingEventBlock);

RCT_EXPORT_VIEW_PROPERTY(onWillPresentModalForNativeAd, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onWillLeaveApplicationFromNativeAd, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onDidDismissModalForNativeAd, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onImpressionData, RCTBubblingEventBlock);

RCT_EXPORT_METHOD(updateBounds:(nonnull NSNumber*) reactTag withWidth:(NSString *) width andHeight:(NSString *) height) {
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
        RNNativeAdView *view = viewRegistry[reactTag];
        if (!view || ![view isKindOfClass:[RNNativeAdView class]]) {
            RCTLogError(@"Cannot find NativeView with tag #%@", reactTag);
            return;
        }
        [view updateBounds:width andHeight:height];
    }];
}
@end
