//
//  AXNetworkingMacro.h
//  AXNetworking
//
//  Created by xiaochenghua on 2019/1/9.
//  Copyright © 2019 xiaochenghua. All rights reserved.
//

#ifndef AXNetworkingMacro_h
#define AXNetworkingMacro_h

#define AXNWeak(o)      autoreleasepool{} __weak typeof(o) weak##o = o;
#define AXNStrong(o)    autoreleasepool{} __strong typeof(o) o = weak##o;

#endif /* AXNetworkingMacro_h */
