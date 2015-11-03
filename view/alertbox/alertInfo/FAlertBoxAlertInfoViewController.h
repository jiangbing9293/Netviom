//
//  FAlertBoxAlertInfoViewController.h
//  Supereye
//
//  Created by jiang bing on 15/10/19.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

extern NSMutableArray *eAlertBoxArray;
/***
 *报警盒报警信息
 ***/
extern NSMutableArray *_events;
/***
 * 报警盒报警信息
 ****/
@interface FAlertBoxAlertInfoViewController : UITableViewController<EGORefreshTableHeaderDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
}
@property ( nonatomic, retain) UIViewController *rootViewController;
- ( void)syncDataFromServer:(NSString *)boxID :( NSString *) startDate :(NSString *)endDate :( NSString *)pageNo :( NSString *) pageSize ;

@end
