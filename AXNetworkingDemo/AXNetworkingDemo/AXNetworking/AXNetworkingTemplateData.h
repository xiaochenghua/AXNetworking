//
//  AXNetworkingTemplateData.h
//  AXNetworking
//
//  Created by xiaochenghua on 2019/1/8.
//  Copyright © 2019 xiaochenghua. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, AXNetworkingResponseErrorType) {
    AXNetworkingResponseErrorTypeUnknow,
    AXNetworkingResponseErrorTypeTimeout,
};

@interface AXNetworkingTemplateData : NSObject

/**
 解析完成的响应数据，原数据为Dictionary
 */
@property (nonatomic, strong, nullable) id data;

/**
 错误码
 */
@property (nonatomic, copy, nullable) NSString *errorCode;

/**
 错误信息
 */
@property (nonatomic, copy, nullable) NSString *errorMessage;

/**
 请求是否成功？
 */
@property (nonatomic, assign, getter=isSuccess) BOOL success;

/**
 错误类型
 */
@property (nonatomic, assign) AXNetworkingResponseErrorType errorType;

/**
 指定初始化方法，构造模板数据

 @param dictionary 字典
 @return 模板数据
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
