//
//  ViewController.m
//  Controls
//
//  Created by landixing on 2018/8/1.
//  Copyright © 2018年 WJQ. All rights reserved.
//

#import "ViewController.h"
#import "AnimationLabel.h"
#import "SELUpdateAlert.h"
#import "VideoPlayerContainerView.h"
#import "JYPPTTopView.h"
#import "TestViewController.h"
#import "RAViewController.h"
#import "PortraitViewController.h"
#import "CustomRingProgressView.h"
#import "FloatAudioView.h"
#import "FloatingView.h"
#import "CustomCornerView.h"
#import "OrderProcessAlert.h"
#import "BannerVC.h"
#import "HUDVC.h"

@interface ViewController ()<KeyToolBarDelegate,UITextViewDelegate,OrderProcessAlertDelegate>
@property (nonatomic, strong) TextViewKeyBoardToolBar *keyboardToolBar;
@property (nonatomic, assign) CGFloat keyBoardHeight;
@property (nonatomic, strong) AnimationLabel *animationLabel;
@property (nonatomic, strong) UILabel *edgeLabel;

@end

@implementation ViewController

- (TextViewKeyBoardToolBar *)keyboardToolBar{
    if (!_keyboardToolBar) {
        _keyboardToolBar = [[TextViewKeyBoardToolBar alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT-keyboardToolBar_height - SafeAreaBottomHeight-kTabBarHeight ,SCREEN_WIDTH, keyboardToolBar_height)];

        _keyboardToolBar.delegate = self;
        _keyboardToolBar.delegate = self;
        _keyboardToolBar = 0;
        WS(weakSelf);
        _keyboardToolBar.textHeightChangeBlock = ^(NSString * _Nonnull text, CGFloat textHeight) {
            NSLog(@"%@ , %f",text, textHeight);
    //        self.tempRect.size.height = textHeight;
            CGRect tempRect = weakSelf.keyboardToolBar.frame;
            tempRect.size.height = textHeight;
            tempRect.origin.y = SCREEN_HEIGHT - (self.keyBoardHeight + textHeight);

            weakSelf.keyboardToolBar.frame = tempRect;
            
        };
        
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[FloatingView sharedInstance] show];
    [[FloatAudioView sharedInstance] show];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[FloatingView sharedInstance] remove];
    [[FloatAudioView sharedInstance] remove];
}
- (void)updateAlert{
    [SELUpdateAlert showUpdateAlertWithVersion:@"1.2" Descriptions:@[@"性能优化:陕西省西安市高新技术产业开发区天谷七路与云水一路交汇处西北侧雁塔区大雁塔街道广场东路3号"]];
}
- (void)orderAlert{
    [OrderProcessAlert showOrderProcessAlert:@"该订单用时62分钟，超时2分钟，此订单将扣除￥2元，具体收益以签收时为准，以后接送单要准时该订单用时62分钟，超时2分钟，此订单将扣除￥2元，具体收益以签收时为准，以后接送单要准时" buttonTitles:@[@"我知道了",@"确认到店"] otherSettings:^(OrderProcessAlert * _Nonnull orderProcess) {
        orderProcess.cornerRadius = 15;
        orderProcess.delegate = self;
    }];
}

- (void)alertCorner{
    [CustomCornerView showAtPoint:CGPointMake(30, 200) titles:@"陕西省西安市高新技术产业开发区天谷七路与云水一路交汇处西北侧雁塔区大雁塔街道广场东路3号" menuWidth:200 otherSettings:^(CustomCornerView * _Nonnull corner) {
           corner.cornerRadius = 10;
           corner.rectCorner = UIRectCornerTopRight | UIRectCornerBottomLeft;
    }];
}
- (void)openHUDVC{
    [self.navigationController pushViewController:[[HUDVC alloc] init] animated:YES];
}

- (void)openSystemSetting {
    NSString *identifier = NSBundle.mainBundle.bundleIdentifier;
    NSString *prefs = [NSString stringWithFormat:@"App-Prefs:root=NOTIFICATIONS_ID&path=%@)",identifier];
    NSURL * URL = [NSURL URLWithString:prefs];
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:URL]) {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:URL];
        }
    }
}
- (void)openTestVC{
    TestViewController * vc = [[TestViewController alloc] init];
    vc.showQuestion = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)openBannerVC{
    BannerVC *vc = [[BannerVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.keyboardToolBar];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"轮播图" style:(UIBarButtonItemStylePlain) target:self action:@selector(openBannerVC)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"videoAction" style:(UIBarButtonItemStylePlain) target:self action:@selector(alertCorner)];

    VideoPlayerContainerView *vpcView = [[VideoPlayerContainerView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight, [UIScreen mainScreen].bounds.size.width, 200)];
    [self.view addSubview:vpcView];
    vpcView.urlVideo = @"https://www.apple.com/105/media/cn/researchkit/2016/a63aa7d4_e6fd_483f_a59d_d962016c8093/films/carekit/researchkit-carekit-cn-20160321_848x480.mp4";
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(15, CGRectGetMaxY(vpcView.frame)+15, 120, 30);
    btn1.backgroundColor = [UIColor brownColor];
    btn1.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn1 setTitle:@"打开系统设置" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(openSystemSetting) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(CGRectGetMaxX(btn1.frame) +15, CGRectGetMinY(btn1.frame), 100, 30);
    btn2.backgroundColor = [UIColor brownColor];
    btn2.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn2 setTitle:@"openTestVC" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(openTestVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake(CGRectGetMaxX(btn2.frame) + 15, CGRectGetMinY(btn1.frame), 120, 30);
    btn3.backgroundColor = [UIColor brownColor];
    btn3.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn3 setTitle:@"updateAlert" forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(updateAlert) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn4.frame = CGRectMake(15, CGRectGetMaxY(btn1.frame)+15, 120, 30);
    btn4.backgroundColor = [UIColor brownColor];
    btn4.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn4 setTitle:@"orderAlert" forState:UIControlStateNormal];
    [btn4 addTarget:self action:@selector(orderAlert) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn4];
    
    UIButton *btn5 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn5.frame = CGRectMake(CGRectGetMaxX(btn4.frame)+5, CGRectGetMaxY(btn1.frame)+15, 60, 30);
    btn5.backgroundColor = [UIColor brownColor];
    btn5.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn5 setTitle:@"HUDVC" forState:UIControlStateNormal];
    [btn5 addTarget:self action:@selector(openHUDVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn5];
    
        
    _animationLabel = [[AnimationLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(btn5.frame)+5, CGRectGetMaxY(btn1.frame)+15, self.view.frame.size.width/2, 23)];
    _animationLabel.text = @"AnimationLabel测试：当内容文字的宽度大于当前控件的宽度时，内容横向滚动，否则不滚动";
    _animationLabel.textColor = [UIColor blackColor];
    _animationLabel.font = [UIFont systemFontOfSize:14];
    _animationLabel.speed = 0.25;
    _animationLabel.backgroundColor = [UIColor brownColor];
    [self.view addSubview:_animationLabel];
    [_animationLabel startAnimation];

    _edgeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(_animationLabel.frame)+15, 60, 18)];
    _edgeLabel.contentInsets = UIEdgeInsetsMake(2, 4, 2, 4);
    _edgeLabel.text = @"内边距label";
    _edgeLabel.font = [UIFont systemFontOfSize:12];
    _edgeLabel.backgroundColor = [UIColor orangeColor];
    _edgeLabel.textColor = [UIColor whiteColor];
    _edgeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_edgeLabel];
    
    WJProgressView * progress = [[WJProgressView alloc]init];
    progress.frame = CGRectMake(15, CGRectGetMaxY(_edgeLabel.frame)+15, 60, 60);
    progress.progress = 0.8;
    progress.progressColor = [UIColor redColor];
    [self.view addSubview:progress];
    
    OpmCustomButton *opmBtn = [[OpmCustomButton alloc] initWithImagePosition:ImagePositionBottom spacing:8 buttonType:OpmButtonTypeLight];
    opmBtn.frame = CGRectMake(15+60+10, CGRectGetMinY(progress.frame), 80, 80);
    [opmBtn setImage:[UIImage imageNamed:@"ppt-video"] forState:UIControlStateNormal];
    [opmBtn setTitle:@"图片文字位置" forState:UIControlStateNormal];
    [opmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [opmBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    opmBtn.showImgBgColorView = YES;
    opmBtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:opmBtn];
    
    
    // 创建中等尺寸指示器
    OpmActivityIndicatorView *indicator =
        [[OpmActivityIndicatorView alloc] initWithStyle:OpmActivityIndicatorViewStyleLarge];
    // 设置位置
    indicator.center = self.view.center;
    // 自定义颜色
    indicator.color = [UIColor blueColor];
    // 添加到视图
    [self.view addSubview:indicator];
    // 开始动画
    [indicator startAnimating];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        // 停止动画（5秒后）
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            // 停止动画（带淡出效果）
//            [indicator stopAnimating];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [indicator startAnimating];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(120 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [indicator stopAnimating];
//                });
//            });
//        });
//    });
    
    
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
