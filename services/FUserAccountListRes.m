//
//  FUserAccountListRes.m
//  Supereye
//
//  Created by jiang bing on 15/7/8.
//  Copyright (c) 2015年 Netviom. All rights reserved.
//

#import "FUserAccountListRes.h"
#import "GDataXMLNode.h"

@implementation FUserAccountListRes

/**
 *解析获取的账户信息
 **/
- (void)parse
{
    [super parse];
    
    self.accountList = [NSMutableArray array];
    
    if ([self isSuccess]) {
        
        
        NSError *error;
        GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithXMLString:self.responseString options:0 error:&error];
        
        if (document != nil) {
            NSError *error;
            
            NSArray *mobileElements = [document.rootElement nodesForXPath:@"//response/item" error:&error];
            
            for (GDataXMLElement *element in mobileElements)
            {
                NSString *account = [[element attributeForName:@"account"] stringValue];
                
                if (account) {
                    [self.accountList addObject:account];
                }
                
            }
            
            [document release];
            
        }
    }
    
}

+ (FUserAccountListRes *)initWithXMLString:(NSString *)xmlString
{
    FUserAccountListRes *response = [[FUserAccountListRes alloc] init];
    response.responseString = xmlString;
    [response parse];
    
    return [response autorelease];
}
@end
