//
//  DeviceTableViewCell.h
//  Supereye
//  报警盒设备Cell
//  Created by jiang bing on 15/10/8.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FAlertBox.h"

@interface DeviceTableViewCell : UITableViewCell

@property (nonatomic, strong) FAlertBox *alertBox;
@property ( nonatomic, retain) UIViewController *rootView;
@property (nonatomic, retain) UILabel * labelDevName;
@property ( nonatomic, retain) UIImageView *imgViewDev;
@property ( nonatomic, retain) UIButton *btnWifiSet;
@property ( nonatomic, retain) UIButton *btnInfoSet;
@property ( nonatomic, retain) UIButton *btnAlertSet;

@end
