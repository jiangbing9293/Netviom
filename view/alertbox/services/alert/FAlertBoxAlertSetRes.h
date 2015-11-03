//
//  FAlertBoxAlertSetRes.h
//  Supereye
//
//  Created by jiang bing on 15/10/15.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import "SEBaseResponse.h"
/***
 *   获取报警盒信息  res 拆包
 ***/
@interface FAlertBoxAlertSetRes : SEBaseResponse

@property ( nonatomic, retain) NSMutableArray *setArray;

- (void)parse;

+ (FAlertBoxAlertSetRes *)initWithXMLString:(NSString *)xmlString;

@end
