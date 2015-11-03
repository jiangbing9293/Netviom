//
//  FAlertBoxAlertDetailViewController.h
//  Supereye
//
//  Created by jiang bing on 15/10/19.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FAlertBoxAlertInfo.h"

extern NSMutableArray *_events;

/***
 * 报警盒报警详细信息
 ****/
@interface FAlertBoxAlertDetailViewController : UIViewController

@property (nonatomic ,assign) FAlertBoxAlertInfo *alertInfo;
@property(nonatomic,assign)UILabel *labDevName;
@property(nonatomic,assign)UILabel *labDevId;
@property(nonatomic,assign)UILabel *labAlertType;
@property(nonatomic,assign)UILabel *labRespType;
@property(nonatomic,assign)UILabel *labAlertTime;
@property(nonatomic,assign)UILabel *labHasPic;
@property(nonatomic,assign)UIView *fileView;
@property(nonatomic, assign)UIScrollView *scrollView;
@property ( nonatomic, assign) NSInteger mCurrent;
@end
