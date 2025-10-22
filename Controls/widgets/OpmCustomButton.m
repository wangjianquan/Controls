//
//  OpmCustomButton.m
//  OpmSDK
//
//  Created by jieyue_M1 on 2025/7/3.
//

#import "OpmCustomButton.h"

@interface OpmCustomButton ()

@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UIView *disabledOverlay; // 禁用状态蒙版
@property (nonatomic, strong) UIColor *originalTitleColor; // 保存原始文字颜色

@end

@implementation OpmCustomButton

- (UIView *)whiteView {
    if (!_whiteView) {
        _whiteView = [[UIView alloc] init];
        _whiteView.backgroundColor = [UIColor colorWithRed:246/255.0 green:248/255.0 blue:253/255.0 alpha:1];
        _whiteView.layer.cornerRadius = 20;
        _whiteView.layer.masksToBounds = YES;
        _whiteView.userInteractionEnabled = NO;
        _whiteView.hidden = YES; // 默认隐藏
    }
    return _whiteView;
}

- (UIView *)disabledOverlay {
    if (!_disabledOverlay) {
        _disabledOverlay = [[UIView alloc] initWithFrame:self.bounds];
        _disabledOverlay.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.6]; // 半透明白色蒙版
        _disabledOverlay.userInteractionEnabled = NO; // 允许事件穿透
        _disabledOverlay.hidden = YES; // 默认隐藏
    }
    return _disabledOverlay;
}

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

- (instancetype)initWithImagePosition:(ImagePosition)position spacing:(CGFloat)spacing {
    self = [super init];
    if (self) {
        [self commonInit];
        self.imagePosition = position;
        self.spacing = spacing;
    }
    return self;
}
- (instancetype)initWithImagePosition:(ImagePosition)position spacing:(CGFloat)spacing buttonType:(OpmButtonType)buttonType {
    self = [super init];
    if (self) {
        [self commonInit];
        self.imagePosition = position;
        self.spacing = spacing;
        self.btnType = buttonType;
        
        // 添加点击效果
        [self addTarget:self action:@selector(handleTap) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
- (void)handleTap {
    // 添加点击动画效果
    [UIView animateWithDuration:0.1 animations:^{
        self.transform = CGAffineTransformMakeScale(0.95, 0.95);
        self.alpha = 0.8;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            self.transform = CGAffineTransformIdentity;
            self.alpha = 1.0;
        }];
    }];
}
- (void)commonInit {
    self.imagePosition = ImagePositionLeft;
    self.spacing = 5.0;
    self.contentInsets = UIEdgeInsetsZero;
    
    // 保存原始文字颜色
    _originalTitleColor = [self titleColorForState:UIControlStateNormal];
    
    // 添加whiteView并确保它在imageView下方
    [self addSubview:self.whiteView];
    [self sendSubviewToBack:self.whiteView];
    
    // 添加禁用状态蒙版
    [self addSubview:self.disabledOverlay];
    [self bringSubviewToFront:self.disabledOverlay];
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 更新禁用蒙版位置
    self.disabledOverlay.frame = self.bounds;
    
    // 如果没有图片或标题，使用系统默认布局
    if (!self.imageView.image || !self.titleLabel.text) {
        self.whiteView.hidden = YES;
        return;
    }
    
    // 获取图片和文字的原始大小
    CGSize imageSize = CGSizeMake(34, 34);
    CGSize titleSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}];
    
    // 计算内容区域的可用空间
    CGFloat contentWidth = CGRectGetWidth(self.bounds) - self.contentInsets.left - self.contentInsets.right;
    CGFloat contentHeight = CGRectGetHeight(self.bounds) - self.contentInsets.top - self.contentInsets.bottom;
    
    // 计算图片和文字的总尺寸
    CGSize totalSize = CGSizeZero;
    if (self.imagePosition == ImagePositionLeft || self.imagePosition == ImagePositionRight) {
        // 水平排列
        totalSize.width = imageSize.width + titleSize.width + self.spacing;
        totalSize.height = MAX(imageSize.height, titleSize.height);
    } else {
        // 垂直排列
        totalSize.width = MAX(imageSize.width, titleSize.width);
        totalSize.height = imageSize.height + titleSize.height + self.spacing;
    }
    
    // 计算内容在按钮中的起始位置（居中对齐）
    CGFloat contentX = self.contentInsets.left + (contentWidth - totalSize.width) / 2.0;
    CGFloat contentY = self.contentInsets.top + (contentHeight - totalSize.height) / 2.0;
    
    // 根据图片位置计算图片和文字的frame
    CGRect imageFrame = CGRectZero;
    CGRect titleFrame = CGRectZero;
    
    switch (self.imagePosition) {
        case ImagePositionLeft: {
            // 图片在左，文字在右
            imageFrame = CGRectMake(contentX, contentY + (totalSize.height - imageSize.height) / 2.0, imageSize.width, imageSize.height);
            titleFrame = CGRectMake(CGRectGetMaxX(imageFrame) + self.spacing, contentY + (totalSize.height - titleSize.height) / 2.0, titleSize.width, titleSize.height);
            break;
        }
            
        case ImagePositionRight: {
            // 图片在右，文字在左
            titleFrame = CGRectMake(contentX, contentY + (totalSize.height - titleSize.height) / 2.0, titleSize.width, titleSize.height);
            imageFrame = CGRectMake(CGRectGetMaxX(titleFrame) + self.spacing, contentY + (totalSize.height - imageSize.height) / 2.0, imageSize.width, imageSize.height);
            break;
        }
            
        case ImagePositionTop: {
            // 图片在上，文字在下
            imageFrame = CGRectMake(contentX + (totalSize.width - imageSize.width) / 2.0, contentY, imageSize.width, imageSize.height);
            titleFrame = CGRectMake(contentX + (totalSize.width - titleSize.width) / 2.0, CGRectGetMaxY(imageFrame) + self.spacing, titleSize.width, titleSize.height);
            break;
        }
            
        case ImagePositionBottom: {
            // 图片在下，文字在上
            titleFrame = CGRectMake(contentX + (totalSize.width - titleSize.width) / 2.0, contentY, titleSize.width, titleSize.height);
            imageFrame = CGRectMake(contentX + (totalSize.width - imageSize.width) / 2.0, CGRectGetMaxY(titleFrame) + self.spacing, imageSize.width, imageSize.height);
            break;
        }
    }
    
    // 应用新的frame
    self.imageView.frame = imageFrame;
    self.titleLabel.frame = titleFrame;
    
    // 设置whiteView的位置和显示状态
    if (self.imageView.image) {
        // 根据外部传入的条件决定是否显示背景
        self.whiteView.hidden = !(self.imageView.image && self.showImgBgColorView);
        if (self.imgBgColor) {
            self.whiteView.backgroundColor = self.imgBgColor;
        } else {
            self.whiteView.backgroundColor = [UIColor colorWithRed:246/255.0 green:248/255.0 blue:253/255.0 alpha:1];
        }

        if (!self.whiteView.hidden) {
            self.whiteView.frame = CGRectMake(0, 0, 40, 40);
            self.whiteView.center = self.imageView.center;
        }
    } else {
        self.whiteView.hidden = YES;
    }
}

#pragma mark - Size Calculation

- (CGSize)sizeThatFits:(CGSize)size {
    // 如果没有图片或标题，使用系统默认大小
    if (!self.imageView.image || !self.titleLabel.text) {
        return [super sizeThatFits:size];
    }
    
    // 获取图片和文字的大小
    CGSize imageSize = CGSizeMake(34, 34);
    CGSize titleSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}];
    
    // 计算按钮的最小尺寸
    CGSize minSize = CGSizeZero;
    if (self.imagePosition == ImagePositionLeft || self.imagePosition == ImagePositionRight) {
        // 水平排列
        minSize.width = imageSize.width + titleSize.width + self.spacing + self.contentInsets.left + self.contentInsets.right;
        minSize.height = MAX(imageSize.height, titleSize.height) + self.contentInsets.top + self.contentInsets.bottom;
    } else {
        // 垂直排列
        minSize.width = MAX(imageSize.width, titleSize.width) + self.contentInsets.left + self.contentInsets.right;
        minSize.height = imageSize.height + titleSize.height + self.spacing + self.contentInsets.top + self.contentInsets.bottom;
    }
    
    // 如果显示背景，额外增加空间（宽高各增加6点）
    if (self.imageView.image && self.showImgBgColorView) {
        minSize.width += 6;
        minSize.height += 6;
    }
    
    // 考虑传入的size约束
    if (size.width > 0 && minSize.width > size.width) {
        minSize.width = size.width;
    }
    
    if (size.height > 0 && minSize.height > size.height) {
        minSize.height = size.height;
    }
    
    return minSize;
}

#pragma mark - State Management

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    
    // 更新禁用状态蒙版
    self.disabledOverlay.hidden = enabled;
    
    // 更新文字颜色
    if (enabled) {
        [self setTitleColor:_originalTitleColor forState:UIControlStateNormal];
    } else {
        // 禁用状态下使用灰色文字
        [self setTitleColor:[UIColor colorWithWhite:0.6 alpha:1.0] forState:UIControlStateNormal];
    }
    
    // 更新图片透明度
    self.imageView.alpha = enabled ? 1.0 : 0.6;
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state {
    [super setTitleColor:color forState:state];
    
    // 保存正常状态下的原始颜色
    if (state == UIControlStateNormal) {
        _originalTitleColor = color;
    }
}

#pragma mark - Property Setter

- (void)setShowImgBgColorView:(BOOL)showImgBgColorView {
    if (_showImgBgColorView != showImgBgColorView) {
        _showImgBgColorView = showImgBgColorView;
        [self setNeedsLayout]; // 标记需要重新布局
    }
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state {
    [super setImage:image forState:state];
    [self setNeedsLayout]; // 图片变化时需要重新布局
}

@end
