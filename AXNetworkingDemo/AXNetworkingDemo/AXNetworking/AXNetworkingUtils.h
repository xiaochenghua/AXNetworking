//
//  AXNetworkingUtils.h
//  AXNetworking
//
//  Created by xiaochenghua on 2019/1/9.
//  Copyright © 2019 xiaochenghua. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AXNetworkingUtils : NSObject

/**
 构造请求参数

 @param userParameters 用户自定义请求字段
 @return 请求参数
 */
+ (NSDictionary *)requestParametersWithUserParameters:(NSDictionary *)userParameters;

@end

NS_ASSUME_NONNULL_END
