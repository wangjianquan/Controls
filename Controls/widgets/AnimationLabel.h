//
//  AnimationLabel.h
//  Controls
//
//  Created by jieyue on 2019/8/26.
//  Copyright © 2019 WJQ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AnimationLabel : UIView

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) CGFloat speed;//0.1-0.5 默认0.3

- (void)startAnimation;

- (void)stopAnimation;

@end

NS_ASSUME_NONNULL_END
