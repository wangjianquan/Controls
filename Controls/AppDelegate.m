//
//  AppDelegate.m
//  Controls
//
//  Created by landixing on 2018/8/1.
//  Copyright © 2018年 WJQ. All rights reserved.
//

#import "AppDelegate.h"
#import "SELUpdateAlert.h"

@interface AppDelegate ()

//网络监听
@property (nonatomic, strong) AliyunReachability *reachability;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //判断网络
    _reachability = [AliyunReachability reachabilityForInternetConnection];
    [_reachability startNotifier];
    switch ([self.reachability currentReachabilityStatus]) {
        case AliyunPVNetworkStatusNotReachable://由播放器底层判断是否有网络
        {
            [MBProgressHUD showError:@"当前网络环境为: 不可用" toView:self.window];
        }
            break;
        case AliyunPVNetworkStatusReachableViaWiFi:
        {
            [MBProgressHUD showSuccess:@"当前网络环境为: WiFi" toView:self.window];
        }
            break;
        case AliyunPVNetworkStatusReachableViaWWAN:
        {
            [MBProgressHUD showSuccess:@"当前网络环境为: 数据流量" toView:self.window];
        }
            break;
        default:
            break;
    }
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(reachabilityChanged)
//                                                 name:AliyunPVReachabilityChangedNotification
//                                               object:nil];
    // Override point for customization after application launch.
    return YES;
}
#pragma mark - 网络状态改变
- (void)reachabilityChanged {
    [self networkChangedToShowPopView];
}

//网络状态判定
- (BOOL)networkChangedToShowPopView {
    BOOL ret = NO;
    switch ([self.reachability currentReachabilityStatus]) {
        case AliyunPVNetworkStatusNotReachable://由播放器底层判断是否有网络
        {
            [MBProgressHUD showText:@"当前网络环境为: 不可用"];
        }
            break;
        case AliyunPVNetworkStatusReachableViaWiFi:
        {
            [MBProgressHUD showText:@"当前网络环境为: WiFi"];
        }
            break;
        case AliyunPVNetworkStatusReachableViaWWAN:
        {
            [MBProgressHUD showText:@"当前网络环境为: 数据流量"];
        }
            break;
        default:
            break;
    }
    return ret;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
