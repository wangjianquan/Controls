//
//  UILabel+Insets.m
//  Controls
//
//  Created by jieyue on 2019/11/14.
//  Copyright © 2019 WJQ. All rights reserved.
//

#import "UILabel+Insets.h"
#import <objc/runtime.h>
@implementation UILabel (Insets)

static char kContentInsetsKey;
static char kshowContentInsetsKey;

- (void)setContentInsets:(UIEdgeInsets)contentInsets
{
    objc_setAssociatedObject(self, &kContentInsetsKey, NSStringFromUIEdgeInsets(contentInsets), OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &kshowContentInsetsKey, @YES, OBJC_ASSOCIATION_COPY_NONATOMIC);

}

- (UIEdgeInsets)contentInsets{
    return UIEdgeInsetsFromString(objc_getAssociatedObject(self, &kContentInsetsKey));
}
+ (void)load{
     [super load];

    // class_getInstanceMethod()

    Method fromMethod = class_getInstanceMethod([self class], @selector(drawTextInRect:));

    Method toMethod = class_getInstanceMethod([self class], @selector(tt_drawTextInRect:));

    // class_addMethod()

    if (!class_addMethod([self class], @selector(drawTextInRect:), method_getImplementation(toMethod), method_getTypeEncoding(toMethod))) {

    method_exchangeImplementations(fromMethod, toMethod);

    }
}

- (void)tt_drawTextInRect:(CGRect)rect{
    BOOL show = objc_getAssociatedObject(self, &kshowContentInsetsKey);
    if (show) {
        rect = UIEdgeInsetsInsetRect(rect, self.contentInsets);
    }
    [self tt_drawTextInRect:rect];
}

@end
