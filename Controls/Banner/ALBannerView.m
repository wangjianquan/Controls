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
        _contentView = [[UIView alloc]init];
    }
    return _contentView;
}
- (iCarousel *)carousel{
    if (!_carousel) {
        _carousel               = [[iCarousel alloc]init];
        _carousel.type          = iCarouselTypeLinear;
        _carousel.delegate      = self;
        _carousel.dataSource    = self;
        _carousel.pagingEnabled = YES;
    }
    return _carousel;
}

-(UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
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
    [self addSubview:self.contentView];
    [self addSubview:self.carousel];
    [self addSubview:self.pageControl];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.backgroundColor = [UIColor blueColor];
    _contentView.backgroundColor = [UIColor redColor];
    
    
    CGFloat carousel_Width = CGRectGetWidth(self.frame);
    CGFloat carousel_Height = CGRectGetHeight(self.frame)*0.618;
    CGFloat carousel_Y = CGRectGetHeight(self.frame)-carousel_Height;
    CGFloat pageControlHeight = 23;
    
    _contentView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-carousel_Height/2);

    _carousel.frame = CGRectMake(0, carousel_Y-10, carousel_Width, carousel_Height);
    _pageControl.frame = CGRectMake(0, CGRectGetMaxY(_carousel.frame) - pageControlHeight,self.frame.size.width, pageControlHeight);
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
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
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
        imageView.backgroundColor = [UIColor yellowColor];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        CGFloat imageWidth = CGRectGetWidth(_carousel.frame) - 40;
        imageView.frame = CGRectMake(0, 0, imageWidth, CGRectGetHeight(_carousel.frame));
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
        return value * 1.4;//间距
    } else if (option == iCarouselOptionWrap) {
        return YES;
    }
    return value;
}
- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
//    NSLog(@"Index: %@", @(_carousel.currentItemIndex));
}

- (void)carouselWillBeginScrollingAnimation:(iCarousel *)carousel{
//        NSLog(@"WillBeginScrollingAnimation");
    // 0.2 表示动画时长为0.2秒
//    self.carousel.transform = CGAffineTransformMakeScale(0.8, 0.8);

//    [UIView animateWithDuration:0.5 animations:^{
//
//        carousel.currentItemView.transform = CGAffineTransformMakeScale(0.8, 0.8);
//
//    } completion:^(BOOL finished) {
//
//    }];
    carousel.currentItemView.transform = CGAffineTransformMakeScale(1.0, 1.0);

    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        carousel.currentItemView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
            carousel.currentItemView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {

        }];
    }];
    
   
}
- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel{
//    NSLog(@"carouselDidEndScrollingAnimation");
    _pageControl.currentPage = carousel.currentItemIndex;
//    self.carousel.transform = CGAffineTransformMakeScale(1.0, 1.0);

//    [UIView animateWithDuration:0.5 animations:^{
////        self.carousel.transform = CGAffineTransformIdentity;
//        carousel.currentItemView.transform = CGAffineTransformIdentity;
//    } completion:^(BOOL finished) {
//
//    }];
   
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        carousel.currentItemView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {

    }];
//    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:2 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
//        carousel.currentItemView.transform = CGAffineTransformMakeScale(0.8, 0.8);
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:2 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
//            carousel.currentItemView.transform = CGAffineTransformIdentity;
//        } completion:^(BOOL finished) {
//
//        }];
//    }];
}

- (void)carouselWillBeginDragging:(iCarousel *)carousel{
    NSLog(@"carouselWillBeginDragging");

    NSLog(@"%@",carousel.currentItemView);
//    carousel.currentItemView.transform = CGAffineTransformMakeScale(0.8, 0.8);

//    [UIView animateWithDuration:0.5 animations:^{
        carousel.currentItemView.transform = CGAffineTransformMakeScale(0.8, 0.8);
//    } completion:^(BOOL finished) {
       
//    }];
}
- (void)carouselDidEndDragging:(iCarousel *)carousel willDecelerate:(BOOL)decelerate{
    NSLog(@"carouselDidEndDragging");
//    carousel.currentItemView.transform = CGAffineTransformIdentity;
//    [UIView animateWithDuration:0.5 animations:^{
        carousel.currentItemView.transform = CGAffineTransformIdentity;
//    }];
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
//    if ([model.type isEqualToString:@"Goods"]) {
//    } else if([model.type isEqualToString:@"url"]) {
//    } else if([model.type isEqualToString:@"Catalog"]) {
//    }
//    DLog(@"Tapped view : %@", model.point);
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
