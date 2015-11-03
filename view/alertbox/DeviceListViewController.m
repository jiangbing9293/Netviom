//
//  DeviceListViewController.m
//  Supereye
//
//  Created by jiang bing on 15/10/8.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import "DeviceListViewController.h"
#import "DeviceTableViewCell.h"
#import "FAlertBoxListReq.h"
#import "FAlertBoxListRes.h"
#import "Tools.h"
#import "Tools.h"
#import "AppData.h"
#import "ASISEHttpRequest.h"

@interface DeviceListViewController ()

@end

@implementation DeviceListViewController

@synthesize devArray = _devArray;
@synthesize tableView =_tableView;
@synthesize mHud = _mHud;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _devArray = [[ NSMutableArray alloc] init];
    [self initView];
}
- ( void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
     [self syncData];
}

- ( void)dealloc{
    [super dealloc];
    [_mHud release];
    [_tableView release];
    [_devArray release];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//初始化UI
-( void) initView{
    self.title = @"报警盒列表";
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = leftBar;
    [leftBar release];
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithTitle:@"刷新" style:UIBarButtonItemStyleBordered target:self action:@selector(syncData)];
    self.navigationItem.rightBarButtonItem = rightBar;
    [rightBar release];
    
    self.view.backgroundColor = [Tools backgroundColor];
    CGFloat mWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat mHeight = [UIScreen mainScreen].bounds.size.height;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, mWidth, mHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView reloadData];
    
    _mHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_mHud setLabelText:@"正在加载数据..."];
}
//同步数据
-( void) syncData{
    if (_mHud){
        [_mHud setHidden:NO];
    }
    FAlertBoxListReq *req = [FAlertBoxListReq requestWithAuth:[Tools currentAuth]];
    ASISEClient *asiseClient = [ASISEClient requestWithUrlString:[AppData getInstance].platform.mobile_url];
    
    asiseClient.delegate = self;
    [asiseClient doPostString:[req getXML] timeout:HTTP_TIME_OUT];
}

- (void)goBack
{
    if ( ![_mHud isHidden]){
        return;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_devArray count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"温馨提示:点击右上角刷新按钮可刷新报警盒在线状态";
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell identify";
    DeviceTableViewCell *cell = (DeviceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identify];
    
    if (cell == nil)
    {
        cell = [[DeviceTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
    }
    cell.rootView = self;
    cell.alertBox = [_devArray objectAtIndex:[indexPath row]];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma ASIHTTPRequest
- (void)requestFinished:(ASIHTTPRequest *)request
{
    [Tools log:[NSString stringWithFormat:@"获取报警盒列表响应:\n%@",request.responseString]];
    if (_mHud) {
        [_mHud setHidden:YES];
    }
    if ([request responseStatusCode] == 200)
    {
        FAlertBoxListRes *respond = [FAlertBoxListRes initWithXMLString:request.responseString];
        
        if ([respond isSuccess])
        {
            [_devArray removeAllObjects];
            [_devArray addObjectsFromArray:respond.deviceArray];
            [_tableView reloadData];
        }
        else
        {
            [Tools showAlert:[respond errorDesc]];
        }
    }
    else
    {
        [Tools showAlert:@"请求失败"];
    }
    
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    [Tools log:@"获取报警盒列表响应:请求失败"];
    if (_mHud ){
        [_mHud setHidden:YES];
    }
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
