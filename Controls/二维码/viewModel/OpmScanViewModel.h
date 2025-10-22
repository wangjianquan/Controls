//
//  OpmScanViewModel.h
//  OpmSDK
//
//  Created by jieyue_M1 on 2025/7/28.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "OpmQRModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ScanError) {
    ScanErrorCameraPermissionDenied,
    ScanErrorCameraNotAvailable,
    ScanErrorSetupFailed
};

@protocol ScanViewModelDelegate <NSObject>
- (void)didScanResultReceived:(NSString *)result;
- (void)scanErrorOccurred:(ScanError)error;
@end

@interface OpmScanViewModel : NSObject <AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic, weak) id<ScanViewModelDelegate> delegate;
@property (nonatomic, strong) OpmQRModel *model;
@property (nonatomic, strong, readonly) AVCaptureSession *captureSession;
@property (nonatomic, assign, readonly) BOOL isScanning;

- (void)startScanning;
- (void)stopScanning;
- (void)restartScanning;
@end

NS_ASSUME_NONNULL_END
