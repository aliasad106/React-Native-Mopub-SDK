//
//  AdLibSDK.m
//  DoubleConversion
//
//  Created by Usama Azam on 29/03/2019.
//

#import "AdLibSDK.h"
#import "AdColonyGlobalMediationSettings.h"
#import "MPGoogleGlobalMediationSettings.h"
#import "TapjoyGlobalMediationSettings.h"
#import "VungleInstanceMediationSettings.h"

@implementation AdLibSDK

+ (void)initializeAdSDK:(NSString *)unitID {
    AdColonyGlobalMediationSettings *adColonyMediationSettings = [[AdColonyGlobalMediationSettings alloc] init];
    MPGoogleGlobalMediationSettings *mpGoogleMediationSettings = [[MPGoogleGlobalMediationSettings alloc] init];
    TapjoyGlobalMediationSettings *tapJoyMediationSettings = [[TapjoyGlobalMediationSettings alloc] init];
    VungleInstanceMediationSettings *vungleMediationSettings = [[VungleInstanceMediationSettings alloc] init];
    
    MPMoPubConfiguration *sdkConfig = [[MPMoPubConfiguration alloc] initWithAdUnitIdForAppInitialization: unitID];
    sdkConfig.loggingLevel = MPBLogLevelDebug;
    sdkConfig.globalMediationSettings = [[NSArray alloc] initWithObjects: @[adColonyMediationSettings, mpGoogleMediationSettings, tapJoyMediationSettings, vungleMediationSettings], nil];
    [[MoPub sharedInstance] initializeSdkWithConfiguration:sdkConfig completion:^{
        NSLog(@"SDK initialization complete");
    }];
}

@end
