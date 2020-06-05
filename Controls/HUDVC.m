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
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //判断网络
    _reachability = [AliyunReachability reachabilityForInternetConnection];
    [_reachability startNotifier];    
    switch ([self.reachability currentReachabilityStatus]) {
        case AliyunPVNetworkStatusNotReachable://由播放器底层判断是否有网络
        {
            [MBProgressHUD showError:@"当前网络环境为: 不可用" toView:self.view];
        }
            break;
        case AliyunPVNetworkStatusReachableViaWiFi:
        {
            [MBProgressHUD showSuccess:@"当前网络环境为: WiFi" toView:self.view];
        }
            break;
        case AliyunPVNetworkStatusReachableViaWWAN:
        {
            [MBProgressHUD showSuccess:@"当前网络环境为: 数据流量" toView:self.view];
        }
            break;
        default:
            break;
    }
}
- (IBAction)top:(id)sender {
    [MBProgressHUD showText:@"top message !" textPositon:HUDTextPositionTop];

}
- (IBAction)bottom:(id)sender {
    [MBProgressHUD showText:@"bottom message !" textPositon:HUDTextPositionBottom];

}
- (IBAction)loading:(id)sender {
    [MBProgressHUD showLoading:@"loading..." toView:self.view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view];
    });
}

- (IBAction)onlyText:(UIButton *)sender {
    [MBProgressHUD showText:@"// In a storyboard-based application, you will often want to do a little preparation before navigation  - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender { // Get the new view controller using [segue destinationViewController]. // Pass the selected object to the new view controller.}"];
}

- (IBAction)success:(UIButton *)sender {
    [MBProgressHUD showSuccess:@"Success" toView:self.view];
}
- (IBAction)error:(UIButton *)sender {
    [MBProgressHUD showError:@"Error"];

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
