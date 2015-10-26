//用户子帐号列表
//  FUserAccountListReq.h
//  Supereye
//
//  Created by jiang bing on 15/7/8.
//  Copyright (c) 2015年 Netviom. All rights reserved.
//

#import "SERequest.h"
/**
 *获取用户子帐号信息
 */
@interface FUserAccountListReq : SERequest

+(id)requestWithAuth:(NSString *)auth;
-(NSString *)getXML;//由子类实现

@end
