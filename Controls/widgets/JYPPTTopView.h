//
//  JYPPTTopView.h
//  dsd
//
//  Created by bxh on 2021/12/3.
//

#import <UIKit/UIKit.h>

@protocol JYPPTTopViewDelegate <NSObject>

- (void)topViewAudioPlayAction;
- (void)topViewVideoPlayAction;
- (void)topViewQuestionAction;

@end

@interface JYPPTTopView : UIView

@property (nonatomic, weak) id<JYPPTTopViewDelegate> delegate;
@property (nonatomic) BOOL open;
@property (nonatomic, copy) NSString * questionTitle;
@property (nonatomic, copy) NSString * questionBadgeStr;
@property (nonatomic, assign) BOOL quesBtnEnabled;
@property (nonatomic, assign) BOOL showQuestion;

@property(nonatomic, copy) void(^updateFrameBlock)(BOOL selected);

@end

