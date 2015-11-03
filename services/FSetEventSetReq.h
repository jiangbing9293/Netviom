//
//  FSetEventSetReq.h
//  Supereye
//
//  Created by jiang bing on 15/7/12.
//  Copyright (c) 2015年 Netviom. All rights reserved.
//

#import "SERequest.h"

@interface FSetEventSetReq : SERequest

@property (nonatomic, assign)NSInteger emailnotify;
@property (nonatomic, assign)NSInteger safelevel;
@property (nonatomic, assign)NSInteger smsnotify;
@property ( nonatomic, assign) NSInteger pushNotify;
@property ( nonatomic, assign) NSInteger wechatNotify;

+(id)requestWithAuth:(NSString *)auth;
-(NSString *)getXML;//由子类实现
@end
