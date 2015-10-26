//
//  FAlertBoxAlarmInfoRes.h
//  Supereye
//
//  Created by jiang bing on 15/10/19.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import "SEBaseResponse.h"
/***
 * 获取报警盒报警信息  res
 ****/
@interface FAlertBoxAlarmInfoRes : SEBaseResponse

@property ( nonatomic, retain) NSMutableArray *alertInfoArray;

- (void)parse;

+ (FAlertBoxAlarmInfoRes *)initWithXMLString:(NSString *)xmlString;


@end
