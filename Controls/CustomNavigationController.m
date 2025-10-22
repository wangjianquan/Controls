//
//  CustomNavigationController.m
//  ZhongSheGou
//
//  Created by landixing on 2016/12/12.
//  Copyright © 2016年 landixing. All rights reserved.
//

#import "CustomNavigationController.h"

@interface CustomNavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

/** 系统手势代理 */
@property (nonatomic, strong) id popGesture;

@end

@implementation CustomNavigationController

#pragma mark - 初始化配置
+ (void)initialize {
    if (self == [CustomNavigationController class]) {
        [self setupNavigationBarAppearance];
    }
}

+ (void)setupNavigationBarAppearance {
    // 1. 统一导航栏样式
    UIColor *barTintColor = [UIColor whiteColor];
    UIColor *titleColor = [UIColor blackColor];
    UIFont *titleFont = [UIFont systemFontOfSize:17];
    // 2. 适配 iOS 13+ 的 Appearance API
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        [appearance configureWithOpaqueBackground];
        appearance.backgroundColor = barTintColor;
        appearance.titleTextAttributes = @{
            NSForegroundColorAttributeName: titleColor,
            NSFontAttributeName: titleFont
        };
        appearance.shadowColor = [UIColor clearColor];// 移除底部阴影线
        UINavigationBar *barAppearance = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[self]];
        barAppearance.standardAppearance = appearance;
        barAppearance.scrollEdgeAppearance = appearance;
//        [barAppearance setTranslucent:NO];
    } else {// iOS 12 及以下
        UINavigationBar *barAppearance = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[self]];
        barAppearance.barTintColor = barTintColor;
        barAppearance.titleTextAttributes = @{
            NSForegroundColorAttributeName: titleColor,
            NSFontAttributeName: titleFont
        };
//        [barAppearance setTranslucent:NO];
        [barAppearance setShadowImage:[UIImage new]]; // 移除导航栏阴影线
    }
}
#pragma mark - 全屏返回手势
- (void)viewDidLoad {
    [super viewDidLoad];
    self.interactivePopGestureRecognizer.enabled = NO; // 禁用系统手势
    // 优化：创建全屏返回手势的更安全方式
    if ([self.interactivePopGestureRecognizer.delegate respondsToSelector:@selector(handleNavigationTransition:)]) {
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.interactivePopGestureRecognizer.delegate action:@selector(handleNavigationTransition:)];
        panGesture.delegate = self;
        [self.view addGestureRecognizer:panGesture];
    }
}


// 仅向左滑动（x 方向位移为正）且非根控制器时允许手势开始
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.viewControllers.count <= 1) return NO;
    
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint translation = [pan translationInView:pan.view];
        return translation.x > 0; // 仅向左滑动有效
    }
    return YES;
}

// 允许与滚动控件手势同时识别
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return [otherGestureRecognizer.view isKindOfClass:[UIScrollView class]];
}

#pragma mark - 控制器跳转逻辑
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 非根控制器隐藏 TabBar
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        [self setupBackButtonForViewController:viewController];
    }
    [super pushViewController:viewController animated:animated];
}

- (void)setupBackButtonForViewController:(UIViewController *)vc {
    // 仅在子控制器未设置 leftBarButtonItem 时才应用默认样式
    if (vc.navigationItem.leftBarButtonItem) return;
    
    // 自定义返回按钮，添加容错处理
    UIImage *backImage = [UIImage imageNamed:@"black_back"];
    // 图片不存在时使用系统默认图片兜底
    if (!backImage) {
        if (@available(iOS 13.0, *)) {
            backImage = [UIImage systemImageNamed:@"chevron.left"];
        } else {
            backImage = [[UIImage imageNamed:@""] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
    } else {
        backImage = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backImage style:UIBarButtonItemStylePlain target:self action:@selector(back)];
}

- (void)back {
    [self popViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotate{
    return self.topViewController.shouldAutorotate;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return self.topViewController.supportedInterfaceOrientations;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.topViewController ? self.topViewController.preferredInterfaceOrientationForPresentation : UIInterfaceOrientationPortrait;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    UIViewController *topVC = self.topViewController;
    return [topVC preferredStatusBarStyle];
}

@end
