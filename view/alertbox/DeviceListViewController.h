//
//  DeviceListViewController.h
//  Supereye
//  报警盒设备列表
//  Created by jiang bing on 15/10/8.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface DeviceListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property ( nonatomic, retain) MBProgressHUD *mHud;
@property ( nonatomic, retain) NSMutableArray *devArray;
@property ( nonatomic, retain) UITableView *tableView;

@end
