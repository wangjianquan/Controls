//
//  CustomRingProgressView.m
//  Controls
//
//  Created by 白小嘿M4Pro on 2025/8/1.
//  Copyright © 2025 WJQ. All rights reserved.
//

#import "CustomRingProgressView.h"
#import <objc/runtime.h>

@interface CustomRingProgressView () <CAAnimationDelegate>

// 核心图层
@property (nonatomic, strong) CALayer *trackLayer;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) CALayer *headDotLayer;

// 文本标签
@property (nonatomic, strong) UILabel *progressLabel;

// 动画系统
@property (nonatomic, strong) CAShapeLayer *headAnimationLayer;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) CGFloat rotationAngle;
@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, assign) CGFloat animationStartProgress;

// 布局缓存
@property (nonatomic, assign) CGPoint ringCenter;
@property (nonatomic, assign) CGFloat ringRadius;
@property (nonatomic, strong) UIBezierPath *cachedRingPath;
@property (nonatomic, assign) CGSize lastBoundsSize;

// 性能管理
@property (nonatomic, assign) BOOL isLowPerformanceDevice;

@end

@implementation CustomRingProgressView

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    // 默认配置
    _progress = 0.0;
    _lineWidth = 5.0;
    _startAngle = -M_PI_2;
    _endAngle = 3 * M_PI_2;
    _progressColor = [UIColor systemBlueColor];
    _trackColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    _showsHeadDot = YES;
    _headDotRadius = _lineWidth / 2.0;
    _showsProgressLabel = NO;
    _progressFormat = @"%.0f%%";
    _defaultAnimationCurve = RingProgressAnimationCurveEaseInOut;
    _animationSpeed = 0.1;
    
    // 视图配置
    self.backgroundColor = [UIColor clearColor];
    self.contentMode = UIViewContentModeRedraw;
    self.clipsToBounds = NO;
    
    // 初始化图层
    [self setupLayers];
    
    // 设备性能检测
    [self detectDevicePerformance];
    
    // 注册通知
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(applicationDidEnterBackground)
                                               name:UIApplicationDidEnterBackgroundNotification
                                             object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(applicationWillEnterForeground)
                                               name:UIApplicationWillEnterForegroundNotification
                                             object:nil];
}

- (void)dealloc {
    [self.displayLink invalidate];
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

#pragma mark - 设备检测
- (void)detectDevicePerformance {
    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
    self.isLowPerformanceDevice = (screenWidth < 375) ||
                                 (UIScreen.mainScreen.scale < 3.0);
}

#pragma mark - 图层初始化
- (void)setupLayers {
    // 背景轨道
    _trackLayer = [CALayer layer];
    [self.layer addSublayer:_trackLayer];
    
    // 进度条
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.fillColor = UIColor.clearColor.CGColor;
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.strokeEnd = _progress;
    [self.layer addSublayer:_progressLayer];
    
    // 渐变色层
    _gradientLayer = [CAGradientLayer layer];
    _gradientLayer.startPoint = CGPointMake(0.5, 0);
    _gradientLayer.endPoint = CGPointMake(0.5, 1);
    [self.layer addSublayer:_gradientLayer];
    _gradientLayer.mask = _progressLayer;
    
    // 头部圆点
    _headDotLayer = [CALayer layer];
    _headDotLayer.hidden = !_showsHeadDot;
    [self.layer addSublayer:_headDotLayer];
    
    // 动画图层
    _headAnimationLayer = [CAShapeLayer layer];
    _headAnimationLayer.fillColor = UIColor.clearColor.CGColor;
    _headAnimationLayer.lineCap = kCALineCapRound;
    _headAnimationLayer.strokeStart = 0.95;
    _headAnimationLayer.strokeEnd = 1.0;
    _headAnimationLayer.hidden = YES;
    [self.layer addSublayer:_headAnimationLayer];
    
    // 进度标签
    _progressLabel = [[UILabel alloc] init];
    _progressLabel.textAlignment = NSTextAlignmentCenter;
    _progressLabel.hidden = !_showsProgressLabel;
    [self addSubview:_progressLabel];
    
    // 更新外观
    [self updateAppearance];
}

#pragma mark - 布局系统
- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 尺寸未变化时跳过布局
    if (CGSizeEqualToSize(self.bounds.size, self.lastBoundsSize)) return;
    
    self.lastBoundsSize = self.bounds.size;
    
    // 计算布局参数
    _ringCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGFloat diameter = MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    _ringRadius = diameter / 2 - _lineWidth / 2;
    _ringRadius = MAX(_ringRadius, 1.0);
    
    // 更新轨道
    [self updateTrackLayer];
    
    // 缓存环形路径
    self.cachedRingPath = [UIBezierPath bezierPathWithArcCenter:_ringCenter
                                                         radius:_ringRadius
                                                     startAngle:_startAngle
                                                       endAngle:_endAngle
                                                      clockwise:YES];
    
    // 更新图层
    _progressLayer.path = _cachedRingPath.CGPath;
    _progressLayer.lineWidth = _lineWidth;
    _headAnimationLayer.path = _cachedRingPath.CGPath;
    _headAnimationLayer.lineWidth = _lineWidth;
    
    // 设置图层frame
    CGRect layerFrame = self.bounds;
    _trackLayer.frame = layerFrame;
    _progressLayer.frame = layerFrame;
    _gradientLayer.frame = layerFrame;
    _headAnimationLayer.frame = layerFrame;
    
    // 更新圆点位置
    [self updateHeadDotPosition];
    
    // 更新进度标签
    _progressLabel.frame = self.bounds;
    _progressLabel.font = [UIFont systemFontOfSize:_ringRadius * 0.4];
    [self updateProgressLabel];
}

- (void)updateTrackLayer {
    if (_trackImage) {
        _trackLayer.contents = (id)_trackImage.CGImage;
    } else {
        // 创建轨道背景
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
        
        [_trackColor setStroke];
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:_ringCenter
                                                           radius:_ringRadius
                                                       startAngle:_startAngle
                                                         endAngle:_endAngle
                                                        clockwise:YES];
        path.lineWidth = _lineWidth;
        path.lineCapStyle = kCGLineCapRound;
        
        // 应用虚线样式
        if (_trackDashPattern.count > 0) {
            CGFloat pattern[_trackDashPattern.count];
            for (int i = 0; i < _trackDashPattern.count; i++) {
                pattern[i] = [_trackDashPattern[i] floatValue];
            }
            [path setLineDash:pattern count:_trackDashPattern.count phase:0];
        }
        
        [path stroke];
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        _trackLayer.contents = (id)image.CGImage;
    }
}

#pragma mark - 外观更新
- (void)updateAppearance {
    // 更新进度条颜色
    if (_progressGradientColors.count > 0) {
        NSMutableArray *cgColors = [NSMutableArray array];
        for (UIColor *color in _progressGradientColors) {
            [cgColors addObject:(id)color.CGColor];
        }
        _gradientLayer.colors = cgColors;
        _gradientLayer.hidden = NO;
        _progressLayer.strokeColor = UIColor.clearColor.CGColor;
    } else {
        _gradientLayer.hidden = YES;
        _progressLayer.strokeColor = _progressColor.CGColor;
    }
    
    // 更新虚线样式
    if (_progressDashPattern.count > 0) {
        NSMutableArray *dashPattern = [NSMutableArray array];
        for (NSNumber *num in _progressDashPattern) {
            [dashPattern addObject:@(num.floatValue * _lineWidth)];
        }
        _progressLayer.lineDashPattern = dashPattern;
        _headAnimationLayer.lineDashPattern = dashPattern;
    } else {
        _progressLayer.lineDashPattern = nil;
        _headAnimationLayer.lineDashPattern = nil;
    }
    
    // 更新头部圆点
    _headDotLayer.bounds = CGRectMake(0, 0, _headDotRadius * 2, _headDotRadius * 2);
    _headDotLayer.cornerRadius = _headDotRadius;
    _headDotLayer.backgroundColor = _progressColor.CGColor;
    _headDotLayer.hidden = !_showsHeadDot;
    
    // 更新动画图层
    _headAnimationLayer.strokeColor = _progressColor.CGColor;
    
    // 设置标记需要重新布局
    [self setNeedsLayout];
}

#pragma mark - 进度控制
// 修复点：保留基础setProgress:实现
- (void)setProgress:(CGFloat)progress {
    [self setProgress:progress animated:NO completion:nil];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated {
    [self setProgress:progress animated:animated completion:nil];
}

- (void)setProgress:(CGFloat)progress
           animated:(BOOL)animated
         completion:(void (^)(BOOL))completion {
    [self setProgress:progress
             animated:animated
             duration:0.3
               curve:_defaultAnimationCurve
         completion:completion];
}

- (void)setProgress:(CGFloat)progress withAnimationDuration:(CFTimeInterval)duration {
    [self setProgress:progress
             animated:YES
             duration:duration
               curve:_defaultAnimationCurve
         completion:nil];
}

- (void)setProgress:(CGFloat)progress
           animated:(BOOL)animated
           duration:(CFTimeInterval)duration
             curve:(RingProgressAnimationCurve)curve
         completion:(void (^)(BOOL))completion {
    if (_isAnimating) {
        if (completion) completion(NO);
        return;
    }
    
    progress = MAX(0.0, MIN(1.0, progress));
    
    if (!animated) {
        _progress = progress;
        _progressLayer.strokeEnd = progress;
        [self updateHeadDotPosition];
        [self updateProgressLabel];
        if (completion) completion(YES);
        return;
    }
    
    CGFloat oldProgress = _progress;
    _progress = progress;
    
    // 创建进度动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @(oldProgress);
    animation.toValue = @(progress);
    animation.duration = duration;
    animation.timingFunction = [self timingFunctionForCurve:curve];
    animation.removedOnCompletion = YES;
    
    // 动画回调处理
    __weak typeof(self) weakSelf = self;
    if (completion) {
        animation.delegate = self;
        void (^completionWrapper)(BOOL) = ^(BOOL finished) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf) {
                strongSelf.layer.shouldRasterize = NO;
            }
            completion(finished);
        };
        objc_setAssociatedObject(animation,
                                @selector(animationDidStop:finished:),
                                completionWrapper,
                                OBJC_ASSOCIATION_COPY);
    }
    
    _progressLayer.strokeEnd = progress;
    [_progressLayer addAnimation:animation forKey:@"progress"];
    
    // 更新进度标签
    [self updateProgressLabel];
    
    // 头部圆点动画
    if (_showsHeadDot && progress > 0.01) {
        CGPoint fromPoint = [self pointForProgress:oldProgress];
        CGPoint toPoint = [self pointForProgress:progress];
        
        CABasicAnimation *dotAnim = [CABasicAnimation animationWithKeyPath:@"position"];
        dotAnim.fromValue = [NSValue valueWithCGPoint:fromPoint];
        dotAnim.toValue = [NSValue valueWithCGPoint:toPoint];
        dotAnim.duration = duration;
        dotAnim.timingFunction = animation.timingFunction;
        [_headDotLayer addAnimation:dotAnim forKey:@"position"];
        _headDotLayer.position = toPoint;
    }
}

// 获取动画曲线
- (CAMediaTimingFunction *)timingFunctionForCurve:(RingProgressAnimationCurve)curve {
    switch (curve) {
        case RingProgressAnimationCurveEaseIn:
            return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        case RingProgressAnimationCurveEaseOut:
            return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        case RingProgressAnimationCurveLinear:
            return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        case RingProgressAnimationCurveBounce:
            return [CAMediaTimingFunction functionWithControlPoints:0.175 :0.885 :0.32 :1.275];
        case RingProgressAnimationCurveEaseInOut:
        default:
            return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    }
}

#pragma mark - 加载动画
- (void)startAnimating {
    if (_isAnimating) return;
    
    _isAnimating = YES;
    _animationStartProgress = _progress;
    
    // 准备动画状态
    _headDotLayer.hidden = YES;
    _headAnimationLayer.hidden = NO;
    
    // 启动显示链接
    [self startDisplayLink];
}

- (void)stopAnimating {
    [self stopAnimatingWithReset:NO];
}

- (void)stopAnimatingAndReset {
    [self stopAnimatingWithReset:YES];
}

- (void)stopAnimatingWithReset:(BOOL)reset {
    if (!_isAnimating) return;
    
    _isAnimating = NO;
    
    // 停止显示链接
    [self stopDisplayLink];
    
    // 恢复状态
    _headAnimationLayer.hidden = YES;
    
    if (reset) {
        _progress = 0;
        _progressLayer.strokeEnd = 0;
        _headDotLayer.hidden = !_showsHeadDot;
        [self updateProgressLabel];
    } else {
        _progress = _animationStartProgress;
        _progressLayer.strokeEnd = _progress;
        [self updateHeadDotPosition];
    }
}

#pragma mark - 动画控制
- (void)startDisplayLink {
    [self stopDisplayLink];
    
    _displayLink = [CADisplayLink displayLinkWithTarget:self
                                              selector:@selector(updateAnimation)];
    _displayLink.preferredFramesPerSecond = _isLowPerformanceDevice ? 20 : 30;
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stopDisplayLink {
    [_displayLink invalidate];
    _displayLink = nil;
}

- (void)updateAnimation {
    _rotationAngle += _animationSpeed;
    _headAnimationLayer.transform = CATransform3DMakeRotation(_rotationAngle, 0, 0, 1);
}

#pragma mark - 后台处理
- (void)applicationDidEnterBackground {
    if (_isAnimating) {
        [self stopDisplayLink];
    }
}

- (void)applicationWillEnterForeground {
    if (_isAnimating) {
        [self startDisplayLink];
    }
}

#pragma mark - 辅助方法
- (void)updateHeadDotPosition {
    if (_showsHeadDot && _progress > 0.01 && !_isAnimating) {
        _headDotLayer.hidden = NO;
        _headDotLayer.position = [self pointForProgress:_progress];
    } else {
        _headDotLayer.hidden = YES;
    }
}

- (CGPoint)pointForProgress:(CGFloat)progress {
    CGFloat angle = _startAngle + progress * (_endAngle - _startAngle);
    return CGPointMake(_ringCenter.x + _ringRadius * cos(angle),
                      _ringCenter.y + _ringRadius * sin(angle));
}

- (void)updateProgressLabel {
    if (_showsProgressLabel) {
        CGFloat percentage = _progress * 100;
        _progressLabel.text = [NSString stringWithFormat:_progressFormat, percentage];
    }
}

#pragma mark - 链式配置方法
- (CustomRingProgressView *)configLineWidth:(CGFloat)lineWidth {
    self.lineWidth = lineWidth;
    return self;
}

- (CustomRingProgressView *)configProgressColor:(UIColor *)color {
    self.progressColor = color;
    return self;
}

- (CustomRingProgressView *)configTrackColor:(UIColor *)color {
    self.trackColor = color;
    return self;
}

- (CustomRingProgressView *)configShowsHeadDot:(BOOL)shows {
    self.showsHeadDot = shows;
    return self;
}

- (CustomRingProgressView *)configShowsProgressLabel:(BOOL)shows {
    self.showsProgressLabel = shows;
    return self;
}

- (CustomRingProgressView *)configProgressGradientColors:(NSArray<UIColor *> *)colors {
    self.progressGradientColors = colors;
    return self;
}

- (CustomRingProgressView *)configHeadDotRadius:(CGFloat)radius {
    self.headDotRadius = radius;
    return self;
}

- (CustomRingProgressView *)configAnimationCurve:(RingProgressAnimationCurve)curve {
    self.defaultAnimationCurve = curve;
    return self;
}

#pragma mark - 属性设置
- (void)setLineWidth:(CGFloat)lineWidth {
    if (fabs(_lineWidth - lineWidth) < CGFLOAT_MIN) return;
    
    _lineWidth = lineWidth;
    if (_headDotRadius == _lineWidth / 2.0) {
        _headDotRadius = lineWidth / 2.0;
    }
    [self setNeedsLayout];
}

- (void)setStartAngle:(CGFloat)startAngle {
    if (fabs(_startAngle - startAngle) < CGFLOAT_MIN) return;
    
    _startAngle = startAngle;
    [self setNeedsLayout];
}

- (void)setEndAngle:(CGFloat)endAngle {
    if (fabs(_endAngle - endAngle) < CGFLOAT_MIN) return;
    
    _endAngle = endAngle;
    [self setNeedsLayout];
}

- (void)setProgressColor:(UIColor *)progressColor {
    if ([_progressColor isEqual:progressColor]) return;
    
    _progressColor = progressColor;
    [self updateAppearance];
}

- (void)setProgressGradientColors:(NSArray<UIColor *> *)progressGradientColors {
    _progressGradientColors = [progressGradientColors copy];
    [self updateAppearance];
}

- (void)setTrackColor:(UIColor *)trackColor {
    if ([_trackColor isEqual:trackColor]) return;
    
    _trackColor = trackColor;
    [self setNeedsLayout];
}

- (void)setTrackImage:(UIImage *)trackImage {
    if ([_trackImage isEqual:trackImage]) return;
    
    _trackImage = trackImage;
    [self setNeedsLayout];
}

- (void)setShowsHeadDot:(BOOL)showsHeadDot {
    if (_showsHeadDot == showsHeadDot) return;
    
    _showsHeadDot = showsHeadDot;
    _headDotLayer.hidden = !showsHeadDot;
}

- (void)setHeadDotRadius:(CGFloat)headDotRadius {
    if (fabs(_headDotRadius - headDotRadius) < CGFLOAT_MIN) return;
    
    _headDotRadius = headDotRadius;
    [self updateAppearance];
}

- (void)setTrackDashPattern:(NSArray<NSNumber *> *)trackDashPattern {
    _trackDashPattern = [trackDashPattern copy];
    [self setNeedsLayout];
}

- (void)setProgressDashPattern:(NSArray<NSNumber *> *)progressDashPattern {
    _progressDashPattern = [progressDashPattern copy];
    [self updateAppearance];
}

- (void)setShowsProgressLabel:(BOOL)showsProgressLabel {
    if (_showsProgressLabel == showsProgressLabel) return;
    
    _showsProgressLabel = showsProgressLabel;
    _progressLabel.hidden = !showsProgressLabel;
    if (showsProgressLabel) {
        [self updateProgressLabel];
    }
}

- (void)setProgressFormat:(NSString *)progressFormat {
    if ([_progressFormat isEqualToString:progressFormat]) return;
    
    _progressFormat = [progressFormat copy];
    if (_showsProgressLabel) {
        [self updateProgressLabel];
    }
}

- (void)setAnimationSpeed:(CGFloat)animationSpeed {
    _animationSpeed = MAX(0.01, MIN(1.0, animationSpeed));
}

#pragma mark - 动画代理
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    void (^completion)(BOOL) = objc_getAssociatedObject(anim, @selector(animationDidStop:finished:));
    if (completion) {
        completion(flag);
        objc_setAssociatedObject(anim, @selector(animationDidStop:finished:), nil, OBJC_ASSOCIATION_RETAIN);
    }
}

@end
