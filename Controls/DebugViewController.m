//
//  DebugViewController.m
//  Controls
//
//  Created by jieyue_M1 on 2025/10/21.
//  Copyright © 2025 WJQ. All rights reserved.
//

#import "DebugViewController.h"
#import "RAViewController.h"

@interface DebugViewController ()

@property (nonatomic, strong) PMPHShopBadgeButton *carBtn;

@end

@implementation DebugViewController

- (PMPHShopBadgeButton *)carBtn{
    if (!_carBtn) {
        _carBtn = [PMPHShopBadgeButton buttonWithType:UIButtonTypeCustom];
        _carBtn.badgeOffset_X = 10;
        _carBtn.badgeOffset_Y = 10;
        [_carBtn setImage:[UIImage imageNamed:@"购物车红"] forState:UIControlStateNormal];
        [_carBtn addTarget:self action:@selector(openRAVC) forControlEvents:UIControlEventTouchUpInside];
    }
    return _carBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    [self.carBtn setTitle:@"99" forState:(UIControlStateNormal)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.carBtn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"扫码" style:(UIBarButtonItemStylePlain) target:self action:@selector(openScanVC)];
}
- (void)openScanVC{
    OpmScanVC *scanVC = [[OpmScanVC alloc] init];
    scanVC.scanResultBlock = ^(NSString * _Nonnull result) {
        [OpmToast showCenterWithText:result];
    };
    CustomNavigationController *navgationVC = [[CustomNavigationController alloc] initWithRootViewController:scanVC];
    navgationVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self.navigationController presentViewController:navgationVC animated:YES completion:nil];
   
//    OpmScanVC *scanVC = [[OpmScanVC alloc] init];
//    scanVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
//    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//        [self.navigationController presentViewController:scanVC animated:YES completion:nil];
//    }];
}
- (void)openRAVC{
    [self.navigationController pushViewController:[[RAViewController alloc] init] animated:YES];
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
