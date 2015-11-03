//
//  FAlertBoxParaGetReq.h
//  Supereye
//
//  Created by jiang bing on 15/10/15.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import "SERequest.h"
/**
 *  获取报警盒设备参数 req
 ***/
@interface FAlertBoxParaGetReq : SERequest
@property ( nonatomic, retain) NSString *boxID;

+(id)requestWithAuth:(NSString *)auth;
-(NSString *)getXML;//由子类实现
@end
