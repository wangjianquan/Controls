//
//  UIColor+OpmExtension.m
//  OpmSDK
//
//  Created by Wennan on 2025/7/29.
//

#import "UIColor+OpmExtension.h"

@implementation UIColor(OpmExtension)

+ (UIColor *)opmColorWithHexStr:(NSString *)string {
    return [UIColor opmColorWithHexStr:string alpha:1.0];
}

+ (UIColor *)opmColorWithHexStr:(NSString *)string alpha:(CGFloat)alpha {
    NSString *str;
    if ([string containsString:@"#"]) {
        str = [string substringFromIndex:1];
    } else {
        str = string;
    }
    
    NSScanner *scanner = [[NSScanner alloc] initWithString:str];
    UInt32 hexNum = 0;
    if ([scanner scanHexInt:&hexNum] == NO) {
        NSLog(@"16进制转UIColor, hexString为空");
    }
    
    return [UIColor opmColorWithR:(hexNum & 0xFF0000) >> 16 g:(hexNum & 0x00FF00) >> 8 b:hexNum & 0x0000FF a:alpha];
}

+ (UIColor *)opmColorWithR:(CGFloat)red g:(CGFloat)green b:(CGFloat)blue a:(CGFloat)alpha {
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:alpha];
}

+ (NSString *)opmHexStringWithColor:(UIColor *)color {
    {
        CGFloat r, g, b, a;
        BOOL bo = [color getRed:&r green:&g blue:&b alpha:&a];
        if (bo) {
            int rgb = (int) (r * 255.0f)<<16 | (int) (g * 255.0f)<<8 | (int) (b * 255.0f)<<0;
            return [NSString stringWithFormat:@"#%06x", rgb].uppercaseString;
        } else {
            return @"";
        }
    }
}

- (BOOL)opmColorIsWhite {
    CGFloat red = 0;
    CGFloat green = 0;
    CGFloat blue = 0;
    [self getRed:&red green:&green blue:&blue alpha:NULL];
    if (red >= 0.99 && green >= 0.99 & blue >= 0.99) {
        return YES;
    }
    return NO;
}

@end
