// OpmTimerManager.h
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TimerManagerType) {
    TimerManagerTypeCountdown,   // 倒计时定时器
    TimerManagerTypeInterval,    // 间隔定时器
    TimerManagerTypeOnceDelay    // 一次性延迟定时器
};

typedef NS_ENUM(NSInteger, TimerManagerStatus) {
    TimerManagerStatusStopped,   // 已停止
    TimerManagerStatusRunning,   // 运行中
    TimerManagerStatusPaused     // 已暂停
};

typedef void (^TimerManagerCallback)(NSInteger currentCount, BOOL *shouldStop);

@interface OpmTimerManager : NSObject

+ (instancetype)sharedManager;

- (NSString *)createTimerWithType:(TimerManagerType)type
                       totalCount:(NSInteger)totalCount
                          seconds:(NSTimeInterval)seconds
                         callback:(TimerManagerCallback)callback;

- (void)startTimer:(NSString *)timerID;
- (void)pauseTimer:(NSString *)timerID;
- (void)resumeTimer:(NSString *)timerID;
- (void)stopTimer:(NSString *)timerID;

- (void)removeAllTimers;

- (TimerManagerStatus)statusForTimer:(NSString *)timerID;
- (NSInteger)remainingCountForTimer:(NSString *)timerID;

@end
