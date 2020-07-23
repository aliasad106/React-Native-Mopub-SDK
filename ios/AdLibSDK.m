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

+ (void)initializeAdSDK:(NSString *)unitID {    
    MPMoPubConfiguration *sdkConfig = [[MPMoPubConfiguration alloc] initWithAdUnitIdForAppInitialization: unitID];
    sdkConfig.loggingLevel = MPBLogLevelDebug;
    [[MoPub sharedInstance] initializeSdkWithConfiguration:sdkConfig completion:^{
        NSLog(@"SDK initialization complete");
    }];
}

@end
