//
//  SetAlertBoxViewController.h
//  Supereye
//  报警盒设置
//  Created by jiang bing on 15/10/10.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FAlertBox.h"
#import "AFPickerView.h"

@interface SetAlertBoxViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate, AFPickerViewDataSource, AFPickerViewDelegate>{
    AFPickerView *defaultPickerView;
}

@property ( nonatomic, retain) UIButton *btnTime;
@property ( nonatomic, retain) FAlertBox *alertBox;
@property ( nonatomic, retain) UITableView *tableView;
@property ( nonatomic, retain) NSMutableArray *items;

@end
