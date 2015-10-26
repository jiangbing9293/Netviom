//
//  FGetSafeEventSetReq.m
//  Supereye
//
//  Created by jiang bing on 15/7/10.
//  Copyright (c) 2015年 Netviom. All rights reserved.
//

#import "FGetSafeEventSetReq.h"

@implementation FGetSafeEventSetReq
+(id)requestWithAuth:(NSString *)auth{
    FGetSafeEventSetReq *req = [[FGetSafeEventSetReq alloc]init];
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
    return [self buildXMLString:@"get_safe_event_setting" body:nil];
}
@end
