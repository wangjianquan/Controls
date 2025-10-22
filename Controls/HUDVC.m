//
//  HUDVC.m
//  Controls
//
//  Created by MacBook Pro on 2020/6/5.
//  Copyright © 2020 WJQ. All rights reserved.
//

#import "HUDVC.h"

@interface HUDVC ()

//网络监听
@property (nonatomic, strong) AliyunReachability *reachability;

@end

@implementation HUDVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    [self setupStackView];
}

- (void)setupStackView {
    // 1. 创建横向StackView
    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.axis = UILayoutConstraintAxisHorizontal; // 横向排列
    stackView.alignment = UIStackViewAlignmentCenter; // 垂直居中对齐
    stackView.distribution = UIStackViewDistributionFillEqually; // 等宽分配
    stackView.spacing = 6; // 按钮间距
    stackView.frame = CGRectMake(10, 100, self.view.frame.size.width-20, 30);
    [self.view addSubview:stackView];
    // 2. 按钮标题数组
    NSArray *buttonTitles = @[@"Top", @"Bottom", @"Loading", @"Text", @"成功", @"失败"];
    // 3. 循环创建按钮并添加到StackView
    for (NSInteger i = 0; i < buttonTitles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:buttonTitles[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:11];
        button.backgroundColor = [UIColor systemBlueColor];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.layer.cornerRadius = 6; // 圆角
        button.contentEdgeInsets = UIEdgeInsetsMake(8, 12, 8, 12); // 内边距
        button.tag = i; // 设置tag（0-5）
        // 添加点击事件
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [stackView addArrangedSubview:button];
    }
}

// 6. 按钮点击事件处理
- (void)buttonTapped:(UIButton *)sender {
    NSString *title = [sender titleForState:UIControlStateNormal] ?: @"Unknown";
    NSLog(@"按钮点击 - 标题: %@, Tag: %ld", title, (long)sender.tag);
    
    if (sender.tag == 0) {
        [MBProgressHUD showText:@"top message !" textPositon:HUDTextPositionTop];
    } else if (sender.tag == 1) {
        [MBProgressHUD showText:@"bottom message !" textPositon:HUDTextPositionBottom];
    } else if (sender.tag == 2) {
        [MBProgressHUD showLoading:@"loading..." toView:self.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view];
        });
    } else if (sender.tag == 3) {
        [MBProgressHUD showText:@"多行文字：以下是对应的 Objective-C 实现代码，实现了横向 UIStackView 包含 6 个指定按钮，并设置了 tag 和点击事件"];
    } else if (sender.tag == 4) {
        [MBProgressHUD showSuccess:@"Success"];
    } else if (sender.tag == 5) {
        [MBProgressHUD showError:@"Error"];
    } else {
        [MBProgressHUD showText:title];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //判断网络
    _reachability = [AliyunReachability reachabilityForInternetConnection];
    [_reachability startNotifier];    
    switch ([self.reachability currentReachabilityStatus]) {
        case AliyunPVNetworkStatusNotReachable://由播放器底层判断是否有网络
        {
            [MBProgressHUD showError:@"当前网络环境为: 不可用"];
        }
            break;
        case AliyunPVNetworkStatusReachableViaWiFi:
        {
            [MBProgressHUD showSuccess:@"当前网络环境为: WiFi"];
        }
            break;
        case AliyunPVNetworkStatusReachableViaWWAN:
        {
            [MBProgressHUD showSuccess:@"当前网络环境为: 数据流量"];
        }
            break;
        default:
            break;
    }
}

@end
