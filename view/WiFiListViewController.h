//
//  WiFiListViewController.h
//  Supereye
//
//  Created by jiang bing on 15/6/18.
//  Copyright (c) 2015年 Netviom. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *mSsid;

@interface WiFiListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *wifiListArray;
}
@property (nonatomic ,retain)UITableView *tableView;

@end
