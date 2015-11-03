//
//  SetAlertBoxViewController.m
//  Supereye
//
//  Created by jiang bing on 15/10/10.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import "SetAlertBoxViewController.h"
#import "Tools.h"
#import "AlertTimeSetAlertBoxViewController.h"
#import "AlertReceiveAlertBoxViewController.h"
#import "AlertBoxIpcamListViewController.h"
#import "FAlertBoxAlertSetReq.h"
#import "FAlertBoxAlertSetRes.h"
#import "FAlertBoxParaGetReq.h"
#import "FAlertBoxParaGetRes.h"
#import "FAlertBoxParamCfgReq.h"
#import "FAlertBoxAlertSet.h"
#import "FAlertBoxParamGet.h"
#import "MBProgressHUD.h"
#import "ASISEHttpRequest.h"
#import "AppData.h"
#import "SEBaseResponse.h"
#import "iToast.h"

/***
 * 报警盒设置界面控件tag
 ***/

typedef enum{
    ALERTBOX_TAG_MOTION = 100,
    ALERTBOX_TAG_ENMERGY,
    ALERTBOX_TAG_GPIO,
    ALERTBOX_TAG_HIDEMODEL
}AlertBox_Set_tag;

/****
 * 报警盒设置界面 设置选项ID
 ****/
typedef enum {
    ALERTBOX_ITEM_TIME,
    ALERTBOX_ITEM_RECEIVE,
    ALERTBOX_ITEM_IPCAM
}AlertBox_Set_Item;

@interface SetAlertBoxViewController ()

@end

static NSString *kHttpUserinfoKey = @"Userinfo";

@implementation SetAlertBoxViewController

@synthesize btnTime = _btnTime;
@synthesize tableView = _tableView;
@synthesize items = _items;
@synthesize alertBox =_alertBox;

NSMutableArray *fSetArray;
NSMutableArray *fParamArray;

FAlertBoxParamGet *sensor100;
FAlertBoxParamGet *sensor200;
FAlertBoxParamGet *sensor300;
FAlertBoxParamGet *bellTime;
FAlertBoxParamGet *hideModel;

FAlertBoxAlertSet *sensor100Set;
FAlertBoxAlertSet *sensor200Set;
FAlertBoxAlertSet *sensor300Set;

MBProgressHUD *mHud;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    fSetArray = [[ NSMutableArray alloc] init];
    fParamArray = [[ NSMutableArray alloc] init];
    
    self.title = [_alertBox boxID];
    
    self.view.backgroundColor = [Tools backgroundColor];
    CGFloat mWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat mHeight = [UIScreen mainScreen].bounds.size.height;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0f, 20.0f, mWidth, mHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    [self initItems];
    [self initNavBar];
    [self syncData];
    [self syncParaData];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)initItems
{
    _items = [[NSMutableArray alloc]init];
    [_items addObject:[[ NSString alloc] initWithString:@"报警时间设置"]];
    [_items addObject:[[ NSString alloc] initWithString:@"报警接收设置"]];
    [_items addObject:[[ NSString alloc] initWithString:@"关联设备"]];
}

- (void)initNavBar
{
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = leftBar;
    [leftBar release];
}
/***
 *  解析报警盒报警设置参数
 ***/
- ( void) parseAlertSet{
    
    for ( int i = 0; i < [fSetArray count]; ++i){
        FAlertBoxAlertSet *set = [ fSetArray objectAtIndex:i];
        if ( set.sensorID){
            if ([set.sensorID isEqualToString:@"100"]) {
                sensor100Set = [fSetArray objectAtIndex:i];
            }
            if ([set.sensorID isEqualToString:@"200"]) {
                sensor200Set = [fSetArray objectAtIndex:i];
            }
            if ([set.sensorID isEqualToString:@"300"]) {
                sensor300Set = [fSetArray objectAtIndex:i];
            }
        }
    }
}

/***
 * 解析报警盒设备参数
 ***/
- ( void)parseParamGet{
    for (int i = 0; i < [fParamArray count]; ++i) {
        FAlertBoxParamGet *param = [fParamArray objectAtIndex:i];
        if ( param.sensorID){
            if ([param.sensorID isEqualToString:@"100"]) {
                sensor100 = [fParamArray objectAtIndex:i];
            }
            if ([param.sensorID isEqualToString:@"200"]) {
                sensor200 = [fParamArray objectAtIndex:i];
            }
            if ([param.sensorID isEqualToString:@"300"]) {
                sensor300 = [fParamArray objectAtIndex:i];
            }
        }
        if (nil == param.sensorID || [param.sensorID isEqualToString:@""]) {
            if ( [param.cfgCode isEqualToString:@"BUZZER_TIME"]){
                bellTime = [ fParamArray objectAtIndex:i];
            }
            if ( [param.cfgCode isEqualToString:@"RUN_MODEL"]){
                hideModel = [ fParamArray objectAtIndex:i];
            }
        }
    }
}

/**
 * 同步报警盒报警设置数据
 **/
- ( void) syncData{
    
    mHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [mHud setLabelText:@"正在获取数据..."];
    FAlertBoxAlertSetReq *req = [FAlertBoxAlertSetReq requestWithAuth:[Tools currentAuth]];
    ASISEClient *asiseClient = [ASISEClient requestWithUrlString:[AppData getInstance].platform.mobile_url];
    req.boxID = [_alertBox boxID];
    asiseClient.delegate = self;
    asiseClient.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:req, kHttpUserinfoKey, nil];
    [asiseClient doPostString:[req getXML] timeout:HTTP_TIME_OUT];
}
/**
 * 同步报警盒报警参数数据
 **/
- ( void) syncParaData{
    
    if ( !mHud){
        mHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [mHud setLabelText:@"正在获取数据..."];
    }
    [mHud setHidden:NO];
    FAlertBoxParaGetReq *req = [FAlertBoxParaGetReq requestWithAuth:[Tools currentAuth]];
    ASISEClient *asiseClient = [ASISEClient requestWithUrlString:[AppData getInstance].platform.mobile_url];
    req.boxID = [_alertBox boxID];
    asiseClient.delegate = self;
    asiseClient.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:req, kHttpUserinfoKey, nil];
    [asiseClient doPostString:[req getXML] timeout:HTTP_TIME_OUT];
}

/***
 *  设置报警盒参数
 ***/
- ( void)syncSetToServer:(FAlertBoxParamGet *)param{
    
    if ( !mHud){
        mHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    [mHud setLabelText:@"正在配置中..."];
    [mHud setHidden:NO];
    FAlertBoxParamCfgReq *req = [FAlertBoxParamCfgReq requestWithAuth:[Tools currentAuth]];
    ASISEClient *asiseClient = [ASISEClient requestWithUrlString:[AppData getInstance].platform.mobile_url];
    req.paramGet = param;
    asiseClient.delegate = self;
    asiseClient.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:req, kHttpUserinfoKey, nil];
    [asiseClient doPostString:[req getXML] timeout:HTTP_TIME_OUT];
}
/**
 *  返回按钮
 ***/
- (void)goBack
{
    if ( ![mHud isHidden]){
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  switch 开关
 **/
- ( IBAction)switchChangeValue:(id)sender {
    
    UIButton *btn = ( UIButton*) sender;
    if ( btn){
        
        switch (btn.tag) {
                // 人体感应
            case ALERTBOX_TAG_MOTION:
                if ( sensor200){
                    if ( [sensor200.cfgValue isEqualToString:@"1"]){
                        sensor200.cfgValue = @"0";
                    }else{
                        sensor200.cfgValue = @"1";
                    }
                    [self syncSetToServer:sensor200];
                }
                break;
                // 紧急按钮
            case ALERTBOX_TAG_ENMERGY:
                if (sensor300) {
                    if ( [sensor300.cfgValue isEqualToString:@"1"]){
                        sensor300.cfgValue = @"0";
                    }else{
                        sensor300.cfgValue = @"1";
                    }
                    [self syncSetToServer:sensor300];
                }

                break;
                //外接报警
            case ALERTBOX_TAG_GPIO:
                if ( [sensor100.cfgValue isEqualToString:@"1"]){
                    sensor100.cfgValue = @"0";
                }else{
                    sensor100.cfgValue = @"1";
                }
                [self syncSetToServer:sensor100];
                break;
                
            case ALERTBOX_TAG_HIDEMODEL:
                if ( [hideModel.cfgValue isEqualToString:@"1"]){
                    hideModel.cfgValue = @"0";
                }else{
                    hideModel.cfgValue = @"1";
                }

                [self syncSetToServer:hideModel];
                break;
        }
        return;
    }
}

#pragma mark - UITableView
-( NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell identify";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSString *value = [_items objectAtIndex:[indexPath row]];
    cell.textLabel.text = value;
    
    return cell;
}
- ( CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50.0f;
}
- ( CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 100.0f;
    }
    return 0;
}
- ( UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    UIView *headerView = [[ UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, 50.0f)];
    UILabel *lableType = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 10.0f, (width - 100.0f), 30.0f)];
    
    [headerView addSubview:lableType];
    
    switch (section) {
        case 0:{
            
            UISwitch *swt = [[ UISwitch alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lableType.frame) , 10.0f, 50.0f, 30.0f)];
            [swt addTarget:self action:@selector(switchChangeValue:) forControlEvents:UIControlEventValueChanged];
            lableType.font = [ UIFont boldSystemFontOfSize:17.0f];
            [headerView addSubview:swt];
            
            if ([[_alertBox boxID] hasPrefix:@"7001"]) {
                lableType.text = [[ NSString alloc] initWithString: @"人体感应开关"];
                swt.tag = ALERTBOX_TAG_MOTION;
                if ( sensor200 && [sensor200.cfgValue isEqualToString:@"1"]){
                    [swt setOn:YES];
                }
                else{
                    [swt setOn:NO];
                }
            }else{
                lableType.text = [[ NSString alloc] initWithString: @"紧急按钮开关"];
                if ( sensor300 && [sensor300.cfgValue isEqualToString:@"1"]){
                    [swt setOn:YES];
                }
                else{
                    [swt setOn:NO];
                }
                swt.tag = ALERTBOX_TAG_ENMERGY;
            }
            
        }
            break;
            
        case 1:{
            
            UISwitch *swt = [[ UISwitch alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lableType.frame) , 10.0f, 50.0f, 30.0f)];
            lableType.font = [ UIFont boldSystemFontOfSize:17.0f];
            
            swt.tag = ALERTBOX_TAG_GPIO;
            [swt addTarget:self action:@selector(switchChangeValue:) forControlEvents:UIControlEventValueChanged];
            [headerView addSubview:swt];
            lableType.text = [[ NSString alloc] initWithString: @"外接报警开关"];
            if ( sensor100 && [sensor100.cfgValue isEqualToString:@"1"]){
                [swt setOn:YES];
            }
            else{
                [swt setOn:NO];
            }
        }
            break;
    }
    return headerView;
}

- ( UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        
        UIView *footView = [[ UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, 100.0f)];
        
        UIView *view1 = [[ UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, 50.0f)];
        UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 10.0f, (width - 100.0f), 30.0f)];
        
        _btnTime = [[ UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lable1.frame) , 10.0f, 50.0f, 30.0f)];
        [_btnTime setTitle:bellTime.cfgValue forState:UIControlStateNormal];
        [_btnTime addTarget:self action:@selector(triggerPicker) forControlEvents:UIControlEventTouchUpInside];
        [_btnTime setTitleColor:[ UIColor blackColor] forState:UIControlStateNormal];
        [view1 addSubview:lable1];
        [view1 addSubview:_btnTime];
        lable1.text = [[ NSString alloc] initWithString: @"报警响铃时长设置"];
        
        [footView addSubview:view1];
        
        UIView *view = [[ UIView alloc] initWithFrame:CGRectMake(0.0f, 50.0f, width, 50.0f)];
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 10.0f, (width - 100.0f), 30.0f)];
        
        UISwitch *swt = [[ UISwitch alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lable.frame) , 10.0f, 50.0f, 30.0f)];
        lable.font = [ UIFont boldSystemFontOfSize:17.0f];
        if ( hideModel && [hideModel.cfgValue isEqualToString:@"0"]){
            [swt setOn:YES];
        }
        else{
            [swt setOn:NO];
        }
        swt.tag = ALERTBOX_TAG_HIDEMODEL;
        [swt addTarget:self action:@selector(switchChangeValue:) forControlEvents:UIControlEventValueChanged];
        [view addSubview:lable];
        [view addSubview:swt];
        lable.text = [[ NSString alloc] initWithString:@"隐蔽模式"];
        
        [footView addSubview:view];
        
        return footView;

    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( [indexPath section] == 0){
        FAlertBoxAlertSet *set = nil;
        if ( [_alertBox.boxID hasPrefix:@"7001"]){
            set = sensor200Set;
        }else{
            set = sensor300Set;
        }
        if ( set){
            if ( [indexPath row] == ALERTBOX_ITEM_TIME ){
                AlertTimeSetAlertBoxViewController *viewController = [[ AlertTimeSetAlertBoxViewController alloc] init];
                viewController.alertSet = set;
                [self.navigationController pushViewController:viewController animated:YES];
                [viewController release];
            }
            if ( [indexPath row] == ALERTBOX_ITEM_RECEIVE){
                AlertReceiveAlertBoxViewController *viewController = [[ AlertReceiveAlertBoxViewController alloc] init];
                viewController.alertSet = set;
                [self.navigationController pushViewController:viewController animated:YES];
                [viewController release];
                
            }
            if ( [indexPath row] == ALERTBOX_ITEM_IPCAM){
                AlertBoxIpcamListViewController *viewController = [[ AlertBoxIpcamListViewController alloc] init];
                viewController.boxID = _alertBox.boxID;
                viewController.sensorID = set.sensorID;
                [self.navigationController pushViewController:viewController animated:YES];
                [viewController release];
            }
        }
    }
    
    if ( [indexPath section] == 1){
        if ( [indexPath row] == ALERTBOX_ITEM_TIME ){
            AlertTimeSetAlertBoxViewController *viewController = [[ AlertTimeSetAlertBoxViewController alloc] init];
            viewController.alertSet = sensor100Set;
            [self.navigationController pushViewController:viewController animated:YES];
            [viewController release];
        }
        if ( [indexPath row] == ALERTBOX_ITEM_RECEIVE){
            AlertReceiveAlertBoxViewController *viewController = [[ AlertReceiveAlertBoxViewController alloc] init];
            viewController.alertSet = sensor100Set;
            [self.navigationController pushViewController:viewController animated:YES];
            [viewController release];
            
        }
        if ( [indexPath row] == ALERTBOX_ITEM_IPCAM){
            AlertBoxIpcamListViewController *viewController = [[ AlertBoxIpcamListViewController alloc] init];
            viewController.boxID = _alertBox.boxID;
            viewController.sensorID = sensor100Set.sensorID;
            [self.navigationController pushViewController:viewController animated:YES];
            [viewController release];
        }

    }
}

- (IBAction)triggerPicker {
    if (defaultPickerView == nil) {
        CGFloat height = [ UIScreen mainScreen].bounds.size.height;
        CGFloat width = [ UIScreen mainScreen].bounds.size.width;
        defaultPickerView = [[AFPickerView alloc] initWithFrame:CGRectMake(0,(height-216),width,216) backgroundImage:@"PickerBG" shadowImage:@"PickerShadow" glassImage:@"pickerGlass" title:@"选择报警响铃时长"];
        defaultPickerView.dataSource = self;
        defaultPickerView.delegate = self;
        [self.view addSubview:defaultPickerView];
    }
    
    [defaultPickerView setSelectedRow:[ bellTime.cfgValue intValue]];
    [defaultPickerView showPicker];
    [defaultPickerView reloadData];
}

#pragma mark - AFPickerViewDataSource

- (NSInteger)numberOfRowsInPickerView:(AFPickerView *)pickerView {
    return 10;
}

- (NSString *)pickerView:(AFPickerView *)pickerView titleForRow:(NSInteger)row {
    return [NSString stringWithFormat:@"%d", (int)row + 1];
}


#pragma mark - AFPickerViewDelegate
- (void)pickerView:(AFPickerView *)pickerView didSelectRow:(NSInteger)row {
    
    NSString *sec = [NSString stringWithFormat:@"%d", (int)row + 1];
    
    [_btnTime setTitle:sec forState:UIControlStateNormal];
    if ( bellTime ){
        bellTime.cfgValue = sec;
    }
}

- ( void) submitButtonClicked{
    if ( bellTime){
        [self syncSetToServer:bellTime];
    }
}

#pragma ASIHTTPRequest
- (void)requestFinished:(ASIHTTPRequest *)request
{
    [Tools log:[NSString stringWithFormat:@"报警盒报警设置信息响应:\n%@",request.responseString]];
    [mHud setHidden:YES];
    id userinfo = [request.userInfo objectForKey:kHttpUserinfoKey];
    if ([userinfo isKindOfClass:[FAlertBoxAlertSetReq class]]){
        if ([request responseStatusCode] == 200){
            FAlertBoxAlertSetRes *res = [FAlertBoxAlertSetRes initWithXMLString:request.responseString];
            if ( [res isSuccess]){
                [fSetArray removeAllObjects];
                [fSetArray addObjectsFromArray:res.setArray];
                [self parseAlertSet];
                [_tableView reloadData];
            }
            else
            {
                [Tools showAlert:[res errorDesc]];
            }
        }
        else
        {
            [Tools showAlert:@"请求失败"];
        }
    }
    else if ( [userinfo isKindOfClass:[ FAlertBoxParaGetReq class]]){
        if ([request responseStatusCode] == 200){
            FAlertBoxParaGetRes *res = [FAlertBoxParaGetRes initWithXMLString:request.responseString];
            if ( [res isSuccess]){
                [fParamArray removeAllObjects];
                [fParamArray addObjectsFromArray:res.setArray];
                [self parseParamGet];
                [_tableView reloadData];
            }
            else
            {
                [Tools showAlert:[res errorDesc]];
            }
        }
        else
        {
            [Tools showAlert:@"请求失败"];
        }
    }
    else if( [ userinfo isKindOfClass:[ FAlertBoxParamCfgReq class]]){
        if ([request responseStatusCode] == 200){
            SEBaseResponse *resp = [ SEBaseResponse initWithXMLString:[ request responseString]];
            if (resp.funcStatus == 200 ) {
                [Tools showAlert:@"配置成功"];
            }else{
                [Tools showAlert:[ resp info]];
            }
        }
        else
        {
            [Tools showAlert:@"请求失败"];
        }

    }
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    [Tools log:@"报警盒报警设置响应:请求失败"];
    [mHud setHidden:YES];
    [Tools showAlert:@"请求失败"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
