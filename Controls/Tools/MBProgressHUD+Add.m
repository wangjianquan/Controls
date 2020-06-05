//
//  MBProgressHUD+Add.h
//
//
//  Created by wjq on 16-6-18.
//  Copyright (c) 2016年 Apple. All rights reserved.
//

#import "MBProgressHUD+Add.h"

@implementation MBProgressHUD (Add)

#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    //设置模式
    hud.mode = MBProgressHUDModeCustomView;
    hud.label.text = text;

    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    // 设置图片
    hud.customView = imageView;
    hud.square = YES;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // 1.5秒之后再消失
    [hud hideAnimated:YES afterDelay:1.5];
}

+ (void)showText:(NSString *)text textPositon:(HUDTextPosition)position{
    UIView * view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(text, @"HUD message title");
    
    hud.label.textColor = [UIColor whiteColor];
    hud.bezelView.blurEffectStyle = UIBlurEffectStyleDark;
    
    // Move to bottm center.
    CGFloat screenHeight =  [UIScreen mainScreen].bounds.size.height;
    if (position == HUDTextPositionTop) {
        hud.offset = CGPointMake(0.f, -(screenHeight/3));
    } else if (position == HUDTextPositionBottom){
        hud.offset = CGPointMake(0.f, screenHeight/3);
    }else{
        hud.offset = CGPointMake(0.f, 0.f);
    }
    [hud hideAnimated:YES afterDelay:1.5f];
}

+ (void)showText:(NSString *)text{
    UIView * view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(text, @"HUD message title");
    hud.label.numberOfLines = 0;
    hud.label.textColor = [UIColor whiteColor];
    hud.bezelView.blurEffectStyle = UIBlurEffectStyleDark;
    [hud hideAnimated:YES afterDelay:1.5f];
}

#pragma mark 显示loading信息
+ (MBProgressHUD *)showLoading:(NSString *)loadingText toView:(UIView *)view{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = loadingText;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.3f];
    return hud;
}

+ (MBProgressHUD *)showLoading:(NSString *)loadingText{
    return [self showLoading:loadingText toView:nil];
}

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"error.png" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success.png" view:view];
}


+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}


+ (void)hideHUDForView:(UIView *)view{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD{
    [self hideHUDForView:nil];
}

@end
