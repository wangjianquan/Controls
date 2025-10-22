//
//  UILabel+Insets.h
//  Controls
//
//  Created by jieyue on 2019/11/14.
//  Copyright © 2019 WJQ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (Insets)

/// 内容边距
@property (nonatomic, assign) UIEdgeInsets contentInsets;

/// 快速创建带内边距的Label
+ (instancetype)labelWithContentInsets:(UIEdgeInsets)contentInsets;

@end

NS_ASSUME_NONNULL_END
