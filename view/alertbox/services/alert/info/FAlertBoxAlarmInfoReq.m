//
//  FAlertBoxAlarmInfoReq.m
//  Supereye
//
//  Created by jiang bing on 15/10/19.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import "FAlertBoxAlarmInfoReq.h"

@implementation FAlertBoxAlarmInfoReq

@synthesize boxID = _boxID;
@synthesize endDate = _endDate;
@synthesize pageNo = _pageNo;
@synthesize pageSize = _pageSize;
@synthesize startDate = _startDate;

- ( void)dealloc{
    [super dealloc];
    [_boxID release];
    [ _endDate release];
    [ _pageNo release];
    [_pageSize release];
    [ _startDate release];
}

+(id)requestWithAuth:(NSString *)auth{
    FAlertBoxAlarmInfoReq *req = [[FAlertBoxAlarmInfoReq alloc]init];
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
 <request func="alterbox_alarminfo" timestamp="20150813111636" token="SRJduQOgkBkQOUP/bHvSlPg2anUUZWbJ3LheGWBmeIpsXEl8+5xR1qJS1XrviqtB">
 <box_id></box_id>
 <endDate>2015-08-12</endDate>
 <pageNo>1</pageNo>
 <pageSize>100</pageSize>
 <startDate>2015-07-12</startDate>
 </request>
 ***/
-(NSString *)getXML
{
    NSMutableString *body = [NSMutableString string];
    [body appendFormat:@"<box_id>%@</box_id>",_boxID];
    [body appendFormat:@"<endDate>%@</endDate>",_endDate];
    [body appendFormat:@"<pageNo>%@</pageNo>",_pageNo];
    [body appendFormat:@"<pageSize>%@</pageSize>",_pageSize];
    [body appendFormat:@"<startDate>%@</startDate>",_startDate];
    return [self buildXMLString:@"alterbox_alarminfo" body:body];
}
@end
