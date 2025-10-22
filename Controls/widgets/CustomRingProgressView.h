//
//  CustomRingProgressView.h
//  Controls
//
//  Created by 白小嘿M4Pro on 2025/8/1.
//  Copyright © 2025 WJQ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, RingProgressAnimationCurve) {
    RingProgressAnimationCurveEaseInOut,
    RingProgressAnimationCurveEaseIn,
    RingProgressAnimationCurveEaseOut,
    RingProgressAnimationCurveLinear,
    RingProgressAnimationCurveBounce
};

@interface CustomRingProgressView : UIView

#pragma mark - 进度属性
@property (nonatomic, assign, readonly) CGFloat progress;
@property (nonatomic, assign) CGFloat startAngle; // 默认为 -M_PI_2
@property (nonatomic, assign) CGFloat endAngle;   // 默认为 3*M_PI_2

#pragma mark - 外观属性
@property (nonatomic, strong) UIColor *progressColor;
@property (nonatomic, strong) NSArray<UIColor *> *progressGradientColors;
@property (nonatomic, strong) UIColor *trackColor;
@property (nonatomic, strong) UIImage *trackImage;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) BOOL showsHeadDot;
@property (nonatomic, assign) CGFloat headDotRadius; // 默认为 lineWidth/2
@property (nonatomic, copy) NSArray<NSNumber *> *trackDashPattern;
@property (nonatomic, copy) NSArray<NSNumber *> *progressDashPattern;

#pragma mark - 文本属性
@property (nonatomic, copy) NSString *progressFormat; // 默认为 @"%.0f%%"
@property (nonatomic, assign) BOOL showsProgressLabel;

#pragma mark - 动画属性
@property (nonatomic, assign) RingProgressAnimationCurve defaultAnimationCurve;
@property (nonatomic, assign) CGFloat animationSpeed; // 加载动画速度，默认为0.1

#pragma mark - 进度设置方法
- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithCoder:(NSCoder *)coder;

// 修复点：移除基础setProgress:方法声明
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated completion:(void (^_Nullable)(BOOL))completion;
- (void)setProgress:(CGFloat)progress withAnimationDuration:(CFTimeInterval)duration;
- (void)setProgress:(CGFloat)progress
           animated:(BOOL)animated
           duration:(CFTimeInterval)duration
             curve:(RingProgressAnimationCurve)curve
         completion:(void (^_Nullable)(BOOL))completion;

#pragma mark - 加载动画方法
- (void)startAnimating;
- (void)stopAnimating;
- (void)stopAnimatingAndReset;

#pragma mark - 链式配置方法
- (CustomRingProgressView *)configLineWidth:(CGFloat)lineWidth;
- (CustomRingProgressView *)configProgressColor:(UIColor *)color;
- (CustomRingProgressView *)configTrackColor:(UIColor *)color;
- (CustomRingProgressView *)configShowsHeadDot:(BOOL)shows;
- (CustomRingProgressView *)configShowsProgressLabel:(BOOL)shows;
- (CustomRingProgressView *)configProgressGradientColors:(NSArray<UIColor *> *)colors;
- (CustomRingProgressView *)configHeadDotRadius:(CGFloat)radius;
- (CustomRingProgressView *)configAnimationCurve:(RingProgressAnimationCurve)curve;

@end

NS_ASSUME_NONNULL_END
