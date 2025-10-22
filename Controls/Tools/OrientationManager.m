//
//  OrientationManager.m
//  OpmSDK
//
//  Created by 白小嘿M4Pro on 2025/7/26.
//

#import "OrientationManager.h"
#import <objc/runtime.h>

@interface OrientationManager ()
@property (nonatomic, strong) NSMapTable<UIViewController *, NSNumber *> *orientationSettings;
@property (nonatomic, weak) UIViewController *activeController;
@end

@implementation OrientationManager

+ (instancetype)shared {
    static OrientationManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[OrientationManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _orientationSettings = [NSMapTable weakToStrongObjectsMapTable];
    }
    return self;
}

#pragma mark - 控制器生命周期处理

// 由外部控制器手动调用（在viewWillAppear中）
- (void)handleControllerWillAppear:(UIViewController *)controller {
    if (!controller) return;
    self.activeController = controller;
    [self applyOrientationForController:controller];
}

// 由外部控制器手动调用（在viewWillDisappear中）
- (void)handleControllerWillDisappear:(UIViewController *)controller {
    if (!controller || self.activeController != controller) return;
    
    // 查找上一个控制器应用其方向设置
    UIViewController *previousController = [self findPreviousControllerFor:controller];
    if (previousController) {
        [self applyOrientationForController:previousController];
    } else {
        // 默认恢复竖屏
        [self forceOrientation:UIInterfaceOrientationPortrait];
    }
}

- (UIViewController *)findPreviousControllerFor:(UIViewController *)currentController {
    if ([currentController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)currentController;
        if (nav.viewControllers.count > 1) {
            return nav.viewControllers[nav.viewControllers.count - 2];
        }
    }
    
    if (currentController.presentingViewController) {
        return currentController.presentingViewController;
    }
    
    return nil;
}

#pragma mark - 方向控制

- (void)setOrientationMode:(OrientationMode)mode forController:(UIViewController *)controller {
    if (!controller) return;
    
    [self.orientationSettings setObject:@(mode) forKey:controller];
    
    // 如果是当前活动控制器，立即应用
    if (self.activeController == controller) {
        [self applyOrientationForController:controller];
    }
}

- (void)removeOrientationSettingForController:(UIViewController *)controller {
    if (!controller) return;
    
    [self.orientationSettings removeObjectForKey:controller];
}

- (void)applyOrientationForController:(UIViewController *)controller {
    OrientationMode mode = [self orientationModeForController:controller];
    
    switch (mode) {
        case OrientationModePortrait:
            [self forceOrientation:UIInterfaceOrientationPortrait];
            break;
        case OrientationModeLandscape:
            [self forceOrientation:UIInterfaceOrientationLandscapeRight];
            break;
        case OrientationModeAll:
            // 不强制方向，使用系统默认
            break;
    }
}

- (OrientationMode)orientationModeForController:(UIViewController *)controller {
    NSNumber *modeNumber = [self.orientationSettings objectForKey:controller];
    if (modeNumber) {
        return [modeNumber integerValue];
    }
    return OrientationModePortrait; // 默认竖屏
}
#pragma mark - 强制旋转核心实现
- (void)forceOrientation:(UIInterfaceOrientation)orientation {
    // 1. 通知控制器更新方向支持
    [self notifyControllersToUpdateOrientation];
    
    // 2. iOS 16+ 使用新API
    if (@available(iOS 16.0, *)) {
        __block UIWindowScene *targetScene = nil;
        NSArray<UIScene *> *scenes = [UIApplication sharedApplication].connectedScenes.allObjects;
        
        // 查找激活状态的应用场景
        [scenes enumerateObjectsUsingBlock:^(UIScene *scene, NSUInteger idx, BOOL *stop) {
            if ([scene isKindOfClass:[UIWindowScene class]] &&
                scene.activationState == UISceneActivationStateForegroundActive &&
                [scene.session.role isEqualToString:UIWindowSceneSessionRoleApplication]) {
                targetScene = (UIWindowScene *)scene;
                *stop = YES;
            }
        }];
        
        if (!targetScene) {
            NSLog(@"⚠️ 未找到有效的UIWindowScene");
            [self fallbackForceOrientation:orientation];
            return;
        }
        
        UIInterfaceOrientationMask mask = (orientation == UIInterfaceOrientationLandscapeRight)
            ? UIInterfaceOrientationMaskLandscapeRight
            : UIInterfaceOrientationMaskPortrait;
        
        UIWindowSceneGeometryPreferencesIOS *preferences =
            [[UIWindowSceneGeometryPreferencesIOS alloc] initWithInterfaceOrientations:mask];
        
        __weak typeof(self) weakSelf = self;
        [targetScene requestGeometryUpdateWithPreferences:preferences
                                          errorHandler:^(NSError *error) {
            if (error) {
                NSLog(@"❌ 场景旋转失败: %@", error);
                [weakSelf fallbackForceOrientation:orientation];
            }
        }];
    }
    // 3. iOS 16以下使用兼容方法
    else {
        [self fallbackForceOrientation:orientation];
    }
    
    // 4. 强制刷新旋转状态
    [UIViewController attemptRotationToDeviceOrientation];
}
// 通知所有相关控制器更新方向
- (void)notifyControllersToUpdateOrientation {
    // 通知活动控制器
    if ([self.activeController respondsToSelector:@selector(setNeedsUpdateOfSupportedInterfaceOrientations)]) {
        [self.activeController setNeedsUpdateOfSupportedInterfaceOrientations];
    }
    
    // 通知导航控制器
    if ([self.activeController.navigationController
         respondsToSelector:@selector(setNeedsUpdateOfSupportedInterfaceOrientations)]) {
        [self.activeController.navigationController setNeedsUpdateOfSupportedInterfaceOrientations];
    }
    
    // 通知根控制器
    UIViewController *rootVC = UIApplication.sharedApplication.windows.firstObject.rootViewController;
    if ([rootVC respondsToSelector:@selector(setNeedsUpdateOfSupportedInterfaceOrientations)]) {
        [rootVC setNeedsUpdateOfSupportedInterfaceOrientations];
    }
}
// 兼容旧版本的方法
- (void)fallbackForceOrientation:(UIInterfaceOrientation)orientation {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                    [UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}
#pragma mark - 状态查询
+ (BOOL)isLandscape {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    return UIInterfaceOrientationIsLandscape(orientation);
}

- (OrientationMode)currentOrientationMode {
    return [OrientationManager isLandscape] ? OrientationModeLandscape : OrientationModePortrait;
}

@end
