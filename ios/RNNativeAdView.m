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
    self.contentView.frame = self.bounds;
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
            self.onNativeAdLoaded(@{});

            self.mpNativeAd = response;
            self.mpNativeAd.delegate = self;
            
            UIView *nativeAdView = [response retrieveAdViewWithError:nil];

            nativeAdView.translatesAutoresizingMaskIntoConstraints = false;
            [self addSubview:nativeAdView];
            
            [nativeAdView.topAnchor constraintEqualToAnchor:self.topAnchor constant:0].active = YES;
                [nativeAdView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:0].active = YES;
                [nativeAdView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:0].active = YES;
                [nativeAdView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:0].active = YES;
            [nativeAdView layoutIfNeeded];
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

- (void)layoutSubviews
{
    [super layoutSubviews];
    // layout your views
}

- (UILabel *)nativeMainTextLabel
{
    return self.mainTextLabel;
}

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
