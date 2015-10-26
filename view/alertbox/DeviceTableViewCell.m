//
//  DeviceTableViewCell.m
//  Supereye
//
//  Created by jiang bing on 15/10/8.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import "DeviceTableViewCell.h"
#import "FTools.h"
#import "Tools.h"
#import "ESPViewController.h"
#import "UpdateALertBoxInfoViewController.h"
#import "SetAlertBoxViewController.h"
#import "AppData.h"

@implementation DeviceTableViewCell

@synthesize alertBox = _alertBox;
@synthesize rootView = _rootView;
@synthesize labelDevName = _labelDevName;
@synthesize imgViewDev = _imgViewDev;
@synthesize btnWifiSet = _btnWifiSet;
@synthesize btnInfoSet = _btnInfoSet;
@synthesize btnAlertSet = _btnAlertSet;

CGFloat mWidth;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    mWidth = [ UIScreen mainScreen].bounds.size.width;
    _imgViewDev = [[ UIImageView alloc] init];
    _labelDevName = [[ UILabel alloc] init];
    _btnWifiSet = [[ UIButton alloc] init];
    _btnInfoSet = [[ UIButton alloc] init];
    _btnAlertSet = [[ UIButton alloc] init];
    
    [_btnWifiSet setImage:[UIImage imageNamed:@"wifi"] forState:UIControlStateNormal];
    [_btnWifiSet addTarget:self action:@selector(btnWifiSetOnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_btnInfoSet setImage:[UIImage imageNamed:@"info-set"] forState:UIControlStateNormal];
    [_btnInfoSet addTarget:self action:@selector(btnInfoSetOnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_btnAlertSet setImage:[UIImage imageNamed:@"alert-set"] forState:UIControlStateNormal];
    [_btnAlertSet addTarget:self action:@selector(btnAlertSetOnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:_imgViewDev];
    [self.contentView addSubview:_labelDevName];
    [self.contentView addSubview:_btnWifiSet];
    [self.contentView addSubview:_btnInfoSet];
    [self.contentView addSubview:_btnAlertSet];
    return self;
}
/****
 * 报警盒信息
 ****/
- (void)setAlertBox:(FAlertBox *)fAlertBox {
    _alertBox = fAlertBox;
    
    if ([[fAlertBox online] isEqualToString:@"1"]) {
        [_imgViewDev setImage:[UIImage imageNamed:@"box_online"]];
    }else{
        [_imgViewDev setImage: [UIImage imageNamed:@"box_offline"]];
    }
    NSString *str = [fAlertBox boxName];
    if ( str){
        if ( [str isEqualToString:@""]){
            if ( [fAlertBox boxID]){
                _labelDevName.text = [fAlertBox boxID];
            }
        }else{
            _labelDevName.text = [fAlertBox boxName];
        }
    }
    
    [self setNeedsLayout];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_imgViewDev setFrame:CGRectMake(10.0f, 10.0f, 30.0f, 30.0f)];
    [_labelDevName setFrame:CGRectMake((CGRectGetMaxX(_imgViewDev.frame)+ 10.0f), 10.0f, (mWidth - 165.0f), 30.0f)];
    [_btnWifiSet setFrame:CGRectMake(CGRectGetMaxX(_labelDevName.frame)+5.0f, 10.f, 30.0f, 30.0f)];
    [_btnInfoSet setFrame:CGRectMake(CGRectGetMaxX(_btnWifiSet.frame)+5.0f, 10.f, 30.0f, 30.0f)];
    [_btnAlertSet setFrame:CGRectMake(CGRectGetMaxX(_btnInfoSet.frame)+5.0f, 10.f, 30.0f, 30.0f)];
    
}
-( void)dealloc{
    [super dealloc];
    [_imgViewDev release];
    [_labelDevName release];
    [_btnWifiSet release];
    [_btnInfoSet release];
    [_btnAlertSet release];
    [_alertBox release];
}
-( IBAction)btnWifiSetOnClicked:(id)sender{
    NSLog(@"%s",__FUNCTION__);
    if( ![ AppData getInstance].userinfoEx.isTopAccount){
        return;
    }
    NSString *ssid = [FTools currentWifiSSID];
    if (nil == ssid || [ssid isEqualToString:@""]) {
        [Tools showAlert:@"检测到你的手机网络处理非Wi-Fi环境中，报警盒Wi-Fi配置需要保证手机已连接正常的Wi-Fi方可配置"];
        return;
    }
    
    ESPViewController *viewControler = [[ESPViewController alloc]init];
    viewControler.ssid = ssid;
    [_rootView.navigationController pushViewController:viewControler animated:YES];
    [viewControler release];
}
-( IBAction)btnInfoSetOnClicked:(id)sender{
    NSLog(@"%s",__FUNCTION__);
    if( ![ AppData getInstance].userinfoEx.isTopAccount){
        return;
    }
    UpdateALertBoxInfoViewController *viewControler = [[UpdateALertBoxInfoViewController alloc]init];
    viewControler.alertBox = _alertBox;
    [_rootView.navigationController pushViewController:viewControler animated:YES];
    [viewControler release];
}
-( IBAction)btnAlertSetOnClicked:(id)sender{
    NSLog(@"%s",__FUNCTION__);
    if( ![ AppData getInstance].userinfoEx.isTopAccount){
        return;
    }
    SetAlertBoxViewController *viewControler = [[SetAlertBoxViewController alloc]init];
    viewControler.alertBox = _alertBox;
    [_rootView.navigationController pushViewController:viewControler animated:YES];
    [viewControler release];

}
@end
