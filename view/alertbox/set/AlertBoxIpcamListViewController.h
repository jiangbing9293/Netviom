//
//  AlertBoxIpcamListViewController.h
//  Supereye
//
//  Created by jiang bing on 15/10/16.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import <UIKit/UIKit.h>
/***
 * 报警盒关联设备列表
 ***/
@interface AlertBoxIpcamListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property( nonatomic ,retain) NSString *boxID;
@property( nonatomic, retain) NSString *sensorID;
@property ( nonatomic, retain) UITableView *tableView;

@end
