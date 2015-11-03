//
//  FAlertBoxInfoUpdateReq.m
//  Supereye
//
//  Created by jiang bing on 15/10/14.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import "FAlertBoxInfoUpdateReq.h"

@implementation FAlertBoxInfoUpdateReq

@synthesize boxID = _boxID;
@synthesize boxName = _boxName;
@synthesize order = _order;

+(id)requestWithAuth:(NSString *)auth{
    FAlertBoxInfoUpdateReq *req = [[FAlertBoxInfoUpdateReq alloc]init];
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
 <request func="alterbox_update" timestamp="20151014141101" token="7OJaac/8ZzgT4Ip11r+rdxAdBCO/b+7kG2gXkhxL7wFu6/AusyaEm9Mej/hAPTWb">
 <box_id>700100000002</box_id>
 <box_name>测试注册1</box_name>
 <order_no>2</order_no>
 </request>
 box_id:需注册在使用设备才可更新
 order_no:如果非整形.则默认为0
 ***/
-(NSString *)getXML
{
    NSMutableString *body = [NSMutableString string];
    [body appendFormat:@"<box_id>%@</box_id>",_boxID];
    [ body appendFormat:@"<box_name>%@</box_name>", _boxName];
    [ body appendFormat:@"<order_no>%@</order_no>", _order];
    return [self buildXMLString:@"alterbox_update" body:body];
}

@end
