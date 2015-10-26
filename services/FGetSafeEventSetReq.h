//
//  FGetSafeEventSetReq.h
//  Supereye
//
//  Created by jiang bing on 15/7/10.
//  Copyright (c) 2015年 Netviom. All rights reserved.
//

#import "SERequest.h"
/***
 * 获取系统安全事件设置状态 Req打包
 ****/
@interface FGetSafeEventSetReq : SERequest

+(id)requestWithAuth:(NSString *)auth;
-(NSString *)getXML;//由子类实现

@end
