//
//  FSetEventSetReq.m
//  Supereye
//
//  Created by jiang bing on 15/7/12.
//  Copyright (c) 2015年 Netviom. All rights reserved.
//
/***
 *设置安全事件
 **/
#import "FSetEventSetReq.h"

@implementation FSetEventSetReq

+(id)requestWithAuth:(NSString *)auth{
    FSetEventSetReq *req = [[FSetEventSetReq alloc]init];
    //    [req setAuth:auth];
    if ([SERequest useToken]) {
        req.m_auth = auth;
    }
    else
    {
        req.m_auth = [GTMBase64 stringByEncodingData:[auth dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    return [req autorelease];
}
//由子类实现
-(NSString *)getXML
{
    NSMutableString *body = [NSMutableString string];
    [body appendFormat:@"<emailnotify>%d</emailnotify>", (int)_emailnotify];
    [body appendFormat:@"<safelevel>%d</safelevel>", (int)_safelevel];
    [body appendFormat:@"<smsnotify>%d</smsnotify>", (int)_smsnotify];
    [body appendFormat:@"<pushnotify>%d</pushnotify>", (int)_pushNotify];
    [body appendFormat:@"<wechatnotify>%d</wechatnotify>", (int)_wechatNotify];
    return [self buildXMLString:@"safe_event_setting" body:body];
}
@end
