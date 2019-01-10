//
//  AXNetworkingManager.h
//  AXNetworking
//
//  Created by xiaochenghua on 2019/1/8.
//  Copyright © 2019 xiaochenghua. All rights reserved.
//

#import "AXNetworkingTemplateData.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, AXNetworkingRequestMethodType) {
    AXNetworkingRequestMethodTypePOST,
    AXNetworkingRequestMethodTypeGET,
    AXNetworkingRequestMethodTypeHEAD,
};

typedef void(^AXHTTPNetworkingCompletion)(AXNetworkingTemplateData *templateData);

@interface AXNetworkingManager : AFHTTPSessionManager

+ (instancetype)manager;

/**
 发起网络请求，请求方法默认为POST

 @param url 请求地址，相对地址
 @param parameters 请求字段
 @param cls 需要解析数据的实体类
 @param completion 请求完成的回调
 */
- (void)requestWithUrl:(NSString *)url
            parameters:(NSDictionary *)parameters
                 class:(Class)cls
            completion:(AXHTTPNetworkingCompletion)completion;

/**
 发起网络请求，支持POST、GET、HEAD三种常用请求方法

 @param methodType 请求方法
 @param url 请求地址，相对地址
 @param parameters 请求字段
 @param cls 需要解析数据的实体类
 @param completion 请求完成的回调
 */
- (void)requestWithMethod:(AXNetworkingRequestMethodType)methodType
                      url:(NSString *)url
               parameters:(NSDictionary *)parameters
                    class:(Class)cls
               completion:(AXHTTPNetworkingCompletion)completion;

@end

NS_ASSUME_NONNULL_END
