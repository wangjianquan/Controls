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
#import "MaskView.h"
@interface ALBannerView ()<iCarouselDelegate,iCarouselDataSource>
{
    ALGCDTimer  *_imageStepTimer;

}
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) iCarousel *carousel;
@property (nonatomic, strong) MaskView * leftMaskView;
@property (nonatomic, strong) MaskView * rightMaskView;

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

-(MaskView *)leftMaskView{
    if (_leftMaskView== nil){
        _leftMaskView = [[MaskView alloc] init];
    }
    return _leftMaskView;
}
-(MaskView *)rightMaskView{
    if (_rightMaskView== nil){
        _rightMaskView = [[MaskView alloc] init];
    }
    return _rightMaskView;
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
        _carousel.type          = iCarouselTypeCustom;
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
    [self addSubview:self.leftMaskView];
    [self addSubview:self.rightMaskView];
    [self addSubview:self.carousel];
    [self addSubview:self.pageControl];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor brownColor];
    
    
    CGFloat carousel_Width = CGRectGetWidth(self.frame);
    CGFloat carousel_Height = CGRectGetHeight(self.frame)*0.618;
    CGFloat carousel_Y = CGRectGetHeight(self.frame)-carousel_Height;
    CGFloat pageControlHeight = 23;
    
    _contentView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-carousel_Height/2);
    _leftMaskView.frame = CGRectMake(-10, 0, self.frame.size.width + 10, self.frame.size.height - 30);
    _rightMaskView.frame = CGRectMake(0, 0, self.frame.size.width + 10, self.frame.size.height - 30);
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
        imageView.backgroundColor = [UIColor clearColor];
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
    NSLog(@"Index: %@", @(_carousel.currentItemIndex));
}
//- (void)carouselDidScroll:(iCarousel *)carousel{
//    CGFloat curretContentOffset = carousel.scrollOffset;
//    NSInteger index = curretContentOffset/SCREEN_WIDTH;
//    NSLog(@"index  %ld",index);
//    if (carousel.isDragging || carousel.isDecelerating){
//        if (curretContentOffset <= 1 && curretContentOffset >= -1){
//
//            NSLog(@">>>>>>");
//            [UIView animateWithDuration:1 animations:^{
//                [self.leftMaskView setRadius:(SCREEN_WIDTH *self->_carousel.currentItemIndex - curretContentOffset)*2  direction:BannerSrollDirectionRight];
//                [self.rightMaskView setRadius:0  direction:BannerSrollDirectionLeft];
//            }];
//
//        }else{
//            NSLog(@"<<<<<<");
//
//            [UIView animateWithDuration:1 animations:^{
//                [self.leftMaskView setRadius:0 direction:BannerSrollDirectionRight];
//                [self.rightMaskView setRadius:(SCREEN_WIDTH *self->_carousel.currentItemIndex - curretContentOffset)*2   direction:BannerSrollDirectionLeft];
//            }];
//        }
//    }
//    else{
//        if (curretContentOffset > 0){
//
//
//
//            [UIView animateWithDuration:1 animations:^{
//                [self.leftMaskView setRadius:(curretContentOffset - SCREEN_WIDTH * self->_carousel.currentItemIndex )*2  direction:BannerSrollDirectionRight];
//                [self.rightMaskView setRadius:0  direction:BannerSrollDirectionLeft];
//            }];
//
//        }else{
//
//
//            [UIView animateWithDuration:1 animations:^{
//                [self.leftMaskView setRadius:0 direction:BannerSrollDirectionRight];
//                [self.rightMaskView setRadius:(curretContentOffset - SCREEN_WIDTH * self->_carousel.currentItemIndex )*2   direction:BannerSrollDirectionLeft];
//            }];
//        }
//    }
//}
- (void)carouselWillBeginScrollingAnimation:(iCarousel *)carousel{
        NSLog(@"WillBeginScrollingAnimation");
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel{
    _pageControl.currentPage = carousel.currentItemIndex;
//    self.contentView.backgroundColor = [PreHelper randomColor];

}

- (void)carouselWillBeginDragging:(iCarousel *)carousel{
    NSLog(@"carouselWillBeginDragging");

    NSLog(@"%@",carousel.currentItemView);

}
- (void)carouselDidEndDragging:(iCarousel *)carousel willDecelerate:(BOOL)decelerate{
    NSLog(@"carouselDidEndDragging");

}



#pragma mark -
#pragma mark iCarousel taps
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    if (index < 0 || index >= self.bannerSource.count) {
           return;
    }
    if (_bannerSelectBlock) {
        _bannerSelectBlock(index);
    }
//    ALBannerModel *model = [_bannerSource objectAtIndex:index];
//    //type:类型 Goods跳转至商品，url跳转网页，Catalog 栏目
//    if ([model.type isEqualToString:@"Goods"]) {
//    } else if([model.type isEqualToString:@"url"]) {
//    } else if([model.type isEqualToString:@"Catalog"]) {
//    }
//    DLog(@"Tapped view : %@", model.point);
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
