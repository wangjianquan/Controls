//
//  UIView+layer.h
//  Controls
//
//  Created by landixing on 2018/8/1.
//  Copyright © 2018年 WJQ. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface UIView (layer)

@property (assign, nonatomic) IBInspectable BOOL masksToBounds;
@property (assign, nonatomic) IBInspectable CGFloat cornerRadius;//圆角
@property (assign, nonatomic) IBInspectable CGFloat borderWidth;//边框宽度
@property (assign, nonatomic) IBInspectable UIColor *borderColor;//边框颜色
@property (assign, nonatomic) IBInspectable UIColor * shadowColor;//阴影颜色
@property (assign, nonatomic) IBInspectable CGSize shadowOffset;//阴影偏移
@property (assign, nonatomic) IBInspectable float shadowOpacity;//阴影透明度
@property (assign, nonatomic) IBInspectable CGFloat shadowRadius;//阴影圆角

@end
