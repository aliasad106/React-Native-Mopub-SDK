//
//  RNNativeAdView.h
//  react-native-ad-lib
//
//  Created by Usama Azam on 27/03/2019.
//

#import "RCTView.h"
#import "MPNativeAdRendering.h"
#import "MPGoogleAdMobNativeRenderer.h"
#import <mopub-ios-sdk/MoPub.h>

@interface RNNativeAdView : RCTView <MPNativeAdRendering>
@property (strong, nonatomic) IBOutlet RNNativeAdView *contentView;

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *iconImageView;
@property (unsafe_unretained, nonatomic) IBOutlet PreferredWidthLabel *titleLabel;
@property (unsafe_unretained, nonatomic) IBOutlet PreferredWidthLabel *mainTextLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *sponsoredByLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *privacyInformationIconImageView;

@property (nonatomic, strong) NSString *adUnitId;
@property (nonatomic, strong) MPNativeAd *mpNativeAd;
@property (nonatomic, copy) RCTBubblingEventBlock onNativeAdLoaded;
@property (nonatomic, copy) RCTBubblingEventBlock onNativeAdFailed;

-(void) updateBounds: (NSString *)width andHeight:(NSString *)height;

@property (nonatomic, copy) RCTBubblingEventBlock onWillPresentModalForNativeAd;
@property (nonatomic, copy) RCTBubblingEventBlock onWillLeaveApplicationFromNativeAd;
@property (nonatomic, copy) RCTBubblingEventBlock onDidDismissModalForNativeAd;
@property (nonatomic, copy) RCTBubblingEventBlock onImpressionData;

@end
