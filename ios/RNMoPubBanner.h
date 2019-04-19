//
//  RNMoPubBanner.h
//  DoubleConversion
//
//  Created by Usama Azam on 26/03/2019.
//

#import "RCTComponent.h"
#import "MPAdView.h"
NS_ASSUME_NONNULL_BEGIN
@class RCTEventDispatcher;

@interface RNMoPubBanner : MPAdView <MPAdViewDelegate>

@property (nonatomic, copy) RCTDirectEventBlock onLoaded;
@property (nonatomic, copy) RCTDirectEventBlock onFailed;
@property (nonatomic, copy) RCTDirectEventBlock onClicked;
@property (nonatomic, copy) RCTDirectEventBlock onExpanded;
@property (nonatomic, copy) RCTDirectEventBlock onCollapsed;

@end

NS_ASSUME_NONNULL_END
