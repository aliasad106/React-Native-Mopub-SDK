#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

#import <Foundation/Foundation.h>
#import <mopub-ios-sdk/MoPub.h>

NS_ASSUME_NONNULL_BEGIN

@interface RNMoPubRewardedVideo : RCTEventEmitter <RCTBridgeModule, MPRewardedVideoDelegate>
@end

NS_ASSUME_NONNULL_END


