//
//  WJProgressView.m
//  CuiGPS
//
//  Created by landixing on 2018/7/26.
//  Copyright © 2018年 WJQ. All rights reserved.
//

#import "WJProgressView.h"

@implementation WJProgressView
- (void)setProgress:(CGFloat)progress{
    _progress = MIN(1, MAX(0, progress));
    [self setNeedsDisplay];
}
- (void)setProgressColor:(UIColor *)progressColor{
    _progressColor = progressColor;
    [self setNeedsDisplay];
}
- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGPoint center = CGPointMake(rect.size.width * 0.5, rect.size.height * 0.5);
    CGFloat radius = rect.size.width * 0.5 - 8;
    CGFloat startAngle = -M_PI_2;
    CGFloat endAngle = (M_PI*2) * _progress + startAngle;
    
    UIBezierPath * bezierPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    [bezierPath addLineToPoint:center];
    [bezierPath closePath];
    if (_progressColor) {
        [_progressColor setFill];
    } else {
        [[UIColor colorWithWhite:1.0 alpha:0.2] setFill];
    }
    [bezierPath fill];
    
    UIBezierPath * closePath = [UIBezierPath bezierPathWithArcCenter:center radius:radius + 5 startAngle: startAngle endAngle: (M_PI*2) + startAngle clockwise:YES];
    if (_progressColor) {
        [_progressColor setStroke];
    } else {
        [[UIColor colorWithWhite:1.0 alpha:0.2] setStroke];
    }
    [closePath stroke];
}


@end
