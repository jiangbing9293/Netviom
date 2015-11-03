//
//  FUserAccountListReq.m
//  Supereye
//
//  Created by jiang bing on 15/7/8.
//  Copyright (c) 2015年 Netviom. All rights reserved.
//

#import "FUserAccountListReq.h"

@implementation FUserAccountListReq

+(id)requestWithAuth:(NSString *)auth{
    FUserAccountListReq *req = [[FUserAccountListReq alloc]init];
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
    return [self buildXMLString:@"accountlist" body:nil];
}

@end
