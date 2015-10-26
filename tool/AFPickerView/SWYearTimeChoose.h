//  用水查询——时间选择
//  SWYearTimeChoose.h
//  IntelligentWaterSystem
//
//  Created by geimin on 15/1/21.
//  Copyright (c) 2015年 Palmtrends. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SWYTCDelegate;

@interface SWYearTimeChoose : UIView
@property ( nonatomic ,retain) id <SWYTCDelegate> delegate;
@end

@protocol SWYTCDelegate <NSObject>

-( void)hourAndMunite:( NSString*)value;

@end