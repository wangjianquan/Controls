//
//  NSObject+property.m
//  Controls
//
//  Created by WJQ on 2019/12/19.
//  Copyright © 2019 WJQ. All rights reserved.
//

#import "NSObject+property.h"
#import <objc/runtime.h>


@implementation NSObject (property)
- (void)setIsSPOC:(BOOL)isSPOC{
    objc_setAssociatedObject(self, @selector(isSPOC), @(isSPOC), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isSPOC{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

@end
