//
//  ALBannerModel.h
//  AssistedLearning
//
//  Created by wjq on 2019/11/4.
//  Copyright © 2019 wjq. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ALBannerModel : NSObject

@property(nonatomic, copy)NSString *path;
@property(nonatomic, copy)NSString *title;
@property(nonatomic, copy)NSString *type;//type:类型 Goods跳转至商品，url跳转网页，Catalog 栏目

@property(nonatomic, copy)NSString *point;//point：跳转所需参数 商品ID、url、栏目ID


@end

NS_ASSUME_NONNULL_END
