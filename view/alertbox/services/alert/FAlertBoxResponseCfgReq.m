//
//  FAlertBoxResponseCfgReq.m
//  Supereye
//
//  Created by jiang bing on 15/10/16.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import "FAlertBoxResponseCfgReq.h"

@implementation FAlertBoxResponseCfgReq

+(id)requestWithAuth:(NSString *)auth{
    FAlertBoxResponseCfgReq *req = [[FAlertBoxResponseCfgReq alloc]init];
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
 <request func="alterbox_response_cfg" timestamp="20150812162710" token="SRJduQOgkBkdoDQjcpl4fvg2anUUZWbJ3LheGWBmeIq49ln44s4+PVEKOdhNsQD8">
	<task_name>100</task_name >
 <box_id>700100000001</box_id>
 <email>rock711@163.com</email>
 <isweek>1</isweek>
 <mobile>15602210731</mobile>
 <rsp_type>11111</rsp_type>
 <sensor_id>100</sensor_id>
 <status>1</status>
 <time_cfg>111</time_cfg>
 <time_value>00:00-08:00;08:00-18:00;18:00-20:00</time_value>
 <week_value>0000000</week_value>
 </request>
 ***/
-(NSString *)getXML
{
    NSMutableString *body = [NSMutableString string];
    
    [body appendFormat:@"<task_name>%@</task_name>",_alertSet.taskName];
    [body appendFormat:@"<box_id>%@</box_id>",_alertSet.boxID];
    [body appendFormat:@"<email>%@</email>",_alertSet.email];
    [body appendFormat:@"<isweek>%@</isweek>",_alertSet.isWeek];
    [body appendFormat:@"<mobile>%@</mobile>",_alertSet.mobile];
    [body appendFormat:@"<rsp_type>%@</rsp_type>",_alertSet.rspType];
    [body appendFormat:@"<sensor_id>%@</sensor_id>",_alertSet.sensorID];
    [body appendFormat:@"<status>%@</status>",_alertSet.status];
    [body appendFormat:@"<time_cfg>%@</time_cfg>",_alertSet.timeCfg];
    [body appendFormat:@"<time_value>%@</time_value>",_alertSet.timeValue];
    [body appendFormat:@"<week_value>%@</week_value>",_alertSet.weekValue];
    
    return [self buildXMLString:@"alterbox_response_cfg" body:body];
}
@end
