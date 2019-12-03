//
//  CustomCornerView.h
//  YBPopupMenuDemo
//
//  Created by WJQ on 2019/12/3.
//  Copyright © 2019 LYB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CustomCornerViewDelegate <NSObject>

- (void)tapGestureLabel:(NSString *)currentString;

@end

@interface CustomCornerView : UIView

@property (nonatomic, weak) id<CustomCornerViewDelegate> delegate;

/**
 标题
 */
@property (nonatomic, copy) NSString  * title;

/**
 圆角半径 Default is 5.0
 */
@property (nonatomic, assign) CGFloat cornerRadius;

/**
 自定义圆角 Default is UIRectCornerAllCorners 
 */
@property (nonatomic, assign) UIRectCorner rectCorner;

/**
 是否显示阴影 Default is YES
 */
@property (nonatomic, assign , getter=isShadowShowing) BOOL isShowShadow;


/**
 点击文字后消失 Default is YES
 */
@property (nonatomic, assign) BOOL dismissOnSelected;

/**
 点击关闭按钮后消失  Default is YES
 */
@property (nonatomic, assign) BOOL dismissOnTouchOutside;

/**
 设置字体大小  Default is 13
 */
@property (nonatomic, assign) CGFloat fontSize;

/**
 设置字体颜色  Default is [UIColor whiteColor]
 */
@property (nonatomic, strong) UIColor * textColor;

/**
 设置偏移距离 (>= 0) Default is 0.0
 */
@property (nonatomic, assign) CGFloat offset;

/**
 可见的最大行数 Default is 5;
 */
@property (nonatomic, assign) NSInteger maxVisibleCount;

/**
 背景色 Default is WhiteColor
 */
@property (nonatomic, strong) UIColor * backColor;

/**
    label closeBtn 内部间距 Default is 10
 */
@property (nonatomic, assign) CGFloat minSpace;

/**
 依赖指定view弹出(推荐方法)

 @param titleString         标题数组  数组里是NSString/NSAttributedString
 @param itemWidth      菜单宽度
 @param otherSetting   其他设置
 */
+ (CustomCornerView *)showRelyOnView:(UIView *)view
                         titles:(NSString *)titleString
                      menuWidth:(CGFloat)itemWidth
                  otherSettings:(void (^) (CustomCornerView * popupMenu))otherSetting;

+ (CustomCornerView *)showAtPoint:(CGPoint)point
                        titles:(NSString *)titleString
                     menuWidth:(CGFloat)itemWidth
                 otherSettings:(void (^) (CustomCornerView * corner))otherSetting;

/**
 消失
 */
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
