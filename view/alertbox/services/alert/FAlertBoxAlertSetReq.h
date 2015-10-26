//
//  FAlertBoxAlertSetReq.h
//  Supereye
//
//  Created by jiang bing on 15/10/15.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import "SERequest.h"
/***
 * 获取报警盒报警设置信息 req 打包  
 ***/
@interface FAlertBoxAlertSetReq : SERequest

@property ( nonatomic, retain) NSString *boxID;

+(id)requestWithAuth:(NSString *)auth;
-(NSString *)getXML;//由子类实现

@end
