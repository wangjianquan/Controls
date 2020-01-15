//
//  MaskView.h
//  Controls
//
//  Created by MacBook Pro on 2020/1/15.
//  Copyright © 2020 WJQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    BannerSrollDirectionUnknow,
    BannerSrollDirectionLeft,
    BannerSrollDirectionRight,
} BannerSrollDirection;

NS_ASSUME_NONNULL_BEGIN

@interface MaskView : UIView

-(void)setRadius:(CGFloat)radius direction:(BannerSrollDirection)dir;
@end

NS_ASSUME_NONNULL_END
