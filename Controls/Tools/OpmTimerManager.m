// OpmTimerManager.m
#import "OpmTimerManager.h"

@interface OpmTimerManager () {
    dispatch_queue_t _timerAccessQueue;
}

@property (nonatomic, strong) NSMutableDictionary<NSString *, dispatch_source_t> *timers;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSNumber *> *remainingCounts;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSNumber *> *timerStatus;
@property (nonatomic, strong) NSMutableDictionary<NSString *, TimerManagerCallback> *callbacks;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSNumber *> *suspendCounts;

@end

@implementation OpmTimerManager

+ (instancetype)sharedManager {
    static OpmTimerManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // 创建串行队列用于安全访问
        _timerAccessQueue = dispatch_queue_create("com.timermanager.access", DISPATCH_QUEUE_SERIAL);
        
        // 初始化字典
        _timers = [NSMutableDictionary dictionary];
        _remainingCounts = [NSMutableDictionary dictionary];
        _timerStatus = [NSMutableDictionary dictionary];
        _callbacks = [NSMutableDictionary dictionary];
        _suspendCounts = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - 定时器管理

- (NSString *)createTimerWithType:(TimerManagerType)type
                       totalCount:(NSInteger)totalCount
                          seconds:(NSTimeInterval)seconds
                         callback:(TimerManagerCallback)callback {
    
    NSString *timerID = [[NSUUID UUID] UUIDString];
    
    dispatch_sync(_timerAccessQueue, ^{
        self.remainingCounts[timerID] = @(totalCount);
        self.timerStatus[timerID] = @(TimerManagerStatusStopped);
        self.callbacks[timerID] = [callback copy];
        self.suspendCounts[timerID] = @0;
    });
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, _timerAccessQueue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, seconds * NSEC_PER_SEC, 0.1 * NSEC_PER_SEC);
    
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(timer, ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        
        // 由于已经在 _timerAccessQueue 上，直接访问状态
        if (!strongSelf.timers[timerID]) return;
        
        NSInteger currentCount = [strongSelf.remainingCounts[timerID] integerValue];
        TimerManagerCallback callbackCopy = [strongSelf.callbacks[timerID] copy];
        
        if (!callbackCopy) return;
        
        // 切换到主线程执行回调
        dispatch_async(dispatch_get_main_queue(), ^{
            BOOL shouldStop = NO;
            callbackCopy(currentCount, &shouldStop);
            
            // 处理定时器逻辑（回到串行队列）
            dispatch_async(strongSelf->_timerAccessQueue, ^{
                // 再次检查定时器是否有效
                if (!strongSelf.timers[timerID]) return;
                
                switch (type) {
                    case TimerManagerTypeCountdown: {
                        NSInteger newCount = currentCount - 1;
                        strongSelf.remainingCounts[timerID] = @(newCount);
                        
                        if (newCount <= 0 || shouldStop) {
                            [strongSelf stopTimerInternal:timerID];
                        }
                        break;
                    }
                        
                    case TimerManagerTypeInterval: {
                        if (shouldStop) {
                            [strongSelf stopTimerInternal:timerID];
                        }
                        break;
                    }
                        
                    case TimerManagerTypeOnceDelay: {
                        [strongSelf stopTimerInternal:timerID];
                        break;
                    }
                }
            });
        });
    });
    
    dispatch_sync(_timerAccessQueue, ^{
        self.timers[timerID] = timer;
    });
    
    return timerID;
}

#pragma mark - 定时器控制

- (void)startTimer:(NSString *)timerID {
    dispatch_sync(_timerAccessQueue, ^{
        dispatch_source_t timer = self.timers[timerID];
        if (!timer) {
            NSLog(@"TimerManager: Timer with ID %@ not found", timerID);
            return;
        }
        
        TimerManagerStatus status = [self.timerStatus[timerID] integerValue];
        if (status == TimerManagerStatusRunning) return;
        
        // 处理暂停状态恢复
        NSInteger suspendCount = [self.suspendCounts[timerID] integerValue];
        if (suspendCount > 0) {
            for (NSInteger i = 0; i < suspendCount; i++) {
                dispatch_resume(timer);
            }
            self.suspendCounts[timerID] = @0;
        }
        
        // 首次启动
        if (status == TimerManagerStatusStopped) {
            dispatch_resume(timer);
        }
        
        self.timerStatus[timerID] = @(TimerManagerStatusRunning);
    });
}

- (void)pauseTimer:(NSString *)timerID {
    dispatch_sync(_timerAccessQueue, ^{
        dispatch_source_t timer = self.timers[timerID];
        if (!timer) {
            NSLog(@"TimerManager: Timer with ID %@ not found", timerID);
            return;
        }
        
        TimerManagerStatus status = [self.timerStatus[timerID] integerValue];
        if (status != TimerManagerStatusRunning) return;
        
        // 更新挂起计数
        NSInteger suspendCount = [self.suspendCounts[timerID] integerValue] + 1;
        self.suspendCounts[timerID] = @(suspendCount);
        
        // 首次挂起才实际暂停
        if (suspendCount == 1) {
            dispatch_suspend(timer);
        }
        
        self.timerStatus[timerID] = @(TimerManagerStatusPaused);
    });
}

- (void)resumeTimer:(NSString *)timerID {
    dispatch_sync(_timerAccessQueue, ^{
        dispatch_source_t timer = self.timers[timerID];
        if (!timer) {
            NSLog(@"TimerManager: Timer with ID %@ not found", timerID);
            return;
        }
        
        TimerManagerStatus status = [self.timerStatus[timerID] integerValue];
        if (status != TimerManagerStatusPaused) return;
        
        // 更新挂起计数
        NSInteger suspendCount = [self.suspendCounts[timerID] integerValue];
        if (suspendCount <= 0) {
            self.timerStatus[timerID] = @(TimerManagerStatusRunning);
            return;
        }
        
        // 恢复一次挂起
        suspendCount--;
        self.suspendCounts[timerID] = @(suspendCount);
        
        // 实际恢复
        if (suspendCount == 0) {
            dispatch_resume(timer);
            self.timerStatus[timerID] = @(TimerManagerStatusRunning);
        }
    });
}

- (void)stopTimer:(NSString *)timerID {
    dispatch_sync(_timerAccessQueue, ^{
        [self stopTimerInternal:timerID];
    });
}

#pragma mark - 内部停止方法
- (void)stopTimerInternal:(NSString *)timerID {
    dispatch_source_t timer = self.timers[timerID];
    if (!timer) return;
    
    // 确保定时器在恢复状态
    NSInteger suspendCount = [self.suspendCounts[timerID] integerValue];
    if (suspendCount > 0) {
        self.suspendCounts[timerID] = @0;
        for (NSInteger i = 0; i < suspendCount; i++) {
            dispatch_resume(timer);
        }
    }
    
    // 取消定时器
    if (dispatch_source_testcancel(timer) == 0) {
        dispatch_source_cancel(timer);
    }
    
    // 清理资源
    [self.timers removeObjectForKey:timerID];
    [self.remainingCounts removeObjectForKey:timerID];
    [self.timerStatus removeObjectForKey:timerID];
    [self.suspendCounts removeObjectForKey:timerID];
    [self.callbacks removeObjectForKey:timerID];
}

#pragma mark - 批量操作

- (void)removeAllTimers {
    dispatch_sync(_timerAccessQueue, ^{
        NSArray<NSString *> *timerIDs = [self.timers allKeys].copy;
        for (NSString *timerID in timerIDs) {
            [self stopTimerInternal:timerID];
        }
    });
}

#pragma mark - 状态查询

- (TimerManagerStatus)statusForTimer:(NSString *)timerID {
    __block TimerManagerStatus status = TimerManagerStatusStopped;
    dispatch_sync(_timerAccessQueue, ^{
        NSNumber *statusNumber = self.timerStatus[timerID];
        if (statusNumber) {
            status = [statusNumber integerValue];
        }
    });
    return status;
}

- (NSInteger)remainingCountForTimer:(NSString *)timerID {
    __block NSInteger count = 0;
    dispatch_sync(_timerAccessQueue, ^{
        NSNumber *countNumber = self.remainingCounts[timerID];
        if (countNumber) {
            count = [countNumber integerValue];
        }
    });
    return count;
}

#pragma mark - 生命周期

- (void)dealloc {
    [self removeAllTimers];
}

@end
