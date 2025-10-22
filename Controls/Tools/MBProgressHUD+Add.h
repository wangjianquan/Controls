//
//  MBProgressHUD+Add.h
//
//
//  Created by wjq on 16-6-18.
//  Copyright (c) 2016年 Apple. All rights reserved.
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


+ (void)showText:(NSString *)text textPositon:(HUDTextPosition)position;
+ (void)showText:(NSString *)text;

+ (MBProgressHUD *)showLoading:(NSString *)loadingText toView:(UIView *)view;
+ (void)hideHUDForView:(UIView *)view;

+ (MBProgressHUD *)showLoading:(NSString *)loadingText;
+ (void)hideHUD;


+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;







@end
