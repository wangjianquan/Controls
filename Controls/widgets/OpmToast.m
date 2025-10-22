

#import "OpmToast.h"

//Toast默认停留时间
#define FBToastDispalyDuration 1.2f
//Toast背景颜色
#define FBToastBackgroundColor [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.75]

@interface OpmToast ()
{
    UIButton *_contentView;
    CGFloat  _duration;
}

@end
@implementation OpmToast

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
}

- (id)initWithText:(NSString *)text{
    if (self = [super init]) {

        UIFont *font = [UIFont boldSystemFontOfSize:16];
        NSDictionary * dict=[NSDictionary dictionaryWithObject: font forKey:NSFontAttributeName];
        CGRect rect=[text boundingRectWithSize:CGSizeMake(250,CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,rect.size.width + 40, rect.size.height+ 20)];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.textColor = [UIColor whiteColor];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.font = font;
        textLabel.text = text;
        textLabel.numberOfLines = 0;
        
        _contentView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, textLabel.frame.size.width, textLabel.frame.size.height)];
        _contentView.layer.cornerRadius = 20.0f;
        _contentView.backgroundColor = FBToastBackgroundColor;
        [_contentView addSubview:textLabel];
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_contentView addTarget:self action:@selector(toastTaped:) forControlEvents:UIControlEventTouchDown];
        _contentView.alpha = 0.0f;
        _duration = FBToastDispalyDuration;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChanged:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    }
    
    return self;
}

- (void)deviceOrientationDidChanged:(NSNotification *)notify{
//    [self hideAnimation];
}

-(void)dismissToast{
    [_contentView removeFromSuperview];
}

-(void)toastTaped:(UIButton *)sender{
    [self hideAnimation];
}

- (void)setDuration:(CGFloat)duration{
    _duration = duration;
}

-(void)showAnimation{
    [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self->_contentView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)hideAnimation{
    [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self->_contentView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self dismissToast];
    }];
}

- (void)show{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self showInView:window];
}

- (void)showInView:(UIView *)superView {
    _contentView.center = CGPointMake(CGRectGetWidth(superView.bounds)/2.0, CGRectGetHeight(superView.bounds)/2.0);
    [superView addSubview:_contentView];
    [self showAnimation];
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:_duration];
}

- (void)showFromTopOffset:(CGFloat)top{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    _contentView.center = CGPointMake(window.center.x, top + _contentView.frame.size.height/2);
    [window  addSubview:_contentView];
    [self showAnimation];
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:_duration];
}

- (void)showFromBottomOffset:(CGFloat)bottom{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    _contentView.center = CGPointMake(window.center.x, window.frame.size.height-(bottom + _contentView.frame.size.height/2));
    [window  addSubview:_contentView];
    [self showAnimation];
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:_duration];
}

#pragma mark-中间显示
+ (void)showCenterWithText:(NSString *)text{
    [OpmToast showCenterWithText:text duration:FBToastDispalyDuration];
}

+ (void)showCenterInView:(UIView *)view withText:(NSString *)text {
    [OpmToast showCenterWithText:text duration:FBToastDispalyDuration inView:view];
}

+ (void)showCenterWithText:(NSString *)text duration:(CGFloat)duration{
    OpmToast *toast = [[OpmToast alloc] initWithText:text];
    [toast setDuration:duration];
    [toast show];
}

+ (void)showCenterWithText:(NSString *)text duration:(CGFloat)duration inView:(UIView *)superView {
    OpmToast *toast = [[OpmToast alloc] initWithText:text];
    [toast setDuration:duration];
    [toast showInView:superView];
}

#pragma mark-上方显示
+ (void)showTopWithText:(NSString *)text{
    [OpmToast showTopWithText:text  topOffset:100.0f duration:FBToastDispalyDuration];
}
+ (void)showTopWithText:(NSString *)text duration:(CGFloat)duration
{
     [OpmToast showTopWithText:text  topOffset:100.0f duration:duration];
}
+ (void)showTopWithText:(NSString *)text topOffset:(CGFloat)topOffset{
    [OpmToast showTopWithText:text  topOffset:topOffset duration:FBToastDispalyDuration];
}

+ (void)showTopWithText:(NSString *)text topOffset:(CGFloat)topOffset duration:(CGFloat)duration{
    OpmToast *toast = [[OpmToast alloc] initWithText:text];
    [toast setDuration:duration];
    [toast showFromTopOffset:topOffset];
}
#pragma mark-下方显示
+ (void)showBottomWithText:(NSString *)text{
    
    [OpmToast showBottomWithText:text  bottomOffset:100.0f duration:FBToastDispalyDuration];
}
+ (void)showBottomWithText:(NSString *)text duration:(CGFloat)duration
{
      [OpmToast showBottomWithText:text  bottomOffset:100.0f duration:duration];
}
+ (void)showBottomWithText:(NSString *)text bottomOffset:(CGFloat)bottomOffset{
    [OpmToast showBottomWithText:text  bottomOffset:bottomOffset duration:FBToastDispalyDuration];
}

+ (void)showBottomWithText:(NSString *)text bottomOffset:(CGFloat)bottomOffset duration:(CGFloat)duration{
    OpmToast *toast = [[OpmToast alloc] initWithText:text];
    [toast setDuration:duration];
    [toast showFromBottomOffset:bottomOffset];
}

@end
