//
//  FloatAudioView.h
//  YunTingKeTang
//
//  Created by wjq on 2019/4/23.
//  Copyright © 2019 云听课堂. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FloatAudioView : UIView

+ (FloatAudioView *)sharedInstance;

//@property (nonatomic, copy) void (^playBlock)(UIButton *sender);
@property (nonatomic, copy) void (^tapBlock)(UIButton *sender);
@property (nonatomic, copy) void (^closeBlock)(UIButton *sender);

/**传入父View*/
@property(nonatomic,weak) UIView *parentView;
@property (nonatomic, strong) UINavigationController *naviControll;
@property (nonatomic, assign) BOOL isHidden;
- (void)show;
- (void)remove;
- (void)playAction;
@property (nonatomic, copy) NSString *imageName;

@end

NS_ASSUME_NONNULL_END
