//
//  PortraitViewController.m
//  Controls
//
//  Created by 白小嘿M4Pro on 2025/7/26.
//  Copyright © 2025 WJQ. All rights reserved.
//

#import "PortraitViewController.h"
#import "UIViewController+WJQOrientation.h"
#import "LandscapeModalVC.h"

@interface PortraitViewController ()

@end

@implementation PortraitViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 注册方向管理器
    [self wjq_registerOrientationManager];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 注销方向管理器
    [self wjq_unregisterOrientationManager];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"竖屏模式";
    // 设置背景色便于区分
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 添加按钮用于跳转横屏控制器
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 90, 200, 50);
    [button setTitle:@"打开横屏控制器" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(openLandscapeController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)openLandscapeController {
//    LandscapeModalVC *vc = [[LandscapeModalVC alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    
    [self presentLandscapeController];
}
- (void)presentLandscapeController {
    LandscapeModalVC *vc = [[LandscapeModalVC alloc] initForModalPresentation];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen; // 必须设置为全屏
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - 方向支持
- (BOOL)shouldAutorotate {
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end
