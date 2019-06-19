//
//  TextViewController.m
//  Controls
//
//  Created by wjq on 2019/6/18.
//  Copyright © 2019 WJQ. All rights reserved.
//

#import "TextViewController.h"

@interface TextViewController ()<KeyToolBarDelegate,UITextViewDelegate>

@property (nonatomic, strong) TextViewKeyBoardToolBar *keyboardToolBar;
@property (nonatomic, strong) CustomTextView *textView;

@end

@implementation TextViewController

- (CustomTextView *)textView{
    if (!_textView) {
        _textView = [[CustomTextView alloc]initWithFrame:CGRectMake(30, 100, SCREEN_WIDTH-60, 44)];
        _textView.placeholderColor = [UIColor orangeColor];
        _textView.placeholder = @"textView placeholder ...";
        _textView.maxNumberOfLines = 6;
        
        _textView.yz_textHeightChangeBlock = ^(NSString * _Nonnull text, CGFloat textHeight) {
            self.textView.frame = CGRectMake(30, 100, SCREEN_WIDTH-60, textHeight);
            NSLog(@"text: %@ , textHeight : %f",text, textHeight);
        };
    }
    return _textView;
}

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    [self.view addSubview:self.textView];
//    // Do any additional setup after loading the view.
//}
- (TextViewKeyBoardToolBar *)keyboardToolBar{
    if (!_keyboardToolBar) {
        _keyboardToolBar = [[TextViewKeyBoardToolBar alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT-keyboardToolBar_height - SafeAreaBottomHeight ,SCREEN_WIDTH, keyboardToolBar_height)];
        //        _keyboardToolBar = [[TextViewKeyBoardToolBar alloc]init];
        _keyboardToolBar.delegate = self;
        _keyboardToolBar.sendTextBlock = ^(NSString *string) {
            NSLog(@"%@",string);
        };        
    }
    return _keyboardToolBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.keyboardToolBar.delegate = self;
    WS(weakSelf);
    self.keyboardToolBar.textHeightChangeBlock = ^(NSString * _Nonnull text, CGFloat textHeight) {
        NSLog(@"%@ , %f",text, textHeight);
        //        self.tempRect.size.height = textHeight;
        CGRect tempRect = weakSelf.keyboardToolBar.frame;
        tempRect.size.height = textHeight;
        self.keyboardToolBar.frame = tempRect;
        
    };
    //    self.keyboardToolBar.placeTextView.yz_textHeightChangeBlock = ^(NSString * _Nonnull text, CGFloat textHeight) {
    //        NSLog(@"%@ , %f",text, textHeight);
    //    };
    [self.view addSubview:self.keyboardToolBar];
    
    //    [self.keyboardToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.right.and.left.equalTo(self.view);
    //        if (@available(iOS 11.0, *)) {
    //            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
    //        } else {
    //            make.bottom.equalTo(self.view);
    //        }
    //        make.height.mas_equalTo(keyboardToolBar_height);
    //    }];
    // Do any additional setup after loading the view, typically from a nib.
}
#pragma mark - inputView deleaget输入键盘的代理
//键盘将要出现
-(void)keyBoardWillShow:(CGFloat)height endEditIng:(BOOL)endEditIng{
    // 添加移动动画，使视图跟随键盘移动
    [UIView animateWithDuration:0.25 animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:7];
        //        [self.keyboardToolBar mas_updateConstraints:^(MASConstraintMaker *make) {
        //            make.right.and.left.equalTo(self.view);
        //            make.bottom.equalTo(self.view).offset(-height);
        //            make.height.mas_equalTo(keyboardToolBar_height);
        //        }];
        //        CGRect
        CGRect tempRect = self.keyboardToolBar.frame;
        tempRect.origin.y = SCREEN_HEIGHT - (height + keyboardToolBar_height);
        self.keyboardToolBar.frame = tempRect;
        
        //        self.keyboardToolBar.frame = CGRectMake(0,SCREEN_HEIGHT - keyboardToolBar_height - height ,SCREEN_WIDTH, keyboardToolBar_height);
    }];
    [self.view layoutIfNeeded];
}

//隐藏键盘
-(void)hiddenKeyBoard{
    //    [self.keyboardToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.right.and.left.equalTo(self.view);
    //        if (@available(iOS 11.0, *)) {
    //            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
    //        } else {
    //            make.bottom.equalTo(self.view);
    //        }
    //        make.height.mas_equalTo(keyboardToolBar_height);
    //    }];
    CGRect tempRect = self.keyboardToolBar.frame;
    tempRect.origin.y = SCREEN_HEIGHT - keyboardToolBar_height - SafeAreaBottomHeight;
    self.keyboardToolBar.frame = tempRect;
    //    self.keyboardToolBar.frame = CGRectMake(0,SCREEN_HEIGHT-keyboardToolBar_height - SafeAreaBottomHeight ,SCREEN_WIDTH, keyboardToolBar_height);
    [UIView animateWithDuration:0.1f animations:^{
        //        self.keyboardToolBar.hidden = YES;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
