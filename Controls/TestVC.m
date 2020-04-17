//
//  TestVC.m
//  Controls
//
//  Created by MacBook Pro on 2020/1/15.
//  Copyright © 2020 WJQ. All rights reserved.
//

#import "TestVC.h"
#import "MaskView.h"

@interface TestVC ()<UIScrollViewDelegate>

@property (nonatomic, strong) MaskView * leftMaskView;
@property (nonatomic, strong) MaskView * rightMaskView;

@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation TestVC
-(MaskView *)leftMaskView{
    if (_leftMaskView== nil){
        _leftMaskView = [[MaskView alloc] initWithFrame:CGRectMake(0, 88, self.view.frame.size.width,250-88)];
    }
    return _leftMaskView;
}
-(MaskView *)rightMaskView{
    if (_rightMaskView== nil){
        _rightMaskView = [[MaskView alloc] initWithFrame:CGRectMake(0, 88, self.view.frame.size.width,250-88)];
    }
    return _rightMaskView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.leftMaskView];
    [self.view addSubview:self.rightMaskView];
    
    self.view.backgroundColor = [UIColor brownColor];
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 250, SCREEN_WIDTH, SCREEN_WIDTH/2)];
    self.scrollView.backgroundColor = [UIColor redColor];
    self.scrollView.bounces = NO;
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 4, self.scrollView.frame.size.height);
    [self.view addSubview:self.scrollView];
    
    // Do any additional setup after loading the view.
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat curretContentOffset = scrollView.contentOffset.x;
    NSInteger index = curretContentOffset/SCREEN_WIDTH;
    NSLog(@"index  %ld",index);
    if (scrollView.isDragging || scrollView.isDecelerating){
        if (curretContentOffset > 2 * SCREEN_WIDTH){

            NSLog(@">>>>>>");
            [UIView animateWithDuration:1 animations:^{
                [self.leftMaskView setRadius:(SCREEN_WIDTH *index - curretContentOffset)*2  direction:BannerSrollDirectionRight];
                [self.rightMaskView setRadius:0  direction:BannerSrollDirectionLeft];
            }];

        }else{
            NSLog(@"<<<<<<");

            [UIView animateWithDuration:1 animations:^{
                [self.leftMaskView setRadius:0 direction:BannerSrollDirectionRight];
                [self.rightMaskView setRadius:(SCREEN_WIDTH *index - curretContentOffset)*2   direction:BannerSrollDirectionLeft];
            }];
        }
    }
    else{
        if (curretContentOffset > 0){
           
           
            
            [UIView animateWithDuration:0.5 animations:^{
                [self.leftMaskView setRadius:(curretContentOffset - SCREEN_WIDTH * index)*2  direction:BannerSrollDirectionRight];
                [self.rightMaskView setRadius:0  direction:BannerSrollDirectionLeft];
            }];
            
        }else{
           
            
            [UIView animateWithDuration:0.5 animations:^{
                [self.leftMaskView setRadius:0 direction:BannerSrollDirectionRight];
                [self.rightMaskView setRadius:(curretContentOffset - SCREEN_WIDTH * index)*2   direction:BannerSrollDirectionLeft];
            }];
        }
    }
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
