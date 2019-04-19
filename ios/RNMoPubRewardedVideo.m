//
//  RNMoPubRewardedVideo.m
//  react-native-ad-lib
//
//  Created by Usama Azam on 28/03/2019.
//

#import "RNMoPubRewardedVideo.h"
#import <AdColonyGlobalMediationSettings.h>
#import <MPGoogleGlobalMediationSettings.h>
#import <TapjoyGlobalMediationSettings.h>
#import <VungleInstanceMediationSettings.h>
#import "MPRewardedVideo.h"
#import "AdLibSDK.h"
@implementation RNMoPubRewardedVideo

RCT_EXPORT_MODULE();

- (NSArray<NSString *> *)supportedEvents {
    return @[
             @"rewardedVideoAdDidLoadForAdUnitID",
             @"rewardedVideoAdDidFailToLoadForAdUnitID",
             @"rewardedVideoAdDidFailToPlayForAdUnitID",
             @"rewardedVideoAdWillAppearForAdUnitID",
             @"rewardedVideoAdDidAppearForAdUnitID",
             @"rewardedVideoAdWillDisappearForAdUnitID",
             @"rewardedVideoAdDidDisappearForAdUnitID",
             @"rewardedVideoAdShouldRewardForAdUnitID",
             @"rewardedVideoAdDidExpireForAdUnitID",
             @"rewardedVideoAdDidReceiveTapEventForAdUnitID",
             @"rewardedVideoAdWillLeaveApplicationForAdUnitID"
             ];
}


RCT_EXPORT_METHOD(loadRewardedVideoAdWithAdUnitID:(NSString *)unitId)
{
    
    [MPRewardedVideo loadRewardedVideoAdWithAdUnitID:unitId withMediationSettings:@[]];
    [MPRewardedVideo setDelegate:self forAdUnitId:unitId];
    
}

RCT_EXPORT_METHOD(initializeSdkForRewardedVideoAd:(NSString *)unitId) {
    [AdLibSDK initializeAdSDK:unitId];
}

RCT_EXPORT_METHOD(presentRewardedVideoAdForAdUnitID:(NSString *) unitId currencyType:(NSString*)currencyType amount:(nonnull NSNumber*) amount callback:(RCTResponseSenderBlock)callback)
{
    
    if ([MPRewardedVideo hasAdAvailableForAdUnitID:unitId]) {
        NSPredicate *rewardPredicate = [NSPredicate predicateWithFormat:@"(SELF.currencyType == %@ AND SELF.amount == %@)", currencyType, amount];
        
        MPRewardedVideoReward *selectedReward = [[MPRewardedVideo availableRewardsForAdUnitID:unitId] filteredArrayUsingPredicate:rewardPredicate].firstObject;
        
        if (selectedReward) {
             UIViewController *vc = [UIApplication sharedApplication].delegate.window.rootViewController;
             [MPRewardedVideo presentRewardedVideoAdForAdUnitID:unitId fromViewController:vc withReward:selectedReward];
             callback(@[@{@"message":@"video showing!"}]);
        } else {
            callback(@[@{@"message":@"reward not found! for these ingredients!"}]);
        }
    } else {
        callback(@[@{@"message":@"ad not found for this UnitId!"}]);
    }
    
}

RCT_EXPORT_METHOD(hasAdAvailableForAdUnitID:(NSString* ) unitId callback: (RCTResponseSenderBlock)callback) {
    BOOL hasAd = [MPRewardedVideo hasAdAvailableForAdUnitID:unitId];
    callback(@[@{@"Has ad": @(hasAd)}]);
}

RCT_EXPORT_METHOD(availableRewardsForAdUnitID: (NSString *)unitId callback: (RCTResponseSenderBlock)callback) {
    
    NSArray *rewards = [MPRewardedVideo availableRewardsForAdUnitID: unitId];
    
    NSMutableArray *rewardDictonaries = [NSMutableArray array];
    for (MPRewardedVideoReward* reward in rewards)
    {
        NSDictionary *rewardDict = @{ reward.currencyType : [NSString stringWithFormat:@"%@",reward.amount]};
        [rewardDictonaries addObject:rewardDict];
    }

    callback(rewardDictonaries);

}


- (void)rewardedVideoAdDidLoadForAdUnitID:(NSString *)adUnitID
{
    
    NSLog(@"video loaded successfully");
    [self sendEventWithName:@"rewardedVideoAdDidLoadForAdUnitID" body:@{@"adUnitID": adUnitID}];
    
}


- (void)rewardedVideoAdDidFailToLoadForAdUnitID:(NSString *)adUnitID error:(NSError *)error
{
    [self sendEventWithName:@"rewardedVideoAdDidFailToLoadForAdUnitID" body:@{@"adUnitID": adUnitID, @"error":error}];
    
}

- (void)rewardedVideoAdDidFailToPlayForAdUnitID:(NSString *)adUnitID error:(NSError *)error
{
    [self sendEventWithName:@"rewardedVideoAdDidFailToPlayForAdUnitID" body:@{@"adUnitID": adUnitID, @"error":error}];
}

- (void)rewardedVideoAdWillAppearForAdUnitID:(NSString *)adUnitID {
     [self sendEventWithName:@"rewardedVideoAdWillAppearForAdUnitID" body:@{@"adUnitID": adUnitID}];
}

- (void)rewardedVideoAdDidAppearForAdUnitID:(NSString *)adUnitID {
     [self sendEventWithName:@"rewardedVideoAdDidAppearForAdUnitID"  body:@{@"adUnitID": adUnitID}];
}

- (void)rewardedVideoAdWillDisappearForAdUnitID:(NSString *)adUnitID {
     [self sendEventWithName:@"rewardedVideoAdWillDisappearForAdUnitID"  body:@{@"adUnitID": adUnitID}];
}

- (void)rewardedVideoAdDidDisappearForAdUnitID:(NSString *)adUnitID {
     [self sendEventWithName:@"rewardedVideoAdDidDisappearForAdUnitID"  body:@{@"adUnitID": adUnitID}];
}

- (void)rewardedVideoAdShouldRewardForAdUnitID:(NSString *)adUnitID reward:(MPRewardedVideoReward *)reward {
     [self sendEventWithName:@"rewardedVideoAdShouldRewardForAdUnitID" body:nil];
}

- (void)rewardedVideoAdDidExpireForAdUnitID:(NSString *)adUnitID {
     [self sendEventWithName:@"rewardedVideoAdDidExpireForAdUnitID"  body:@{@"adUnitID": adUnitID}];
}

- (void)rewardedVideoAdDidReceiveTapEventForAdUnitID:(NSString *)adUnitID {
     [self sendEventWithName:@"rewardedVideoAdDidReceiveTapEventForAdUnitID" body:@{@"adUnitID": adUnitID}];
}

- (void)rewardedVideoAdWillLeaveApplicationForAdUnitID:(NSString *)adUnitID {
     [self sendEventWithName:@"rewardedVideoAdWillLeaveApplicationForAdUnitID" body:@{@"adUnitID": adUnitID}];
}


- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}


@end
