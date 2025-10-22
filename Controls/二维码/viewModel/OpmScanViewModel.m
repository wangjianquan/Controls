//
//  OpmScanViewModel.m
//  OpmSDK
//
//  Created by jieyue_M1 on 2025/7/28.
//

#import "OpmScanViewModel.h"

@interface OpmScanViewModel ()

@property (nonatomic, strong) dispatch_queue_t sessionQueue;
@property (nonatomic, strong) AVCaptureMetadataOutput *metadataOutput;
@property (nonatomic, assign) BOOL setupCompleted;
@property (nonatomic, assign) BOOL shouldStartScanningWhenReady;

@end

@implementation OpmScanViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _sessionQueue = dispatch_queue_create("com.Controls.scan.sessionQueue", DISPATCH_QUEUE_SERIAL);
        _model = [[OpmQRModel alloc] init];
        _setupCompleted = NO;
        _shouldStartScanningWhenReady = NO;
        
        dispatch_async(_sessionQueue, ^{
            [self setupCaptureSession];
        });
    }
    return self;
}

- (void)setupCaptureSession {
    if (_setupCompleted) return;
    
    _captureSession = [[AVCaptureSession alloc] init];
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if (!device) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate scanErrorOccurred:ScanErrorCameraNotAvailable];
        });
        return;
    }
    
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    if (!input) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate scanErrorOccurred:ScanErrorSetupFailed];
        });
        return;
    }
    
    if ([_captureSession canAddInput:input]) {
        [_captureSession addInput:input];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate scanErrorOccurred:ScanErrorSetupFailed];
        });
        return;
    }
    
    _metadataOutput = [[AVCaptureMetadataOutput alloc] init];
    if ([_captureSession canAddOutput:_metadataOutput]) {
        [_captureSession addOutput:_metadataOutput];
        [_metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        [_metadataOutput setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate scanErrorOccurred:ScanErrorSetupFailed];
        });
        return;
    }
    
    _setupCompleted = YES;
    
    // 如果之前请求了开始扫描
    if (_shouldStartScanningWhenReady) {
        _shouldStartScanningWhenReady = NO;
        [self startScanning];
    }
}

- (void)startScanning {
    if (!_setupCompleted) {
        _shouldStartScanningWhenReady = YES;
        return;
    }
    
    dispatch_async(_sessionQueue, ^{
        if (!self.captureSession.isRunning) {
            [self.captureSession startRunning];
        }
    });
}

- (void)stopScanning {
    dispatch_async(_sessionQueue, ^{
        if (self.captureSession.isRunning) {
            [self.captureSession stopRunning];
        }
    });
}

- (void)restartScanning {
    [self stopScanning];
    [self startScanning];
}

- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    for (AVMetadataObject *metadata in metadataObjects) {
        if ([metadata.type isEqualToString:AVMetadataObjectTypeQRCode]) {
            AVMetadataMachineReadableCodeObject *code = (AVMetadataMachineReadableCodeObject *)metadata;
            if (code.stringValue) {
                // 防止重复处理
                if (![self.model.scannedResult isEqualToString:code.stringValue]) {
                    self.model.scannedResult = code.stringValue;
                    [self stopScanning];
                    
                    if ([self.delegate respondsToSelector:@selector(didScanResultReceived:)]) {
                        [self.delegate didScanResultReceived:code.stringValue];
                    }
                }
            }
        }
    }
}

@end
