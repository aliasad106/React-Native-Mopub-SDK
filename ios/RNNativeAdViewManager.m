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
@end
