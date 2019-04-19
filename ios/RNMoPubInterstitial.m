
#import "RNMoPubInterstitial.h"
#import <React/RCTLog.h>
#import "RNNativeAdView.h"
#import <AdColonyGlobalMediationSettings.h>
#import <MPGoogleGlobalMediationSettings.h>
#import <TapjoyGlobalMediationSettings.h>
#import <VungleInstanceMediationSettings.h>
#import "MPNativeAdConstants.h"
#import "AdLibSDK.h"

@implementation RNMoPubInterstitial

RCT_EXPORT_MODULE();


- (NSArray<NSString *> *)supportedEvents {
    return @[
             @"onLoaded",
             @"onFailed",
             @"onShown",
             @"onDismissed",
             @"onClicked"
             ];
}


- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}



RCT_EXPORT_METHOD(initializeInterstitialAd:(NSString *)unitId)
{
    
    [AdLibSDK initializeAdSDK:unitId];
    RCTLog(@"Mopub Initialized from Library!");
    self.interstitial = [MPInterstitialAdController interstitialAdControllerForAdUnitId:unitId];
    self.interstitial.delegate = self;
    
}

RCT_REMAP_METHOD(isReady, resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    if (self.interstitial == nil){
        resolve(false);
    }
    else {
        resolve([NSNumber numberWithBool:[self.interstitial ready]]);
    }
}


RCT_EXPORT_METHOD(setKeywords:(NSString *)keywords) {
    [self.interstitial setKeywords:keywords];
}

RCT_EXPORT_METHOD(loadAd) {
    
    [self.interstitial loadAd];
    
}

RCT_EXPORT_METHOD(show) {
    if (self.interstitial != nil) {
        UIViewController *vc = [UIApplication sharedApplication].delegate.window.rootViewController;
        [self.interstitial showFromViewController:vc];
    }
}


- (void)interstitialDidFailToLoadAd:(MPInterstitialAdController *)interstitial
{
    RCTLog(@"MoPub interstital failed to load");
    [self sendEventWithName:@"onFailed" body:@{@"message": @"MoPub interstital failed to load"}];
    
}

- (void)interstitialDidLoadAd:(MPInterstitialAdController *)interstitial {
    RCTLog(@"onLoaded");
    [self sendEventWithName:@"onLoaded" body:nil];
}


- (void)interstitialDidAppear:(MPInterstitialAdController *)interstitial {
    RCTLog(@"onShown");
    [self sendEventWithName:@"onShown" body:nil];
    
}

- (void)interstitialDidDisappear:(MPInterstitialAdController *)interstitial {
    RCTLog(@"onDismissed");
    [self sendEventWithName:@"onDismissed" body:nil];}

- (void)interstitialDidReceiveTapEvent:(MPInterstitialAdController *)interstitial {
    RCTLog(@"onClicked");
    [self sendEventWithName:@"onClicked" body:nil];
}



@end
