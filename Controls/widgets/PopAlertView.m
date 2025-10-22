//
//  PopAlertView.m
//  GiantWheat
//
//  Created by WJQ on 2019/11/26.
//  Copyright © 2019 jumaihuishou. All rights reserved.
//

#import "PopAlertView.h"

#import "RadianLayerView.h"

@interface PopAlertView ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) RadianLayerView *radianLayerView;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIButton *cancelBtn;

@end

@implementation PopAlertView
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]initWithFrame:CGRectZero];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelAction)];
        _backView.userInteractionEnabled = YES;
        [_backView addGestureRecognizer:tap];
    }
    return _backView;
}

-(UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentView.backgroundColor    = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 5;
    }
    return _contentView;
}
- (RadianLayerView *)radianLayerView{
    if (!_radianLayerView) {
        _radianLayerView = [[RadianLayerView alloc]initWithFrame:CGRectZero];
        _radianLayerView.backgroundColor = [UIColor orangeColor];
        _radianLayerView.layer.cornerRadius = 5;
    }
    return _radianLayerView;
}
- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _bgImageView.image       = [UIImage imageNamed:@"xuezhiqian"];
        _bgImageView.contentMode  = UIViewContentModeScaleAspectFit;
        _bgImageView.userInteractionEnabled = YES;
    }
    return _bgImageView;
}


- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont systemFontOfSize:23];
        _titleLabel.text = @"发布成功!";
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel{
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _subTitleLabel.text = @"审核中~审核成功可在首页查看";
        _subTitleLabel.font = [UIFont systemFontOfSize:13];
        _subTitleLabel.textColor = [UIColor darkGrayColor];
        _subTitleLabel.numberOfLines = 1;
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _subTitleLabel;
}

-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType: UIButtonTypeSystem];
       [_cancelBtn setBackgroundColor:[UIColor orangeColor]];
       [_cancelBtn setBackgroundImage:[UIImage imageNamed:@"ppt-back"] forState:UIControlStateNormal];
       [_cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)animated{
    [self setUI];
}

-(void)setUI{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;

    CGFloat contentView_Width = screenWidth - 2*45;
    CGFloat contentView_Height = screenWidth - 45;

    self.backView.frame = CGRectMake(0,0,screenWidth,screenHeight);
    // 模糊背景
    self.contentView.frame = CGRectMake(45, (screenHeight - contentView_Height)/2, contentView_Width, contentView_Height);
    self.cancelBtn.frame = CGRectMake(CGRectGetWidth(self.contentView.frame)-10-23, 10, 23, 23);
    
    self.radianLayerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), CGRectGetWidth(self.contentView.frame)/3*2);
    self.radianLayerView.direction = RadianDirectionBottom;
    self.radianLayerView.radian = 25;
    
    self.bgImageView.frame = CGRectMake((CGRectGetWidth(self.radianLayerView.frame)-CGRectGetWidth(self.radianLayerView.frame)/2)/2, 45, CGRectGetWidth(self.radianLayerView.frame)/2, CGRectGetWidth(self.radianLayerView.frame)/2);

    
    self.titleLabel.frame = CGRectMake(0, CGRectGetMaxY(self.radianLayerView.frame) + 45, CGRectGetWidth(self.contentView.frame), 21);
    self.subTitleLabel.frame =  CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame) + 15, CGRectGetWidth(self.contentView.frame), 21);
    
    
   
    [self.contentView addSubview:self.radianLayerView];
    [self.contentView addSubview:self.cancelBtn];

    [self.radianLayerView addSubview:self.bgImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subTitleLabel];
    [self.backView addSubview:self.contentView];
//    [self addSubview:self.backView];
    [[UIApplication sharedApplication].delegate.window addSubview:self.backView];
    [[UIApplication sharedApplication].delegate.window addSubview:self];
   
    __weak typeof (self) weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
//        weakSelf.contentView.mj_y = (screenHeight - weakSelf.contentView.mj_h)/2;
        weakSelf.backView.backgroundColor =  [[UIColor blackColor]colorWithAlphaComponent:0.7f];
    }];
}


-(void)cancelAction{
    [self removeAllCustomView];
}

// 移除背景
-(void)removeAllCustomView{
    __weak typeof (self) weakSelf = self;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;

    [UIView animateWithDuration:0.25 animations:^{
//        weakSelf.contentView.mj_y = screenHeight + weakSelf.mj_h;
//        weakSelf.backView.backgroundColor =  [UIColor clearColor];
    } completion:^(BOOL finished) {
        [weakSelf.backView removeFromSuperview];
        [weakSelf removeFromSuperview];
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
