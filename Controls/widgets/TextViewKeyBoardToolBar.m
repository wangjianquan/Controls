//
//  TextViewKeyBoardToolBar.m
//  YunTingKeTang
//
//  Created by wjq on 2019/6/17.
//  Copyright © 2019 西安三八妇乐. All rights reserved.
//

#import "TextViewKeyBoardToolBar.h"

@interface TextViewKeyBoardToolBar ()<UITextViewDelegate>

// (弹幕按钮 + textField + 发送)
@property (nonatomic, strong) UIView           * contentView;
@property (nonatomic, strong) UIButton         * emojiButton;//表情
@property (nonatomic, strong) UIButton         * sendButton;//发送按钮
@property (nonatomic, strong) NSMutableArray   * danMuArray;//弹幕数组
@property (nonatomic, strong) NSTimer          * danMuTimer;
@property (nonatomic, assign) CGRect             keyboardRect;//键盘尺寸
@property (nonatomic, assign) BOOL               keyboardHidden;//是否隐藏键盘
@property (nonatomic, strong) CustomTextView  * placeTextView;//textField

@end

#define sapce 10

@implementation TextViewKeyBoardToolBar
//内容view
- (UIView *)contentView{
    if(!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _contentView;
}

//表情按钮
- (UIButton *)emojiButton{
    if (!_emojiButton) {
        _emojiButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _emojiButton.frame = CGRectMake(0, 0, 30, 30);
        _emojiButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_emojiButton setImage:[UIImage imageNamed:@"face_nov"] forState:UIControlStateNormal];
        [_emojiButton setImage:[UIImage imageNamed:@"face_hov"] forState:UIControlStateSelected];
        [_emojiButton addTarget:self action:@selector(faceBoardClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _emojiButton;
}

-(UIButton *)sendButton {
    if(!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.backgroundColor = [UIColor orangeColor];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_sendButton addTarget:self action:@selector(sendBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}


- (CustomTextView *)placeTextView{
    if (!_placeTextView) {
        _placeTextView = [[CustomTextView alloc]initWithFrame:CGRectZero];
        _placeTextView.placeholderColor = [UIColor orangeColor];
        _placeTextView.placeholder = @"扯犊子...";
        _placeTextView.maxNumberOfLines = 5;
        _placeTextView.delegate = self;
    }
    return _placeTextView;
}




/**
 *  @brief  初始化
 */
- (instancetype)init{
    if (self = [super init]) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    //添加通知
    [self addObserver];
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    
    [self.contentView addSubview:self.sendButton];
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-sapce);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
    }];
    
    //输入框
    [self.contentView addSubview:self.placeTextView];
    [self.placeTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(sapce);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.sendButton.mas_left).offset(-15);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-sapce);
    }];
    
    
    
    __weak __typeof(&*self)weakSelf = self;
    self.placeTextView.yz_textHeightChangeBlock = ^(NSString * _Nonnull text, CGFloat textHeight) {
        if (weakSelf.textHeightChangeBlock) {
            weakSelf.textHeightChangeBlock(text,textHeight + 2 * sapce);
        }
    };
    
}
- (void)setTextHeightChangeBlock:(void (^)(NSString * _Nonnull, CGFloat))textHeightChangeBlock{
    _textHeightChangeBlock= textHeightChangeBlock;
    
}
- (void)setIsEditing:(BOOL)isEditing{
    
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    [self.placeTextView becomeFirstResponder];
}
- (void)textViewDidChange:(UITextView *)textView{
    if(_placeTextView.text.length > 300) {
        //        [self.view endEditing:YES];
        _placeTextView.text = [_placeTextView.text substringToIndex:300];
//        [MBProgressHUD showInfoMessage:@"输入限制在300个字符以内"];
        NSLog(@"输入限制在300个字符以内");
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        
        return NO;
    }
    return YES;
}
#pragma mark 发送聊天
-(void)sendBtnClicked {
    [self chatSendMessage];
}

-(void)chatSendMessage {
    NSString *str = _placeTextView.text;
    if(str == nil || str.length == 0) {
        return;
    }
    // 发送公聊信息
    if (self.sendTextBlock) {
        self.sendTextBlock(str);
    }
    _placeTextView.text = nil;
    _placeTextView.placeholder = @"说点什么吧...";
    if (_placeTextView.changeBlock) {
        _placeTextView.changeBlock();
    }
    [_placeTextView resignFirstResponder];
}


#pragma mark -- 键盘监听
- (void)addObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
   
    //接收到停止弹出键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenKeyBoard:) name:@"KEYBOARD_HIDDEN_NOTIFICATION" object:nil];
}
-(void)removeObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KEYBOARD_HIDDEN_NOTIFICATION" object:nil];
}

#pragma mark keyboard notification  键盘出现
- (void)keyboardWillShow:(NSNotification *)notification{
    if (![self.placeTextView isFirstResponder]) {
        return ;
    }
    [self.placeTextView becomeFirstResponder];
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    _keyboardRect = [aValue CGRectValue];
    CGFloat y = _keyboardRect.size.height;
    
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardEndY = value.CGRectValue.origin.y;
    // 得到键盘弹出后的键盘视图所在y坐标
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    if (self.delegate) {
        [self.delegate
         keyBoardWillShow:y endEditIng:self.keyboardHidden];
    }
    
    
}



#pragma mark keyboard 键盘消失
- (void)keyboardWillHide:(NSNotification *)notification {
//    self.placeTextView = nil;
//    [self.placeTextView resignFirstResponder];
    if (self.delegate) {
        [self.delegate hiddenKeyBoard];
    }
}

#pragma mark - 键盘事件
-(void)hiddenKeyBoard:(NSNotification *)noti{
    NSDictionary *userInfo = [noti userInfo];
    self.keyboardHidden = [userInfo[@"KEYBOARD_HIDDEN_NOTIFICATION"] boolValue];
}

- (void)dealloc{
    [self removeObserver];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
