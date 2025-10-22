//
//  UIColor+OpmExtension.h
//  OpmSDK
//
//  Created by Wennan on 2025/7/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor(OpmExtension)

+ (UIColor *)opmColorWithHexStr:(NSString *)string;
+ (UIColor *)opmColorWithHexStr:(NSString *)string alpha:(CGFloat)alpha;
+ (UIColor *)opmColorWithR:(CGFloat)red g:(CGFloat)green b:(CGFloat)blue a:(CGFloat)alpha;
+ (NSString *)opmHexStringWithColor:(UIColor *)color;
- (BOOL)opmColorIsWhite;

@end

NS_ASSUME_NONNULL_END
