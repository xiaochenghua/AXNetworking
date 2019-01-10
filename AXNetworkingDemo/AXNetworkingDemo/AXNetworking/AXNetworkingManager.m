//
//  AXNetworkingManager.m
//  AXNetworking
//
//  Created by xiaochenghua on 2019/1/8.
//  Copyright © 2019 xiaochenghua. All rights reserved.
//

#import "AXNetworkingManager.h"
#import "AFHTTPSessionManager.h"
#import "AXNetworkingUtils.h"
#import "AXNetworkingMacro.h"
#import "AXNetworkingConstants.h"

@implementation AXNetworkingManager

static AXNetworkingManager *_manager = nil;

#pragma mark - 分配内存：单例
+ (instancetype)manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[self allocWithZone:NULL] initWithBaseURL:[NSURL URLWithString:@""]];
        //  设置请求头信息
        [_manager setUpRequestHeaderFields];
        //  设置响应头信息
        [_manager setUpResponseHeaderFields];
        //  配置安全策略
        [_manager setUpSecurityPolicy];
    });
    return _manager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self manager];
}

#pragma mark - 设置信息
- (void)setUpRequestHeaderFields {
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    self.requestSerializer.timeoutInterval = 40;
    [self.requestSerializer setValue:@"AXNetworking-Demo-iOS" forHTTPHeaderField:@"User-Agent"];
    [self.requestSerializer setValue:@"UTF-8" forHTTPHeaderField:@"Charset"];
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [self.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [self.requestSerializer setValue:@"lite" forHTTPHeaderField:@"Xne"];
}

- (void)setUpResponseHeaderFields {
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    NSMutableSet *additionSet = [NSMutableSet setWithArray:@[@"text/plain", @"application/json", @"text/json", @"application/xml", @"text/html", @"image/tiff", @"image/jpeg", @"image/gif", @"image/png", @"image/ico", @"image/x-icon", @"image/bmp", @"image/x-bmp", @"image/x-xbitmap", @"image/x-win-bitmap", @"multipart/form-data"]];
    self.responseSerializer.acceptableContentTypes = [self.responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:additionSet];
}

- (void)setUpSecurityPolicy {
#ifdef DEBUG
    //  设置校验证书模式(不校验证书)
    self.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    //  信任非法证书
    self.securityPolicy.allowInvalidCertificates = YES;
#else
    //  设置校验证书模式(校验证书)
    self.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
    //  不信任非法证书
    self.securityPolicy.allowInvalidCertificates = NO;
#endif
    //  是否在证书域字段中验证域名
    self.securityPolicy.validatesDomainName = NO;
}

#pragma mark - 网络请求
- (void)requestWithUrl:(NSString *)url parameters:(NSDictionary *)parameters class:(Class)cls completion:(AXNetworkingCompletion)completion {
    [self requestWithMethod:AXNetworkingRequestMethodTypePOST
                        url:url
                 parameters:parameters
                      class:cls
                 completion:completion];
}

- (void)requestWithMethod:(AXNetworkingRequestMethodType)methodType url:(NSString *)url parameters:(NSDictionary *)parameters class:(Class)cls completion:(AXNetworkingCompletion)completion {
    NSString *urlString = [NSURL URLWithString:url relativeToURL:self.baseURL].absoluteString;
    NSDictionary *requestParameters = [AXNetworkingUtils requestParametersWithUserParameters:parameters];
    
    @AXNWeak(self)
    [self requestWithMethod:methodType
                        url:urlString
                 parameters:requestParameters
                      class:cls
                    success:^(id _Nullable responseObject) {
                        @AXNStrong(self)
                        [self handleWithResponseObject:responseObject class:cls completion:completion];
                    } failure:^(NSError * _Nonnull error) {
                        @AXNStrong(self)
                        [self handleWithError:error completion:completion];
                    }];
}

- (void)requestWithMethod:(AXNetworkingRequestMethodType)methodType url:(NSString *)urlString parameters:(NSDictionary *)requestParameters class:(Class)cls success:(void (^)(id _Nullable))success failure:(void (^)(NSError * _Nonnull))failure {
    switch (methodType) {
        case AXNetworkingRequestMethodTypePOST: {
            [self postUrl:urlString parameters:requestParameters class:cls success:success failure:failure];
            break;
        }
        case AXNetworkingRequestMethodTypeGET: {
            [self getUrl:urlString parameters:requestParameters class:cls success:success failure:failure];
            break;
        }
        case AXNetworkingRequestMethodTypeHEAD: {
            [self headUrl:urlString parameters:requestParameters class:cls success:success failure:failure];
            break;
        }
    }
}

- (void)postUrl:(NSString *)urlString parameters:(NSDictionary *)requestParameters class:(Class)cls success:(void (^)(id _Nullable))success failure:(void (^)(NSError * _Nonnull))failure {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self POST:urlString parameters:requestParameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) {
                    success(responseObject);
                }
            });
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) {
                    failure(error);
                }
            });
        }];
    });
}

- (void)getUrl:(NSString *)urlString parameters:(NSDictionary *)requestParameters class:(Class)cls success:(void (^)(id _Nullable))success failure:(void (^)(NSError * _Nonnull))failure {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self GET:urlString parameters:requestParameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) {
                    success(responseObject);
                }
            });
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) {
                    failure(error);
                }
            });
        }];
    });
}

- (void)headUrl:(NSString *)urlString parameters:(NSDictionary *)requestParameters class:(Class)cls success:(void (^)(id _Nullable))success failure:(void (^)(NSError * _Nonnull))failure {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self HEAD:urlString parameters:requestParameters success:^(NSURLSessionDataTask * _Nonnull task) {
            NSDictionary *allHeaderFields = ((NSHTTPURLResponse *)task.response).allHeaderFields;
            NSLog(@"%@", allHeaderFields);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) {
                    failure(error);
                }
            });
        }];
    });
}

#pragma mark - 主线程中处理回调
/**
 处理响应数据

 @param responseObject 响应数据
 @param cls 需要解析成的实体类
 @param completion 最后需要执行的回调
 */
- (void)handleWithResponseObject:(id)responseObject class:(Class)cls completion:(AXNetworkingCompletion)completion {
    [self handleWithResponseObject:responseObject class:cls error:nil completion:completion];
}

/**
 处理错误

 @param error 错误信息
 @param completion 最后需要执行的回调
 */
- (void)handleWithError:(NSError *)error completion:(AXNetworkingCompletion)completion {
    [self handleWithResponseObject:nil class:nil error:error completion:completion];
}

/**
 统一处理响应或错误

 @param responseObject 响应数据
 @param cls 需要解析成的实体类
 @param error 错误信息
 @param completion 最后需要执行的回调
 */
- (void)handleWithResponseObject:(id)responseObject class:(Class)cls error:(NSError *)error completion:(AXNetworkingCompletion)completion {
    if (!completion) { return; }
    AXNetworkingTemplateData *templateData = [self templateDataWithObject:responseObject class:cls error:error];
    dispatch_async(dispatch_get_main_queue(), ^{
        //  主线程执行
        completion(templateData);
    });
}

#pragma mark - 构建响应数据
- (AXNetworkingTemplateData *)templateDataWithObject:(id)responseObject class:(Class)cls error:(NSError *)error {
    AXNetworkingTemplateData *templateData = nil;
    if (error) {
        //  失败
        templateData = [[AXNetworkingTemplateData alloc] init];
        templateData.success = NO;
        templateData.errorCode = [NSString stringWithFormat:@"%ld", (long)error.code];
        templateData.errorType = AXNetworkingResponseErrorTypeUnknow;
        templateData.data = nil;
        
        switch (error.code) {
            case NSURLErrorTimedOut:{
                templateData.errorType = AXNetworkingResponseErrorTypeTimeout;
                break;
            }
                
            case NSURLErrorUserCancelledAuthentication: {
                [[NSNotificationCenter defaultCenter] postNotificationName:kAXNetworkingNotificationNameUnsafeNetwork object:nil];
                break;
            }
        }
        
        if ([AFNetworkReachabilityManager manager].networkReachabilityStatus == AFNetworkReachabilityStatusUnknown || [AFNetworkReachabilityManager manager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kAXNetworkingNotificationNameUnKnowNetwork object:nil];
        }
    } else {
        //  成功
        if (!responseObject || ![responseObject isKindOfClass:NSDictionary.class]) { return nil; }
        
        NSDictionary *responseDict = (NSDictionary *)responseObject;
        templateData = [[AXNetworkingTemplateData alloc] initWithDictionary:responseDict];
        
        if (cls && [responseDict[@"data"] isKindOfClass:NSDictionary.class]) {
            templateData.data = [cls performSelector:@selector(yy_modelWithDictionary:) withObject:(NSDictionary *)responseDict[@"data"]];
        }
        templateData.success = YES;
        templateData.errorCode = nil;
        templateData.errorMessage = nil;
        templateData.errorType = -1;
    }
    return templateData;
}

@end
