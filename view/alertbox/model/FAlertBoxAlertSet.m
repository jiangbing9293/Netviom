//
//  FAlertBoxAlertSet.m
//  Supereye
//
//  Created by jiang bing on 15/10/15.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import "FAlertBoxAlertSet.h"

@implementation FAlertBoxAlertSet

@synthesize taskName = _taskName;
@synthesize boxID = _boxID;
@synthesize email = _email;
@synthesize isWeek = _isWeek;
@synthesize rspType = _rspType;
@synthesize mobile = _mobile;
@synthesize timeCfg = _timeCfg;
@synthesize timeValue = _timeValue;
@synthesize weekValue = _weekValue;
@synthesize sensorID = _sensorID;
@synthesize status = _status;

- ( void) dealloc{
    [super dealloc];
    [_taskName release];
    [_boxID release];
    [_email release];
    [_mobile release];
    [_isWeek release];
    [_rspType release];
    [_timeCfg release];
    [_timeValue release];
    [_weekValue release];
    [_sensorID release];
    [_status release];
}

@end
