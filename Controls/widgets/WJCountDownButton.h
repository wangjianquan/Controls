#import <UIKit/UIKit.h>

@class WJCountDownButton;

typedef NSString * _Nullable (^CountDownChanging)(WJCountDownButton *countDownButton, NSUInteger second);
typedef NSString * _Nullable (^CountDownFinished)(WJCountDownButton *countDownButton, NSUInteger second);
typedef void (^TouchedCountDownButtonHandler)(WJCountDownButton *countDownButton, NSInteger tag);
typedef void (^CountDownErrorHandler)(WJCountDownButton *countDownButton, NSError *error);

NS_ASSUME_NONNULL_BEGIN

@interface WJCountDownButton : UIButton

@property (nonatomic, strong, nullable) id userInfo;
/** 是否正在倒计时*/
@property (nonatomic, assign, readonly) BOOL isCountingDown;
/** 剩余秒数 */
@property (nonatomic, assign, readonly) NSUInteger remainingSeconds;

/** 倒计时按钮点击回调*/
- (void)countDownButtonHandler:(TouchedCountDownButtonHandler)touchedCountDownButtonHandler;
/** 倒计时时间改变回调*/
- (void)countDownChanging:(CountDownChanging)countDownChanging;
/** 倒计时结束回调*/
- (void)countDownFinished:(CountDownFinished)countDownFinished;
/** 错误处理回调 */
- (void)countDownErrorHandler:(CountDownErrorHandler)countDownErrorHandler;

/** 开始倒计时*/
- (void)startCountDownWithSecond:(NSUInteger)second;
/** 停止倒计时*/
- (void)stopCountDown;
/** 重置倒计时状态*/
- (void)resetCountDown;

@end

NS_ASSUME_NONNULL_END
