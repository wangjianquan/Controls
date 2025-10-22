//
//  WJProgressView.h
//  CuiGPS
//
//  Created by landixing on 2018/7/26.
//  Copyright © 2018年 WJQ. All rights reserved.
// 自定义图片加载进度(圆形)

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface WJProgressView : UIView

@property (assign, nonatomic) IBInspectable CGFloat progress;
@property (nullable, nonatomic,copy) IBInspectable UIColor *progressColor;
@end
