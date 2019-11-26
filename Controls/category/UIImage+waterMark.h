//
//  UIImage+waterMark.h
//  PickerImageDemo
//
//  Created by WJQ on 2019/11/27.
//  Copyright © 2019 WJQ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (waterMark)
/**
 *  打水印
 *      本地图片
 *  @param backgroundImage   背景图片
 *  @param markName 右下角的水印图片
 */
+ (instancetype)waterMarkWithImageName:(NSString *)backgroundImage andMarkImageName:(NSString *)markName;
/**
*  打水印
*  @param backgroundImage   图片
*  @param markName  右下角的水印图片(
*/
+ (instancetype)waterMarkWithImage:(UIImage *)backgroundImage andMarkImageName:(NSString *)markName;

@end

NS_ASSUME_NONNULL_END
