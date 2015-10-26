//
//  FAccountListViewController.m
//  Supereye
//
//  Created by jiang bing on 15/7/8.
//  Copyright (c) 2015年 Netviom. All rights reserved.
//

#import "FAccountListViewController.h"
#import "Tools.h"
#import "AppData.h"
#import "MBProgressHUD.h"
#import "FUserAccountListReq.h"
#import "FUserAccountListRes.h"
#import "ASISEHttpRequest.h"

@interface FAccountListViewController ()

@end

@implementation FAccountListViewController

MBProgressHUD *mHud;

@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    accountListArray = [[NSMutableArray alloc]init];
    [self initView];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self initData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *@初始化数据
 **/
-(void)initData
{
    FUserAccountListReq *req = [FUserAccountListReq requestWithAuth:[Tools currentAuth]];
    
    ASISEClient *asiseClient = [ASISEClient requestWithUrlString:[AppData getInstance].platform.mobile_url];
    
    asiseClient.delegate = self;
    [asiseClient doPostString:[req getXML] timeout:HTTP_TIME_OUT];
}
/**
 *@ 初始化UI
 **/
-(void) initView
{
    self.view.backgroundColor = [Tools backgroundColor];
    CGFloat mWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat mHeight = [UIScreen mainScreen].bounds.size.height;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, mWidth, mHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView reloadData];
    mHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [mHud setLabelText:@"正在获取子帐号..."];
    self.title = @"子账户列表";
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [accountListArray count];
}
///返回每个索引的内容
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"请选择子账户";
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell identify";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identify];
    
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = [accountListArray objectAtIndex:[indexPath row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    e_mAccount = [accountListArray objectAtIndex:[indexPath row]];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma ASIHTTPRequest

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [Tools log:[NSString stringWithFormat:@"获取子帐号响应:\n%@",request.responseString]];
    [mHud setHidden:YES];
    if ([request responseStatusCode] == 200)
    {
        FUserAccountListRes *respond = [FUserAccountListRes initWithXMLString:request.responseString];
        
        if ([respond isSuccess])
        {
            [accountListArray addObject:@"默认(全部)"];
            [accountListArray addObjectsFromArray:respond.accountList];
            [self.tableView reloadData];
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
    [Tools log:@"获取子帐号响应:请求失败"];
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
