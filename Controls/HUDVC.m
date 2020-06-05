//
//  HUDVC.m
//  Controls
//
//  Created by MacBook Pro on 2020/6/5.
//  Copyright © 2020 WJQ. All rights reserved.
//

#import "HUDVC.h"

@interface HUDVC ()

@end

@implementation HUDVC

- (void)viewDidLoad {
    [super viewDidLoad];
       //    [MBProgressHUD showText:@"center message !" textPositon:HUDTextPositionCenter];
      
    // Do any additional setup after loading the view.
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
