//
//  RadianLayerView.h
//  GiantWheat
//
//  Created by WJQ on 2019/11/26.
//  Copyright © 2019 jumaihuishou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, RadianDirection) {
    RadianDirectionBottom     = 0,
    RadianDirectionTop        = 1,
    RadianDirectionLeft       = 2,
    RadianDirectionRight      = 3,
};

@interface RadianLayerView : UIView
// 圆弧方向, 默认在下方
@property (nonatomic) RadianDirection direction;
// 圆弧高/宽, 可为负值。 正值凸, 负值凹
@property (nonatomic) CGFloat radian;
@end

NS_ASSUME_NONNULL_END
