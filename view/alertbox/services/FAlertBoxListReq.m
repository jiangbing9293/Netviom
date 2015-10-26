//
//  SERequest+FAlertBoxListReq.m
//  Supereye
//
//  Created by jiang bing on 15/10/8.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import "FAlertBoxListReq.h"

@implementation FAlertBoxListReq

+(id)requestWithAuth:(NSString *)auth{
    FAlertBoxListReq *req = [[FAlertBoxListReq alloc]init];
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
    [body appendFormat:@"<box_id></box_id>"];
    return [self buildXMLString:@"alterbox_list" body:body];
}
@end
