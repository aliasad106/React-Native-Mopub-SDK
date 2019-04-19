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
    
    [self configureMopubMediationWithID:adUnitId];
    MPStaticNativeAdRendererSettings *settings = [[MPStaticNativeAdRendererSettings alloc] init];
    settings.renderingViewClass = [RNNativeAdView class];
    MPNativeAdRendererConfiguration *config = [MPStaticNativeAdRenderer rendererConfigurationWithRendererSettings:settings];
    MPNativeAdRequest *adRequest = [MPNativeAdRequest requestWithAdUnitIdentifier:adUnitId rendererConfigurations:@[config]];
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
            nativeAdView.frame = self.bounds;
            [self addSubview:nativeAdView];
            
            
        }
    }];
}

-(void) configureMopubMediationWithID:(NSString *)unitID
{
    MPMoPubConfiguration *sdkConfig = [[MPMoPubConfiguration alloc] initWithAdUnitIdForAppInitialization: unitID];
    sdkConfig.loggingLevel = MPBLogLevelDebug;
    sdkConfig.globalMediationSettings = [[NSArray alloc] initWithObjects:  @[], nil];
    [[MoPub sharedInstance] initializeSdkWithConfiguration:sdkConfig completion:^{
        NSLog(@"SDK initialization complete");
    }];
}

- (void)willPresentModalForNativeAd:(MPNativeAd *)nativeAd {
    _onWillPresentModalForNativeAd(@{@"message":@"willPresentModalForNativeAd"});
}

- (void)willLeaveApplicationFromNativeAd:(MPNativeAd *)nativeAd {
    _onWillLeaveApplicationFromNativeAd(@{@"message":@"willLeaveApplicationFromNativeAd"});
}

- (void)didDismissModalForNativeAd:(MPNativeAd *)nativeAd {
    _onDidDismissModalForNativeAd(@{@"message":@"didDismissModalForNativeAd"});
}

- (UIViewController *)viewControllerForPresentingModalView {
    
    return [UIApplication sharedApplication].delegate.window.rootViewController;
}


@end
