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
        
    }
    return self;
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
            
            self.mpNativeAd = response;
            
            NSDictionary *data = [response properties];
            
            NSString *title =  data[@"title"];
            NSString *mainText =  data[@"text"];
            NSString *callToActionText =  data[@"ctatext"];
            NSString *mainImageSource =  data[@"mainimage"];
            NSString *privacyIconImageSource =  data[@"privacyicon"];
            NSString *iconImageSource =  data[@"iconimage"];
            
            self.onNativeAdLoaded(@{@"title":title, @"mainText": mainText, @"callToActionText":callToActionText,@"mainImageSource":mainImageSource, @"privacyIconImageSource":privacyIconImageSource,@"iconImageSource":iconImageSource});
            
            self.mpNativeAd.delegate = self;
            
            UIView *nativeAdView = [response retrieveAdViewWithError:nil];
            nativeAdView.tag = 123456;
            
            [self setFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
            [nativeAdView setBounds:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            [nativeAdView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
           
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
    NSLog(@"[Mopub] bounds %@ %@ %@", width, height, str);
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

@end
