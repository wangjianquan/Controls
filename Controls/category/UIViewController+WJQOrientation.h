//
//  UIViewController+Orientation.h
//  Controls
//
//  Created by 白小嘿M4Pro on 2025/7/26.
//  Copyright © 2025 WJQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrientationManager.h"

NS_ASSUME_NONNULL_BEGIN

// 使用SDK前缀防止命名冲突
@interface UIViewController (WJQOrientation)

/// 设置当前控制器方向模式
- (void)wjq_setOrientationMode:(OrientationMode)mode;

/// 强制横屏
- (void)wjq_forceLandscapeOrientation;

/// 强制竖屏
- (void)wjq_forcePortraitOrientation;

/// 注册方向管理（在viewWillAppear中调用）
- (void)wjq_registerOrientationManager;

/// 注销方向管理（在viewWillDisappear中调用）
- (void)wjq_unregisterOrientationManager;

@end

NS_ASSUME_NONNULL_END
