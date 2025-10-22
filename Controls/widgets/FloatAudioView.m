//
//  FloatAudioView.m
//  YunTingKeTang
//
//  Created by wjq on 2019/4/23.
//  Copyright © 2019 云听课堂. All rights reserved.
//

#import "FloatAudioView.h"
#import <UIKit/UIKit.h>

#define SafeAreaBottomHeight        ([UIApplication sharedApplication].statusBarFrame.size.height == 44 ? 34 : 0)
#define WJ_SafeAreaTopHeight           ([UIApplication sharedApplication].statusBarFrame.size.height == 44 ? 24 : 0)
@interface FloatAudioView ()
{
    UIView  * _line1;
    UIView  * _line2;
}

@property (nonatomic, strong)  UIView *moveView;
@property (nonatomic, strong)  UIButton *iconBtn;
@property (nonatomic, strong)  UIButton *closeBtn;
@property (nonatomic, strong)  UIButton *playBtn;

@end

@implementation FloatAudioView

#define space 5
#define widget_Y  5

+ (FloatAudioView *)sharedInstance{
    static FloatAudioView * floatAudioView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        floatAudioView = [[FloatAudioView alloc] init];
    });
    return floatAudioView;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(8, 100, 160, 40);
        self.backgroundColor = [UIColor whiteColor];
        [self setUI];
    }
    return self;
}

- (void)setUI {
    self.moveView = [[UIView alloc]initWithFrame:self.frame];
    self.moveView.backgroundColor = [UIColor whiteColor];
    self.moveView.layer.cornerRadius = self.frame.size.height/2;
    self.moveView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.moveView.layer.shadowOffset = CGSizeMake(0,3);
    self.moveView.layer.shadowOpacity = 0.5;
    self.moveView.layer.shadowRadius = 5;
//    self.moveView.clipsToBounds = YES;

    
    CGFloat btnWidth = self.moveView.frame.size.height - 2 * widget_Y;

    
    self.playBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.playBtn.frame = CGRectMake(_moveView.center.x-btnWidth/2, widget_Y, btnWidth, btnWidth);
    [self.playBtn setImage:[UIImage imageNamed:@"暂停"] forState:(UIControlStateNormal)];
    [self.playBtn setImage:[UIImage imageNamed:@"播放"] forState:(UIControlStateSelected)];
    [self.playBtn addTarget:self action:@selector(playAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.moveView addSubview:self.playBtn];

    _line1 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.playBtn.frame) - 2 * space, 2 * widget_Y, 1.5, (self.frame.size.height - 4 * widget_Y))];
    _line1.backgroundColor = [UIColor darkGrayColor];
    [self.moveView addSubview:_line1];
    
    _line2 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.playBtn.frame) + 2 * space, _line1.frame.origin.y, 1.5, _line1.frame.size.height)];
    _line2.backgroundColor = [UIColor darkGrayColor];
    [self.moveView addSubview:_line2];
    
    
    self.iconBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.iconBtn.frame = CGRectMake(2 * space, widget_Y, btnWidth, btnWidth);
    self.iconBtn.imageView.layer.cornerRadius = btnWidth/2;
    [self.iconBtn setImage:[UIImage imageNamed:@"xuezhiqian"] forState:(UIControlStateNormal)];
    [self.iconBtn addTarget:self action:@selector(iconAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.moveView addSubview:self.iconBtn];
    
    
    self.closeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.closeBtn.frame = CGRectMake(self.frame.size.width - 2 * space - btnWidth, widget_Y, btnWidth, btnWidth);
    self.closeBtn.layer.cornerRadius = btnWidth/2;
    [self.closeBtn setImage:[UIImage imageNamed:@"关闭"] forState:(UIControlStateNormal)];
    [self.closeBtn addTarget:self action:@selector(closeBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.moveView addSubview:self.closeBtn];
    [self animateRotationZ:self.iconBtn];

    
//    [[UIApplication sharedApplication].delegate.window addSubview:self.moveView];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [self.moveView addGestureRecognizer:panGesture];
    
}
- (void)animateRotationZ:(UIView *)view{
    [view.layer removeAllAnimations];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue = [NSNumber numberWithFloat: M_PI *2];
    animation.duration = 10;
    animation.autoreverses = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = MAXFLOAT; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
    [view.layer addAnimation:animation forKey:nil];
}
- (void)iconAction:(UIButton *)sender{
    if (self.tapBlock) {
        self.tapBlock(sender);
    }
}

- (void)playAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    [self animateRotationZ:self.iconBtn];
}

- (void)setImageName:(NSString *)imageName{

}
- (void)closeBtnAction:(UIButton *)sender{
    [self.moveView removeFromSuperview];

}

- (void)show{
    self.isHidden = NO;
    [[UIApplication sharedApplication].delegate.window addSubview:self.moveView];
}

- (void)remove{
    
}

- (void)hiddenFloat{
    
}

- (void)setIsHidden:(BOOL)isHidden{
    self.moveView.hidden = isHidden;
}

- (void)panGesture:(UIPanGestureRecognizer *)gesture{
    UIWindow * superView = [UIApplication sharedApplication].delegate.window;
    CGPoint position = [gesture locationInView:superView];
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.moveView.alpha = 0.5;
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            self.moveView.center = position;
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            CGFloat x = 8;
            if (position.x > SCREEN_WIDTH * 0.5) {
                x = SCREEN_WIDTH - self.moveView.frame.size.width - 8;
            }
            
            // 防止和 statusBar 下拉手势冲突 , 上方始终保持 20 间距
            CGFloat y = 0;
            CGFloat safeBottom = 10;
            if (kIsBangsScreen) {
                safeBottom = 34;
            }
            CGFloat maxY = SCREEN_HEIGHT - self.moveView.frame.size.height - safeBottom;

            if(position.y <= WJ_SafeAreaTopHeight + kStatusBarHeight){
                
                y = position.y + WJ_SafeAreaTopHeight + kStatusBarHeight;
            }else if (position.y > maxY) {
                
                y = SCREEN_HEIGHT - self.moveView.frame.size.height - safeBottom;
            }else{
                
                y = position.y;
            }
           
            CGRect newFrame = CGRectMake(x, y, self.moveView.frame.size.width, self.moveView.frame.size.height);
            [UIView animateWithDuration:0.3 animations:^{
                self.moveView.frame = newFrame;
                self.moveView.alpha = 1;
            }];
        }
            break;
        default:
            break;
    }
}

@end
