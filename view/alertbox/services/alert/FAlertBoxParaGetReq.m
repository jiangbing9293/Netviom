//
//  FAlertBoxParaGetReq.m
//  Supereye
//
//  Created by jiang bing on 15/10/15.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import "FAlertBoxParaGetReq.h"

@implementation FAlertBoxParaGetReq
@synthesize boxID = _boxID;

- ( void)dealloc{
    [super dealloc];
    [_boxID release];
}

+(id)requestWithAuth:(NSString *)auth{
    FAlertBoxParaGetReq *req = [[FAlertBoxParaGetReq alloc]init];
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
 <request func="alterbox_param_get" timestamp="20150814143949" token="SRJduQOgkBlpQE13Bq5+Wvg2anUUZWbJ3LheGWBmeIpWigEjrOQJGZIAMamRRljl">
 <box_id>1</box_id>
 </request>
 ***/
-(NSString *)getXML
{
    NSMutableString *body = [NSMutableString string];
    [body appendFormat:@"<box_id>%@</box_id>",_boxID];
    return [self buildXMLString:@"alterbox_param_get" body:body];
}
@end
