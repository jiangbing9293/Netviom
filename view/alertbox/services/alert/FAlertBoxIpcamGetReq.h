//
//  FAlertBoxIpcamGetReq.h
//  Supereye
//
//  Created by jiang bing on 15/10/16.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import "SERequest.h"
/****
 *   查看报警盒鱼ipcam 关联配置
 ****/
@interface FAlertBoxIpcamGetReq : SERequest
@property ( nonatomic, retain) NSString *boxID;
+(id)requestWithAuth:(NSString *)auth;
-(NSString *)getXML;//由子类实现
@end
