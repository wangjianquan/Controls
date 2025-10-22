//
//  OpmActivityIndicatorView.m
//  Controls
//
//  Created by 白小嘿M4Pro on 2025/8/2.
//  Copyright © 2025 WJQ. All rights reserved.
//

#import "OpmActivityIndicatorView.h"
#import <QuartzCore/QuartzCore.h>

// 常量定义
static CGSize const kMediumSize = {24, 24};  // 中等尺寸
static CGSize const kLargeSize = {37, 37};   // 大尺寸

@interface OpmActivityIndicatorView ()

// MARK: - 私有属性

/// 轨道图层（背景圆环）
@property (nonatomic, strong) CAShapeLayer *trackLayer;

/// 进度图层（动画圆环）
@property (nonatomic, strong) CAShapeLayer *progressLayer;

/// 当前描边宽度
@property (nonatomic, assign) CGFloat strokeWidth;

/// 上次计算的半径（用于优化路径更新）
@property (nonatomic, assign) CGFloat lastRadius;

/// 动画是否被暂停
@property (nonatomic, assign) BOOL isAnimationPaused;

/// 旋转动画键
@property (nonatomic, copy) NSString *rotationAnimationKey;

/// 淡出动画键
@property (nonatomic, copy) NSString *fadeAnimationKey;

@end

@implementation OpmActivityIndicatorView

#pragma mark - 生命周期方法

// 使用指定样式初始化
- (instancetype)initWithStyle:(OpmActivityIndicatorViewStyle)style {
    // 根据样式获取固有尺寸
    CGSize size = [self intrinsicContentSizeForStyle:style];
    self = [super initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    if (self) {
        _style = style;
        [self commonInit];
    }
    return self;
}

// 使用Frame初始化
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

// 从Storyboard/XIB初始化
- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

/// 通用初始化设置
- (void)commonInit {
    // 设置默认值
    _hidesWhenStopped = YES;
    _color = [UIColor systemGrayColor];
    _animationDuration = 1.0;
    _rotationAnimationKey = @"rotationAnimation";
    _fadeAnimationKey = @"fadeAnimation";
    
    // 视图基础设置
    self.backgroundColor = [UIColor clearColor];
    self.hidden = self.hidesWhenStopped;
    
    // 创建图层
    _trackLayer = [CAShapeLayer layer];
    _progressLayer = [CAShapeLayer layer];
    
    // 配置图层
    [self configureLayerPerformance];
    [self setupLayers];
    
    // 应用初始样式
    [self updateIndicatorStyle];
    [self updateColors];
    
    // 无障碍支持
    [self setupAccessibility];
    
    // 注册应用状态通知
    [self setupNotifications];
}

- (void)dealloc {
    // 清理资源
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self stopAnimating];
    [self.progressLayer removeAllAnimations];
    [self.trackLayer removeAllAnimations];
}

#pragma mark - 图层配置

/// 设置图层层次结构和基本属性
- (void)setupLayers {
    // 轨道层配置（背景圆环）
    self.trackLayer.fillColor = [UIColor clearColor].CGColor;
    self.trackLayer.lineCap = kCALineCapRound;  // 圆形端点
    [self.layer addSublayer:self.trackLayer];
    
    // 进度层配置（动画圆环）
    self.progressLayer.fillColor = [UIColor clearColor].CGColor;
    self.progressLayer.strokeStart = 0;      // 设置缺口起始点
    self.progressLayer.strokeEnd = 0.7;      // 设置缺口结束点（70%位置）
    self.progressLayer.lineCap = kCALineCapRound;
    [self.layer addSublayer:self.progressLayer];
}

/// 配置图层性能优化选项
- (void)configureLayerPerformance {
    CGFloat screenScale = [UIScreen mainScreen].scale;
    
    // 设置内容缩放比例匹配屏幕
    self.trackLayer.contentsScale = screenScale;
    self.progressLayer.contentsScale = screenScale;
    
    // 启用光栅化提高滚动性能
    self.trackLayer.shouldRasterize = YES;
    self.progressLayer.shouldRasterize = YES;
    self.trackLayer.rasterizationScale = screenScale;
    self.progressLayer.rasterizationScale = screenScale;
    
    // 禁用组透明度减少离屏渲染
    self.trackLayer.allowsGroupOpacity = NO;
    self.progressLayer.allowsGroupOpacity = NO;
    
    // 启用异步绘制提高性能
    self.trackLayer.drawsAsynchronously = YES;
    self.progressLayer.drawsAsynchronously = YES;
}

#pragma mark - 布局

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 优化：仅在边界变化时更新图层
    if (!CGRectEqualToRect(self.trackLayer.frame, self.bounds)) {
        self.trackLayer.frame = self.bounds;
        self.progressLayer.frame = self.bounds;
        [self updateCircularPath];
    }
}

/// 更新圆形路径（核心渲染）
- (void)updateCircularPath {
    // 计算有效尺寸（防止除零错误）
    CGFloat minSize = MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    CGFloat validSize = MAX(minSize, 1);
    CGFloat radius = (validSize - self.strokeWidth) / 2;
    
    // 优化：仅在半径变化超过0.5点时更新路径
    if (fabs(radius - self.lastRadius) > 0.5) {
        self.lastRadius = radius;
        
        // 创建圆形路径（从顶部开始，顺时针绘制完整圆）
        CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        UIBezierPath *circularPath = [UIBezierPath bezierPathWithArcCenter:center
                                                                   radius:radius
                                                               startAngle:-M_PI_2   // -90度（顶部）
                                                                 endAngle:3 * M_PI_2  // 270度（完整圆+起点）
                                                                clockwise:YES];
        self.trackLayer.path = circularPath.CGPath;
        self.progressLayer.path = circularPath.CGPath;
    }
}

/// 获取指定样式的固有内容尺寸
- (CGSize)intrinsicContentSizeForStyle:(OpmActivityIndicatorViewStyle)style {
    switch (style) {
        case OpmActivityIndicatorViewStyleMedium:
            return kMediumSize;
        case OpmActivityIndicatorViewStyleLarge:
            return kLargeSize;
    }
}

/// 根据当前样式返回固有内容尺寸
- (CGSize)intrinsicContentSize {
    return [self intrinsicContentSizeForStyle:self.style];
}

#pragma mark - 样式和颜色更新

/// 根据当前样式更新指示器外观
- (void)updateIndicatorStyle {
    CGFloat newStrokeWidth = (self.style == OpmActivityIndicatorViewStyleMedium) ? 2.0 : 3.0;
    
    // 仅当描边宽度变化时更新
    if (self.strokeWidth != newStrokeWidth) {
        self.strokeWidth = newStrokeWidth;
        self.trackLayer.lineWidth = self.strokeWidth;
        self.progressLayer.lineWidth = self.strokeWidth;
        
        // 通知系统内容尺寸变化
        [self invalidateIntrinsicContentSize];
        [self setNeedsLayout];
    }
}

/// 更新图层颜色
- (void)updateColors {
    // 轨道层使用半透明版本
    self.trackLayer.strokeColor = [self.color colorWithAlphaComponent:0.2].CGColor;
    // 进度层使用完整颜色
    self.progressLayer.strokeColor = self.color.CGColor;
}

/// 根据动画状态更新可见性
- (void)updateVisibility {
    self.hidden = !self.animating && self.hidesWhenStopped;
}

#pragma mark - 属性设置方法

- (void)setStyle:(OpmActivityIndicatorViewStyle)style {
    if (_style != style) {
        _style = style;
        // 主线程更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateIndicatorStyle];
            [self setNeedsLayout];
        });
    }
}

- (void)setColor:(UIColor *)color {
    if (_color != color) {
        _color = color;
        [self updateColors];
    }
}

- (void)setHidesWhenStopped:(BOOL)hidesWhenStopped {
    if (_hidesWhenStopped != hidesWhenStopped) {
        _hidesWhenStopped = hidesWhenStopped;
        [self updateVisibility];
    }
}

#pragma mark - 动画控制

- (void)startAnimating {
    // 防止重复启动
    if (self.animating) {
        return;
    }
    
    _animating = YES;
    [self updateVisibility];
    
    // 确保在主线程执行动画
    dispatch_async(dispatch_get_main_queue(), ^{
        [self addRotationAnimation];
    });
}

- (void)stopAnimating {
    // 防止重复停止
    if (!self.animating) {
        return;
    }
    
    _animating = NO;
    [self updateVisibility];
    
    // 确保在主线程执行动画停止
    dispatch_async(dispatch_get_main_queue(), ^{
        [self stopRotationAnimation];
    });
}

/// 重启动画（用于持续时间等参数变化时）
- (void)restartAnimation {
    if (!self.animating) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.progressLayer removeAnimationForKey:self.rotationAnimationKey];
        [self addRotationAnimation];
    });
}

/// 添加旋转动画
- (void)addRotationAnimation {
    // 移除可能存在的旧动画
    [self.progressLayer removeAnimationForKey:self.rotationAnimationKey];
    
    // 确保进度层完全可见
    self.progressLayer.opacity = 1.0;
    
    // 创建旋转动画
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = @0;
    rotationAnimation.toValue = @(2 * M_PI);  // 360度旋转
    rotationAnimation.duration = self.animationDuration;
    rotationAnimation.repeatCount = HUGE_VALF;   // 无限重复
    rotationAnimation.removedOnCompletion = NO;  // 动画完成后不移除
    rotationAnimation.fillMode = kCAFillModeForwards;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    [self.progressLayer addAnimation:rotationAnimation forKey:self.rotationAnimationKey];
}

/// 停止旋转动画（带淡出效果）
- (void)stopRotationAnimation {
    // 移除旋转动画
    [self.progressLayer removeAnimationForKey:self.rotationAnimationKey];
    
    // 创建淡出动画
    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnimation.fromValue = @1.0;
    fadeAnimation.toValue = @0.0;
    fadeAnimation.duration = 0.2;
    fadeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    fadeAnimation.fillMode = kCAFillModeForwards;
    fadeAnimation.removedOnCompletion = NO;
    
    // 使用事务确保动画完成后执行清理
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        // 移除淡出动画
        [self.progressLayer removeAnimationForKey:self.fadeAnimationKey];
        // 更新可见性状态
        [self updateVisibility];
    }];
    
    [self.progressLayer addAnimation:fadeAnimation forKey:self.fadeAnimationKey];
    [CATransaction commit];
}

#pragma mark - 动画状态管理

/// 暂停动画（用于进入后台等场景）
- (void)pauseAnimation {
    // 仅当正在动画且未被暂停时执行
    if (!self.animating || self.isAnimationPaused) {
        return;
    }
    
    // 保存当前动画时间
    CFTimeInterval pausedTime = [self.progressLayer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.progressLayer.speed = 0.0;
    self.progressLayer.timeOffset = pausedTime;
    self.isAnimationPaused = YES;
}

/// 恢复动画（用于返回前台等场景）
- (void)resumeAnimation {
    // 仅当正在动画且已被暂停时执行
    if (!self.animating || !self.isAnimationPaused) {
        return;
    }
    
    // 计算暂停时间并恢复动画
    CFTimeInterval pausedTime = self.progressLayer.timeOffset;
    self.progressLayer.speed = 1.0;
    self.progressLayer.timeOffset = 0.0;
    self.progressLayer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [self.progressLayer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.progressLayer.beginTime = timeSincePause;
    self.isAnimationPaused = NO;
}

#pragma mark - 窗口和应用状态处理

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    
    if (newWindow == nil) {
        // 视图离开窗口时暂停动画
        [self pauseAnimation];
    } else if (self.animating) {
        // 视图进入窗口时恢复动画
        [self resumeAnimation];
    }
}

/// 设置应用状态通知监听
- (void)setupNotifications {
    // 应用即将进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    // 应用进入后台
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
}

/// 处理应用返回前台事件
- (void)applicationWillEnterForeground {
    // 仅当正在动画且有窗口时恢复
    if (self.animating && self.window != nil) {
        [self resumeAnimation];
    }
}

/// 处理应用进入后台事件
- (void)applicationDidEnterBackground {
    // 当应用进入后台时暂停动画
    if (self.animating) {
        [self pauseAnimation];
    }
}

#pragma mark - 无障碍访问

/// 设置无障碍访问属性
- (void)setupAccessibility {
    self.isAccessibilityElement = YES;
    // 组合特性：频繁更新+图像类型
    self.accessibilityTraits = UIAccessibilityTraitUpdatesFrequently | UIAccessibilityTraitImage;
    self.accessibilityLabel = NSLocalizedString(@"Loading indicator", @"无障碍标签：加载指示器");
    self.accessibilityHint = NSLocalizedString(@"Indicates an ongoing operation", @"无障碍提示：表示正在进行中的操作");
}

/// 动态无障碍值（根据动画状态变化）
- (NSString *)accessibilityValue {
    return self.animating ?
        NSLocalizedString(@"In progress", @"无障碍值：进行中") :
        NSLocalizedString(@"Stopped", @"无障碍值：已停止");
}

#pragma mark - 系统特性变化响应

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    // 当内容尺寸类别变化时重新布局
    if (self.traitCollection.preferredContentSizeCategory != previousTraitCollection.preferredContentSizeCategory) {
        [self setNeedsLayout];
    }
}

@end
