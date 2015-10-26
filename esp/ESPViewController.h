//
//  ESPViewController.h
//  EspTouchDemo
//
//  Created by 白 桦 on 3/23/15.
//  Copyright (c) 2015 白 桦. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESPViewController : UIViewController<UITextFieldDelegate>

@property (assign, nonatomic) UILabel *ssidLabel;
@property (assign, nonatomic) UILabel *pwdLabel;
@property (assign ,nonatomic) UITextField *ssidTextView;
@property (assign, nonatomic) NSString *ssid;
@property (strong, nonatomic) NSString *bssid;

@end
