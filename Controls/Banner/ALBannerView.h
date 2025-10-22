//
//  ALBannerView.h
//  AssistedLearning
//
//  Created by wjq on 2019/11/5.
//  Copyright © 2019 wjq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALBannerModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ALBannerView : UIView

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) BOOL loadBanner;

@property (nonatomic, copy) void (^bannerSelectBlock)(ALBannerModel *banner);
- (void)freeSpeedTimer;

@end

NS_ASSUME_NONNULL_END
