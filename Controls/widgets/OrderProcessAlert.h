//
//  OrderProcessAlert.h
//  Controls
//
//  Created by WJQ on 2019/12/3.
//  Copyright © 2019 WJQ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol OrderProcessAlertDelegate <NSObject>

- (void)orderProcessAlertSureBtnAction:(NSString *)btnTitle;

@end

@interface OrderProcessAlert : UIView


@property (nonatomic, weak) id<OrderProcessAlertDelegate> delegate;

@property (nonatomic, assign) CGFloat cornerRadius;

/**
 
 */
+ (void)showOrderProcessAlert:(NSString *)description
                 buttonTitles:(NSArray *)btnTitles
                          otherSettings:(void (^) (OrderProcessAlert * orderProcess))otherSetting;

@end

NS_ASSUME_NONNULL_END
