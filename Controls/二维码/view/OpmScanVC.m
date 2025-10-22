//
//  OpmScanVC.m
//  OpmSDK
//
//  Created by jieyue_M1 on 2025/7/28.
//

#import "OpmScanVC.h"
#import "OpmScanViewModel.h"
#import "OpmToast.h"

@interface OpmScanVC () <ScanViewModelDelegate>
@property (nonatomic, strong) OpmScanViewModel *viewModel;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *hintLabel;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIView *navBar;
@property (nonatomic, strong) UIView *scanFrameView;
@property (nonatomic, strong) CAShapeLayer *overlayLayer;
@property (nonatomic, strong) CAShapeLayer *scanLineLayer;
@property (nonatomic, assign) BOOL isScanningAnimationActive;
@property (nonatomic, assign) BOOL viewAppeared;
@property (nonatomic, copy) NSString *scanResult;

@end

@implementation OpmScanVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.viewAppeared = YES;
    if (self.previewLayer) {
        [self startScanning];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewModel = [[OpmScanViewModel alloc] init];
    self.viewModel.delegate = self;
    [self setupView];
    [self checkCameraPermission];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 延迟设置预览层，确保视图尺寸正确
    if (!self.previewLayer) {
        [self setupPreviewLayer];
        [self startScanning];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopScanning];
    self.viewAppeared = NO;
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (_scanResultBlock) {
        _scanResultBlock(_scanResult);
    }
}
- (void)setupView {
    self.view.backgroundColor = [UIColor blackColor];
    
    // 状态栏高度
    CGFloat navBarHeight = kStatusBarHeight + 44;
    CGFloat selfWidth = self.view.bounds.size.width;

    // 自定义导航栏
    self.navBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, selfWidth, navBarHeight)];
    self.navBar.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.navBar];
    
    // 返回按钮
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.frame = CGRectMake(10, kStatusBarHeight, 44, 44);
    __weak typeof(self) weakSelf = self;
    
    // 自定义返回按钮，添加容错处理
    UIImage *backImage = [UIImage imageNamed:@"ppt-back"];
    // 图片不存在时使用系统默认图片兜底
    if (!backImage) {
        if (@available(iOS 13.0, *)) {
            backImage = [UIImage systemImageNamed:@"chevron.left"];
        } else {
            backImage = [[UIImage imageNamed:@""] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
    } else {
        backImage = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    [self.backButton setImage:backImage forState:(UIControlStateNormal)];
    self.backButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:self.backButton];
    
    // 标题
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, self.navBar.bounds.size.width, 44)];
    self.titleLabel.text = @"扫码";
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.navBar addSubview:self.titleLabel];
    
    // 容器视图
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, navBarHeight,selfWidth, self.view.bounds.size.height - navBarHeight)];
    self.containerView.backgroundColor = [UIColor clearColor];
    self.containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.containerView];
    
    // 扫描框视图
    CGFloat scanSize = self.containerView.bounds.size.width * 0.7;
    CGFloat scanX = (self.containerView.bounds.size.width - scanSize) / 2;
    CGFloat scanY = (self.containerView.bounds.size.height - scanSize) / 2 - 20;
    
    self.scanFrameView = [[UIView alloc] initWithFrame:CGRectMake(scanX, scanY, scanSize, scanSize)];
    self.scanFrameView.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor;
    self.scanFrameView.layer.borderWidth = 1.0;
    self.scanFrameView.backgroundColor = [UIColor clearColor];
    self.scanFrameView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin |
                                         UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.containerView addSubview:self.scanFrameView];
    
    // 提示文字
    self.hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(40,
                                                              CGRectGetMaxY(self.scanFrameView.frame) + 40,
                                                              self.containerView.bounds.size.width - 80,
                                                              50)];
    self.hintLabel.numberOfLines = 0;
    self.hintLabel.textAlignment = NSTextAlignmentCenter;
    self.hintLabel.text = @"请扫描无人车屏幕上的二维码\n绑定车辆后遥控";
    self.hintLabel.textColor = [UIColor whiteColor];
    self.hintLabel.font = [UIFont systemFontOfSize:16];
    self.hintLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [self.containerView addSubview:self.hintLabel];
    
    // 添加扫描框四角装饰
    [self addCornerMarksToView:self.scanFrameView];
}

- (void)setupPreviewLayer {
    if (self.previewLayer) return;
    
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.viewModel.captureSession];
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.previewLayer.frame = self.containerView.bounds;
    [self.containerView.layer insertSublayer:self.previewLayer atIndex:0];
    
    // 添加半透明遮罩层
    [self addScanOverlay];
    
    // 设置扫描线
    [self setupScanLine];
}

- (void)addCornerMarksToView:(UIView *)view {
    // 清除旧的角标
    NSArray *subLayers = [view.layer.sublayers copy];
    for (CALayer *layer in subLayers) {
        if ([layer isKindOfClass:[CAShapeLayer class]]) {
            [layer removeFromSuperlayer];
        }
    }
    
    CGFloat cornerLength = 20.0;
    CGFloat lineWidth = 2.0;
    UIColor *cornerColor = [UIColor colorWithRed:0.0 green:0.8 blue:0.4 alpha:1.0];
    CGRect bounds = view.bounds;
    
    // 左上角
    [self addCornerLineFrom:CGPointMake(0, 0) to:CGPointMake(cornerLength, 0) color:cornerColor width:lineWidth toView:view];
    [self addCornerLineFrom:CGPointMake(0, 0) to:CGPointMake(0, cornerLength) color:cornerColor width:lineWidth toView:view];
    
    // 右上角
    [self addCornerLineFrom:CGPointMake(bounds.size.width, 0) to:CGPointMake(bounds.size.width - cornerLength, 0) color:cornerColor width:lineWidth toView:view];
    [self addCornerLineFrom:CGPointMake(bounds.size.width, 0) to:CGPointMake(bounds.size.width, cornerLength) color:cornerColor width:lineWidth toView:view];
    
    // 左下角
    [self addCornerLineFrom:CGPointMake(0, bounds.size.height) to:CGPointMake(cornerLength, bounds.size.height) color:cornerColor width:lineWidth toView:view];
    [self addCornerLineFrom:CGPointMake(0, bounds.size.height) to:CGPointMake(0, bounds.size.height - cornerLength) color:cornerColor width:lineWidth toView:view];
    
    // 右下角
    [self addCornerLineFrom:CGPointMake(bounds.size.width, bounds.size.height) to:CGPointMake(bounds.size.width - cornerLength, bounds.size.height) color:cornerColor width:lineWidth toView:view];
    [self addCornerLineFrom:CGPointMake(bounds.size.width, bounds.size.height) to:CGPointMake(bounds.size.width, bounds.size.height - cornerLength) color:cornerColor width:lineWidth toView:view];
}

- (void)addCornerLineFrom:(CGPoint)from to:(CGPoint)to color:(UIColor *)color width:(CGFloat)width toView:(UIView *)view {
    CAShapeLayer *line = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:from];
    [path addLineToPoint:to];
    
    line.path = path.CGPath;
    line.strokeColor = color.CGColor;
    line.lineWidth = width;
    line.fillColor = nil;
    
    [view.layer addSublayer:line];
}

- (void)addScanOverlay {
    if (self.overlayLayer) {
        [self.overlayLayer removeFromSuperlayer];
    }
    
    self.overlayLayer = [CAShapeLayer layer];
    self.overlayLayer.fillColor = [[UIColor blackColor] colorWithAlphaComponent:0.4].CGColor;
    
    UIBezierPath *overlayPath = [UIBezierPath bezierPathWithRect:self.containerView.bounds];
    
    // 扫描框透明区域
    UIBezierPath *transparentPath = [UIBezierPath bezierPathWithRect:self.scanFrameView.frame];
    [overlayPath appendPath:transparentPath];
    overlayPath.usesEvenOddFillRule = YES;
    
    self.overlayLayer.path = overlayPath.CGPath;
    self.overlayLayer.fillRule = kCAFillRuleEvenOdd;
    
    [self.containerView.layer insertSublayer:self.overlayLayer above:self.previewLayer];
}

- (void)setupScanLine {
    if (self.scanLineLayer) {
        [self.scanLineLayer removeFromSuperlayer];
        self.scanLineLayer = nil;
    }
    
    self.scanLineLayer = [CAShapeLayer layer];
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:CGPointMake(0, 0)];
    [linePath addLineToPoint:CGPointMake(CGRectGetWidth(self.scanFrameView.bounds), 0)];
    
    self.scanLineLayer.path = linePath.CGPath;
    self.scanLineLayer.strokeColor = [UIColor colorWithRed:0.0 green:0.8 blue:0.4 alpha:1.0].CGColor;
    self.scanLineLayer.lineWidth = 2.0;
    self.scanLineLayer.shadowColor = [UIColor greenColor].CGColor;
    self.scanLineLayer.shadowOffset = CGSizeMake(0, 0);
    self.scanLineLayer.shadowRadius = 3.0;
    self.scanLineLayer.shadowOpacity = 0.8;
    
    [self.scanFrameView.layer addSublayer:self.scanLineLayer];
}

- (void)startScanLineAnimation {
    if (!self.scanLineLayer || self.isScanningAnimationActive) return;
    
    CABasicAnimation *scanAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    scanAnimation.fromValue = @(0);
    scanAnimation.toValue = @(CGRectGetHeight(self.scanFrameView.bounds));
    scanAnimation.duration = 2.0;
    scanAnimation.repeatCount = HUGE_VALF;
    scanAnimation.autoreverses = YES;
    scanAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [self.scanLineLayer addAnimation:scanAnimation forKey:@"scanLineAnimation"];
    self.isScanningAnimationActive = YES;
}

- (void)stopScanLineAnimation {
    if (self.scanLineLayer) {
        [self.scanLineLayer removeAllAnimations];
        self.isScanningAnimationActive = NO;
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat navBarHeight = kNavigationBarHeight;
    CGFloat selfWidth = self.view.bounds.size.width;
    
    self.navBar.frame = CGRectMake(0, 0, selfWidth, navBarHeight);
    
    // 更新容器视图
    self.containerView.frame = CGRectMake(0, navBarHeight,selfWidth,
                                        self.view.bounds.size.height - navBarHeight);
    
    // 更新扫描框位置
    CGFloat scanSize = self.containerView.bounds.size.width * 0.7;
    CGFloat scanX = (self.containerView.bounds.size.width - scanSize) / 2;
    CGFloat scanY = (self.containerView.bounds.size.height - scanSize) / 2 - 20;
    self.scanFrameView.frame = CGRectMake(scanX, scanY, scanSize, scanSize);
    
    // 更新提示文字位置
    self.hintLabel.frame = CGRectMake(40, CGRectGetMaxY(self.scanFrameView.frame) + 40, self.containerView.bounds.size.width - 80, 50);
    
    // 更新返回按钮位置
    self.backButton.frame = CGRectMake(10, kStatusBarHeight, 44, 44);
    
    // 更新标题位置
    self.titleLabel.frame = CGRectMake(0, kStatusBarHeight, self.navBar.bounds.size.width, 44);
    
    // 更新预览层frame
    if (self.previewLayer) {
        self.previewLayer.frame = self.containerView.bounds;
    }
    
    // 更新遮罩层
    if (self.overlayLayer) {
        [self addScanOverlay];
    }
    
    // 更新扫描框角标
    [self addCornerMarksToView:self.scanFrameView];
    
    // 更新扫描线
    if (self.scanLineLayer) {
        [self setupScanLine];
        if (self.isScanningAnimationActive) {
            [self startScanLineAnimation];
        }
    }
}

- (void)checkCameraPermission {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    switch (status) {
        case AVAuthorizationStatusAuthorized:
            // 已授权，延迟设置预览层
            break;
            
        case AVAuthorizationStatusNotDetermined: {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (granted) {
                        if (self.viewAppeared) {
                            [self setupPreviewLayer];
                            [self startScanning];
                        }
                    } else {
                        [self handleCameraPermissionDenied];
                    }
                });
            }];
            break;
        }
            
        default: {
            [self handleCameraPermissionDenied];
            break;
        }
    }
}

- (void)handleCameraPermissionDenied {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.viewModel.delegate scanErrorOccurred:ScanErrorCameraPermissionDenied];
    });
}

- (void)startScanning {
    [self.viewModel startScanning];
    [self startScanLineAnimation];
}

- (void)stopScanning {
    [self.viewModel stopScanning];
    [self stopScanLineAnimation];
}

- (void)backAction {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.presentingViewController) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else if (self.navigationController) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    });
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - ScanViewModelDelegate
- (void)didScanResultReceived:(NSString *)result {
    if (result) {
        [self stopScanning];
        self.scanResult = result;
        [self backAction];
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"扫描成功" message:[NSString stringWithFormat:@"已扫描: %@", result] preferredStyle:UIAlertControllerStyleAlert];
//        __weak typeof(self) weakSelf = self;
//        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            [weakSelf.viewModel restartScanning];
//            [weakSelf startScanning];
//        }]];
//        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [OpmToast showCenterWithText:@"未识别到有效二维码"];
        [self.viewModel restartScanning];
        [self startScanning];
    }
}

- (void)scanErrorOccurred:(ScanError)error {
    NSString *errorMessage = nil;
    
    switch (error) {
        case ScanErrorCameraPermissionDenied:
            errorMessage = @"相机权限被拒绝，请前往设置开启权限";
            break;
            
        case ScanErrorCameraNotAvailable:
            errorMessage = @"相机不可用";
            break;
            
        case ScanErrorSetupFailed:
            errorMessage = @"相机初始化失败";
            break;
    }
    
    __weak typeof(self) weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf backAction];
    }];
    [alert addAction:confirmAction];
    // 仅当权限问题时才显示设置按钮
    if (error == ScanErrorCameraPermissionDenied) {
        UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        }];
        [alert addAction:settingsAction];
    }
    [self presentViewController:alert animated:YES completion:nil];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}

@end
