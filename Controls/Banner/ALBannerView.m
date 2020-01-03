//
//  ALBannerView.m
//  AssistedLearning
//
//  Created by wjq on 2019/11/5.
//  Copyright © 2019 wjq. All rights reserved.
//

#import "ALBannerView.h"
#import "iCarousel.h"
#import "ALBannerModel.h"
#import "ALGCDTimer.h"

@interface ALBannerView ()<iCarouselDelegate,iCarouselDataSource>
{
    ALGCDTimer  *_imageStepTimer;

}
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) iCarousel *carousel;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *bannerSource;

@end

@implementation ALBannerView
- (NSMutableArray *)bannerSource{
    if (!_bannerSource) {
        _bannerSource = [[NSMutableArray alloc]init];
    }
    return _bannerSource;
}
- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return _contentView;
}
- (iCarousel *)carousel{
    if (!_carousel) {
        _carousel               = [[iCarousel alloc] initWithFrame:CGRectZero];
        _carousel.type          = iCarouselTypeLinear;
        _carousel.delegate      = self;
        _carousel.dataSource    = self;
        _carousel.pagingEnabled = YES;
    }
    return _carousel;
}

-(UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
        _pageControl.userInteractionEnabled = NO;
//        _pageControl.pageIndicatorImage = [UIImage al_imageNamed:@"al_banner_inactiveImage"];
//        _pageControl.currentPageIndicatorImage = [UIImage al_imageNamed:@"al_sele_banner_page"];
//        [_pageControl sizeToFit];
    }
    return _pageControl;
}


- (void)dealloc {

    [self freeSpeedTimer];
}

- (instancetype)init{
    if (self =  [super init]) {
        [self setupUI];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.carousel];
    [self.contentView addSubview:self.pageControl];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat pageControlHeight = 30;
    self.contentView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    
    CGFloat imageWidth = CGRectGetWidth(_carousel.frame) - 30;
    CGFloat imageHeight = imageWidth*312*1.0/686;
    self.carousel.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), imageHeight);
    self.pageControl.frame = CGRectMake(0, CGRectGetMaxY(self.carousel.frame) + 5,self.frame.size.width, pageControlHeight);
}

- (void)setLoadBanner:(BOOL)loadBanner{
    _loadBanner = loadBanner;
    if (_loadBanner == YES) {
        [self getBanner];
    } else {
        
    }
}

- (void)getBanner{
    /*网络请求
         if (_bannerRequest) {
         [_bannerRequest cancel];
         }
         _bannerRequest = [[ALMainBannerRequest alloc]init];
         _bannerRequest.delegate = self;
         [_bannerRequest requestALBanner];
     */
    //本地数据
    [self test];
}

- (void)test{
    NSArray *imageNames = @[@"h1.jpg",@"h2.jpg",@"h3.jpg",@"h4.jpg"];
    self.bannerSource = [imageNames mutableCopy];
    [self.carousel reloadData];
    self.pageControl.numberOfPages = self.bannerSource.count;
    [self createSpeedTimer];
    if (_bannerSuccessBlock) {
          _bannerSuccessBlock();
      }
}
#pragma mark - 轮播图代理 ALMainBannerRequestDelegate
//- (void)requestALBannerSucceed:(NSMutableArray *)banners{
//    self.bannerSource = banners;
//    [self.carousel reloadData];
//    self.pageControl.numberOfPages = self.bannerSource.count;
//    [self createSpeedTimer];
//    if (_bannerSuccessBlock) {
//        _bannerSuccessBlock();
//    }
//}
//
//- (void)requestALBannerFailed:(NSString *)error{
//    if (_bannerFailedBlock) {
//        _bannerFailedBlock();
//    }
//}


- (void)freeSpeedTimer {
    if (_imageStepTimer) {
        [_imageStepTimer invalidate];
        _imageStepTimer = nil;
    }
}

- (void)createSpeedTimer {
    [self freeSpeedTimer];
    __block id weakSelf = self;
    _imageStepTimer = [ALGCDTimer repeatingTimerWithTimeInterval:3 block:^{
                                                            [weakSelf changeToNextImage];
                                                        }];
}
- (void)changeToNextImage {
    if (_carousel.numberOfItems > 0) {
        NSInteger nextIndex = _carousel.currentItemIndex + 1;
        if (nextIndex >= _carousel.numberOfItems) {
            nextIndex = 0;
        }
        [_carousel scrollToItemAtIndex:nextIndex animated:YES];
    }
}

#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return _bannerSource.count;

}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{

    UIImageView *imageView = nil;
//    ALBannerModel *model = [_bannerSource objectAtIndex:index];
    if (view) {
        imageView = (UIImageView *)view;
        
//        [imageView sd_cancelCurrentImageLoad];
        imageView.image = nil;
    } else {
        imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = [UIColor redColor];
        CGFloat imageWidth = CGRectGetWidth(_carousel.frame) - 30;
        CGFloat imageHeight = imageWidth*312*1.0/686;
        imageView.frame = CGRectMake(0, 0, CGRectGetWidth(_carousel.frame) - 30, imageHeight);
        imageView.layer.cornerRadius = 5;
        imageView.clipsToBounds = YES;
    }

    /* 加载image url地址
     NSURL *url = [NSURL URLWithString:model.path];

         [imageView sd_setImageWithURL:url
                       placeholderImage:nil
                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                  if (!image || error) {
     //                                 imageView.image = [UIImage al_imageNamed:@"al_banner_default"];
                                  }
         }];
     */
//    NSString * image = self.bannerSource[index];
    imageView.image = [UIImage imageNamed:self.bannerSource[index]];
    return imageView;
}

#pragma mark - iCarouselDelegate methods
- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (option == iCarouselOptionSpacing) {
        return value * 1.025;
    } else if (option == iCarouselOptionWrap) {
        return YES;
    }
    return value;
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel {
    _pageControl.currentPage = carousel.currentItemIndex;
}

#pragma mark -
#pragma mark iCarousel taps

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    if (index < 0 || index >= self.bannerSource.count) {
           return;
    }
//    ALBannerModel *model = [_bannerSource objectAtIndex:index];
//    //type:类型 Goods跳转至商品，url跳转网页，Catalog 栏目
//
//    if ([model.type isEqualToString:@"Goods"]) {
//
//    } else if([model.type isEqualToString:@"url"]) {
//
//    } else if([model.type isEqualToString:@"Catalog"]) {
//
//    }
//    DLog(@"Tapped view : %@", model.point);
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
//    NSLog(@"Index: %@", @(_carousel.currentItemIndex));
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
