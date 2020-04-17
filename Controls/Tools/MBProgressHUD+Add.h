//
//  MBProgressHUD+Add.h
//  视频客户端
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD.h"

typedef NS_ENUM(NSInteger, HUDTextPosition) {
    /// top.
    HUDTextPositionTop,
    /// center
    HUDTextPositionCenter,
    /// bottom
    HUDTextPositionBottom,
};

@interface MBProgressHUD (Add)
+ (void)showError:(NSString *)error toView:(UIView *)view;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view;

+ (void)showText:(NSString *)text;
+ (void)showText:(NSString *)text textPositon:(HUDTextPosition)position;
@end
