//
//  FAlertBoxAlertInfo.m
//  ;
//
//  Created by jiang bing on 15/10/19.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import "FAlertBoxAlertInfo.h"

@implementation FAlertBoxAlertInfo

@synthesize boxID = _boxID;
@synthesize boxName = _boxName;
@synthesize sensorID = _sensorID;
@synthesize alertTime = _alertTime;
@synthesize alertModel = _alertModel;
@synthesize filePath = _filePath;
@synthesize alertContent = _alertContent;

- ( void)dealloc{
    [super dealloc];
    [_boxID release];
    [_boxName release];
    [_sensorID release];
    [_alertTime release];
    [_alertModel release];
    [_filePath release];
    [ _alertContent release];
}

@end
