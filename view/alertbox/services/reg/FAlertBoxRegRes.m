//
//  FAlertBoxRegReq.m
//  Supereye
//
//  Created by jiang bing on 15/10/9.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import "FAlertBoxRegRes.h"

#import "GDataXMLNode.h"

@implementation FAlertBoxRegRes

@synthesize info= _info;
@synthesize status = _status;

- (void)dealloc
{
    [_info release];
    _status = -1;
    [super dealloc];
}
/***
 *<response func="alterbox_reg" status="400" message="没有找到这个ID(700100000000)的设备"/>
 ****/
+ (id)initWithXMLString:(NSString *)xmlString
{
    FAlertBoxRegRes *res =  [[FAlertBoxRegRes alloc]init];
    
    NSError *error ;
    GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithXMLString:xmlString options:0 error:&error];
    
    if (document) {
        res.status = [[[document.rootElement attributeForName:@"status"] stringValue] intValue];
        res.info = [[document.rootElement attributeForName:@"message"] stringValue];
    }
    [document release];
    
    
    return [res autorelease];
}
@end
