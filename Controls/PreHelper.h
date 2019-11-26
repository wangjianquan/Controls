//
//  PreHelper.h
//  PickerImageDemo
//
//  Created by WJQ on 2019/11/25.
//  Copyright © 2019 WJQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PreHelper : NSObject

+ (UIViewController *)getCurrentViewControll;

+ (UIImage *)getWaterMarkImage: (UIImage *)originalImage andTitle: (NSString *)title andMarkFont: (UIFont *)markFont andMarkColor: (UIColor *)markColor;
+(UIColor*)mostColor:(UIImage*)image;


@end

NS_ASSUME_NONNULL_END
