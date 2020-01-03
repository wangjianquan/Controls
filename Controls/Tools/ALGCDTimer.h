//
//  ALGCDTimer.h
//  AssistedLearning
//
//  Created by jieyue on 2019/11/5.
//  Copyright © 2019 qipei. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ALGCDTimer : NSObject

+ (ALGCDTimer *)repeatingTimerWithTimeInterval:(NSTimeInterval)seconds block:(dispatch_block_t)block;

- (void)fire;

- (void)invalidate;


@end



