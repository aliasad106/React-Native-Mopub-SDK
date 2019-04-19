//
//  RNNativeAdView.h
//  react-native-ad-lib
//
//  Created by Usama Azam on 27/03/2019.
//

#import "RCTView.h"
#import "MPNativeAdRendering.h"
#import "MPNativeAdConstants.h"
#import <RCTTextView.h>
#import <mopub-ios-sdk/MoPub.h>
NS_ASSUME_NONNULL_BEGIN

@interface RNNativeAdView : RCTView <MPNativeAdRendering, MPNativeAdDelegate>

@property (nonatomic, strong) NSString *adUnitId;
@property (nonatomic, strong) MPNativeAd *mpNativeAd;
@property (nonatomic, copy) RCTBubblingEventBlock onNativeAdLoaded;
@property (nonatomic, copy) RCTBubblingEventBlock onNativeAdFailed;

@property (nonatomic, copy) RCTBubblingEventBlock onWillPresentModalForNativeAd;
@property (nonatomic, copy) RCTBubblingEventBlock onWillLeaveApplicationFromNativeAd;
@property (nonatomic, copy) RCTBubblingEventBlock onDidDismissModalForNativeAd;
@end


NS_ASSUME_NONNULL_END

