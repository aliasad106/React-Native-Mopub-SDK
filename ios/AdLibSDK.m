//
//  AdLibSDK.m
//  DoubleConversion
//
//  Created by Usama Azam on 29/03/2019.
//

#import "AdLibSDK.h"
#import "MoPub.h"
#import "MPMoPubConfiguration.h"

@implementation AdLibSDK

RCT_EXPORT_MODULE();

- (NSArray<NSString *> *)supportedEvents {
    return @[
             @"onSDKInitialized",
            ];
}


RCT_EXPORT_METHOD(initializeSDK:(NSString *)unitID onComplete:(RCTResponseSenderBlock)onComplete) 
{
    MPMoPubConfiguration *sdkConfig = [[MPMoPubConfiguration alloc] initWithAdUnitIdForAppInitialization: unitID];
    sdkConfig.loggingLevel = MPBLogLevelDebug;
    [[MoPub sharedInstance] initializeSdkWithConfiguration:sdkConfig completion:^{
        NSLog(@"SDK initialization complete");
        [self sendEventWithName:@"onSDKInitialized" body:nil];
    }];
}

@end
