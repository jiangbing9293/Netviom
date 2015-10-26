//
//  FSetEventRes.h
//  Supereye
//
//  Created by jiang bing on 15/7/12.
//  Copyright (c) 2015年 Netviom. All rights reserved.
//
/***
 *设置安全事件响应
 ***/
#import "SEBaseResponse.h"

@interface FSetEventRes : SEBaseResponse
- (void)parse;

+ (FSetEventRes *)initWithXMLString:(NSString *)xmlString;

@end
