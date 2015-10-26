//
//  FAlertBoxAlertSetRes.m
//  Supereye
//
//  Created by jiang bing on 15/10/15.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import "FAlertBoxAlertSetRes.h"
#import "GDataXMLNode.h"
#import "FAlertBoxAlertSet.h"

@implementation FAlertBoxAlertSetRes


/****
 <?xml version="1.0" encoding="gbk"?>
 
 <response func="alterbox_response_get" status="200">
 <rspcfgs>
 <rspcfg task_name="我的报警" box_id="700100000001" sensor_id="100" status="1" isweek="1" week_value="0000000" time_cfg="111" time_value="00:00-08:00;08:00-18:00;18:00-20:00" rsp_type="11111" mobile="15602210731" email="rock711@163.com" update_time="2015-08-12 16:27:10.727"/>
 </rspcfgs>
 </response>
 ***/
- (void)parse
{
    [super parse];
    self.setArray = [[ NSMutableArray alloc] init];
    if ([self isSuccess])
    {
        NSError *error;
        GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithXMLString:self.responseString options:0 error:&error];
        
        if (document != nil) {
            NSError *error;
            
            NSArray *mobileElements = [document.rootElement nodesForXPath:@"//response/rspcfgs/rspcfg" error:&error];
            
            for (GDataXMLElement *element in mobileElements)
            {
                FAlertBoxAlertSet *alertSet = [[ FAlertBoxAlertSet alloc] init];
                
                alertSet.taskName = [[ element attributeForName:@"task_name"] stringValue];
                alertSet.boxID = [[ element attributeForName:@"box_id"] stringValue];
                alertSet.sensorID = [[ element attributeForName:@"sensor_id"] stringValue];
                alertSet.status = [[ element attributeForName:@"status"] stringValue];
                alertSet.isWeek = [[ element attributeForName:@"isweek"] stringValue];
                alertSet.weekValue = [[ element attributeForName:@"week_value"] stringValue];
                alertSet.timeCfg = [[ element attributeForName:@"time_cfg"] stringValue];
                alertSet.timeValue = [[ element attributeForName:@"time_value"] stringValue];
                alertSet.rspType = [[ element attributeForName:@"rsp_type"] stringValue];
                alertSet.mobile = [[ element attributeForName:@"mobile"] stringValue];
                alertSet.email = [[ element attributeForName:@"email"] stringValue];
                
                if (alertSet) {
                    [self.setArray addObject:alertSet];
                }
                [alertSet release];
            }
            [document release];
        }
    }
}

+ (FAlertBoxAlertSetRes *)initWithXMLString:(NSString *)xmlString
{
    FAlertBoxAlertSetRes *response = [[FAlertBoxAlertSetRes alloc] init];
    response.responseString = xmlString;
    [response parse];
    return [response autorelease];
}

@end
