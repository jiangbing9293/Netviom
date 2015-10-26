//
//  FAlertBoxResponseCfgReq.h
//  Supereye
//
//  Created by jiang bing on 15/10/16.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import "SERequest.h"
#import "FAlertBoxAlertSet.h"
/***
 * 配置报警盒报警设置 req
 ****/
@interface FAlertBoxResponseCfgReq : SERequest

@property ( nonatomic, retain) FAlertBoxAlertSet *alertSet;
+(id)requestWithAuth:(NSString *)auth;
-(NSString *)getXML;//由子类实现

@end
