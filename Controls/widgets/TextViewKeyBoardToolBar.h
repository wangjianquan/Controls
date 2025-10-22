//
//  TextViewKeyBoardToolBar.h
//  YunTingKeTang
//
//  Created by wjq on 2019/6/17.
//  Copyright © 2019 wjq. All rights reserved.
//评论工具条

#import <UIKit/UIKit.h>
#import "CustomTextView.h"

NS_ASSUME_NONNULL_BEGIN


//发送消息回调
typedef void(^KeyBoardSendMessageBlock)(void);

@protocol KeyToolBarDelegate <NSObject>
/**
 键盘将要出现回调
 
 @param height 键盘的行高
 @param endEditIng 是否停止编辑(当一些视图出现时，停止编辑,强制退出输入框)
 */
-(void)keyBoardWillShow:(CGFloat)height endEditIng:(BOOL)endEditIng;
/**
 关闭键盘
 */
- (void)hiddenKeyBoard;




@end

@interface TextViewKeyBoardToolBar : UIView
@property (nonatomic, copy) void(^sendTextBlock)(NSString *string);//发送聊天
@property (nonatomic, weak) id<KeyToolBarDelegate> delegate;

@property (nonatomic, copy) void(^textHeightChangeBlock)(NSString *text,CGFloat textHeight);

@property (nonatomic, assign) BOOL isEditing;//
@end

NS_ASSUME_NONNULL_END
