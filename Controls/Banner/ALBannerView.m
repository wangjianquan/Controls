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
#import "SDWebImage.h"
#import "JYPMPHZZSMPageControl.h"

@interface ALBannerView ()<iCarouselDelegate,iCarouselDataSource>{
    NSMutableArray * _data;//轮播图模型数
    ALGCDTimer  *_imageStepTimer;

}

@property (nonatomic, strong) iCarousel *carousel;

@property (nonatomic, strong) JYPMPHZZSMPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *bannerSource;

@end

@implementation ALBannerView

- (NSMutableArray *)bannerSource{
    if (!_bannerSource) {
        _bannerSource = [[NSMutableArray alloc]init];
    }
    return _bannerSource;
}

- (iCarousel *)carousel{
    if (!_carousel) {
        _carousel               = [[iCarousel alloc]init];
        _carousel.type          = iCarouselTypeCustom;
        _carousel.delegate      = self;
        _carousel.dataSource    = self;
        _carousel.pagingEnabled = YES;
        _carousel.layer.cornerRadius = 8;
        _carousel.layer.masksToBounds = YES;
    }
    return _carousel;
}

-(JYPMPHZZSMPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[JYPMPHZZSMPageControl alloc] initWithFrame:CGRectZero];
        _pageControl.userInteractionEnabled = NO;
        _pageControl.pageIndicatorImage = [UIImage imageNamed:@"al_banner_inactiveImage"];
        _pageControl.currentPageIndicatorImage = [UIImage imageNamed:@"al_sele_banner_page"];
        _pageControl.alignment = SMPageControlAlignmentRight;
        [_pageControl sizeToFit];
    }
    return _pageControl;
}

- (void)dealloc {
    [self freeSpeedTimer];
}

- (instancetype)init{
    self =  [super init];
    if (self) {
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
    self.backgroundColor = [UIColor redColor];
    [self addSubview:self.carousel];
    [self addSubview:self.pageControl];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat carousel_Width = CGRectGetWidth(self.frame);
    CGFloat carousel_Height = CGRectGetHeight(self.frame);
    CGFloat page_H = 30;
   
    self.carousel.frame = CGRectMake(0, 15, carousel_Width, carousel_Height-2*15);
    self.pageControl.frame = CGRectMake(20, CGRectGetMaxY(self.carousel.frame)-page_H,carousel_Width-40, page_H);
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

}
#pragma mark - 轮播图代理 ALMainBannerRequestDelegate
//- (void)requestALBannerSucceed:(NSMutableArray *)banners{
//    self.bannerSource = banners;
//    [self.carousel reloadData];
//    self.pageControl.numberOfPages = self.bannerSource.count;
//    [self createSpeedTimer];
//}

//- (void)requestALBannerFailed:(NSString *)error{

//}

- (void)setDataSource:(NSMutableArray *)dataSource{
    if (dataSource.count == 0) {
        return;
    }
    [self freeSpeedTimer];
    self.bannerSource = dataSource;
    [_carousel scrollToItemAtIndex:0 animated:NO];
    [self.carousel reloadData];
    
    self.pageControl.numberOfPages = self.bannerSource.count;
    self.carousel.currentItemIndex = 0;
    self.pageControl.currentPage = 0;
    
    [self createSpeedTimer];
}

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
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return _bannerSource.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UIImageView *imageView = nil;
    ALBannerModel *model = nil;
    if (index >= 0 && index < _bannerSource.count) {
        model = [_bannerSource objectAtIndex:index];
    }
    if (view) {
        imageView = (UIImageView *)view;
        [imageView sd_cancelCurrentImageLoad];
        imageView.image = nil;
    } else {
        imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        CGFloat imageWidth = CGRectGetWidth(_carousel.frame) - 40;
        imageView.frame = CGRectMake(0, 0, imageWidth, CGRectGetHeight(_carousel.frame));
        imageView.layer.cornerRadius = 8;
        imageView.clipsToBounds = YES;
    }
   
//    NSURL *url = [NSURL URLWithString:model.path];
//    [imageView sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        if (!image || error) {
//            imageView.image = [UIImage imageNamed:@"al_banner_default"];
//        }
//    }];
    //本地数据，模拟
    imageView.image = [UIImage imageNamed:self.bannerSource[index]];
    return imageView;
}

#pragma mark - iCarouselDelegate methods
- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (option == iCarouselOptionSpacing) {
        return value * 1.4;//间距
    } else if (option == iCarouselOptionWrap) {
        return YES;
    }
    return value;
}
- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel{
    _pageControl.currentPage = carousel.currentItemIndex;
}

#pragma mark iCarousel taps
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    if (index < 0 || index >= self.bannerSource.count) {
        return;
    }
//    ALBannerModel * moel = self.bannerSource[index];
//    if (_bannerSelectBlock) {
//        _bannerSelectBlock(moel);
//    }
}
#pragma mark - 自定义carousel动画 (carousel.type = iCarouselTypeCustom)
- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform {
    
    static CGFloat max_sacle = 1.0f;
    static CGFloat min_scale = 0.6f;
    if (offset <= 1 && offset >= -1) {
        float tempScale = offset < 0 ? 1+offset : 1-offset;
        float slope = (max_sacle - min_scale) / 1;
        
        CGFloat scale = min_scale + slope*tempScale;
        transform = CATransform3DScale(transform, scale, scale, 1);
    }else{
        transform = CATransform3DScale(transform, min_scale, min_scale, 1);
    }
    UIImageView * imageView = (UIImageView *)carousel.currentItemView;
//    imageView.image
//    NSLog(@"%@",imageView.image);

    return CATransform3DTranslate(transform, offset * self.carousel.itemWidth * 1.4, 0.0, 0.0);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
