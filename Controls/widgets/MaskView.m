//
//  MaskView.m
//  Controls
//
//  Created by MacBook Pro on 2020/1/15.
//  Copyright © 2020 WJQ. All rights reserved.
//

#import "MaskView.h"

@interface MaskView ()

@property (assign, readonly, nonatomic) CGFloat maskRadius;

@property (assign, readonly, nonatomic) BannerSrollDirection direction;

@end

@implementation MaskView

- (void)setRadius:(CGFloat)radius direction:(BannerSrollDirection)dir{
    _maskRadius = radius;
    _direction = dir;

    if (_direction != BannerSrollDirectionUnknow) {
       [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect {
    self.backgroundColor = [UIColor clearColor];
    if (_direction != BannerSrollDirectionUnknow) {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        if (_direction == BannerSrollDirectionLeft){
            CGContextAddArc(ctx, self.center.x + rect.size.width/2, rect.size.height/2, _maskRadius, 0, M_PI * 2, NO);
        }else{
            CGContextAddArc(ctx, self.center.x - rect.size.width/2, rect.size.height/2, _maskRadius, 0, M_PI * 2, NO);
        }
        CGContextSetFillColorWithColor(ctx, [[UIColor yellowColor] CGColor]);
        CGContextFillPath(ctx);
//        CGContextRelease(ctx);
    }
}

@end
