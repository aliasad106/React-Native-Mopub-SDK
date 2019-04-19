#if __has_include(<React/RCTBridgeModule.h>)
#import <React/RCTBridgeModule.h>
#else
#import "RCTBridgeModule.h"
#endif

#import <React/RCTEventEmitter.h>

#import <Foundation/Foundation.h>
#import <mopub-ios-sdk/MoPub.h>

@interface RNMoPubInterstitial : RCTEventEmitter <RCTBridgeModule, MPInterstitialAdControllerDelegate>
@property (nonatomic, retain) MPInterstitialAdController *interstitial;
@end


