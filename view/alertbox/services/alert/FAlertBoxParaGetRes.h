//
//  FAlertBoxParaGetRes.h
//  Supereye
//
//  Created by jiang bing on 15/10/15.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import "SEBaseResponse.h"
/***
 *  报警盒配置参数 res
 ***/
@interface FAlertBoxParaGetRes : SEBaseResponse

@property ( nonatomic, retain) NSMutableArray *setArray;

- (void)parse;
+ (FAlertBoxParaGetRes *)initWithXMLString:(NSString *)xmlString;

@end
