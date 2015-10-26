//
//  FAlertBoxParamGet.m
//  Supereye
//
//  Created by jiang bing on 15/10/15.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import "FAlertBoxParamGet.h"

@implementation FAlertBoxParamGet

@synthesize boxID = _boxID;
@synthesize sensorID = _sensorID;
@synthesize isPublic = _isPublic;
@synthesize cfgType = _cfgType;
@synthesize cfgCode = _cfgCode;
@synthesize cfgValue = _cfgValue;

- ( void)dealloc{
    [super dealloc];
    [_boxID release];
    [_sensorID release];
    [_isPublic release];
    [_cfgType release];
    [_cfgCode release];
    [_cfgValue release];
}
@end
