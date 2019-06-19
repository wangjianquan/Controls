//
//  Const.h
//  Controls
//
//  Created by wjq on 2019/6/18.
//  Copyright © 2019 WJQ. All rights reserved.
//

#ifndef Const_h
#define Const_h


#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;


#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define kScreenScale                [UIScreen mainScreen].scale
#define kScaleW                     (kScreenWidth)*(kScreenScale)
#define kScaleH                     (kScreenHeight)*(kScreenScale)
#define kScaleWidth     SCREEN_WIDTH / 375 // 宽度之比
#define kScaleHeight    SCREEN_HEIGHT / 667 // 高度之比

#define kStatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height

#define kNavigationBarHeight        self.navigationController.navigationBar.frame.size.height
#define kTabBarHeight self.tabBarController.tabBar.frame.size.height

#define is_iPhoneX   [UIApplication sharedApplication].statusBarFrame.size.height == 44 ? YES : NO


#define SafeAreaBottomHeight        ([UIApplication sharedApplication].statusBarFrame.size.height == 44 ? 34 : 0)
#define SafeAreaTopHeight           ([UIApplication sharedApplication].statusBarFrame.size.height == 44 ? 24 : 0)
#define keyboardToolBar_height 55

#endif /* Const_h */
