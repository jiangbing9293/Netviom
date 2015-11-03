//
//  FSetEventRes.m
//  Supereye
//
//  Created by jiang bing on 15/7/12.
//  Copyright (c) 2015年 Netviom. All rights reserved.
//

#import "FSetEventRes.h"

@implementation FSetEventRes
- (void)parse
{
    [super parse];
    
    if ([self isSuccess])
    {
        
    }
    
}

+ (FSetEventRes *)initWithXMLString:(NSString *)xmlString
{
    FSetEventRes *response = [[FSetEventRes alloc] init];
    response.responseString = xmlString;
    [response parse];
    return [response autorelease];
}
@end
