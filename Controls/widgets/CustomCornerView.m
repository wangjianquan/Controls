//
//  CustomCornerView.m
//  YBPopupMenuDemo
//
//  Created by WJQ on 2019/12/3.
//  Copyright © 2019 LYB. All rights reserved.
//

#import "CustomCornerView.h"

@interface CustomCornerView ()

@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UILabel *titleLabel;


@property (nonatomic) CGRect                relyRect;
@property (nonatomic, assign) CGFloat       itemWidth;
@property (nonatomic) CGPoint               point;
@property (nonatomic, assign) BOOL          isCornerChanged;
@property (nonatomic, strong) UIColor     * separatorColor;
@property (nonatomic, assign) BOOL          isChangeDirection;

@end
#define WJ_SAFE_BLOCK(BlockName, ...) ({ !BlockName ? nil : BlockName(__VA_ARGS__); })

@implementation CustomCornerView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setDefaultSettings];
    }
    return self;
}
+ (CustomCornerView *)showRelyOnView:(UIView *)view titles:(NSString *)titleString menuWidth:(CGFloat)itemWidth otherSettings:(void (^)(CustomCornerView * _Nonnull))otherSetting{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect absoluteRect = [view convertRect:view.bounds toView:window];
    CGPoint relyPoint = CGPointMake(absoluteRect.origin.x + absoluteRect.size.width / 2, absoluteRect.origin.y + absoluteRect.size.height);

    
    CustomCornerView * customCorner = [[CustomCornerView alloc]init];
    customCorner.point = relyPoint;
    customCorner.relyRect = absoluteRect;
    customCorner.title = titleString;
    customCorner.itemWidth = itemWidth;
    WJ_SAFE_BLOCK(otherSetting,customCorner);
    [customCorner show];
    return customCorner;
}

+ (CustomCornerView *)showAtPoint:(CGPoint)point titles:(NSString *)titleString menuWidth:(CGFloat)itemWidth otherSettings:(void (^)(CustomCornerView * _Nonnull))otherSetting
{
    CustomCornerView * customCorner = [[CustomCornerView alloc]init];
    customCorner.point = point;
    customCorner.title = titleString;
    customCorner.itemWidth = itemWidth;
    WJ_SAFE_BLOCK(otherSetting,customCorner);
    [customCorner show];
    return customCorner;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
        tap.numberOfTouchesRequired = 1; //手指数
        tap.numberOfTapsRequired = 1; //tap次数
        _titleLabel.userInteractionEnabled = YES;
        [_titleLabel addGestureRecognizer:tap];
    }
    return _titleLabel;
}
- (UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setTitle:@"x" forState:(UIControlStateNormal)];
        [_closeBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_closeBtn addTarget:self action:@selector(closeAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _closeBtn;
}

- (void)setDefaultSettings{
    self.cornerRadius = 5.0;
    _rectCorner = UIRectCornerTopLeft|UIRectCornerTopRight|UIRectCornerBottomRight;
    self.isShowShadow = YES;
    self.dismissOnSelected = YES;
    self.dismissOnTouchOutside = YES;
    self.fontSize = 13;
    self.textColor = [UIColor whiteColor];
    self.offset = 0.0;
    self.relyRect = CGRectZero;
    self.point = CGPointZero;
    self.backColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    self.minSpace = 12.0;
    self.maxVisibleCount = 3;
    self.isCornerChanged = NO;
    self.alpha = 0;
    self.backgroundColor = self.backColor;
    [self addSubview:self.closeBtn];
    [self addSubview:self.titleLabel];
}

//显示
- (void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
//    [UIView animateWithDuration: 0.25 animations:^{
//        self.layer.affineTransform = CGAffineTransformMakeScale(1.0, 1.0);
//        self.alpha = 1;
//    } completion:^(BOOL finished) {
//
//    }];
    
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        self.layer.affineTransform = CGAffineTransformMakeScale(1.0, 1.0);
        self.alpha = 1;
    } completion:^(BOOL finished) {

    }];
}
- (void)dismiss{
//    [UIView animateWithDuration: 0.25 animations:^{
//        self.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
//        self.alpha = 0;
//    } completion:^(BOOL finished) {
//        self.delegate = nil;
//        [self removeFromSuperview];
//    }];
    
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
            self.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
            self.alpha = 0;
        } completion:^(BOOL finished) {
            self.delegate = nil;
            [self removeFromSuperview];
        }];
}

- (void)tapGesture:(UITapGestureRecognizer *)gesture{
    if ([_delegate respondsToSelector:@selector(tapGestureLabel:)]) {
        [_delegate tapGestureLabel:self.titleLabel.text];
    }
    if (_dismissOnSelected == YES) {
        [self dismiss];
    }
}
- (void)closeAction:(UIButton *)sender{
    if (_dismissOnTouchOutside == YES) {
        [self dismiss];
    }
}

/*
 ** setter
 */
- (void)setIsShowShadow:(BOOL)isShowShadow{
    _isShowShadow = isShowShadow;
    self.layer.shadowOpacity = isShowShadow ? 0.5 : 0;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowRadius = isShowShadow ? 2.0 : 0;
}

- (void)setFontSize:(CGFloat)fontSize{
    _fontSize = fontSize;
    self.titleLabel.font = [UIFont systemFontOfSize:_fontSize];
}

- (void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    self.titleLabel.textColor = textColor;
}

- (void)setPoint:(CGPoint)point{
    _point = point;
    [self updateUI];
}

- (void)setItemWidth:(CGFloat)itemWidth{
    _itemWidth = itemWidth;
    [self updateUI];
}

- (void)setMaxVisibleCount:(NSInteger)maxVisibleCount{
    _maxVisibleCount = maxVisibleCount;
    self.titleLabel.numberOfLines = _maxVisibleCount;
    if (_maxVisibleCount == 1) {
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    [self updateUI];
}

- (void)setBackColor:(UIColor *)backColor{
    _backColor = backColor;
    self.backgroundColor = _backColor;
    [self updateUI];
}
- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = _title;
    [self updateUI];
}

- (void)setRectCorner:(UIRectCorner)rectCorner{
    _rectCorner = rectCorner;
    [self updateUI];
}

- (void)setCornerRadius:(CGFloat)cornerRadius{
    _cornerRadius = cornerRadius;
    [self updateUI];
}

- (void)setOffset:(CGFloat)offset{
    _offset = offset;
    [self updateUI];
}

- (void)updateUI{

     _isChangeDirection = NO;
    if (_itemWidth == 0) return;
   
    CGFloat closeBtnWH = 18;
    CGFloat textHeight = 20;
    CGFloat textWidth = _itemWidth - _minSpace - (closeBtnWH+_minSpace/2) - _minSpace/2;// 15 closeBtn.widht;
    CGSize  textSize = [_title boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:_fontSize]} context:nil].size;
    if (textSize.height > 60) {
        textHeight = 60;
    }else if (textSize.height < 15){
        textHeight = 20;
    }else{
        textHeight = textSize.height;
    }

    self.frame = CGRectMake(_point.x, _point.y, _itemWidth, textHeight + 2 * _minSpace);

    self.closeBtn.frame = CGRectMake(_itemWidth-closeBtnWH-_minSpace/2, (self.frame.size.height - closeBtnWH)/2, closeBtnWH, closeBtnWH);
    self.titleLabel.frame = CGRectMake(_minSpace,_minSpace, textWidth, textHeight);
    
//    [self setRelyRect];

//    [self setAnchorPoint];
//    [self setOffset];

    [self setNeedsDisplay];
}

- (void)setRelyRect
{
    if (CGRectEqualToRect(_relyRect, CGRectZero)) {
        return;
    }
    if (_rectCorner == UIRectCornerTopRight || _rectCorner == UIRectCornerTopLeft ) {
        _point.y = _relyRect.size.height + _relyRect.origin.y;
    }else if (_rectCorner == UIRectCornerBottomLeft || _rectCorner == UIRectCornerBottomRight) {
        _point.y = _relyRect.origin.y;
    }else if (_rectCorner == UIRectCornerBottomLeft || UIRectCornerTopLeft) {
        _point = CGPointMake(_relyRect.origin.x + _relyRect.size.width, _relyRect.origin.y + _relyRect.size.height / 2);
    }else {
        _point = CGPointMake(_relyRect.origin.x, _relyRect.origin.y + _relyRect.size.height / 2);
    }
}
- (void)setAnchorPoint{
    if (_itemWidth == 0) return;
    CGPoint point = CGPointMake(0.5, 0.5);
    CGRect originRect = self.frame;
    self.layer.anchorPoint = point;
    self.frame = originRect;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    self.backgroundColor = _backColor;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:_rectCorner cornerRadii:CGSizeMake(_cornerRadius, _cornerRadius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

@end
