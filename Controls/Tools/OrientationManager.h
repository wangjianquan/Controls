//
//  OrientationManager.h
//  OpmSDK
//
//  Created by 白小嘿M4Pro on 2025/7/26.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, OrientationMode) {
    OrientationModePortrait,
    OrientationModeLandscape,
    OrientationModeAll
};

@interface OrientationManager : NSObject

/// 单例实例
+ (instancetype)shared;

/// 强制设备方向
/// @param orientation 目标方向
- (void)forceOrientation:(UIInterfaceOrientation)orientation;

/// 设置当前控制器方向模式
/// @param controller 目标控制器
/// @param mode 方向模式
- (void)setOrientationMode:(OrientationMode)mode forController:(UIViewController *)controller;

/// 移除控制器的方向设置
/// @param controller 目标控制器
- (void)removeOrientationSettingForController:(UIViewController *)controller;

/// 获取当前方向模式
- (OrientationMode)currentOrientationMode;

/// 设备是否处于横屏状态
+ (BOOL)isLandscape;

/// 获取指定控制器的方向模式
- (OrientationMode)orientationModeForController:(UIViewController *)controller;

- (void)notifyControllersToUpdateOrientation;

@end

NS_ASSUME_NONNULL_END
