//
//  ProjectMigrationPop.h
//  Controls
//
//  Created by jieyue on 2022/10/13.
//  Copyright © 2022 WJQ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProjectMigrationPop : UIView

@property (nonatomic, assign) CGFloat cornerRadius;
+ (void)showAlert:(NSString *)description
    otherSettings:(void (^) (ProjectMigrationPop *orderProcess))otherSetting;


@end

NS_ASSUME_NONNULL_END
