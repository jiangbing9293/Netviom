//
//  UpdateALertBoxInfoViewController.h
//  Supereye
//
//  Created by jiang bing on 15/10/10.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FAlertBox.h"

@interface UpdateALertBoxInfoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property ( nonatomic, retain) FAlertBox *alertBox;

@property (retain, nonatomic) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *items;
@end
