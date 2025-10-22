#import "WJCountDownButton.h"

@interface WJCountDownButton() {
    NSInteger _second;
    NSUInteger _totalSecond;
    
    CountDownChanging _countDownChanging;
    CountDownFinished _countDownFinished;
    TouchedCountDownButtonHandler _touchedCountDownButtonHandler;
    CountDownErrorHandler _countDownErrorHandler;
    
    NSTimeInterval _backgroundTime;
    BOOL _shouldResumeAfterBackground;
}

@property (nonatomic, assign) BOOL isCountingDown;
@property (strong, nonatomic) dispatch_source_t timer;

@end

@implementation WJCountDownButton

#pragma mark - Lifecycle

- (void)dealloc {
    [self stopCountDown];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"WJCountDownButton dealloc");
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    _isCountingDown = NO;
    _shouldResumeAfterBackground = NO;
    [self setupNotifications];
}

- (void)setupNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillTerminate)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
}

#pragma mark - Notification Handlers

- (void)applicationDidEnterBackground {
    if (!self.isCountingDown) return;
    
    _shouldResumeAfterBackground = YES;
    _backgroundTime = [NSDate date].timeIntervalSince1970;
    
    // 暂停 GCD 定时器
    if (_timer) {
        dispatch_suspend(_timer);
    }
}

- (void)applicationWillEnterForeground {
    if (!_shouldResumeAfterBackground) return;
    
    NSTimeInterval currentTime = [NSDate date].timeIntervalSince1970;
    NSTimeInterval backgroundTime = MAX(0, currentTime - _backgroundTime);
    
    // 更新剩余时间
    _second = MAX(0, _second - (NSInteger)backgroundTime);
    
    if (_second <= 0) {
        [self stopCountDown];
    } else {
        // 恢复 GCD 定时器
        if (_timer) {
            dispatch_resume(_timer);
        }
        [self updateTitleForCurrentSecond];
    }
    
    _shouldResumeAfterBackground = NO;
}

- (void)applicationWillTerminate {
    [self stopCountDown];
}

#pragma mark - Touche Action
/** 倒计时按钮点击回调*/
- (void)countDownButtonHandler:(TouchedCountDownButtonHandler)touchedCountDownButtonHandler {
    _touchedCountDownButtonHandler = [touchedCountDownButtonHandler copy];
    [self addTarget:self action:@selector(touched:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)touched:(WJCountDownButton*)sender {
    if (self.isCountingDown) {
        if (_countDownErrorHandler) {
            NSError *error = [NSError errorWithDomain:@"WJCountDownButton"
                                                 code:1001
                                             userInfo:@{NSLocalizedDescriptionKey: @"倒计时正在进行中，请等待结束后再操作"}];
            _countDownErrorHandler(self, error);
        }
        return;
    }
    
    if (_touchedCountDownButtonHandler) {
        _touchedCountDownButtonHandler(sender, sender.tag);
    }
}

#pragma mark - Count Down Methods
/** 开始倒计时*/
- (void)startCountDownWithSecond:(NSUInteger)totalSecond {
    // 参数校验
    if (totalSecond == 0) {
        if (_countDownErrorHandler) {
            NSError *error = [NSError errorWithDomain:@"WJCountDownButton"
                                                 code:1002
                                             userInfo:@{NSLocalizedDescriptionKey: @"倒计时时间不能为0"}];
            _countDownErrorHandler(self, error);
        }
        return;
    }
    
    if (self.isCountingDown) {
        if (_countDownErrorHandler) {
            NSError *error = [NSError errorWithDomain:@"WJCountDownButton"
                                                 code:1003
                                             userInfo:@{NSLocalizedDescriptionKey: @"倒计时已经在进行中"}];
            _countDownErrorHandler(self, error);
        }
        return;
    }
    
    // 清理之前的定时器
    [self cleanupTimer];
    
    _totalSecond = totalSecond;
    _second = totalSecond;
    _isCountingDown = YES;
    self.enabled = NO;
    _shouldResumeAfterBackground = NO;
    
    [self updateTitleForCurrentSecond];
    
    // 使用 GCD 定时器避免循环引用
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    if (!_timer) {
        [self handleTimerCreationError];
        return;
    }
    
    // 设置定时器
    dispatch_source_set_timer(_timer,
                             dispatch_walltime(NULL, 0),
                             1.0 * NSEC_PER_SEC,
                             0.1 * NSEC_PER_SEC); // 允许 100ms 的误差
    
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(_timer, ^{
        typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf timerTick];
        });
    });
    
    // 启动定时器
    dispatch_resume(_timer);
}

- (void)timerTick {
    if (!self.isCountingDown) return;
    
    _second--;
    
    if (_second <= 0) {
        [self stopCountDown];
    } else {
        [self updateTitleForCurrentSecond];
    }
}

- (void)updateTitleForCurrentSecond {
    NSString *title = nil;
    
    if (_countDownChanging) {
        title = _countDownChanging(self, _second);
    }
    
    if (!title) {
        title = [NSString stringWithFormat:@"%zd秒", _second];
    }
    
    // 确保在主线程同步更新，避免闪烁
    if ([NSThread isMainThread]) {
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitle:title forState:UIControlStateDisabled];
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self setTitle:title forState:UIControlStateNormal];
            [self setTitle:title forState:UIControlStateDisabled];
        });
    }
}
/** 停止倒计时*/
- (void)stopCountDown {
    [self cleanupTimer];
    
    _isCountingDown = NO;
    _second = _totalSecond;
    self.enabled = YES;
    _shouldResumeAfterBackground = NO;
    
    [self updateFinishedTitle];
}
/** 重置倒计时状态*/
- (void)resetCountDown {
    [self stopCountDown];
    
    // 同步重置标题
    if ([NSThread isMainThread]) {
        [self setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self setTitle:@"获取验证码" forState:UIControlStateDisabled];
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self setTitle:@"获取验证码" forState:UIControlStateNormal];
            [self setTitle:@"获取验证码" forState:UIControlStateDisabled];
        });
    }
}

- (void)updateFinishedTitle {
    NSString *title = nil;
    
    if (_countDownFinished) {
        title = _countDownFinished(self, _totalSecond);
    }
    
    if (!title) {
        title = @"重新获取";
    }
    
    // 同步更新标题
    if ([NSThread isMainThread]) {
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitle:title forState:UIControlStateDisabled];
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self setTitle:title forState:UIControlStateNormal];
            [self setTitle:title forState:UIControlStateDisabled];
        });
    }
}

- (void)cleanupTimer {
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}

- (void)handleTimerCreationError {
    _isCountingDown = NO;
    self.enabled = YES;
    
    if (_countDownErrorHandler) {
        NSError *error = [NSError errorWithDomain:@"WJCountDownButton"
                                             code:1004
                                         userInfo:@{NSLocalizedDescriptionKey: @"定时器创建失败"}];
        _countDownErrorHandler(self, error);
    } else {
        NSLog(@"WJCountDownButton Error: 定时器创建失败");
    }
}

#pragma mark - Block Setters
/** 倒计时时间改变回调*/
- (void)countDownChanging:(CountDownChanging)countDownChanging {
    _countDownChanging = [countDownChanging copy];
}
/** 倒计时结束回调*/
- (void)countDownFinished:(CountDownFinished)countDownFinished {
    _countDownFinished = [countDownFinished copy];
}
/** 错误处理回调 */
- (void)countDownErrorHandler:(CountDownErrorHandler)countDownErrorHandler {
    _countDownErrorHandler = [countDownErrorHandler copy];
}

#pragma mark - Public Properties

- (BOOL)isCountingDown {
    return _isCountingDown;
}

- (NSUInteger)remainingSeconds {
    return MAX(0, _second);
}

@end
