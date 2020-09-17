#import "RNMoPubRewardedVideo.h"
#import "MPRewardedVideo.h"
#import <React/RCTLog.h>

@implementation RNMoPubRewardedVideo

RCT_EXPORT_MODULE();

- (NSArray<NSString *> *)supportedEvents {
    return @[
             @"onRewardedVideoLoadSuccess",
             @"onRewardedVideoLoadFailure",
             @"onRewardedVideoPlaybackError",
             @"rewardedVideoAdWillAppearForAdUnitID",
             @"onRewardedVideoStarted",
             @"rewardedVideoAdWillDisappearForAdUnitID",
             @"onRewardedVideoClosed",
             @"onRewardedVideoCompleted",
             @"rewardedVideoAdDidExpireForAdUnitID",
             @"onRewardedVideoClicked",
             @"rewardedVideoAdWillLeaveApplicationForAdUnitID",
             @"onTrackImpressionData"
             ];
}


RCT_EXPORT_METHOD(loadRewardedVideoWithUnitID:(NSString *)unitId)
{
    [MPRewardedVideo loadRewardedVideoAdWithAdUnitID:unitId withMediationSettings:@[]];
    [MPRewardedVideo setDelegate:self forAdUnitId:unitId];
}

RCT_EXPORT_METHOD(showRewardedVideoWithUnitID:(NSString *)unitId onError:(RCTResponseSenderBlock)onError)
{
    NSArray *rewardeds = [MPRewardedVideo availableRewardsForAdUnitID:unitId];

    if ([rewardeds count] == 0) {
        onError(@[@{@"error":@"Ad not found for this unit ID"}]);
    } else {
        onError(@[@{@"error": @NO}]);
        UIViewController *vc = [UIApplication sharedApplication].delegate.window.rootViewController;
        [MPRewardedVideo presentRewardedVideoAdForAdUnitID:unitId fromViewController:vc withReward:rewardeds[0] customData:@""];
    }
}

RCT_EXPORT_METHOD(initializeRewardedAd) {
    // Required to be iso Android
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
    [self sendEventWithName:@"onRewardedVideoLoadSuccess" body:@{@"adUnitID": adUnitID}];
    
}


- (void)rewardedVideoAdDidFailToLoadForAdUnitID:(NSString *)adUnitID error:(NSError *)error
{
    [self sendEventWithName:@"onRewardedVideoLoadFailure" body:@{@"adUnitID": adUnitID, @"error":error}];
    
}

- (void)rewardedVideoAdDidFailToPlayForAdUnitID:(NSString *)adUnitID error:(NSError *)error
{
    [self sendEventWithName:@"onRewardedVideoPlaybackError" body:@{@"adUnitID": adUnitID, @"error":error}];
}

- (void)rewardedVideoAdWillAppearForAdUnitID:(NSString *)adUnitID {
     [self sendEventWithName:@"rewardedVideoAdWillAppearForAdUnitID" body:@{@"adUnitID": adUnitID}];
}

- (void)rewardedVideoAdDidAppearForAdUnitID:(NSString *)adUnitID {
     [self sendEventWithName:@"onRewardedVideoStarted"  body:@{@"adUnitID": adUnitID}];
}

- (void)rewardedVideoAdWillDisappearForAdUnitID:(NSString *)adUnitID {
     [self sendEventWithName:@"rewardedVideoAdWillDisappearForAdUnitID"  body:@{@"adUnitID": adUnitID}];
}

- (void)rewardedVideoAdDidDisappearForAdUnitID:(NSString *)adUnitID {
     [self sendEventWithName:@"onRewardedVideoClosed"  body:@{@"adUnitID": adUnitID}];
}

- (void)rewardedVideoAdShouldRewardForAdUnitID:(NSString *)adUnitID reward:(MPRewardedVideoReward *)reward {
     [self sendEventWithName:@"onRewardedVideoCompleted" body:nil];
}

- (void)rewardedVideoAdDidExpireForAdUnitID:(NSString *)adUnitID {
     [self sendEventWithName:@"rewardedVideoAdDidExpireForAdUnitID"  body:@{@"adUnitID": adUnitID}];
}

- (void)rewardedVideoAdDidReceiveTapEventForAdUnitID:(NSString *)adUnitID {
     [self sendEventWithName:@"onRewardedVideoClicked" body:@{@"adUnitID": adUnitID}];
}

- (void)rewardedVideoAdWillLeaveApplicationForAdUnitID:(NSString *)adUnitID {
     [self sendEventWithName:@"rewardedVideoAdWillLeaveApplicationForAdUnitID" body:@{@"adUnitID": adUnitID}];
}

- (void)didTrackImpressionWithAdUnitID:(NSString *)adUnitID impressionData:(MPImpressionData *)impressionData {
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


- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}


@end
