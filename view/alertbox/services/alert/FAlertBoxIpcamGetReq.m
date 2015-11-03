//
//  FAlertBoxIpcamGetReq.m
//  Supereye
//
//  Created by jiang bing on 15/10/16.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import "FAlertBoxIpcamGetReq.h"

@implementation FAlertBoxIpcamGetReq

@synthesize boxID = _boxID;

- ( void)dealloc{
    [super dealloc];
    [_boxID release];
}

+(id)requestWithAuth:(NSString *)auth{
    FAlertBoxIpcamGetReq *req = [[FAlertBoxIpcamGetReq alloc]init];
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
 <request func="alterbox_ipcam_get" timestamp="20150812161008" token="SRJduQOgkBlW2Vs2KuFH9Pg2anUUZWbJ3LheGWBmeIq2JSlbdc2wHJn4TGNNkGKd">
 <box_id></box_id>
 </request>
 说明：
 box_id :可选择某一ID. 模糊查询.可为空
 ***/
-(NSString *)getXML
{
    NSMutableString *body = [NSMutableString string];
    [body appendFormat:@"<box_id>%@</box_id>",_boxID];
    return [self buildXMLString:@"alterbox_ipcam_get" body:body];
}

@end
