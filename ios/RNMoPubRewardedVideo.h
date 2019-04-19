//
//  RNMoPubRewardedVideo.h
//  react-native-ad-lib
//
//  Created by Usama Azam on 28/03/2019.
//


#if __has_include(<React/RCTBridgeModule.h>)
#import <React/RCTBridgeModule.h>
#else
#import "RCTBridgeModule.h"
#endif

#import <React/RCTEventEmitter.h>

#import <Foundation/Foundation.h>
#import <mopub-ios-sdk/MoPub.h>

NS_ASSUME_NONNULL_BEGIN

@interface RNMoPubRewardedVideo : RCTEventEmitter <RCTBridgeModule, MPRewardedVideoDelegate>
@end

NS_ASSUME_NONNULL_END


