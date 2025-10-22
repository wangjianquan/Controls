//
//  FloatingView.m
//  Controls
//
//  Created by WJQ on 2019/12/1.
//  Copyright © 2019 WJQ. All rights reserved.
//

#import "FloatingView.h"
@interface FloatingView ()

@property (nonatomic, strong)  UIView *moveView;
@property (nonatomic, strong)  UIButton *button;

@end

@implementation FloatingView

#define space 5
#define widget_Y  5
#define WJ_SafeAreaTopHeight           ([UIApplication sharedApplication].statusBarFrame.size.height == 44 ? 24 : 0)

+ (FloatingView *)sharedInstance{
    static FloatingView * floatingView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        floatingView = [[FloatingView alloc] init];
    });
    return floatingView;

}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(8, 100, 80, 80);
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
    self.moveView.clipsToBounds = YES;

    
    
    self.button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.button.frame = CGRectMake(0, 0, CGRectGetWidth(self.moveView.frame), CGRectGetHeight(self.moveView.frame));
    self.button.backgroundColor = [UIColor orangeColor];
    [self.button setTitle:@"暂停" forState:(UIControlStateNormal)];
    [self.button addTarget:self action:@selector(btnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.moveView addSubview:self.button];
    
    [self animateRotationZ:self.button];

    
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
- (void)btnAction:(UIButton *)sender{
      if (self.tapBlock) {
          self.tapBlock(sender);
      }
    
}
- (void)remove{
    [self.moveView removeFromSuperview];
}

- (void)show{
    self.isHidden = NO;
    [[UIApplication sharedApplication].delegate.window addSubview:self.moveView];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
