//
//  PMPHShopBadgeButton.m
//  JYPMPHShop
//
//  Created by MacBook Pro on 2020/11/27.
//

#import "PMPHShopBadgeButton.h"

@implementation PMPHShopBadgeButton
- (instancetype)init{
    self = [super init];
    if (self) {
        [self setUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        [self setUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.adjustsImageWhenHighlighted = NO;
    self.titleLabel.layer.cornerRadius = 8;
    self.titleLabel.layer.masksToBounds = YES;
    self.titleLabel.font = [UIFont systemFontOfSize:10];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.badgeOffset_X = 0;
    self.badgeOffset_Y = 0;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(CGRectGetWidth(self.frame)-16-self.badgeOffset_X, self.badgeOffset_Y, 16, 16);
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state{
    [super setTitle:title forState:state];
    NSInteger value = [title integerValue];
    if (title.length > 0 && value > 0) {
        self.titleLabel.backgroundColor = [UIColor redColor];
        [self setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    }else{
        self.titleLabel.backgroundColor = [UIColor clearColor];
        [self setTitleColor:[UIColor clearColor] forState:(UIControlStateNormal)];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
