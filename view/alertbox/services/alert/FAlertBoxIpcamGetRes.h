//
//  FAlertBoxIpcamGetRes.h
//  Supereye
//
//  Created by jiang bing on 15/10/17.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import "SEBaseResponse.h"
/**
 * 获取报警盒ipcam联动  res
 ***/
@interface FAlertBoxIpcamGetRes : SEBaseResponse

@property ( nonatomic ,retain) NSMutableArray *setArray;

- (void)parse;
+ (FAlertBoxIpcamGetRes *)initWithXMLString:(NSString *)xmlString;

@end
