//
//  SERequest+FAlertBoxListReq.h
//  Supereye
//
//  Created by jiang bing on 15/10/8.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import "SEBaseResponse.h"
/***
 * 获取报警盒设备列表 res 拆包
 ****/
@interface FAlertBoxListRes : SEBaseResponse

@property ( nonatomic, retain) NSMutableArray *deviceArray;

- (void)parse;

+ (FAlertBoxListRes *)initWithXMLString:(NSString *)xmlString;

@end
