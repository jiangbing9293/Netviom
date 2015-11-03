//
//  FAlertBoxIpcamCfg.m
//  Supereye
//
//  Created by jiang bing on 15/10/17.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import "FAlertBoxIpcamCfg.h"

@implementation FAlertBoxIpcamCfg

@synthesize boxID = _boxID;
@synthesize ipcamID = _ipcamID;
@synthesize sensorID = _sensorID;
@synthesize status = _status;

-( void)dealloc{
    
    [super dealloc];
    [_boxID release];
    [_ipcamID release];
    [_sensorID release];
    [_status release];
}

@end
