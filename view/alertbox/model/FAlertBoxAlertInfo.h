//
//  FAlertBoxAlertInfo.h
//  Supereye
//
//  Created by jiang bing on 15/10/19.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import <Foundation/Foundation.h>
/***
 * 报警盒报警信息
 ****/
@interface FAlertBoxAlertInfo : NSObject

@property ( nonatomic, retain) NSString *boxID;
@property ( nonatomic, retain) NSString *boxName;
@property ( nonatomic, retain) NSString *sensorID;
@property ( nonatomic, retain) NSString *alertTime;
@property ( nonatomic, retain) NSString *alertModel;
@property ( nonatomic, retain) NSString *alertContent;
@property ( nonatomic, retain) NSString *filePath;

@end
