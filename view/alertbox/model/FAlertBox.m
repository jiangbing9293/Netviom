//
//  NSObject+FAlertBox.m
//  Supereye
//
//  Created by jiang bing on 15/10/8.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import "FAlertBox.h"

@implementation FAlertBox

@synthesize boxID = _boxID;
@synthesize boxName =_boxName;
@synthesize boxType = _boxType;
@synthesize orderOn = _orderOn;
@synthesize status = _status;
@synthesize online = _online;
@synthesize addTime = _addTime;
@synthesize sensorArray = _sensorArray;

-(void)dealloc{
    [super dealloc];
    [_boxID release];
    [_boxName release];
    [_boxType release];
    [_orderOn release];
    [_sensorArray release];
    [_orderOn release];
    [_status release];
    [_online release];
    [_addTime release];
}

@end
