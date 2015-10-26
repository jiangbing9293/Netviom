//
//  AlertReceiveAlertBoxViewController.h
//  Supereye
//  报警接收设置
//  Created by jiang bing on 15/10/12.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FAlertBoxAlertSet.h"

@interface AlertReceiveAlertBoxViewController : UIViewController< UITableViewDataSource, UITableViewDelegate>

@property ( nonatomic, retain) FAlertBoxAlertSet *alertSet;
@property ( nonatomic, retain) UITableView *tableView;
@property ( nonatomic, retain) NSMutableArray *itemsPhone;
@property ( nonatomic, retain) NSMutableArray *itemsEmail;
@property ( nonatomic, retain) NSMutableArray *itemsRspType;

@end
