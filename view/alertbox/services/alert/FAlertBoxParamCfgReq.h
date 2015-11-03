//
//  FAlertBoxParamCfgReq.h
//  Supereye
//
//  Created by jiang bing on 15/10/16.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import "SERequest.h"
#import "FAlertBoxParamGet.h"
/**
 *  配置报警盒设备参数  req
 ***/
@interface FAlertBoxParamCfgReq : SERequest
@property ( nonatomic, retain) FAlertBoxParamGet *paramGet;

+(id)requestWithAuth:(NSString *)auth;
-(NSString *)getXML;//由子类实现

@end
