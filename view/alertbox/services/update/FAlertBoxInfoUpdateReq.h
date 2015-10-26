//
//  FAlertBoxInfoUpdateReq.h
//  Supereye
//
//  Created by jiang bing on 15/10/14.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import "SERequest.h"
/***
 * 更新报警盒设备名称于排序 req 打包
 **/
@interface FAlertBoxInfoUpdateReq : SERequest

@property ( nonatomic, retain) NSString *boxID;
@property ( nonatomic, retain) NSString *boxName;
@property ( nonatomic, retain) NSString *order;

+(id)requestWithAuth:(NSString *)auth;
-(NSString *)getXML;//由子类实现
@end
