//
//  UINavigationController+Orientation.m
//  Controls
//
//  Created by 白小嘿M4Pro on 2025/7/26.
//  Copyright © 2025 WJQ. All rights reserved.
//

#import "UINavigationController+WJQOrientation.h"
#import "OrientationManager.h"
#import <objc/runtime.h>

@implementation UINavigationController (WJQOrientation)

// 使用动态方法解析避免覆盖接入方的方法
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self wjq_swizzleOrientationMethods];
    });
}

+ (void)wjq_swizzleOrientationMethods {
    Class class = [self class];
    
    // 方法交换：shouldAutorotate
    SEL originalShouldAutorotate = @selector(shouldAutorotate);
    SEL swizzledShouldAutorotate = @selector(wjq_shouldAutorotate);
    [self wjq_swizzleMethod:class original:originalShouldAutorotate swizzled:swizzledShouldAutorotate];
    
    // 方法交换：supportedInterfaceOrientations
    SEL originalSupported = @selector(supportedInterfaceOrientations);
    SEL swizzledSupported = @selector(wjq_supportedInterfaceOrientations);
    [self wjq_swizzleMethod:class original:originalSupported swizzled:swizzledSupported];
    
    // 方法交换：preferredInterfaceOrientationForPresentation
    SEL originalPreferred = @selector(preferredInterfaceOrientationForPresentation);
    SEL swizzledPreferred = @selector(wjq_preferredInterfaceOrientationForPresentation);
    [self wjq_swizzleMethod:class original:originalPreferred swizzled:swizzledPreferred];
}

+ (void)wjq_swizzleMethod:(Class)class original:(SEL)originalSelector swizzled:(SEL)swizzledSelector {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    // 尝试添加原始方法（如果不存在）
    BOOL didAddMethod = class_addMethod(class,
                                       originalSelector,
                                       method_getImplementation(swizzledMethod),
                                       method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        // 添加成功：替换新方法实现
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        // 方法已存在：直接交换
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (BOOL)wjq_shouldAutorotate {
    // 先调用原始实现（可能是接入方的方法）
    BOOL originalResult = [self wjq_shouldAutorotate];
    
    // 然后添加我们的逻辑
    if (self.topViewController) {
        return [self.topViewController shouldAutorotate] && originalResult;
    }
    
    return originalResult;
}

- (UIInterfaceOrientationMask)wjq_supportedInterfaceOrientations {
    // 先调用原始实现（可能是接入方的方法）
    UIInterfaceOrientationMask originalMask = [self wjq_supportedInterfaceOrientations];
    
    // 然后添加我们的逻辑
    if (self.topViewController) {
        UIInterfaceOrientationMask topControllerMask = [self.topViewController supportedInterfaceOrientations];
        return topControllerMask & originalMask; // 取交集
    }
    
    // 使用全局设置
    OrientationMode globalMode = [[OrientationManager shared] currentOrientationMode];
    UIInterfaceOrientationMask defaultMask = (globalMode == OrientationModeLandscape) ?
        UIInterfaceOrientationMaskLandscapeRight : UIInterfaceOrientationMaskPortrait;
    
    return defaultMask & originalMask; // 取交集
}

- (UIInterfaceOrientation)wjq_preferredInterfaceOrientationForPresentation {
    // 先调用原始实现（可能是接入方的方法）
    UIInterfaceOrientation originalOrientation = [self wjq_preferredInterfaceOrientationForPresentation];
    
    // 然后添加我们的逻辑
    if (self.topViewController && [self.topViewController respondsToSelector:@selector(preferredInterfaceOrientationForPresentation)]) {
        return [self.topViewController preferredInterfaceOrientationForPresentation];
    }
    
    // 使用全局设置
    OrientationMode globalMode = [[OrientationManager shared] currentOrientationMode];
    return (globalMode == OrientationModeLandscape) ?
        UIInterfaceOrientationLandscapeRight : UIInterfaceOrientationPortrait;
}

@end
