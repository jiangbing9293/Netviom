//
//  FTools.h
//  Supereye
//
//  Created by jiang bing on 15/6/13.
//  Copyright (c) 2015年 Netviom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/CaptiveNetwork.h>
@interface FTools : NSObject
/**
 *  获取当前WIFI SSID
 *
 *  @return ssid
 */
+(NSString *)currentWifiSSID;

+ (NSData*) base64Decode:(NSString *)string;
+ (NSString*) base64Encode:(NSData *)data;

@end
