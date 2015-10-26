//
//  FAlertBoxRegReq.m
//  Supereye
//
//  Created by jiang bing on 15/10/9.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import "FAlertBoxRegReq.h"

@implementation FAlertBoxRegReq

@synthesize boxID = _boxID;
@synthesize boxName = _boxName;
@synthesize pwd = _pwd;

- ( void) dealloc{
    [super dealloc];
    [_boxID release];
    [_boxName release];
    [_pwd release];
}

+(id)requestWithAuth:(NSString *)auth{
    FAlertBoxRegReq *req = [[FAlertBoxRegReq alloc]init];
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
/***
 <?xml version="1.0" encoding="utf-8"?>
 <request func="alterbox_reg" timestamp="20150812152944" token="SRJduQOgkBngeyoTkPxjB/g2anUUZWbJ3LheGWBmeIrAw+j+qmzdWjKDdzpsQyEx">
 <box_id>700100000001</box_id>
 <box_name>测试注册</box_name>
 <reg_pwd>NzAwMTAwMDAwMDAx</reg_pwd>
 </request>
 说明：
 box_id :设备ID
 box_name:给设备取的名字
 reg_pwd:对应平台的注册密码(BASE64)
 ****/
-(NSString *)getXML
{
    NSMutableString *body = [NSMutableString string];
    [body appendFormat:@"<box_id>%@</box_id>", _boxID];
    [body appendFormat:@"<box_name>%@</box_name>", _boxName];
    [body appendFormat:@"<reg_pwd>%@</reg_pwd>", [ GTMBase64 stringByEncodingData:[ _pwd dataUsingEncoding:NSUTF8StringEncoding]]];
    
    return [self buildXMLString:@"alterbox_reg" body:body];
}
@end
