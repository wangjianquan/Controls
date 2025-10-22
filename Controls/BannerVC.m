//
//  BannerVC.m
//  Controls
//
//  Created by MacBook Pro on 2020/1/3.
//  Copyright © 2020 WJQ. All rights reserved.
//

#import "BannerVC.h"
#import "ALBannerView.h"
#import "MaskView.h"
@interface BannerVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) ALBannerView *bannerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MaskView * maskView;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation BannerVC

-(ALBannerView *)bannerView{
    if (!_bannerView) {
        _bannerView = [[ALBannerView alloc]initWithFrame:CGRectMake(0, 0 , SCREEN_WIDTH, SCREEN_WIDTH/2 )];
        __weak typeof(self) weakSelf = self;
        _bannerView.bannerSelectBlock = ^(NSInteger index) {
            weakSelf.navigationItem.title = [NSString stringWithFormat:@"%ld",index];
        };
    }
    return _bannerView;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//        CGFloat imageHeight = imageWidth*312*1.0/686;

    
    
    [self.view addSubview:self.bannerView];
    self.tableView.tableHeaderView = self.bannerView;
    self.bannerView.loadBanner = YES;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    // Do any additional setup after loading the view.
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"test - %ld ",indexPath.row];
    return cell;
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
