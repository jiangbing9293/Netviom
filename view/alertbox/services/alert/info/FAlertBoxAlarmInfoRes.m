//
//  FAlertBoxAlarmInfoRes.m
//  Supereye
//
//  Created by jiang bing on 15/10/19.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import "FAlertBoxAlarmInfoRes.h"
#import "FAlertBoxAlertInfo.h"
#import "GDataXMLNode.h"

@implementation FAlertBoxAlarmInfoRes
/****
 <?xml version="1.0" encoding="gbk"?>
 
 <response func="alterbox_alarminfo" status="200" pageno="1" totalpage="1" totalcount="2">
 <alarmInfos>
 <alarmInfo box_id="700100000001" sensor_id="100" alter_time="2015-08-01 00:00:00" msg_count="1" alert_model="00000" alert_content="报警了">
 <ipcamAlarmInfo file_path="" alert_model="0" alert_content="尊敬的【jishubu】您好,您名下的监控点发生了移动侦测报警,地址:[200111003713],报警方式为拍照,拍照失败" ipcamid="200111003713"/>
 </alarmInfo>
 <alarmInfo box_id="700100000001" sensor_id="100" alter_time="2015-08-01 00:00:00" msg_count="1" alert_model="1" alert_content="又报警了"/>
 </alarmInfos>
 </response>
 ***/
- (void)parse
{
    [super parse];
    self.alertInfoArray = [[ NSMutableArray alloc] init];
    if ([self isSuccess])
    {
        NSError *error;
        GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithXMLString:self.responseString options:0 error:&error];
        
        if (document != nil) {
            NSError *error;
            
            NSArray *mobileElements = [document.rootElement nodesForXPath:@"//response/alarmInfos/alarmInfo" error:&error];
            
            for (GDataXMLElement *element in mobileElements)
            {
                FAlertBoxAlertInfo *alertInfo = [[ FAlertBoxAlertInfo alloc] init];
                alertInfo.boxID = [[ element attributeForName:@"box_id"]stringValue];
                alertInfo.sensorID = [[ element attributeForName:@"sensor_id"]stringValue];
                alertInfo.alertTime = [[ element attributeForName:@"alter_time"]stringValue];
                alertInfo.alertContent = [[ element attributeForName:@"alert_content"]stringValue];
                
                NSArray *chidlElements = element.children;
                if ( chidlElements){
                    for (GDataXMLElement *celement in chidlElements){
                        alertInfo.alertModel = [[ celement attributeForName:@"alert_model"]stringValue];
                        alertInfo.filePath = [[ celement attributeForName:@"file_path"]stringValue];
                    }
                }
                
                if (alertInfo) {
                    [self.alertInfoArray addObject:alertInfo];
                }
                [alertInfo release];
            }
            [document release];
        }
    }
}

+ (FAlertBoxAlarmInfoRes *)initWithXMLString:(NSString *)xmlString
{
    FAlertBoxAlarmInfoRes *response = [[FAlertBoxAlarmInfoRes alloc] init];
    response.responseString = xmlString;
    [response parse];
    return [response autorelease];
}
@end
