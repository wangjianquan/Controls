//
//  UIView+layer.m
//  Controls
//
//  Created by landixing on 2018/8/1.
//  Copyright © 2018年 WJQ. All rights reserved.
//

#import "UIView+layer.h"

@implementation UIView (layer)
- (void)setCornerRadius:(CGFloat)cornerRadius{
    self.layer.cornerRadius = cornerRadius;
}

- (void)setBorderWidth:(CGFloat)borderWidth{
    self.layer.borderWidth = borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor{
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setMasksToBounds:(BOOL)masksToBounds{
    self.layer.masksToBounds = masksToBounds;
}

- (void)setShadowColor:(UIColor *)shadowColor{
    self.layer.shadowColor = shadowColor.CGColor;
}
- (void)setShadowOffset:(CGSize)shadowOffset{
    self.layer.shadowOffset = shadowOffset;
}

- (void)setShadowOpacity:(float)shadowOpacity{
    self.layer.shadowOpacity = shadowOpacity;
}
- (void)setShadowRadius:(CGFloat)shadowRadius{
    self.layer.shadowRadius = shadowRadius;
}

-(CGFloat)cornerRadius{
    return self.layer.cornerRadius;
}
-(CGFloat)borderWidth{
    return self.layer.borderWidth;
}
-(UIColor *)borderColor{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}
- (BOOL)masksToBounds{
    return self.layer.masksToBounds;
}

- (UIColor *)shadowColor{
    return [UIColor colorWithCGColor:self.layer.shadowColor];
}

- (CGSize)shadowOffset{
    return self.layer.shadowOffset;
}

- (float)shadowOpacity{
    return self.layer.shadowOpacity;
}

- (CGFloat)shadowRadius{
    return self.layer.shadowRadius;
}
@end
