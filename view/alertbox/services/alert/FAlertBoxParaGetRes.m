//
//  FAlertBoxParaGetRes.m
//  Supereye
//
//  Created by jiang bing on 15/10/15.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import "FAlertBoxParaGetRes.h"
#import "GDataXMLNode.h"
#import "FAlertBoxParamGet.h"

@implementation FAlertBoxParaGetRes

/****
 <?xml version="1.0" encoding="gbk"?>
 
 <response func="alterbox_param_get" status="200">
 <paramcfgs>
 <paramcfg box_id="700100000001" sensor_id="" is_public="1" cfg_type="1" cfg_code="BUZZER_TIME" cfg_value="10" update_time="2015-08-14 14:38:01"/>
 </paramcfgs>
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
            
            NSArray *mobileElements = [document.rootElement nodesForXPath:@"//response/paramcfgs/paramcfg" error:&error];
            
            for (GDataXMLElement *element in mobileElements)
            {
                FAlertBoxParamGet *alertSet = [[ FAlertBoxParamGet alloc] init];
                
                alertSet.boxID = [[ element attributeForName:@"box_id"] stringValue];
                alertSet.sensorID = [[ element attributeForName:@"sensor_id"] stringValue];
                alertSet.isPublic = [[ element attributeForName:@"is_public"] stringValue];
                alertSet.cfgCode = [[ element attributeForName:@"cfg_code"] stringValue];
                alertSet.cfgType = [[ element attributeForName:@"cfg_type"] stringValue];
                alertSet.cfgValue = [[ element attributeForName:@"cfg_value"] stringValue];
                
                if (alertSet) {
                    [self.setArray addObject:alertSet];
                }
                [alertSet release];
            }
            [document release];
        }
    }
}

+ (FAlertBoxParaGetRes *)initWithXMLString:(NSString *)xmlString
{
    FAlertBoxParaGetRes *response = [[FAlertBoxParaGetRes alloc] init];
    response.responseString = xmlString;
    [response parse];
    return [response autorelease];
}

@end
