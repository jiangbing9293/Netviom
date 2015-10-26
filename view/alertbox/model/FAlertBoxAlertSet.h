//
//  FAlertBoxAlertSet.h
//  Supereye
//
//  Created by jiang bing on 15/10/15.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import <Foundation/Foundation.h>
/***
 *  报警盒报警设置信息
 *****/
@interface FAlertBoxAlertSet : NSObject

@property ( nonatomic, retain) NSString *taskName;
@property ( nonatomic, retain) NSString *boxID;
@property ( nonatomic, retain) NSString *email;
@property ( nonatomic, retain) NSString *mobile;
@property ( nonatomic, retain) NSString *isWeek;
@property ( nonatomic, retain) NSString *rspType;
@property ( nonatomic, retain) NSString *sensorID;
@property ( nonatomic, retain) NSString *timeCfg;
@property ( nonatomic, retain) NSString *timeValue;
@property ( nonatomic, retain) NSString *weekValue;
@property ( nonatomic, retain) NSString *status;

@end
