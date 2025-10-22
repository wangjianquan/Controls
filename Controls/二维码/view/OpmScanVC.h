//
//  OpmScanVC.h
//  OpmSDK
//
//  Created by jieyue_M1 on 2025/7/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OpmScanVC : UIViewController

@property (nonatomic, nullable, copy) NSString *vin;
@property (nonatomic, nullable, copy) void(^scanResultBlock)(NSString *result);

@end

NS_ASSUME_NONNULL_END
