//
//  FAccountListViewController.h
//  Supereye
//
//  Created by jiang bing on 15/7/8.
//  Copyright (c) 2015年 Netviom. All rights reserved.
//

//子账户
extern NSString *e_mAccount;

#import <UIKit/UIKit.h>
/***
 * 用户子帐号列表
 ***/
@interface FAccountListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *accountListArray;
}

@property (nonatomic ,retain)UITableView *tableView;

@end
