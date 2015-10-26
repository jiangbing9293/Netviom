//
//  ApSetWiFiViewController.h
//  Supereye
//  Wi-Fi配置
//  Created by jiang bing on 15/6/12.
//  Copyright (c) 2015年 Netviom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCDAsyncSocket.h"
#import "CellItem.h"
#import "Tools.h"
#import "MBProgressHUD.h"

extern NSString *mSsid;

@interface ApSetWiFiViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,GCDAsyncSocketDelegate>

@property (retain, nonatomic) UITableView *apInfoTableView;
@property (nonatomic, retain) NSMutableArray *items;

@end
