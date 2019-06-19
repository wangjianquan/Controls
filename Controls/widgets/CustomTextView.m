//
//  CustomTextView.m
//  Controls
//
//  Created by wjq on 2019/6/18.
//  Copyright © 2019 WJQ. All rights reserved.
//

#import "CustomTextView.h"

@interface CustomTextView ()
/**
 *  占位文字View: 为什么使用UITextView，这样直接让占位文字View = 当前textView,文字就会重叠显示
 */
@property (nonatomic, weak) UITextView * placeholderView;

@property (assign, nonatomic) NSInteger  textHeight; //文字高度

@property (assign, nonatomic) NSInteger maxTextHeight; //最大文字高度
@end

@implementation CustomTextView
- (UITextView *)placeholderView{
    if (!_placeholderView) {
        UITextView * placeholderView  = [[UITextView alloc]init];
        _placeholderView = placeholderView;
        _placeholderView.scrollEnabled = NO;
        _placeholderView.showsHorizontalScrollIndicator = NO;
        _placeholderView.showsVerticalScrollIndicator = NO;
        _placeholderView.userInteractionEnabled = NO;
        _placeholderView.font = self.font;
        _placeholderView.textColor = [UIColor lightGrayColor];
        _placeholderView.backgroundColor = [UIColor clearColor];
        [self addSubview:placeholderView];
    }
    return _placeholderView;
}


- (void)awakeFromNib{
    [super awakeFromNib];
    [self setUp];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setUp];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self  = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp{
    self.scrollEnabled = NO;
    self.scrollsToTop = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.enablesReturnKeyAutomatically = YES;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 5;
    self.layer.borderColor = [[UIColor lightTextColor]CGColor];
    self.backgroundColor = [UIColor whiteColor];
    self.font = [UIFont systemFontOfSize:14];
    self.placeholderColor = [UIColor orangeColor];
    self.placeholder = @"说点什么...";
    self.maxNumberOfLines = 3;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    
    __weak __typeof(&*self)weakSelf = self;
    self.changeBlock = ^{
        [weakSelf textDidChange];
    };
}

- (void)setMaxNumberOfLines:(NSUInteger)maxNumberOfLines{
    
    _maxNumberOfLines = maxNumberOfLines;
    
    //计算最大高度 = (每行高度* 总行数 + 文字上下间距)
    _maxTextHeight = ceil(self.font.lineHeight * maxNumberOfLines + self.textContainerInset.top + self.textContainerInset.bottom);
}


- (void)setCornerRadius:(NSUInteger)cornerRadius{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
}

- (void)setYz_textHeightChangeBlock:(void (^)(NSString *, CGFloat))yz_textHeightChangeBlock{
    _yz_textHeightChangeBlock = yz_textHeightChangeBlock;
    [self textDidChange];
    
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor  = placeholderColor;
    self.placeholderView.textColor = placeholderColor;
}

- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    self.placeholderView.text = placeholder;
}

- (void)textDidChange{
    
    //占位符隐藏 = 文字的长度大于0
    self.placeholderView.hidden = self.text.length > 0;
    
    NSInteger height = ceil([self sizeThatFits:CGSizeMake(self.bounds.size.width, MAXFLOAT)].height);
    
    if (_textHeight != height) { //高度不一样, 就改变高度
        
        //最大高度, 可以滚动
        self.scrollEnabled = height > _maxTextHeight && _maxTextHeight > 0;
        
        _textHeight = height;
        if (_yz_textHeightChangeBlock && self.scrollEnabled == NO) { // && self.scrollEnabled == NO
            _yz_textHeightChangeBlock(self.text, height);
            [self.superview layoutIfNeeded];
            self.placeholderView.frame = self.bounds;
        }
    }
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
