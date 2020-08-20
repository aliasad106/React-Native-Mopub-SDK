
#import "RNMoPubInterstitial.h"
#import <React/RCTLog.h>

#import "MoPub.h"
#import "MPMoPubConfiguration.h"

@implementation RNMoPubInterstitial

RCT_EXPORT_MODULE();


- (NSArray<NSString *> *)supportedEvents {
    return @[
             @"onLoaded",
             @"onFailed",
             @"onShown",
             @"onDismissed",
             @"onClicked",
             @"onTrackImpressionData",
             @"onSDKInitialized"
            ];
}


- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}



RCT_EXPORT_METHOD(initializeInterstitialAd:(NSString *)unitId)
{
    MPMoPubConfiguration *sdkConfig = [[MPMoPubConfiguration alloc] initWithAdUnitIdForAppInitialization:unitId];
    sdkConfig.loggingLevel = MPBLogLevelDebug;
    [[MoPub sharedInstance] initializeSdkWithConfiguration:sdkConfig completion:^{
        RCTLog(@"SDK initialized");
    [self sendEventWithName:@"onSDKInitialized" body:nil];
    }];
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

- (void)mopubAd:(id<MPMoPubAd>)ad didTrackImpressionWithImpressionData:(MPImpressionData * _Nullable)impressionData
{
    RCTLog(@"onTrackImpressionData");

    if (impressionData == nil)
    {
            [self sendEventWithName:@"onTrackImpressionData" body:@{@"impressionData": @""}];
    } else {
            NSError *jsonSerializationError = nil;
            NSObject *impressionObject = [NSJSONSerialization JSONObjectWithData:impressionData.jsonRepresentation options:0 error:&jsonSerializationError];
            [self sendEventWithName:@"onTrackImpressionData" body:@{@"impressionData": impressionObject}];
    }
}



@end
