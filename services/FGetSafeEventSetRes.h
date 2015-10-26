//
//  FGetSafeEventSetRes.h
//  Supereye
//
//  Created by jiang bing on 15/7/10.
//  Copyright (c) 2015年 Netviom. All rights reserved.
//

#import "SEBaseResponse.h"
/***
 * 获取系统安全事件设置状态 Res 拆包
 ****/
@interface FGetSafeEventSetRes : SEBaseResponse
@property (nonatomic, retain) NSMutableArray * setList;
- (void)parse;

+ (FGetSafeEventSetRes *)initWithXMLString:(NSString *)xmlString;

@end
