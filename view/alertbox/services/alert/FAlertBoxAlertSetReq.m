//
//  FAlertBoxAlertSetReq.m
//  Supereye
//
//  Created by jiang bing on 15/10/15.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import "FAlertBoxAlertSetReq.h"

@implementation FAlertBoxAlertSetReq

@synthesize boxID = _boxID;

- ( void)dealloc{
    [super dealloc];
    [_boxID release];
}

+(id)requestWithAuth:(NSString *)auth{
    FAlertBoxAlertSetReq *req = [[FAlertBoxAlertSetReq alloc]init];
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
 <request func="alterbox_response_get" timestamp="20150812163339" token="SRJduQOgkBleeYfa55bsDfg2anUUZWbJ3LheGWBmeIog8FhDSsPzbS07bTobgzEZ">
 <box_id>1</box_id>
 </request>
 ***/
-(NSString *)getXML
{
    NSMutableString *body = [NSMutableString string];
    [body appendFormat:@"<box_id>%@</box_id>",_boxID];
    return [self buildXMLString:@"alterbox_response_get" body:body];
}


@end
