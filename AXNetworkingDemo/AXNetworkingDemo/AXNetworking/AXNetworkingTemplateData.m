//
//  AXNetworkingTemplateData.m
//  AXNetworking
//
//  Created by xiaochenghua on 2019/1/8.
//  Copyright © 2019 xiaochenghua. All rights reserved.
//

#import "AXNetworkingTemplateData.h"

@implementation AXNetworkingTemplateData

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}

- (instancetype)init {
    return [self initWithDictionary:@{}];
}

@end
