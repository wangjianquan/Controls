//
//  OpmActivityIndicatorView.h
//  Controls
//
//  Created by 白小嘿M4Pro on 2025/8/2.
//  Copyright © 2025 WJQ. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 圆形活动指示器视图样式
typedef NS_ENUM(NSInteger, OpmActivityIndicatorViewStyle) {
    OpmActivityIndicatorViewStyleMedium,  // 中等尺寸 (24x24)
    OpmActivityIndicatorViewStyleLarge    // 大尺寸 (37x37)
};

NS_ASSUME_NONNULL_BEGIN

/// 高性能圆形活动指示器视图
@interface OpmActivityIndicatorView : UIView
@property (nonatomic, strong) UIActivityIndicatorView *d;
/// 指示器样式（设置后自动更新UI）
@property (nonatomic, assign) OpmActivityIndicatorViewStyle style;

/// 停止时是否隐藏（默认YES）
@property (nonatomic, assign) BOOL hidesWhenStopped;

/// 指示器颜色（默认系统灰色）
@property (nonatomic, strong) UIColor *color;

/// 动画一圈的持续时间（秒，默认1.0）
@property (nonatomic, assign) NSTimeInterval animationDuration;

/// 是否正在动画（只读）
@property (nonatomic, readonly, getter=isAnimating) BOOL animating;

/**
 * 使用指定样式初始化指示器
 * @param style 指示器样式
 */
- (instancetype)initWithStyle:(OpmActivityIndicatorViewStyle)style;

/// 开始动画
- (void)startAnimating;

/// 停止动画
- (void)stopAnimating;

@end

NS_ASSUME_NONNULL_END
