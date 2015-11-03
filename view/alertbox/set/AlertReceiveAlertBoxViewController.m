//
//  AlertReceiveAlertBoxViewController.m
//  Supereye
//
//  Created by jiang bing on 15/10/12.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import "AlertReceiveAlertBoxViewController.h"
#import "Tools.h"
#import "MBProgressHUD.h"
#import "ASISEHttpRequest.h"
#import "SEBaseResponse.h"
#import "MyUtil.h"
#import "GetBindEmailResponse.h"
#import "GetBindMobileResponse.h"
#import "FAlertBoxResponseCfgReq.h"
#import "SEBindReq.h"

static NSString *kHttpUserinfoKey = @"Userinfo";

@interface AlertReceiveAlertBoxViewController ()

@end

@implementation AlertReceiveAlertBoxViewController

@synthesize tableView = _tableView;
@synthesize itemsEmail = _itemsEmail;
@synthesize itemsPhone = _itemsPhone;
@synthesize itemsRspType = _itemsRspType;
@synthesize alertSet = _alertSet;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"报警接收设置";
    
    _itemsPhone = [[NSMutableArray alloc]init];
    _itemsEmail = [[ NSMutableArray alloc]init];
    _itemsRspType = [[ NSMutableArray alloc] init];
    
    self.view.backgroundColor = [Tools backgroundColor];
    CGFloat mWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat mHeight = [UIScreen mainScreen].bounds.size.height;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0f, 20.0f, mWidth, mHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    [self initItems];
    [self initNavBar];
    
    [self loadNumbers];
    
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
    [_itemsRspType addObject:[[ NSString alloc] initWithString:@"短信"]];
    [_itemsRspType addObject:[[ NSString alloc] initWithString:@"邮件"]];
    [_itemsRspType addObject:[[ NSString alloc] initWithString:@"微信"]];
    [_itemsRspType addObject:[[ NSString alloc] initWithString:@"推送"]];
//    [_itemsRspType addObject:[[ NSString alloc] initWithString:@"联通IPCAM"]];
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
    [self syncSetToServer];
}
/**
 *  返回按钮
 ***/
- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
- ( void) syncSetToServer{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setLabelText:@"正在配置中..."];
    
    
    ASISEClient *asiseClient = [ASISEClient requestWithUrlString:[Tools mobileUrl]];
    
    asiseClient.delegate = self;
    
    FAlertBoxResponseCfgReq *req = [FAlertBoxResponseCfgReq requestWithAuth:[Tools currentAuth]];
    req.alertSet = _alertSet;
    asiseClient.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:req, kHttpUserinfoKey, nil];
    
    [asiseClient doPostString:[req getXML] timeout:HTTP_TIME_OUT];
}
/**
 * 获取手机号
 **/
- (void)loadNumbers
{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setLabelText:@"正在加载数据..."];
    
    
    ASISEClient *asiseClient = [ASISEClient requestWithUrlString:[Tools mobileUrl]];
    
    asiseClient.delegate = self;
    
    SEGetBindMobileReq *req = [SEGetBindMobileReq requestWithAuth:[Tools currentAuth]];
    
    asiseClient.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:req, kHttpUserinfoKey, nil];
    
    [asiseClient doPostString:[req getXML] timeout:HTTP_TIME_OUT];
    
    
}

- (void)loadEmails
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setLabelText:@"正在加载数据..."];
    
    ASISEClient *asiseClient = [ASISEClient requestWithUrlString:[Tools mobileUrl]];
    
    asiseClient.delegate = self;
    
    SEGetBindEmailReq *req = [SEGetBindEmailReq requestWithAuth:[Tools currentAuth]];
    
    asiseClient.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:req, kHttpUserinfoKey, nil];
    
    [asiseClient doPostString:[req getXML] timeout:HTTP_TIME_OUT];
}

#pragma mark - UITableView
-( NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [_itemsPhone count];
    }
    if ( section == 2){
        return [_itemsRspType count];
    }
    return [_itemsEmail count];
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
    if ([ indexPath section] == 0 ) {
        BindMobile *value = [_itemsPhone objectAtIndex:[indexPath row]];
        cell.textLabel.text = value.mobile;
        if ([@"" isEqualToString:value.mobile]){
            cell.textLabel.text = [[ NSString alloc] initWithString:@"不绑定"];
        }
        if ([value.mobile isEqualToString:_alertSet.mobile]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    
    if ([ indexPath section] == 1 ) {
        BindEmail *value = [_itemsEmail objectAtIndex:[indexPath row]];
        cell.textLabel.text = value.email;
        if ([@"" isEqualToString:value.email]){
            cell.textLabel.text = [[ NSString alloc] initWithString:@"不绑定"];
        }
        if ([value.email isEqualToString:_alertSet.email]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    if ([ indexPath section] == 2 ) {
        NSString *value = [_itemsRspType objectAtIndex:[indexPath row]];
        cell.textLabel.text = value;
        if ([[_alertSet.rspType substringWithRange:NSMakeRange([ indexPath row], 1)] isEqualToString:@"1"]){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    
    return cell;
}
- ( CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30.0f;
}
- ( UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    UIView *headerView = [[ UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, 30.0f)];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, (width - 160.0f), 30.0f)];
    
    lable.font = [ UIFont boldSystemFontOfSize:17.0f];
    [headerView addSubview:lable];
    switch (section) {
        case 0:
            lable.text = [[ NSString alloc] initWithString: @"报警接收手机号"];
            break;
            
        case 1:
            lable.text = [[ NSString alloc] initWithString: @"报警接收邮箱"];
            break;
        case 2:
            lable.text = [[ NSString alloc] initWithString: @"报警响应类型"];
            break;
    }
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 0) {
        BindMobile *phone = [_itemsPhone objectAtIndex:[ indexPath row]];
        _alertSet.mobile = phone.mobile;
    }
    if ([ indexPath section] == 1) {
        BindEmail *email = [ _itemsEmail objectAtIndex:[ indexPath row]];
        _alertSet.email = email.email;
    }
    if ( [ indexPath section] == 2){
        if ( [[_alertSet.rspType substringWithRange:NSMakeRange([ indexPath row], 1)] isEqualToString:@"1"]){
           _alertSet.rspType = [_alertSet.rspType stringByReplacingCharactersInRange:NSMakeRange([ indexPath row], 1) withString:@"0"];
        }else{
           _alertSet.rspType = [_alertSet.rspType stringByReplacingCharactersInRange:NSMakeRange([ indexPath row], 1) withString:@"1"];
        }
    }
    [_tableView reloadData];
}

#pragma mark - http
- (void)requestFinished:(ASIHTTPRequest *)request
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    MyLog(@"response:\n%@",[request responseString]);
    
    id userinfo = [request.userInfo objectForKey:kHttpUserinfoKey];
    
    if ([userinfo isKindOfClass:[SEGetBindMobileReq class]]) {
        
        GetBindMobileResponse *response = [GetBindMobileResponse initWithXMLString:[request responseString]];
        
        if ([response isSuccess]) {
            [_itemsPhone removeAllObjects];
            [_itemsPhone addObjectsFromArray: response.mobiles];
            
            BindMobile *tphone = [[ BindMobile alloc] init];
            tphone.mobile = @"";
            [_itemsPhone addObject:tphone];
            [tphone release];
            
            BOOL has = NO;
            for (BindMobile *mobile in _itemsPhone) {
                if( [mobile.mobile isEqualToString:_alertSet.mobile]){
                    has = YES;
                    break;
                }
            }
            if ( !has){
                if ( _alertSet && ![_alertSet.mobile isEqualToString:@""]){
                    BindMobile *phone = [[ BindMobile alloc] init];
                    phone.mobile = _alertSet.mobile;
                    [_itemsPhone addObject:phone];
                    [phone release];
                }
            }
        }
        else
        {
             [Tools showToast:@"获取绑手机号码失败" inView:self.view];
        }
        
        [self loadEmails];
    }
    else if ([userinfo isKindOfClass:[SEGetBindEmailReq class]])
    {
        GetBindEmailResponse *response = [GetBindEmailResponse initWithXMLString:[request responseString]];
        
        if ([response isSuccess]) {
            [_itemsEmail addObjectsFromArray: response.emails];
            
            BindEmail *temail = [[ BindEmail alloc] init];
            temail.email = @"";
            [_itemsEmail addObject:temail];
            [temail release];
            
            BOOL has = NO;
            for (BindEmail *email in _itemsEmail) {
                if( [email.email isEqualToString:_alertSet.email]){
                    has = YES;
                    break;
                }
            }
            if ( !has){
                if( _alertSet.email && ![_alertSet.email isEqualToString:@""]){
                    BindEmail *email = [[ BindEmail alloc] init];
                    email.email = _alertSet.email;
                    [_itemsEmail addObject:email];
                    [email release];
                }
            }
        }
        else
        {
            [Tools showToast:@"获取Email失败" inView:self.view];
        }
        [_tableView reloadData];
    }
    else if([userinfo isKindOfClass:[FAlertBoxResponseCfgReq class]]){
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
    MyLog(@"response:\n%@",[request responseString]);
    
    [Tools showToast:@"请求失败" inView:self.view];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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
