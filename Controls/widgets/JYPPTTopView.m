//
//  JYPPTTopView.m
//  dsd
//
//  Created by bxh on 2021/12/3.
//

#import "JYPPTTopView.h"
#import "UIButton+ImageTitleSpacing.h"

@interface JYPPTTopView()

@property (nonatomic, strong) UIButton *audioBtn;
@property (nonatomic, strong) UIButton *videoBtn;
@property (nonatomic, strong) UIButton *questionBtn;
@property (nonatomic, strong) UIButton *arrowBtn;
@property (nonatomic, strong) UILabel *questionBadge;

@end

@implementation JYPPTTopView

- (UIButton *)audioBtn{
    if (!_audioBtn) {
        _audioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _audioBtn.exclusiveTouch = YES;
        _audioBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_audioBtn setImage:[UIImage imageNamed:@"ppt-audio"] forState:UIControlStateNormal];
        [_audioBtn setTitle:@"音频" forState:(UIControlStateNormal)];
        [_audioBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [_audioBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateDisabled)];
        [_audioBtn addTarget:self action:@selector(audioBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _audioBtn;
}

- (UIButton *)videoBtn{
    if (!_videoBtn) {
        _videoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _videoBtn.exclusiveTouch = YES;
        _videoBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_videoBtn setImage:[UIImage imageNamed:@"ppt-video"] forState:UIControlStateNormal];
        [_videoBtn setTitle:@"视频" forState:(UIControlStateNormal)];
        [_videoBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [_videoBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateDisabled)];
        [_videoBtn addTarget:self action:@selector(videoBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _videoBtn;
}

- (UIButton *)questionBtn{
    if (!_questionBtn) {
        _questionBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _questionBtn.exclusiveTouch = YES;
        _questionBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_questionBtn setImage:[UIImage imageNamed:@"ppt-question"] forState:UIControlStateNormal];
        [_questionBtn setTitle:@"提问" forState:(UIControlStateNormal)];
        [_questionBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
               [_questionBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateDisabled)];
        [_questionBtn addTarget:self action:@selector(questionBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _questionBtn;
}
- (UILabel *)questionBadge{
    if (!_questionBadge) {
        _questionBadge = [[UILabel alloc] init];
        _questionBadge.layer.cornerRadius = 6;
        _questionBadge.clipsToBounds = YES;
        _questionBadge.backgroundColor = [UIColor redColor];
        _questionBadge.textAlignment = NSTextAlignmentCenter;
        _questionBadge.textColor = [UIColor whiteColor];
        _questionBadge.font = [UIFont systemFontOfSize:9];
        _questionBadge.adjustsFontSizeToFitWidth = YES;
        _questionBadge.hidden = YES;
    }
    return _questionBadge;
}

- (UIButton *)arrowBtn{
    if (!_arrowBtn) {
        _arrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _arrowBtn.exclusiveTouch = YES;
        _arrowBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_arrowBtn setTitle:@"收起" forState:(UIControlStateNormal)];
        [_arrowBtn setImage:[UIImage imageNamed:@"ppt-expand"]  forState:UIControlStateNormal];
        [_arrowBtn setImage:[UIImage imageNamed:@"ppt-shrink"] forState:UIControlStateSelected];
        [_arrowBtn addTarget:self action:@selector(arrowAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _arrowBtn;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUI];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setOpen:(BOOL)open{
    _open = open;
    self.arrowBtn.selected = _open;
    [_arrowBtn setTitleColor:(_open == YES) ? [UIColor blackColor] : [UIColor clearColor] forState:UIControlStateNormal];
}

- (void)setUI{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 25;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0,0);
    self.layer.shadowOpacity = 0.2;
    self.layer.shadowRadius = 3;
    
    [self addSubview:self.arrowBtn];
    [self addSubview:self.audioBtn];
    [self addSubview:self.videoBtn];
    [self addSubview:self.questionBtn];
    [self.questionBtn addSubview:self.questionBadge];
    self.showQuestion = YES;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    NSInteger count = (self.showQuestion == YES) ? 4 : 3;
    
    CGFloat space = 10;
    CGFloat btnW = CGRectGetWidth(self.frame);
    CGFloat btnH = (CGRectGetHeight(self.frame)-3*space)/count;

    self.arrowBtn.frame = CGRectMake(0, space, btnW, btnW);
    self.audioBtn.frame = CGRectMake(0, CGRectGetMaxY(self.arrowBtn.frame)+space, btnW, btnH);
    self.videoBtn.frame = CGRectMake(0, CGRectGetMaxY(self.audioBtn.frame), btnW, btnH);
   
    self.audioBtn.hidden = !self.open;
    self.videoBtn.hidden = !self.open;
    self.questionBtn.hidden = !self.open;

    [self.arrowBtn wh_layoutButtonWithEdgeInsetsStyle:JRButtonEdgeInsetsStyleTop imageTitleSpace:7];
    [self.audioBtn wh_layoutButtonWithEdgeInsetsStyle:JRButtonEdgeInsetsStyleTop imageTitleSpace:7];
    [self.videoBtn wh_layoutButtonWithEdgeInsetsStyle:JRButtonEdgeInsetsStyleTop imageTitleSpace:7];
    
    if (self.showQuestion == YES) {
        self.questionBtn.hidden = !(self.open && self.showQuestion);
        self.questionBtn.frame = CGRectMake(0, CGRectGetMaxY(self.videoBtn.frame), btnW, btnH);
        self.questionBadge.frame = CGRectMake(CGRectGetWidth(self.questionBtn.frame)-23, CGRectGetHeight(self.questionBtn.frame)-33, 20, 12);
        [self.questionBtn wh_layoutButtonWithEdgeInsetsStyle:JRButtonEdgeInsetsStyleTop imageTitleSpace:7];
    }
}


- (void)setShowQuestion:(BOOL)showQuestion{
    _showQuestion = showQuestion;
}

- (void)setQuesBtnEnabled:(BOOL)quesBtnEnabled{
    _quesBtnEnabled = quesBtnEnabled;
    self.questionBtn.enabled = !_quesBtnEnabled;
}

- (void)setQuestionTitle:(NSString *)questionTitle{
    _questionTitle = questionTitle;
    if (_questionTitle) {
        [_questionBtn setTitle:questionTitle forState:UIControlStateNormal];
    }
}

#pragma mark - 角标
- (void)setQuestionBadgeStr:(NSString *)questionBadgeStr{
    _questionBadgeStr = questionBadgeStr;
    if (_questionBadgeStr) {
        self.questionBadge.hidden = (_questionBadgeStr.length > 0) ? NO : YES;
        if (_questionBadgeStr.length > 0) {
            self.questionBadge.text = ([_questionBadgeStr integerValue] > 99) ? @"99+" : _questionBadgeStr;
        }
    }
}

#pragma mark - btn action
- (void)audioBtnAction{
    if (_delegate) {
        [_delegate topViewAudioPlayAction];
    }
}

- (void)videoBtnAction{
    if (_delegate) {
        [_delegate topViewVideoPlayAction];
    }
}

- (void)questionBtnAction{
    if (_delegate) {
        [_delegate topViewQuestionAction];
    }
}

- (void)arrowAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    self.open = sender.selected;
    if (_updateFrameBlock) {
        _updateFrameBlock(sender.selected);
    }
    [self layoutSubviews];
}


@end
