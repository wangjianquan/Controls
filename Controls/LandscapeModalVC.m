//
//  LandscapeModalVC.m
//  Controls
//
//  Created by 白小嘿M4Pro on 2025/7/26.
//  Copyright © 2025 WJQ. All rights reserved.
//

#import "LandscapeModalVC.h"
#import "UIViewController+WJQOrientation.h"
#import "OrientationManager.h"

@interface LandscapeModalVC ()

@property (nonatomic, assign) BOOL isPresented; // 标记是否为模态呈现

@end

@implementation LandscapeModalVC

- (void)closeVC {
    if (self.isPresented) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor brownColor];
    
    self.navigationItem.title = @"横屏模式";
    
    // 添加关闭按钮 - 确保图片正确渲染
    UIImage *backImage = [[UIImage imageNamed:@"ppt-back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 根据呈现方式决定关闭按钮位置
    if (self.isPresented || !self.navigationController) {
        // 模态呈现时，添加右上角关闭按钮
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(closeVC)];
    } else {
        // Push 方式时，添加左上角返回按钮
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backImage style:UIBarButtonItemStyleDone target:self action:@selector(closeVC)];
    }
    
    // 添加示例标签
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(48, 100, 200, 44);
    label.text = @"当前为横屏模式";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    label.layer.cornerRadius = 8;
    label.layer.masksToBounds = YES;
    [self.view addSubview:label];
    
    // 添加呈现方式提示
    UILabel *modeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 160, self.view.bounds.size.width-40, 30)];
    modeLabel.text = self.isPresented ? @"模态呈现 (presentViewController)" : @"导航栈呈现 (pushViewController)";
    modeLabel.textAlignment = NSTextAlignmentCenter;
    modeLabel.textColor = [UIColor darkGrayColor];
    [self.view addSubview:modeLabel];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 注册方向管理器
    [self wjq_registerOrientationManager];
    // 设置方向模式为横屏
    [self wjq_setOrientationMode:OrientationModeLandscape];
    // 强制横屏方向
    [self wjq_forceLandscapeOrientation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 注销方向管理器
    [self wjq_unregisterOrientationManager];
    // 如果是模态呈现，退出时恢复竖屏
    if (self.isPresented) {
        [self wjq_forcePortraitOrientation];
    }
}

- (void)dealloc {
    // 确保移除方向设置
    [[OrientationManager shared] removeOrientationSettingForController:self];
}

#pragma mark - 方向支持

- (BOOL)shouldAutorotate {
    return YES;  // 允许自动旋转
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    // 只支持横屏右方向
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    // 首选横屏右方向
    return UIInterfaceOrientationLandscapeRight;
}

#pragma mark - 初始化方法（支持两种呈现方式）

// 初始化方法（用于 push 方式）
- (instancetype)initForNavigation {
    self = [super init];
    if (self) {
        _isPresented = NO;
    }
    return self;
}

// 初始化方法（用于 present 方式）
- (instancetype)initForModalPresentation {
    self = [super init];
    if (self) {
        _isPresented = YES;
    }
    return self;
}

@end
