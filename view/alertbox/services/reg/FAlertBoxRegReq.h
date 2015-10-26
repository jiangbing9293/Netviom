//
//  FAlertBoxRegReq.h
//  Supereye
//
//  Created by jiang bing on 15/10/9.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import "SERequest.h"
/***
 * 注册报警盒设备 req 打包
 ****/
@interface FAlertBoxRegReq : SERequest

@property ( nonatomic, retain) NSString *boxID;
@property ( nonatomic, retain) NSString *boxName;
@property ( nonatomic, retain) NSString *pwd;

+(id)requestWithAuth:(NSString *)auth;
-(NSString *)getXML;//由子类实现

@end

