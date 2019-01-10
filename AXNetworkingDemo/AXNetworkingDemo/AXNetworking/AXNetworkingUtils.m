//
//  AXNetworkingUtils.m
//  AXNetworking
//
//  Created by xiaochenghua on 2019/1/9.
//  Copyright © 2019 xiaochenghua. All rights reserved.
//

#import "AXNetworkingUtils.h"
#import <CommonCrypto/CommonDigest.h>
#import <CoreLocation/CoreLocation.h>
#import "AXNetworkingConstants.h"
#import "sys/utsname.h"

@implementation AXNetworkingUtils

+ (NSDictionary *)requestParametersWithUserParameters:(NSDictionary *)userParameters {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (userParameters) {
        [parameters setValue:userParameters forKey:@"body"];
    }
    //  设置自定义
    [parameters setValue:[self headerParameters] forKey:@"header"];
    return parameters.copy;
}

+ (NSDictionary *)headerParameters {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:UIDevice.currentDevice.systemName forKey:@"OSType"];
    [parameters setValue:UIDevice.currentDevice.systemVersion forKey:@"OSVersion"];
    [parameters setValue:NSBundle.mainBundle.infoDictionary[@"CFBundleShortVersionString"] forKey:@"APPVersion"];
    [parameters setValue:[self deviceType] forKey:@"DeviceType"];
    [parameters setValue:[self deviceResolution] forKey:@"DeviceResolution"];
    [parameters setValue:[self currentNetwork] forKey:@"Network"];
    return parameters.copy;
}

+ (NSString *)md5StringWithString:(NSString *)string {
    const char *cStr = string.UTF8String;
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *resultString = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [resultString appendFormat:@"%02X", digest[i]];
    }
    return resultString;
}

+ (NSString *)deviceType {
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

+ (NSString *)deviceResolution {
    CGRect bounds = UIScreen.mainScreen.bounds;
    CGFloat scale = UIScreen.mainScreen.scale;
    return [NSString stringWithFormat:@"%.0f*%.0f", CGRectGetWidth(bounds) * scale, CGRectGetHeight(bounds) * scale];
}

+ (NSString *)currentNetwork {
    switch ([AFNetworkReachabilityManager manager].networkReachabilityStatus) {
        case AFNetworkReachabilityStatusUnknown: {
            return @"Unknown";
        }
        case AFNetworkReachabilityStatusNotReachable: {
            return nil;
        }
        case AFNetworkReachabilityStatusReachableViaWWAN: {
            return @"Cellular";
        }
        case AFNetworkReachabilityStatusReachableViaWiFi: {
            return @"WiFi";
        }
    }
}

@end
