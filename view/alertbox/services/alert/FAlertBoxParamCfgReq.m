//
//  FAlertBoxParamCfgReq.m
//  Supereye
//
//  Created by jiang bing on 15/10/16.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import "FAlertBoxParamCfgReq.h"

@implementation FAlertBoxParamCfgReq
@synthesize paramGet = _paramGet;

- ( void)dealloc{
    [super dealloc];
    [_paramGet release];
}

+(id)requestWithAuth:(NSString *)auth{
    FAlertBoxParamCfgReq *req = [[FAlertBoxParamCfgReq alloc]init];
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
 <request func="alterbox_param_cfg" timestamp="20150814143949" token="SRJduQOgkBl7iUHizCDeD/g2anUUZWbJ3LheGWBmeIpWigEjrOQJGVMlBmlE+bTc">
 <box_id>700100000001</box_id>
 <cfg_code>BUZZER_TIME</cfg_code>
 <cfg_type>1</cfg_type>
 <cfg_value>10</cfg_value>
 <is_public>1</is_public>
 <sensor_id></sensor_id>
 </request>
 ***/
-(NSString *)getXML
{
    NSMutableString *body = [NSMutableString string];
    [body appendFormat:@"<box_id>%@</box_id>",_paramGet.boxID];
    [body appendFormat:@"<cfg_code>%@</cfg_code>",_paramGet.cfgCode];
    [body appendFormat:@"<cfg_type>%@</cfg_type>",_paramGet.cfgType];
    [body appendFormat:@"<cfg_value>%@</cfg_value>",_paramGet.cfgValue];
    [body appendFormat:@"<is_public>%@</is_public>",_paramGet.isPublic];
    NSString *sensor_id = _paramGet.sensorID;
    if ( sensor_id && ![sensor_id isEqualToString:@""]){
        [body appendFormat:@"<sensor_id>%@</sensor_id>",sensor_id];
    }
    return [self buildXMLString:@"alterbox_param_cfg" body:body];
}

@end
