//
//  UIViewController+WJQOrientation.m
//  Controls
//
//  Created by 白小嘿M4Pro on 2025/7/26.
//  Copyright © 2025 WJQ. All rights reserved.
//

#import "UIViewController+WJQOrientation.h"
#import "OrientationManager.h"

// 私有API声明
@interface OrientationManager (PrivateAPI)
- (void)handleControllerWillAppear:(UIViewController *)controller;
- (void)handleControllerWillDisappear:(UIViewController *)controller;
@end

@implementation UIViewController (WJQOrientation)

- (void)wjq_setOrientationMode:(OrientationMode)mode {
    [[OrientationManager shared] setOrientationMode:mode forController:self];
}

- (void)wjq_forceLandscapeOrientation {
    [[OrientationManager shared] forceOrientation:UIInterfaceOrientationLandscapeRight];
}

- (void)wjq_forcePortraitOrientation {
    [[OrientationManager shared] forceOrientation:UIInterfaceOrientationPortrait];
}

- (void)wjq_registerOrientationManager {
    [[OrientationManager shared] handleControllerWillAppear:self];
}

- (void)wjq_unregisterOrientationManager {
    [[OrientationManager shared] handleControllerWillDisappear:self];
}

@end
