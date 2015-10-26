//
//  FAlertBoxIpcamCfgReq.h
//  Supereye
//
//  Created by jiang bing on 15/10/17.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import "SERequest.h"
#import "FAlertBoxIpcamCfg.h"
/***
 *  配置报警盒于IPCAM联动
 ***/
@interface FAlertBoxIpcamCfgReq : SERequest

@property ( nonatomic ,retain) FAlertBoxIpcamCfg *ipcamCfg;

+(id)requestWithAuth:(NSString *)auth;
-(NSString *)getXML;//由子类实现

@end
