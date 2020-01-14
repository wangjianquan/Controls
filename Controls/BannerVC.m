//
//  BannerVC.m
//  Controls
//
//  Created by MacBook Pro on 2020/1/3.
//  Copyright © 2020 WJQ. All rights reserved.
//

#import "BannerVC.h"
#import "ALBannerView.h"

@interface BannerVC ()
@property (nonatomic, strong) ALBannerView *bannerView;

@end

@implementation BannerVC
//-(ALBannerView *)bannerView{
//    if (!_bannerView) {
//        _bannerView = [ALBannerView alloc]initWithFrame:<#(CGRect)#>
//    }
//    return _bannerView;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//        CGFloat imageHeight = imageWidth*312*1.0/686;

    
    _bannerView = [[ALBannerView alloc]initWithFrame:CGRectMake(0, 90 , SCREEN_WIDTH, SCREEN_WIDTH/2 )];
    WS(weakSelf);
    _bannerView.bannerSuccessBlock = ^{
    };
    _bannerView.bannerFailedBlock = ^{
    };
    self.bannerView.loadBanner = YES;
    [self.view addSubview:_bannerView];

    // Do any additional setup after loading the view.
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
