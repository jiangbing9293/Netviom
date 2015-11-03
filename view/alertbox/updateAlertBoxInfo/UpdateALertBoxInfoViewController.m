//
//  UpdateALertBoxInfoViewController.m
//  Supereye
//
//  Created by jiang bing on 15/10/10.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import "UpdateALertBoxInfoViewController.h"
#import "Tools.h"
#import "CellItem.h"
#import "MBProgressHUD.h"
#import "FAlertBoxInfoUpdateReq.h"
#import "ASISEHttpRequest.h"
#import "AppData.h"
#import "SEBaseResponse.h"
#import "iToast.h"

@interface UpdateALertBoxInfoViewController ()

@end

@implementation UpdateALertBoxInfoViewController

@synthesize tableView = _tableView;
@synthesize items = _items;
@synthesize alertBox = _alertBox;

MBProgressHUD *mHud;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"报警盒信息";
    
    mHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [mHud setLabelText:@"正在更新数据..."];
    
    self.view.backgroundColor = [Tools backgroundColor];
    CGFloat mWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat mHeight = [UIScreen mainScreen].bounds.size.height;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0f, 40.0f, mWidth, mHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    [self initItems];
    [self initNavBar];
    
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
    self.items = [NSMutableArray array];
    
    CellItem *nameItem = [CellItem itemWithTitle:@"报警盒名称" target:self action:@selector(setName)];
    nameItem.subTitle = [[_alertBox boxName] isEqualToString:@""]?[ _alertBox boxID]:[ _alertBox boxName];
    [self.items addObject:nameItem];
    
    CellItem *orderItem = [CellItem itemWithTitle:@"报警盒排序" target:self action:@selector(setOrder)];
    orderItem.subTitle = [_alertBox orderOn];
    [self.items addObject:orderItem];
    
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

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickSaveBtn
{
    CellItem *name = [self.items objectAtIndex:0];
    if(name.subTitle)
    {
    
    }
    CellItem *order = [self.items objectAtIndex:1];
    if(order.subTitle && ![self isPureInt:order.subTitle])
    {
        order.subTitle = @"0";
    }
    [mHud setHidden:NO];
    FAlertBoxInfoUpdateReq *req = [FAlertBoxInfoUpdateReq requestWithAuth:[Tools currentAuth]];
    ASISEClient *asiseClient = [ASISEClient requestWithUrlString:[AppData getInstance].platform.mobile_url];
    req.boxID = [_alertBox boxID];
    req.boxName = name.subTitle;
    req.order = order.subTitle;
    asiseClient.delegate = self;
    [asiseClient doPostString:[req getXML] timeout:HTTP_TIME_OUT];
}
//判断是否为整形：

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}
- ( void) setName{
    [self showAlert:@"请输入报警盒名称" tag:0];
}
- ( void) setOrder{
    [self showAlert:@"请输入报警盒排序" tag:1];
}
-(void)showAlert:(NSString*)title_ tag:(NSInteger)tag_
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title_ message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = tag_;
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    CellItem *item = [self.items objectAtIndex:tag_];
    UITextField *textField = [alert textFieldAtIndex:0];
    textField.text = item.subTitle;
    if ( tag_ == 1){
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    [alert show];
    [alert release];
}

#pragma ASIHTTPRequest
- (void)requestFinished:(ASIHTTPRequest *)request
{
    [Tools log:[NSString stringWithFormat:@"更新报警盒信息响应:\n%@",request.responseString]];
    [mHud setHidden:YES];
    if ([request responseStatusCode] == 200){
        SEBaseResponse *resp = [ SEBaseResponse initWithXMLString:[ request responseString]];
        if (resp.funcStatus == 200 ) {
            [Tools showAlert:@"配置成功"];
        }else{
            [Tools showAlert:[ resp info]];
        }
        [self goBack];

    }
    else
    {
        [Tools showAlert:@"请求失败"];
    }
    
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    [Tools log:@"更新报警盒信息响应:请求失败"];
    [mHud setHidden:YES];
    [Tools showAlert:@"请求失败"];
}

#pragma mark - UITableView
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
    CellItem *item = [self.items objectAtIndex:[indexPath row]];
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.subTitle;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellItem *item = [self.items objectAtIndex:[indexPath row]];
    if (item.sel && [item.target respondsToSelector:item.sel]) {
        [item.target performSelector:item.sel];
    }
    
}
#pragma mark - UIAlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(1 == buttonIndex)
    {
        UITextField *textField = [alertView textFieldAtIndex:0];
        NSString *str = textField.text;
        CellItem *item = [self.items objectAtIndex:alertView.tag];
        item.subTitle = str;
        [_tableView reloadData];
    }
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
