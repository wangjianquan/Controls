//
//  OrderProcessAlert.m
//  Controls
//
//  Created by WJQ on 2019/12/3.
//  Copyright © 2019 WJQ. All rights reserved.
//

#import "OrderProcessAlert.h"

@interface OrderProcessAlert()

@property (nonatomic, copy) NSString *desc;
/**
 按钮标题数组只读属性
 */
@property (nonatomic, strong) NSArray  * titles;
@property (nonatomic, strong) UIView *contentView;

@end

#define Ratio_375 (SCREEN_WIDTH/375.0)
/**转换成当前比例的数*/
#define Ratio(x) ((int)((x) * Ratio_375))
#define DEFAULT_MAX_HEIGHT SCREEN_HEIGHT/3*2
#define YB_SAFE_BLOCK(BlockName, ...) ({ !BlockName ? nil : BlockName(__VA_ARGS__); })

@implementation OrderProcessAlert

+ (void)showOrderProcessAlert:(NSString *)description buttonTitles:(NSArray *)btnTitles otherSettings:(void (^)(OrderProcessAlert * _Nonnull))otherSetting{
    
    OrderProcessAlert * alert = [[OrderProcessAlert alloc]initWithDes:description buttonTitles:btnTitles];
    YB_SAFE_BLOCK(otherSetting,alert);
    [[UIApplication sharedApplication].delegate.window addSubview:alert];
}

- (instancetype)initWithDes:(NSString *)description buttonTitles:(NSArray *)titles
{
    self = [super init];
    if (self) {
        self.desc = description;
        self.titles = titles;
        [self setupUI];
    }
    return self;
}
- (void)setupUI{
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3/1.0];
    
    //获取更新内容高度
    CGFloat descHeight = [self _sizeofString:self.desc font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(self.frame.size.width - Ratio(80) - Ratio(56), CGFLOAT_MAX)].height;
    
    //bgView实际高度
    CGFloat realHeight = descHeight + Ratio(208);
    
    //bgView最大高度
    CGFloat maxHeight = DEFAULT_MAX_HEIGHT;
    //更新内容可否滑动显示
    BOOL scrollEnabled = NO;
    
    //重置bgView最大高度 设置更新内容可否滑动显示
    if (realHeight > DEFAULT_MAX_HEIGHT) {
        scrollEnabled = YES;
        descHeight = DEFAULT_MAX_HEIGHT - Ratio(208);
    }else
    {
        maxHeight = realHeight;
    }
    
    //backgroundView
    UIView *bgView = [[UIView alloc]init];
    bgView.center = self.center;
    bgView.backgroundColor = [UIColor clearColor];
    bgView.bounds = CGRectMake(0, 0, self.frame.size.width - Ratio(40), maxHeight);
    [self addSubview:bgView];
    
    //添加更新提示
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(Ratio(20), 0, bgView.frame.size.width - Ratio(40), maxHeight)];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.masksToBounds = YES;
    contentView.layer.cornerRadius = 4.0f;
    [bgView addSubview:contentView];
    self.contentView = contentView;
    
    
    //20+60+20+28+10+descHeight+20+40+20 = 314+descHeight 内部元素高度计算bgView高度
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake((contentView.frame.size.width - Ratio(60))/2, Ratio(40), Ratio(60), Ratio(60))];
    icon.image = [UIImage imageNamed:@"icon_warn_w"];
    [contentView addSubview:icon];
    
    
    //更新内容
    UITextView *descTextView = [[UITextView alloc]initWithFrame:CGRectMake(Ratio(28), Ratio(20) + CGRectGetMaxY(icon.frame), contentView.frame.size.width - Ratio(56), descHeight)];
    descTextView.font = [UIFont systemFontOfSize:15];
    descTextView.textContainer.lineFragmentPadding = 0;
    descTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    descTextView.text = self.desc;
    descTextView.editable = NO;
    descTextView.selectable = NO;
    descTextView.textAlignment = NSTextAlignmentCenter;
    descTextView.scrollEnabled = scrollEnabled;
    descTextView.showsVerticalScrollIndicator = scrollEnabled;
    descTextView.showsHorizontalScrollIndicator = NO;
    [contentView addSubview:descTextView];
    
    if (scrollEnabled) {
        //若显示滑动条，提示可以有滑动条
        [descTextView flashScrollIndicators];
    }
    
//    //更新按钮
//    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    sureButton.backgroundColor = [UIColor redColor];
//    sureButton.clipsToBounds = YES;
//    sureButton.layer.cornerRadius = 2.0f;
//    [sureButton addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
//    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [contentView addSubview:sureButton];
//
//    //取消按钮
//    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    cancelButton.backgroundColor = [UIColor redColor];
//    cancelButton.clipsToBounds = YES;
//    cancelButton.layer.cornerRadius = 2.0f;
//    [cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
//    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [contentView addSubview:cancelButton];
//    if (self.titles.count == 1) {
//
//    }
    for (int i = 0; i<self.titles.count; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
        if (self.titles.count == 1) {
            btn.frame = CGRectMake(Ratio(25), maxHeight - Ratio(20) - Ratio(40), contentView.frame.size.width - Ratio(50), Ratio(40));
            btn.backgroundColor = [UIColor redColor];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        }else if (self.titles.count == 2){
//            btn.frame = CGRectMake(15+i*(30+(kMAIN_SCREEN_WIDTH-15*2-30*2)/3), 44+4, (kMAIN_SCREEN_WIDTH-15*2-30*2)/3, 36);

            CGFloat btnWidth = (contentView.frame.size.width - Ratio(50)-10)/2;
            btn.frame = CGRectMake(Ratio(25) + i *(10+btnWidth), maxHeight - Ratio(20) - Ratio(40), btnWidth, Ratio(40));
            if (i == 0) {
                [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
                btn.layer.borderWidth = 1.0f;
            } else {
                btn.backgroundColor = [UIColor redColor];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
        }
        [btn setTitle:self.titles[i] forState:(UIControlStateNormal)];
        btn.tag = i;
        btn.clipsToBounds = YES;
        btn.layer.cornerRadius = 3.0f;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:btn];
    }
    //显示更新
    [self showWithAlert:bgView];
}

- (void)setCornerRadius:(CGFloat)cornerRadius{
    _cornerRadius = cornerRadius;
    self.contentView.cornerRadius = _cornerRadius;
}

- (void)btnAction:(UIButton * )sender{
   
    if ([self.delegate respondsToSelector:@selector(orderProcessAlertSureBtnAction:)]) {
        [self.delegate orderProcessAlertSureBtnAction:sender.titleLabel.text];
    }
    [self dismissAlert];

}
/** 更新按钮点击事件 跳转AppStore更新 */
- (void)sureBtnAction
{
//    NSString *appId = @"1280760449";
//    NSString *str = [NSString stringWithFormat:@"http://itunes.apple.com/us/app/id%@", appId];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    [self dismissAlert];
}

/** 取消按钮点击事件 */
- (void)cancelAction{
    [self dismissAlert];
}

/**
  *添加Alert入场动画
*/
- (void)showWithAlert:(UIView *)alert{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.6f;
    
    NSMutableArray * values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [alert.layer addAnimation:animation forKey:nil];
}

/**
  *添加Alert出场动画
 */
- (void)dismissAlert{
    [UIView animateWithDuration:0.6f animations:^{
        self.transform = (CGAffineTransformMakeScale(1.5, 1.5));
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0;
    }completion:^(BOOL finished) {
       
//        self.delegate = nil;
        [self removeFromSuperview];
    } ];
}

/**
 计算字符串高度
 @param string 字符串
 @param font 字体大小
 @param maxSize 最大Size
 @return 计算得到的Size
 */
- (CGSize)_sizeofString:(NSString *)string font:(UIFont *)font maxSize:(CGSize)maxSize
{
    return [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
