//
//  OpmCustomButton.h
//  OpmSDK
//
//  Created by jieyue_M1 on 2025/7/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, ImagePosition) {
    ImagePositionLeft = 0,    // 图片在左，文字在右
    ImagePositionRight = 1,   // 图片在右，文字在左
    ImagePositionTop = 2,     // 图片在上，文字在下
    ImagePositionBottom = 3   // 图片在下，文字在上
};
typedef NS_ENUM(NSInteger, OpmButtonType) {
    OpmButtonTypeInteract,     // 互动
    OpmButtonTypeMonitor,      // 监控
    OpmButtonTypeTaskRecord,   // 任务记录
    OpmButtonTypePower,        // 开机/关机
    OpmButtonTypeOpenCabinet,  // 开柜门
    OpmButtonTypeRemote,       // 遥控
    OpmButtonTypeLight,       // 灯光
    OpmButtonTypeOpenBatteryCabin//开电池舱
};
@interface OpmCustomButton : UIButton

@property (nonatomic, assign) OpmButtonType btnType;
@property (nonatomic, assign) ImagePosition imagePosition; // 图片位置
@property (nonatomic, assign) CGFloat spacing;             // 图片和文字的间距
@property (nonatomic, assign) UIEdgeInsets contentInsets;  // 内容内边距
@property (nonatomic, assign) BOOL showImgBgColorView;
@property (nonatomic, strong) UIColor *imgBgColor;

/**
 便捷初始化方法

 @param position 图片位置
 @param spacing 图片和文字的间距
 @return 自定义按钮实例
 */
- (instancetype)initWithImagePosition:(ImagePosition)position spacing:(CGFloat)spacing buttonType:(OpmButtonType)buttonType;

@end

NS_ASSUME_NONNULL_END
