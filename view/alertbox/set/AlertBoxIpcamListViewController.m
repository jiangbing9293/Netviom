//
//  AlertBoxIpcamListViewController.m
//  Supereye
//
//  Created by jiang bing on 15/10/16.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import "AlertBoxIpcamListViewController.h"
#import "MBProgressHUD.h"
#import "ASISEHttpRequest.h"
#import "AppData.h"
#import "Tools.h"
#import "SEBaseResponse.h"
#import "FAlertBoxIpcamGetReq.h"
#import "FAlertBoxIpcamGetRes.h"
#import "FAlertBoxIpcamCfgReq.h"
#import "Camera.h"

@interface AlertBoxIpcamListViewController ()

@end

@implementation AlertBoxIpcamListViewController

static NSString *kHttpUserinfoKey = @"Userinfo";

@synthesize boxID = _boxID;
@synthesize sensorID = _sensorID;

NSMutableArray *ipcamArray;

FAlertBoxIpcamCfg *mIpcamCfg;

BOOL isCheck;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"关联设备";
    [self initNavBar];
    [self syncDataFromServer];
    isCheck = YES;
    mIpcamCfg = [[ FAlertBoxIpcamCfg alloc] init];
    self.view.backgroundColor = [Tools backgroundColor];
    CGFloat mWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat mHeight = [UIScreen mainScreen].bounds.size.height;
    ipcamArray = [[ NSMutableArray alloc] init];
    
    [ipcamArray addObjectsFromArray:[ AppData getInstance].deviceArray];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0f, 70.0f, mWidth, (mHeight-70)) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNavBar
{
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = leftBar;
    [leftBar release];
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStyleBordered target:self action:@selector(clickSaveBtn)];
    self.navigationItem.rightBarButtonItem = rightBar;
    [rightBar release];
}
/***
 *  设置按钮
 ***/
- ( void)clickSaveBtn{
    mIpcamCfg.boxID = _boxID;
    mIpcamCfg.sensorID = _sensorID;
    [self syncDataToServer];
}

-( void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  switch 开关
 **/
- ( IBAction)switchChangeValue:(id)sender {
    if ([@"1" isEqualToString:mIpcamCfg.status] ) {
        mIpcamCfg.status = [[ NSString alloc] initWithString:@"0"];
    }else{
        mIpcamCfg.status = [[ NSString alloc] initWithString:@"1"];
    }
}
- ( void)syncDataFromServer{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setLabelText:@"正在获取数据..."];
    [hud setHidden:NO];
    FAlertBoxIpcamGetReq *req = [FAlertBoxIpcamGetReq requestWithAuth:[Tools currentAuth]];
    ASISEClient *asiseClient = [ASISEClient requestWithUrlString:[AppData getInstance].platform.mobile_url];
    req.boxID = _boxID;
    asiseClient.delegate = self;
    asiseClient.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:req, kHttpUserinfoKey, nil];
    [asiseClient doPostString:[req getXML] timeout:HTTP_TIME_OUT];
}
- ( void) syncDataToServer{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setLabelText:@"正在配置数据..."];
    [hud setHidden:NO];
    FAlertBoxIpcamCfgReq *req = [FAlertBoxIpcamCfgReq requestWithAuth:[Tools currentAuth]];
    ASISEClient *asiseClient = [ASISEClient requestWithUrlString:[AppData getInstance].platform.mobile_url];
    req.ipcamCfg = mIpcamCfg;
    asiseClient.delegate = self;
    asiseClient.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:req, kHttpUserinfoKey, nil];
    [asiseClient doPostString:[req getXML] timeout:HTTP_TIME_OUT];
}
#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ipcamArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell identify";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    Camera *cam = [ ipcamArray objectAtIndex:[ indexPath row]];
    NSString *ipcamID = cam.cameraid;
    if (ipcamID) {
        cell.textLabel.text = cam.cameraname;
        if ( [ipcamID isEqualToString:mIpcamCfg.ipcamID] && isCheck){
             cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    
    return cell;
}
- ( CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50.0f;
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
            lableType.text = [[ NSString alloc] initWithString: @"关联开关"];
            if ([mIpcamCfg.status isEqualToString:@"1"]){
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Camera *cam = [ ipcamArray objectAtIndex:[ indexPath row]];
    NSString *ipcamID = cam.cameraid;
    if (ipcamID) {
        if ( [ipcamID isEqualToString:mIpcamCfg.ipcamID] && isCheck){
            isCheck = NO;
        }
        else{
            isCheck = YES;
        }
        if ( ![ipcamID isEqualToString:mIpcamCfg.ipcamID]){
            isCheck = YES;
            mIpcamCfg.ipcamID = ipcamID;
        }
    }
    [_tableView reloadData];
}

#pragma ASIHTTPRequest
- (void)requestFinished:(ASIHTTPRequest *)request
{
    [Tools log:[NSString stringWithFormat:@"%s:\n%@", __FUNCTION__,request.responseString]];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    id userinfo = [request.userInfo objectForKey:kHttpUserinfoKey];
    if ([userinfo isKindOfClass:[FAlertBoxIpcamGetReq class]]){
        if ( [request responseStatusCode] == 200){
            FAlertBoxIpcamGetRes *response = [ FAlertBoxIpcamGetRes initWithXMLString:[ request responseString]];
            if( response.setArray){
                for (FAlertBoxIpcamCfg *cfg in response.setArray) {
                    if ( [cfg.sensorID isEqualToString:_sensorID]){
                        mIpcamCfg.ipcamID = cfg.ipcamID;
                        mIpcamCfg.status = cfg.status;
                        break;
                    }
                }
            }
            [_tableView reloadData];
        }else{
            [Tools showAlert:@"请求失败"];
        }
    }
    else if( [ userinfo isKindOfClass:[ FAlertBoxIpcamCfgReq class]]){
        if ( [request responseStatusCode] == 200){
            SEBaseResponse *resp = [ SEBaseResponse initWithXMLString:[ request responseString]];
            if (resp.funcStatus == 200 ) {
                [Tools showAlert:@"配置成功"];
            }else{
                [Tools showAlert:[ resp info]];
            }
            [self goBack];
        }else{
            [Tools showAlert:@"请求失败"];
        }
    }
   
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    [Tools log:[NSString stringWithFormat:@"%s:请求失败\n", __FUNCTION__]];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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
