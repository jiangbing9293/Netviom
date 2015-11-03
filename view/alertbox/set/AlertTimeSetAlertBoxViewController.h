//
//  AlertTimeSetAlertBoxViewController.h
//  Supereye
//  报警时间设置
//  Created by jiang bing on 15/10/11.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FAlertBoxAlertSet.h"

@interface AlertTimeSetAlertBoxViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property ( nonatomic, retain) FAlertBoxAlertSet *alertSet;
@property ( nonatomic, retain) UITableView *tableView;
@property ( nonatomic, retain) NSMutableArray *itemsWeek;
@property ( nonatomic, retain) NSMutableArray *itemsTime;

@end
