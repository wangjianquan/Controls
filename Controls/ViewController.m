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
#import "FloatAudioView.h"
#import "FloatingView.h"
#import "CustomCornerView.h"
#import "OrderProcessAlert.h"
#import "BannerVC.h"
#import "TestVC.h"

@interface ViewController ()<KeyToolBarDelegate,UITextViewDelegate,OrderProcessAlertDelegate>
@property (nonatomic, strong) TextViewKeyBoardToolBar *keyboardToolBar;
@property (nonatomic, assign) CGFloat keyBoardHeight;

@property (nonatomic, strong) AnimationLabel * animationLabel;
@property (weak, nonatomic) IBOutlet UILabel *edgeLabel;

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
            [MBProgressHUD showText:string];
        };
    }
    return _keyboardToolBar;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
    [[FloatingView sharedInstance]show];
    [[FloatAudioView sharedInstance]show];

    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[FloatingView sharedInstance]remove];
    [[FloatAudioView sharedInstance]remove];
}

- (void)orderProcessAlertSureBtnAction:(NSString *)btnTitle{
    NSLog(@"orderProcessAlertSureBtnAction : %@",btnTitle);
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];


    
  
}
- (void)bannerAction{
    BannerVC * vc = [[BannerVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _edgeLabel.contentInsets = UIEdgeInsetsMake(2, 4, 2, 4);

    _animationLabel = [[AnimationLabel   alloc]initWithFrame:CGRectMake(15, 230, self.view.frame.size.width/2, 40)];
    _animationLabel.text = @"AnimationLabel测试：当内容文字的宽度大于当前控件的宽度时，内容横向滚动，否则不滚动";
    _animationLabel.textColor = [UIColor blackColor];
    _animationLabel.font = [UIFont systemFontOfSize:14];
    _animationLabel.speed = 0.25;
    _animationLabel.backgroundColor = [UIColor brownColor];
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
    
    
//    [CustomCornerView showAtPoint:CGPointMake(30, 200) titles:@"陕西省西安市高新技术产业开发区天谷七路与云水一路交汇处西北侧雁塔区大雁塔街道广场东路3号" menuWidth:200 otherSettings:^(CustomCornerView * _Nonnull corner) {
//           corner.cornerRadius = 10;
//           corner.rectCorner = UIRectCornerTopRight | UIRectCornerBottomLeft;
//    }];
       
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"banner" style:(UIBarButtonItemStylePlain) target:self action:@selector(bannerAction)];
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

#pragma mark --

- (IBAction)hudAction:(UIButton *)sender {
   

}
- (IBAction)alertAction:(id)sender {
    [SELUpdateAlert showUpdateAlertWithVersion:@"1.2" Descriptions:@[@"性能优化"]];

    [OrderProcessAlert showOrderProcessAlert:@"该订单用时62分钟，超时2分钟，此订单将扣除￥2元，具体收益以签收时为准，以后接送单要准时该订单用时62分钟，超时2分钟，此订单将扣除￥2元，具体收益以签收时为准，以后接送单要准时" buttonTitles:@[@"我知道了",@"确认到店"] otherSettings:^(OrderProcessAlert * _Nonnull orderProcess) {
        orderProcess.cornerRadius = 15;
        orderProcess.delegate = self;
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
