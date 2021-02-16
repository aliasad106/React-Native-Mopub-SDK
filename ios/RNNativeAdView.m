//
//  RNNativeAdView.m
//  react-native-ad-lib
//
//  Created by Usama Azam on 27/03/2019.
//

#import "RNNativeAdView.h"


@implementation RNNativeAdView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self customInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self customInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self customInit];
    }
    return self;
}

- (void)customInit
{
    [[NSBundle mainBundle] loadNibNamed:@"NativeAdListView" owner:self options:nil];
    [self addSubview:self.contentView];
//    self.contentView.frame = self.bounds;
}

- (void)setAdUnitId:(NSString *)adUnitId {
    MPStaticNativeAdRendererSettings *settings = [[MPStaticNativeAdRendererSettings alloc] init];
    settings.renderingViewClass = [RNNativeAdView class];
    // Mopub rendered
    MPNativeAdRendererConfiguration *mopubConfiguration = [MPStaticNativeAdRenderer rendererConfigurationWithRendererSettings:settings];
    // Google rendered
    MPNativeAdRendererConfiguration *googleConfiguration = [MPGoogleAdMobNativeRenderer rendererConfigurationWithRendererSettings:settings];

    MPNativeAdRequest *adRequest = [MPNativeAdRequest requestWithAdUnitIdentifier:adUnitId rendererConfigurations:@[mopubConfiguration, googleConfiguration]];
    
    MPNativeAdRequestTargeting *targeting = [MPNativeAdRequestTargeting targeting];
    targeting.desiredAssets = [NSSet setWithObjects:kAdTitleKey, kAdTextKey, kAdCTATextKey, kAdIconImageKey, kAdMainImageKey, kAdStarRatingKey, nil]; //The constants correspond to the 6 elements of MoPub native ads
    adRequest.targeting = targeting;
    
    [adRequest startWithCompletionHandler:^(MPNativeAdRequest *request, MPNativeAd *response, NSError *error) {
        if (error) {
            self.onNativeAdFailed(@{@"error":error.localizedDescription});
        } else {
            self.onNativeAdLoaded(@{@"height": [NSString stringWithFormat:@"%.2f", self.contentView.frame.size.height], @"width": [NSString stringWithFormat:@"%.2f", self.contentView.frame.size.width]});

            self.mpNativeAd = response;
            self.mpNativeAd.delegate = self;
            
            UIView *nativeAdView = [response retrieveAdViewWithError:nil];
            nativeAdView.tag = 123456;

            NSLog(@"Mopub xib content frame %f", self.contentView.bounds.size.height);
            NSLog(@"Mopub xib content bounds %f", self.contentView.frame.size.height);
            NSLog(@"Mopub xib frame %f", self.frame.size.height);
            NSLog(@"Mopub xib bounds %f", self.bounds.size.height);
            NSLog(@"Mopub xib NA bounds %f", nativeAdView.bounds.size.height);
            NSLog(@"Mopub xib NA frame %f", nativeAdView.frame.size.height);
            
            nativeAdView.frame = self.bounds;
            // [nativeAdView layoutIfNeeded];
            [self addSubview:nativeAdView];
        }
    }];
}

- (void)willPresentModalForNativeAd:(MPNativeAd *)nativeAd {
    if (_onWillPresentModalForNativeAd) {
        _onWillPresentModalForNativeAd(@{@"message":@"willPresentModalForNativeAd"});
    }
}

- (void)willLeaveApplicationFromNativeAd:(MPNativeAd *)nativeAd {
    if (_onWillLeaveApplicationFromNativeAd) {
        _onWillLeaveApplicationFromNativeAd(@{@"message":@"willLeaveApplicationFromNativeAd"});
    }
}

- (void)didDismissModalForNativeAd:(MPNativeAd *)nativeAd {
    if (_onDidDismissModalForNativeAd) {
        _onDidDismissModalForNativeAd(@{@"message":@"didDismissModalForNativeAd"});
    }
}

- (UIViewController *)viewControllerForPresentingModalView {
    return [UIApplication sharedApplication].delegate.window.rootViewController;
}

- (void)updateBounds:(NSString *)width andHeight:(NSString *)height{
    NSString *str = [NSString stringWithFormat:@"{{0, 0}, {%@, %@}}", width, height];
    NSLog(@"Mopub [Mopub] bounds %@ %@ %@", width, height, str);
    [[self viewWithTag:123456] setFrame:CGRectFromString(str)];
}

- (void)mopubAd:(id<MPMoPubAd>)ad didTrackImpressionWithImpressionData:(MPImpressionData * _Nullable)impressionData
{
    if (impressionData == nil)
    {
            _onImpressionData(@{@"impressionData": @""});
    } else {
            NSError *jsonSerializationError = nil;
            NSObject *impressionObject = [NSJSONSerialization JSONObjectWithData:impressionData.jsonRepresentation options:0 error:&jsonSerializationError];
            _onImpressionData(@{@"impressionData": impressionObject});
    }
}

//- (UILabel *)nativeMainTextLabel
//{
//    return self.mainTextLabel;
//}

- (UILabel *)nativeTitleTextLabel
{
    return self.titleLabel;
}

- (UIImageView *)nativeIconImageView
{
    return self.iconImageView;
}

- (UIImageView *)nativePrivacyInformationIconImageView
{
    return self.privacyInformationIconImageView;
}


@end
