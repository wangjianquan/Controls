//
//  ViewController.m
//  Controls
//
//  Created by landixing on 2018/8/1.
//  Copyright © 2018年 WJQ. All rights reserved.
//

#import "ViewController.h"
#import "AnimationLabel.h"



@interface ViewController ()<KeyToolBarDelegate,UITextViewDelegate>
@property (nonatomic, strong) TextViewKeyBoardToolBar *keyboardToolBar;
@property (nonatomic, assign) CGFloat keyBoardHeight;
@property (nonatomic, strong) AnimationLabel * animationLabel;
@end

@implementation ViewController

- (TextViewKeyBoardToolBar *)keyboardToolBar{
    if (!_keyboardToolBar) {
        _keyboardToolBar = [[TextViewKeyBoardToolBar alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT-keyboardToolBar_height - SafeAreaBottomHeight ,SCREEN_WIDTH, keyboardToolBar_height)];

        _keyboardToolBar.delegate = self;
        WS(weakSelf);
        _keyboardToolBar.sendTextBlock = ^(NSString *string) {
            CGRect tempRect = weakSelf.keyboardToolBar.frame;
            tempRect.size.height = keyboardToolBar_height;
            tempRect.origin.y = SCREEN_HEIGHT - CGRectGetHeight(tempRect) - SafeAreaBottomHeight;
            weakSelf.keyboardToolBar.frame = tempRect;
            NSLog(@"发送: %@",string);
        };
        
        
    }
    return _keyboardToolBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _animationLabel = [[AnimationLabel   alloc]initWithFrame:CGRectMake(20, 200, self.view.frame.size.width/2, 40)];
    _animationLabel.text = @"AnimationLabel测试：当内容文字的宽度大于当前控件的宽度时，内容横向滚动，否则不滚动";
    _animationLabel.textColor = [UIColor blackColor];
    _animationLabel.font = [UIFont systemFontOfSize:14];
    _animationLabel.speed = 0.25;
    [self.view addSubview:_animationLabel];
    [_animationLabel startAnimation];
    
    self.keyboardToolBar.delegate = self;
    self.keyBoardHeight = 0;
    WS(weakSelf);
    self.keyboardToolBar.textHeightChangeBlock = ^(NSString * _Nonnull text, CGFloat textHeight) {
        NSLog(@"%@ , %f",text, textHeight);
//        self.tempRect.size.height = textHeight;
        CGRect tempRect = weakSelf.keyboardToolBar.frame;
        tempRect.size.height = textHeight;
        tempRect.origin.y = SCREEN_HEIGHT - (self.keyBoardHeight + textHeight);

        weakSelf.keyboardToolBar.frame = tempRect;
        
    };

    [self.view addSubview:self.keyboardToolBar];
}
#pragma mark - inputView deleaget输入键盘的代理
//键盘将要出现
-(void)keyBoardWillShow:(CGFloat)height endEditIng:(BOOL)endEditIng{
    self.keyBoardHeight = height;
    // 添加移动动画，使视图跟随键盘移动
    [UIView animateWithDuration:0.25 animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:7];
        CGRect tempRect = self.keyboardToolBar.frame;
        tempRect.origin.y = SCREEN_HEIGHT - (height + CGRectGetHeight(tempRect));
        self.keyboardToolBar.frame = tempRect;
        
//        self.keyboardToolBar.frame = CGRectMake(0,SCREEN_HEIGHT - keyboardToolBar_height - height ,SCREEN_WIDTH, keyboardToolBar_height);
    }];
    [self.view layoutIfNeeded];
}

//隐藏键盘
-(void)hiddenKeyBoard{

    CGRect tempRect = self.keyboardToolBar.frame;
    tempRect.origin.y = SCREEN_HEIGHT - CGRectGetHeight(tempRect) - SafeAreaBottomHeight;
    self.keyboardToolBar.frame = tempRect;
//    self.keyboardToolBar.frame = CGRectMake(0,SCREEN_HEIGHT-keyboardToolBar_height - SafeAreaBottomHeight ,SCREEN_WIDTH, keyboardToolBar_height);
    [UIView animateWithDuration:0.1f animations:^{
        //        self.keyboardToolBar.hidden = YES;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
