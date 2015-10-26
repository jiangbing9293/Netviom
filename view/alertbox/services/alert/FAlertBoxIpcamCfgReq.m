//
//  FAlertBoxIpcamCfgReq.m
//  Supereye
//
//  Created by jiang bing on 15/10/17.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import "FAlertBoxIpcamCfgReq.h"

@implementation FAlertBoxIpcamCfgReq
+(id)requestWithAuth:(NSString *)auth{
    FAlertBoxIpcamCfgReq *req = [[FAlertBoxIpcamCfgReq alloc]init];
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
 <request func="alterbox_ipcam_cfg" timestamp="20150812160446" token="SRJduQOgkBlD9ePskWz4lvg2anUUZWbJ3LheGWBmeIobKkLxQtKUnUWzFR1QcnP9">
 <box_id>700100000001</box_id>
 <ipcamid>200100000669</ipcamid>
 <sensor_id>100</sensor_id>
 <status>1</status>
 </request>
 ***/
-(NSString *)getXML
{
    NSMutableString *body = [NSMutableString string];
    if ( _ipcamCfg){
        [body appendFormat:@"<box_id>%@</box_id>",_ipcamCfg.boxID];
        [body appendFormat:@"<ipcamid>%@</ipcamid>",_ipcamCfg.ipcamID];
        [body appendFormat:@"<sensor_id>%@</sensor_id>",_ipcamCfg.sensorID];
        [body appendFormat:@"<status>%@</status>",_ipcamCfg.status];
    }
    return [self buildXMLString:@"alterbox_ipcam_cfg" body:body];
}
@end
