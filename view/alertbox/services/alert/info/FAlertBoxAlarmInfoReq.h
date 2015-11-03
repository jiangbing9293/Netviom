//
//  FAlertBoxAlarmInfoReq.h
//  Supereye
//
//  Created by jiang bing on 15/10/19.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import "SERequest.h"
/***
 * 获取报警盒报警信息 req
 ****/
@interface FAlertBoxAlarmInfoReq : SERequest

@property ( nonatomic, retain) NSString *boxID;
@property ( nonatomic, retain) NSString *endDate;
@property ( nonatomic, retain) NSString *pageNo;
@property ( nonatomic, retain) NSString *pageSize;
@property ( nonatomic, retain) NSString *startDate;

+(id)requestWithAuth:(NSString *)auth;
-(NSString *)getXML;//由子类实现

@end
