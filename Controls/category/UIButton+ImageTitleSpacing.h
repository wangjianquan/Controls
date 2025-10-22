//
//  UIButton+ImageTitleSpacing.h
//  SystemPreferenceDemo
//
//  Created by wenhao lei on 12/28/15.
//  Copyright © 2015 wenhao lei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JRButtonEdgeInsetsStyle) {
    JRButtonEdgeInsetsStyleTop, ///<image在上，label在下;
    JRButtonEdgeInsetsStyleLeft, ///<image在左，label在右;
    JRButtonEdgeInsetsStyleBottom, ///<image在下，label在上;
    JRButtonEdgeInsetsStyleRight ///<image在右，label在左;
};

@interface UIButton (ImageTitleSpacing)

/**
 *  设置button的titleLabel和imageView的布局样式，及间距
 *
 *  @param style titleLabel和imageView的布局样式
 *  @param space titleLabel和imageView的间距
 */
- (void)wh_layoutButtonWithEdgeInsetsStyle:(JRButtonEdgeInsetsStyle)style
                           imageTitleSpace:(CGFloat)space;

- (void)wh_addTarget:(id)target action:(SEL)action;

@end
