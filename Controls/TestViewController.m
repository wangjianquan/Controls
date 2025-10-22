//
//  TestViewController.m
//  Controls
//
//  Created by bxh on 2021/12/9.
//  Copyright © 2021 WJQ. All rights reserved.
//

#import "TestViewController.h"
#import "JYPPTTopView.h"
#import "TextViewController.h"
#import "PopAlertView.h"

@interface TestViewController ()<JYPPTTopViewDelegate>

@property (nonatomic, strong) JYPPTTopView *topView;

@property (nonatomic, assign) CGFloat selfWidth;
@property (nonatomic, strong) WJCountDownButton *countDownButton;
@property (nonatomic, strong) PopAlertView *popAlertView;

// 轮询定时器ID
@property (nonatomic, copy) NSString *detailPollingTimerID;
@property (nonatomic, copy) NSString *timerID;

@end

@implementation TestViewController
// 配置视图
- (void)setupTopView {
    self.topView.questionTitle = @"问答";
    self.topView.questionBadgeStr = @"5";
    self.topView.quesBtnEnabled = NO;
}
- (JYPPTTopView *)topView{
    if (!_topView) {
        _topView = [[JYPPTTopView alloc]init];
        _topView.open = NO;
        _topView.delegate = self;
        _topView.showQuestion = self.showQuestion;

        CGFloat width = CGRectGetWidth(self.view.frame);
        _topView.frame = CGRectMake(width - 80, kNavigationBarHeight, 50, 50);
        CGFloat maxHeight = (self.showQuestion == YES) ? 270 : 200;

        @wj_weakify(self)
        _topView.updateFrameBlock = ^(BOOL selected) {
            @wj_strongify(self)
            if (selected) {
                self.topView.frame = CGRectMake(width - 80, kNavigationBarHeight, 50, maxHeight);
            } else {
                self.topView.frame = CGRectMake(width - 80, kNavigationBarHeight, 50, 50);
            }
        };
    }
    return _topView;
}
- (PopAlertView *)popAlertView{
    if (!_popAlertView) {
        _popAlertView = [[PopAlertView alloc]init];
        CGFloat width = CGRectGetWidth(self.view.frame);
        _popAlertView.frame = CGRectMake(30, kNavigationBarHeight+20, width-60, 100);
    }
    return _popAlertView;
}
// 在控制器销毁时
- (void)dealloc {
    [self.countDownButton stopCountDown];
    [self stopPollingTimer];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.countDownButton stopCountDown];
}
-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self stopPollingTimer];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor systemGroupedBackgroundColor];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.popAlertView];
    [self createCountDownBtn];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startOperation];
}
- (void)createCountDownBtn{
    __weak __typeof(self) weakSelf = self;
    WJCountDownButton *countDownButton = [WJCountDownButton buttonWithType:UIButtonTypeCustom];
    countDownButton.frame = CGRectMake(15, kNavigationBarHeight, 120, 32);
    countDownButton.backgroundColor = [UIColor brownColor];
    [countDownButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [countDownButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [countDownButton setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
    [self.view addSubview:countDownButton];
    self.countDownButton = countDownButton;
    // 设置点击回调
    [countDownButton countDownButtonHandler:^(WJCountDownButton *countDownButton, NSInteger tag) {
        // test 发送验证码请求
        [weakSelf setupTopView];
        [weakSelf countdown];
        // 开始倒计时
        [countDownButton startCountDownWithSecond:60];
    }];
    // 设置倒计时过程中的标题变化
    [countDownButton countDownChanging:^NSString *(WJCountDownButton *countDownButton, NSUInteger second) {
        return [NSString stringWithFormat:@"剩余%zd秒",second];
    }];
    // 设置倒计时结束后的标题
    [countDownButton countDownFinished:^NSString *(WJCountDownButton *countDownButton, NSUInteger second) {
        [weakSelf.popAlertView animated];
        return @"重新获取";
    }];
    [countDownButton countDownErrorHandler:^(WJCountDownButton *countDownButton, NSError *error) {
        NSLog(@"倒计时错误: %@", error.localizedDescription);
    }];
}

#pragma mark - JYPPTTopViewDelegate
- (void)topViewQuestionAction{
    [self.navigationController pushViewController:[[DebugViewController alloc] init] animated:YES];
}
- (void)topViewAudioPlayAction {
    [self.navigationController pushViewController:[[TextViewController alloc] init] animated:YES];

}
- (void)topViewVideoPlayAction {
    [self countdown];
}

#pragma mark - 定时器管理
- (void)stopPollingTimer {
    if (self.detailPollingTimerID) {
        [[OpmTimerManager sharedManager] stopTimer:self.detailPollingTimerID];
        self.detailPollingTimerID = nil;
        NSLog(@"详情轮询timer == nil");
    } else {
        NSLog(@"详情轮询timer释放成功");
    }
}
#pragma mark - 操作流程
- (void)startOperation {
    [self stopPollingTimer];
    [self startPollingTimer];
}
#pragma mark - 创建轮询
- (void)startPollingTimer {
    if (self.detailPollingTimerID) {
        return;
    }
    __weak __typeof(self) weakSelf = self;
    self.detailPollingTimerID = [[OpmTimerManager sharedManager] createTimerWithType:TimerManagerTypeInterval totalCount:0 seconds:5 callback:^(NSInteger currentCount, BOOL *shouldStop) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        //立即执行了第一次请求，TimerManager内部是DISPATCH_TIME_NOW，之后会每5秒轮询
        [strongSelf loadData];
        NSLog(@"详情接口轮询中");
    }];
    [[OpmTimerManager sharedManager] startTimer:self.detailPollingTimerID];
}
- (void)loadData {
    //网络请求
    [OpmToast showCenterWithText:@"接口5秒轮询一次"];
}

#pragma mark - 定时器管理
- (void)invalidateTimer {
    OpmTimerManager *manager = [OpmTimerManager sharedManager];
    if (self.timerID) {
        [manager stopTimer:self.timerID];
        self.timerID = nil;
    }
}
- (void)countdown{
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(15, 2*kNavigationBarHeight, 80, 20);
    label.backgroundColor = [UIColor brownColor];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    [self invalidateTimer];
    __weak typeof(self) weakSelf = self;
    self.timerID = [[OpmTimerManager sharedManager] createTimerWithType:TimerManagerTypeCountdown totalCount:60 seconds:1.0 callback:^(NSInteger currentCount, BOOL *shouldStop) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        dispatch_async(dispatch_get_main_queue(), ^{
//            if (currentCount == 1) {
//                strongSelf.arrowLabel.hidden = YES;
//            }
            label.text = [NSString stringWithFormat:@"%ld",currentCount];
        });
    }];
    [[OpmTimerManager sharedManager] startTimer:self.timerID];
}
@end
