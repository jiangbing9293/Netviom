//
//  SERequest+FAlertBoxListReq.m
//  Supereye
//
//  Created by jiang bing on 15/10/8.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import "FAlertBoxListRes.h"
#import "GDataXMLNode.h"
#import "FAlertBox.h"

@implementation FAlertBoxListRes

- (void)parse
{
    [super parse];
    self.deviceArray = [[ NSMutableArray alloc] init];
    if ([self isSuccess])
    {
        NSError *error;
        GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithXMLString:self.responseString options:0 error:&error];
        
        if (document != nil) {
            NSError *error;
            
            NSArray *mobileElements = [document.rootElement nodesForXPath:@"//response/boxs/box" error:&error];
            
            for (GDataXMLElement *element in mobileElements)
            {
                FAlertBox *alertBox = [[ FAlertBox alloc] init];
                
                NSString *boxName = [[ element attributeForName:@"box_name"] stringValue];
                NSString *online = [[ element attributeForName:@"online"] stringValue];
                NSString *boxID = [[ element attributeForName:@"box_id"] stringValue];
                NSString *orderOn = [[ element attributeForName:@"order_on"] stringValue];
                
                [alertBox setBoxName:boxName];
                [alertBox setOnline:online];
                [alertBox setBoxID:boxID];
                [alertBox setOrderOn:orderOn];
                
                if (alertBox) {
                    [self.deviceArray addObject:alertBox];
                }
                [alertBox release];
            }
            [document release];
        }
    }
}

+ (FAlertBoxListRes *)initWithXMLString:(NSString *)xmlString
{
    FAlertBoxListRes *response = [[FAlertBoxListRes alloc] init];
    response.responseString = xmlString;
    [response parse];
    return [response autorelease];
}
@end
