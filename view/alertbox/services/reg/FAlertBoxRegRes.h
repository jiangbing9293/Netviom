//
//  FAlertBoxRegRes.h
//  Supereye
//
//  Created by jiang bing on 15/10/9.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import <Foundation/Foundation.h>

/***
 * 注册报警盒设备 res 拆包
 ****/
@interface FAlertBoxRegRes : NSObject

@property (nonatomic,assign) int status;
@property (retain, nonatomic) NSString *info;

+ (id)initWithXMLString:(NSString *)xmlString;
@end

