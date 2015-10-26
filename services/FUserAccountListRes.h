//
//  FUserAccountListRes.h
//  Supereye
//
//  Created by jiang bing on 15/7/8.
//  Copyright (c) 2015年 Netviom. All rights reserved.
//

#import "SEBaseResponse.h"

@interface FUserAccountListRes : SEBaseResponse

@property (nonatomic, retain) NSMutableArray * accountList; 

- (void)parse;

+ (FUserAccountListRes *)initWithXMLString:(NSString *)xmlString;

@end
