//
//  CustomTextView.h
//  Controls
//
//  Created by wjq on 2019/6/18.
//  Copyright © 2019 WJQ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomTextView : UITextView
/**
 *  textView最大行数
 */
@property (nonatomic, assign) NSUInteger maxNumberOfLines;

/**
 *  文字高度改变block → 文字高度改变会自动调用
 *  block参数(text) → 文字内容
 *  block参数(textHeight) → 文字高度
 */
@property (nonatomic, copy) void(^yz_textHeightChangeBlock)(NSString *text,CGFloat textHeight);

/**
 *  设置圆角
 */
@property (nonatomic, assign) NSUInteger cornerRadius;

/**
 *  占位文字
 */
@property (nonatomic, strong) NSString *placeholder;

/**
 *  占位文字颜色
 */
@property (nonatomic, strong) UIColor *placeholderColor;
@property (nonatomic, copy) void (^changeBlock)(void);
@end

NS_ASSUME_NONNULL_END
