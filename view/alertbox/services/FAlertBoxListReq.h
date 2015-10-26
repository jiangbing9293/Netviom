//
//  SERequest+FAlertBoxListReq.h
//  Supereye
//
//  Created by jiang bing on 15/10/8.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import "SERequest.h"
/***
 * 获取报警盒设备列表 req 打包
 ****/
@interface FAlertBoxListReq : SERequest

+(id)requestWithAuth:(NSString *)auth;
-(NSString *)getXML;//由子类实现

@end
