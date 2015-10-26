//
//  FAlertBoxIpcamGetRes.m
//  Supereye
//
//  Created by jiang bing on 15/10/17.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import "FAlertBoxIpcamGetRes.h"
#import "GDataXMLNode.h"
#import "FAlertBoxIpcamCfg.h"

@implementation FAlertBoxIpcamGetRes

/****
 <?xml version="1.0" encoding="gbk"?>
 
 <response func="alterbox_ipcam_get" status="200">
 <ipcams>
 <ipcam box_id="700100000001" ipcamid="200100000669" sensor_id="100" status="1"/>
 </ipcams>
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
            
            NSArray *mobileElements = [document.rootElement nodesForXPath:@"//response/ipcams/ipcam" error:&error];
            
            for (GDataXMLElement *element in mobileElements)
            {
                FAlertBoxIpcamCfg *ipcamCfg = [[ FAlertBoxIpcamCfg alloc] init];
                
                ipcamCfg.boxID = [[ element attributeForName:@"box_id"] stringValue];
                ipcamCfg.ipcamID = [[ element attributeForName:@"ipcamid"] stringValue];
                ipcamCfg.sensorID = [[ element attributeForName:@"sensor_id"] stringValue];
                ipcamCfg.status = [[ element attributeForName:@"status"] stringValue];
                
                if (ipcamCfg) {
                    [self.setArray addObject:ipcamCfg];
                }
                [ipcamCfg release];
            }
            [document release];
        }
    }
}

+ (FAlertBoxIpcamGetRes *)initWithXMLString:(NSString *)xmlString
{
    FAlertBoxIpcamGetRes *response = [[FAlertBoxIpcamGetRes alloc] init];
    response.responseString = xmlString;
    [response parse];
    return [response autorelease];
}

@end
