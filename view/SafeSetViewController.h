//
//  SafeSetViewController.h
//  Supereye
//
//  Created by jiang bing on 15/6/28.
//  Copyright (c) 2015年 Netviom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SafeSetViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSMutableArray *setListArray;
}
@property (retain, nonatomic) IBOutlet UITableView *mSafeSetTableView;

@property (retain, nonatomic) NSMutableArray *typeArray;
@property (retain, nonatomic) NSMutableArray *safeLevelArray;

@end
