//
//  SafeSetViewController.m
//  Supereye
//
//  Created by jiang bing on 15/6/28.
//  Copyright (c) 2015年 Netviom. All rights reserved.
//

#import "SafeSetViewController.h"
#import "FGetSafeEventSetReq.h"
#import "Tools.h"
#import "AppData.h"
#import "MBProgressHUD.h"
#import "FGetSafeEventSetRes.h"
#import "FSetEventSetReq.h"
#import "FSetEventRes.h"
#import "ASISEHttpRequest.h"

@interface SafeSetViewController ()

@end

@implementation SafeSetViewController

@synthesize mSafeSetTableView = _mSafeSetTableView;
@synthesize typeArray = _typeArray;
@synthesize safeLevelArray = _safeLevelArray;

BOOL isSave;
static int type[4];
static int safeLevel[3];
MBProgressHUD *mHud;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    isSave = NO;
    for (int i = 0; i < sizeof(type); ++i) {
        type[i] = 0;
    }
    for (int i = 0; i < sizeof(safeLevel); ++i)
    {
         safeLevel[i] = 0;
    }
    setListArray = [[NSMutableArray alloc]init];
    _typeArray = [[NSMutableArray alloc]initWithObjects:@"邮箱通知", @"短信通知", @"推送通知", @"微信通知", nil];
    _safeLevelArray =[[NSMutableArray alloc]initWithObjects:@"关闭通知", @"登录通知", @"视频通知＋登录通知", nil];
    [self initView];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self initData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [_mSafeSetTableView release];
    [_safeLevelArray release];
    [_typeArray release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMSafeSetTableView:nil];
    _typeArray = nil;
    _safeLevelArray = nil;
    [super viewDidUnload];
}
/**
 *    @author FREELANCER, 2015年06月28日 11:06:10
 *
 *    @brief  返回
 *
 *    @since 1.0
 */
-(void)goBack
{
    [self  dismissViewControllerAnimated:YES completion:nil];
}
/**
 *    @author FREELANCER, 2015年06月28日 11:06:27
 *
 *    @brief 保存设置
 *
 *    @since 1.0
 */
-(void)doSave
{
    [mHud setHidden:NO];
    isSave = YES;
    FSetEventSetReq *req = [FSetEventSetReq requestWithAuth:[Tools currentAuth]];
    req.emailnotify = type[0];
    req.smsnotify = type[1];
    req.pushNotify = type[ 2];
    req.wechatNotify = type[ 3];
    for (int i = 0; i < sizeof(safeLevel); ++i)
    {
        if (safeLevel[i])
        {
            req.safelevel = i;
            break;
        }
    }
    ASISEClient *asiseClient = [ASISEClient requestWithUrlString:[AppData getInstance].platform.mobile_url];
    
    asiseClient.delegate = self;
    [asiseClient doPostString:[req getXML] timeout:HTTP_TIME_OUT];
}
/**
 *@初始化数据
 **/
-(void)initData
{
    [mHud setHidden:NO];
    FGetSafeEventSetReq *req = [FGetSafeEventSetReq requestWithAuth:[Tools currentAuth]];
    ASISEClient *asiseClient = [ASISEClient requestWithUrlString:[AppData getInstance].platform.mobile_url];
    
    asiseClient.delegate = self;
    [asiseClient doPostString:[req getXML] timeout:HTTP_TIME_OUT];
}
/**
 *    @author FREELANCER, 2015年06月28日 11:06:13
 *
 *    @brief  初始化UI
 *
 *    @since 1.0
 */
-(void) initView
{
    self.title = @"安全设置提醒";
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = leftBar;
    [leftBar release];
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(doSave)];
    self.navigationItem.rightBarButtonItem = rightBar;
    [rightBar release];

    [self.view addSubview:_mSafeSetTableView];
    [_mSafeSetTableView reloadData];
    
    mHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [mHud setLabelText:@"正在加载中..."];
    [mHud setHidden:YES];
}

#pragma UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
///返回每个索引的内容
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"通知类型";
    }
    return @"安全级别";
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return [_typeArray count];
    }
    return [_safeLevelArray count];
}
// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell identify";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify] autorelease];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    if ([indexPath section] == 0)
    {
        cell.textLabel.text = [_typeArray objectAtIndex:[indexPath row]];
        if (type[[indexPath row]]) {
              cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    else if([indexPath section] == 1)
    {
        cell.textLabel.text = [_safeLevelArray objectAtIndex:[indexPath row]];
        if (safeLevel[[indexPath row]]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }

    }
    return cell;
}
// custom view for footer. will be adjusted to default or specified footer height
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 50.0f;
    }
    return 0.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, 10.0f, ([UIScreen mainScreen].bounds.size.width), 50.0f)];
        [label setText:@""];
        [label setTextColor:[UIColor grayColor]];
        label.lineBreakMode = UILineBreakModeWordWrap;
        label.numberOfLines = 2;
        return label;
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 0)
    {
        int size = sizeof(type);
        if ([indexPath row] < size)
        {
            if (type[[indexPath row]])
            {
                type[[indexPath row]] = 0;
            }
            else
            {
                type[[indexPath row]] = 1;
            }
        }
    }
    else if ([indexPath section] == 1)
    {
        int size = sizeof(safeLevel);
        if ([indexPath row] < size)
        {
            for(int i = 0; i < size; ++i)
            {
                safeLevel[i] = 0;
            }
            safeLevel[[indexPath row]] = 1;
        }
    }
    [_mSafeSetTableView reloadData];
}
#pragma ASIHTTPRequest

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [Tools log:[NSString stringWithFormat:@"获取安全设置响应:\n%@",request.responseString]];
    [mHud setHidden:YES];
    if ([request responseStatusCode] == 200)
    {
        if (isSave)
        {
            isSave = NO;
            [Tools showAlert:@"设置成功"];
            [self dismissModalViewControllerAnimated:YES];
            return;
        }
        FGetSafeEventSetRes *respond = [FGetSafeEventSetRes initWithXMLString:request.responseString];
        
        if ([respond isSuccess])
        {
            [setListArray addObjectsFromArray:respond.setList];
            for (int i = 0; i < [setListArray count]; ++i)
            {
                NSString *str = [setListArray objectAtIndex:i];
                if (i == 0 && str)
                {
                    type[0] = [str intValue];
                }
                if (i == 1 && str)
                {
                    type[1] = [str intValue];
                }
                if (i == 2 && str)
                {
                    type[2] = [str intValue];
                }
                if (i == 3 && str)
                {
                    type[3] = [str intValue];
                }
                if (i == 4 && str)
                {
                    int safe = [str intValue];
                    if (safe < 3)
                    {
                        safeLevel[safe] = 1;
                    }
                }
            }
            [self.mSafeSetTableView reloadData];
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
    [Tools log:@"获取安全设置响应:请求失败"];
    [mHud setHidden:YES];
    [Tools showAlert:@"请求失败"];
}

@end
