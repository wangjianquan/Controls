//
//  AppDelegate.m
//  Controls
//
//  Created by landixing on 2018/8/1.
//  Copyright © 2018年 WJQ. All rights reserved.
//

#import "AppDelegate.h"
#import "OrientationManager.h"
#import "CustomTabBarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
 
- (void)appDidEnterBackground:(NSNotification *)notification {
    UIViewController *vc = [PreHelper getCurrentViewControll];
    NSLog(@"vc=%@", vc);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
//    NSUserDefaults *useDef = [NSUserDefaults standardUserDefaults];
//    if (![useDef boolForKey:@"firstStart"]) {
//        [useDef setBool:YES forKey:@"firstStart"];
//        // 第一次清空用户数据
//        [User clearAccount];
//        application.applicationIconBadgeNumber = 0;
//        // 如果是第一次进入引导页
//        self.window.rootViewController = [[GuideViewController alloc] init];
//    }else{
        // 否则直接进入应用
        self.window.rootViewController = [[CustomTabBarController alloc]init];
//    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [self.window makeKeyAndVisible];    
    return YES;
}
- (void)orientationDidChange:(NSNotification *)notification {
    // 处理方向变化逻辑
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    NSLog(@"设备方向已改变: %ld", (long)orientation);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // 应用进入后台
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // 应用将进入前台
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // 应用变为活跃状态
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // 应用即将终止
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application
  supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    
    // 获取当前活动控制器
    UIViewController *topController = [self topViewControllerForWindow:window];
    
    if (!topController) return UIInterfaceOrientationMaskAll;
    
    // 获取控制器的方向模式
    OrientationMode mode = [[OrientationManager shared] orientationModeForController:topController];
    
    switch (mode) {
        case OrientationModePortrait:
            return UIInterfaceOrientationMaskPortrait;
        case OrientationModeLandscape:
            return UIInterfaceOrientationMaskLandscapeRight;
        case OrientationModeAll:
        default:
            return UIInterfaceOrientationMaskAll;
    }
}

// 获取窗口的顶层控制器
- (UIViewController *)topViewControllerForWindow:(UIWindow *)window {
    UIViewController *rootVC = window.rootViewController;
    return [self topViewControllerFrom:rootVC];
}

- (UIViewController *)topViewControllerFrom:(UIViewController *)controller {
    if (controller == nil) return nil;
    
    if ([controller isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)controller;
        return [self topViewControllerFrom:nav.topViewController];
    }
    
    if ([controller isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tab = (UITabBarController *)controller;
        return [self topViewControllerFrom:tab.selectedViewController];
    }
    
    if (controller.presentedViewController) {
        return [self topViewControllerFrom:controller.presentedViewController];
    }
    
    return controller;
}

@end
