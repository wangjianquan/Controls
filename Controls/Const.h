//
//  Const.h
//  Controls
//
//  Created by wjq on 2019/6/18.
//  Copyright © 2019 WJQ. All rights reserved.
//

#ifndef Const_h
#define Const_h

#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define wj_weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define wj_weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define wj_weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define wj_weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define wj_strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define wj_strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define wj_strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define wj_strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;


#define SCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT   ([UIScreen mainScreen].bounds.size.height)

#define kScreenScale                [UIScreen mainScreen].scale
#define kScaleW                     (kScreenWidth)*(kScreenScale)
#define kScaleH                     (kScreenHeight)*(kScreenScale)
#define kScaleWidth     SCREEN_WIDTH / 375 // 宽度之比
#define kScaleHeight    SCREEN_HEIGHT / 667 // 高度之比

// 判断是否为刘海屏设备
#define kIsBangsScreen ({\
    BOOL isBangsScreen = NO;\
    if (@available(iOS 11.0, *)) {\
        UIWindow *window = [UIApplication sharedApplication].keyWindow;\
        if (!window) {\
            window = [UIApplication sharedApplication].windows.firstObject;\
        }\
        isBangsScreen = window.safeAreaInsets.bottom > 0.0;\
    }\
    (isBangsScreen);\
})
// 获取状态栏高度
#define kStatusBarHeight ({\
    CGFloat statusBarHeight = 0;\
    if (@available(iOS 13.0, *)) {\
        UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].keyWindow.windowScene.statusBarManager;\
        statusBarHeight = statusBarManager.statusBarFrame.size.height;\
    } else {\
        statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;\
    }\
    (statusBarHeight);\
})
// 获取底部安全区域高度
#define SafeAreaBottomHeight ({\
    CGFloat safeAreaHeight = 0;\
    if (@available(iOS 11.0, *)) {\
        UIWindow *window = [UIApplication sharedApplication].keyWindow;\
        if (!window) {\
            window = [UIApplication sharedApplication].windows.firstObject;\
        }\
        safeAreaHeight = window.safeAreaInsets.bottom;\
    }\
    (safeAreaHeight);\
})
// 获取顶部安全区域高度
#define kSafeAreaTopHeight ({\
    CGFloat safeAreaHeight = 0;\
    if (@available(iOS 11.0, *)) {\
        UIWindow *window = [UIApplication sharedApplication].keyWindow;\
        if (!window) {\
            window = [UIApplication sharedApplication].windows.firstObject;\
        }\
        safeAreaHeight = window.safeAreaInsets.top;\
    }\
    (safeAreaHeight);\
})

// 导航栏总高度（状态栏高度 + 44）
#define kNavigationBarHeight (kStatusBarHeight + 44.0f)
// TabBar总高度（49 + 底部安全区域高度）
#define kTabBarHeight (49.0f + SafeAreaBottomHeight)

#define keyboardToolBar_height 55

#endif /* Const_h */
