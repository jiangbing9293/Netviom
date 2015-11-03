//
//  NSObject+FAlertBox.h
//  Supereye
//
//  Created by jiang bing on 15/10/8.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FAlertBox : NSObject

@property ( nonatomic, retain) NSString *boxID;
@property ( nonatomic, retain) NSString *boxName;
@property ( nonatomic, retain) NSString *boxType;
@property ( nonatomic, retain) NSString *orderOn;
@property ( nonatomic, retain) NSString *status;
@property ( nonatomic, retain) NSString *online;
@property ( nonatomic, retain) NSString *addTime;
@property ( nonatomic, retain) NSMutableArray *sensorArray;


@end
