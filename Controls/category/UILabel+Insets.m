//
//  UILabel+Insets.m
//  Controls
//
//  Created by jieyue on 2019/11/14.
//  Copyright © 2019 WJQ. All rights reserved.
//

#import "UILabel+Insets.h"
#import <objc/runtime.h>

// 关联对象键
static char kContentInsetsKey;
static char kHasContentInsetsKey;

@implementation UILabel (Insets)

#pragma mark - Associated Properties

- (void)setContentInsets:(UIEdgeInsets)contentInsets {
    // 使用NSValue存储UIEdgeInsets
    NSValue *insetsValue = [NSValue valueWithUIEdgeInsets:contentInsets];
    objc_setAssociatedObject(self, &kContentInsetsKey, insetsValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // 标记是否设置了内边距
    BOOL hasInsets = !UIEdgeInsetsEqualToEdgeInsets(contentInsets, UIEdgeInsetsZero);
    objc_setAssociatedObject(self, &kHasContentInsetsKey, @(hasInsets), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // 设置内边距后需要重新绘制
    [self setNeedsDisplay];
}

- (UIEdgeInsets)contentInsets {
    NSValue *insetsValue = objc_getAssociatedObject(self, &kContentInsetsKey);
    if (insetsValue) {
        return [insetsValue UIEdgeInsetsValue];
    }
    return UIEdgeInsetsZero;
}

#pragma mark - Method Swizzling

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceMethod:@selector(drawTextInRect:)
                       withMethod:@selector(insets_drawTextInRect:)];
        
        [self swizzleInstanceMethod:@selector(textRectForBounds:limitedToNumberOfLines:)
                       withMethod:@selector(insets_textRectForBounds:limitedToNumberOfLines:)];
        
        [self swizzleInstanceMethod:@selector(intrinsicContentSize)
                       withMethod:@selector(insets_intrinsicContentSize)];
    });
}

+ (void)swizzleInstanceMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector {
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(class,
                                        originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

#pragma mark - Swizzled Methods

- (void)insets_drawTextInRect:(CGRect)rect {
    NSNumber *hasInsets = objc_getAssociatedObject(self, &kHasContentInsetsKey);
    if (hasInsets && [hasInsets boolValue]) {
        rect = UIEdgeInsetsInsetRect(rect, self.contentInsets);
    }
    [self insets_drawTextInRect:rect];
}

- (CGRect)insets_textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    NSNumber *hasInsets = objc_getAssociatedObject(self, &kHasContentInsetsKey);
    if (hasInsets && [hasInsets boolValue]) {
        bounds = UIEdgeInsetsInsetRect(bounds, self.contentInsets);
    }
    
    CGRect textRect = [self insets_textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    
    if (hasInsets && [hasInsets boolValue]) {
        textRect = CGRectMake(textRect.origin.x - self.contentInsets.left,
                            textRect.origin.y - self.contentInsets.top,
                            textRect.size.width + self.contentInsets.left + self.contentInsets.right,
                            textRect.size.height + self.contentInsets.top + self.contentInsets.bottom);
    }
    
    return textRect;
}

- (CGSize)insets_intrinsicContentSize {
    CGSize intrinsicSize = [self insets_intrinsicContentSize];
    
    NSNumber *hasInsets = objc_getAssociatedObject(self, &kHasContentInsetsKey);
    if (hasInsets && [hasInsets boolValue]) {
        intrinsicSize.width += self.contentInsets.left + self.contentInsets.right;
        intrinsicSize.height += self.contentInsets.top + self.contentInsets.bottom;
    }
    
    return intrinsicSize;
}

#pragma mark - Convenience Methods

+ (instancetype)labelWithContentInsets:(UIEdgeInsets)contentInsets {
    UILabel *label = [[self alloc] init];
    label.contentInsets = contentInsets;
    return label;
}

@end
