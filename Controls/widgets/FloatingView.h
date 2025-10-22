//
//  FloatingView.h
//  Controls
//
//  Created by WJQ on 2019/12/1.
//  Copyright © 2019 WJQ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FloatingView : UIView
+ (FloatingView *)sharedInstance;

@property (nonatomic, copy) void (^tapBlock)(UIButton *sender);
@property (nonatomic, copy) void (^closeBlock)(UIButton *sender);
@property (nonatomic, assign) BOOL isHidden;
- (void)show;
- (void)remove;
@end

NS_ASSUME_NONNULL_END
