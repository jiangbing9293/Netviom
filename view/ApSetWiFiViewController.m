//
//  ApSetWiFiViewController.m
//  Supereye
//
//  Created by jiang bing on 15/6/12.
//  Copyright (c) 2015年 Netviom. All rights reserved.
//

#import "ApSetWiFiViewController.h"
#import "f_define.h"
#import "iToast.h"
#import "FTools.h"

@implementation ApSetWiFiViewController

int SetStatus;
MBProgressHUD *mHud;
NSString *host;
GCDAsyncSocket *mSocket;

-(id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    SetStatus = -1;
    host = @"192.168.50.1";
    mSocket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    // Do any additional setup after loading the view from its nib.
    self.title = @"摄像头Wi-Fi配置";
    self.view.backgroundColor = [Tools backgroundColor];
    CGFloat mWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat mHeight = [UIScreen mainScreen].bounds.size.height;
    
    _apInfoTableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0f, 20.0f, mWidth, mHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:_apInfoTableView];
    [self initItems];
    [self initNavBar];
    
    _apInfoTableView.dataSource = self;
    _apInfoTableView.delegate = self;
    [_apInfoTableView reloadData];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [mSocket disconnect];
}
- (void)viewDidUnload
{
    _apInfoTableView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [_apInfoTableView release];
    [super dealloc];
}
/*********************
 *@ 发送设置Wi-Fi命令
 ***********************************/
-(void)sendSetWiFiCmd
{
    CellItem *ssid = [self.items objectAtIndex:DEVICE_SSID];
    CellItem *password = [self.items objectAtIndex:DEVICE_WIFI_PASSWORD];
    
    char *ssid_ = (char *)[ssid.subTitle cStringUsingEncoding:NSASCIIStringEncoding];
    char *password_ = (char *)[password.subTitle cStringUsingEncoding:NSASCIIStringEncoding];
    char *host_ = (char*)[host cStringUsingEncoding:NSASCIIStringEncoding];
    
    char param[1024*2] = {0};
    char cmd[512] = {0};
    sprintf(cmd,AP_SET_WIFI_CMD,ssid_,password_);
    int length = (int)(strlen(cmd));
    sprintf(param,AP_SETPARA_POST,host_,host_,length,cmd);

    NSError *error;
    if (![mSocket isConnected])
    {
        if(![mSocket connectToHost:host onPort:80 error:&error])
        {
            NSLog(@"%s,%@", __func__, error.description);
            SetStatus = CONNECT_FAIL;
        }
        else
        {
            NSLog(@"ok open port");
            SetStatus = SET_WIFI;
        }
    }
    [mSocket writeData:[[NSData alloc] initWithBytes:param length:strlen(param)] withTimeout:3000 tag:1];
    
    [mSocket readDataWithTimeout:3000 tag:1];
    [self setWifi];
}
/*********************
 *@ 发送设置DHCP命令
 ***********************************/
-(void)sendSetDHCPCmd
{
    CellItem *username = [self.items objectAtIndex:DEVICE_USERNAME];
    CellItem *password = [self.items objectAtIndex:DEVICE_PASSWORD];
    NSString *user_auth = [[NSString alloc] initWithFormat:@"%@:%@",username.subTitle,password.subTitle];
    
    const char *auth = [[FTools base64Encode:[user_auth dataUsingEncoding:NSUTF8StringEncoding]]UTF8String];
    char *host_ = (char*)[host cStringUsingEncoding:NSASCIIStringEncoding];
    
    char param[1024*2] = {0};
    int length = (int)(strlen(AP_DHCP_CMD));
    sprintf(param,AP_POST,host_,host_,length,auth,AP_DHCP_CMD);
    
    NSError *error;
    if (![mSocket isConnected])
    {
        if(![mSocket connectToHost:host onPort:80 error:&error])
        {
            NSLog(@"%s, %@", __func__, error.description);
            SetStatus = CONNECT_FAIL;
        }
        else
        {
            NSLog(@"ok open port");
            SetStatus = SET_DHCP_ENABLE;
        }
    }
    [mSocket writeData:[[NSData alloc] initWithBytes:param length:strlen(param)] withTimeout:3000 tag:2];
    [mSocket readDataWithTimeout:3000 tag:2];
    [self setWifi];
}
/*********************
 *@ 发送重启命令
 ***********************************/
-(void)sendSetRebootCmd
{
    CellItem *username = [self.items objectAtIndex:DEVICE_USERNAME];
    CellItem *password = [self.items objectAtIndex:DEVICE_PASSWORD];
    NSString *user_auth = [[NSString alloc] initWithFormat:@"%@:%@",username.subTitle,password.subTitle];
    const char *auth = [[FTools base64Encode:[user_auth dataUsingEncoding:NSUTF8StringEncoding]]UTF8String];
    char *host_ = (char*)[host cStringUsingEncoding:NSASCIIStringEncoding];
    
    char param[1024*2] = {0};
    int length = (int)(strlen(AP_REBOOT_CMD));
    sprintf(param,AP_POST,host_,host_,length,auth,AP_REBOOT_CMD);
    
    NSError *error;
    if (![mSocket isConnected])
    {
        if(![mSocket connectToHost:host onPort:80 error:&error])
        {
            NSLog(@"%s,%@", __func__, error.description);
            SetStatus = CONNECT_FAIL;
        }
        else
        {
            NSLog(@"ok open port");
            SetStatus = REBOOT;
        }
    }

    [mSocket writeData:[[NSData alloc] initWithBytes:param length:strlen(param)] withTimeout:3000 tag:3];
    [mSocket readDataWithTimeout:3000 tag:3];
    [self setWifi];
}

/*********************************
 * 状态机
 *****************************************/
-(void)setWifi
{
    switch (SetStatus)
    {
        case -1:
            if (mHud != nil) {
                [mHud hide:YES];
            }
            break;
            
        case CONNECT_DEVICE:
            if(mHud != nil)
            {
                [mHud setLabelText:@"正在连接设备..."];
            }
            break;
        case CONNECT_FAIL:
            if(mHud != nil)
            {
                [Tools showAlert:@"设备连接失败\n*摄像机WIFI配置需开启手机wifi功能，\n*请返回到手机主界面进入设置->WIFI设置，\n*选择名称为‘IPCAM_XXXX’形式的WIFI，\n*后输入密码88888888保存，待链接成功后，\n*再返回神眼客户端进行操作"];
                SetStatus = -1;
                [self setWifi];
            }
            break;
            
        case UNAUTHORIZED:
            if(mHud != nil)
            {
                [Tools showAlert:@"认证错误，开启DHCP失败。\n请输入正确的设备信息重新配置。"];
                SetStatus = -1;
                [self setWifi];
            }
            break;
            
        case SET_WIFI:
            if(mHud != nil)
            {
                [mHud setLabelText:@"正在配置Wi-Fi信息到设备..."];
            }
            break;
        case SET_DHCP_ENABLE:
            if(mHud != nil)
            {
                [mHud setLabelText:@"Wi-Fi配置成功，开启设备DHCP..."];
            }
            break;
        case REBOOT:
            if(mHud != nil)
            {
//                [mHud setLabelText:@"设置完成，正在重启设备..."];
                 [Tools showAlert:@"设置完成，设备正在重启"];
            }
            SetStatus = -1;
            [self goBack];
            break;
            
        default:
            break;
    }
}

-(void)showAlert:(NSString*)title_ tag:(NSInteger)tag_
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title_ message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = tag_;
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    CellItem *item = [self.items objectAtIndex:tag_];
    UITextField *textField = [alert textFieldAtIndex:0];
    textField.text = item.subTitle;
    
    [alert show];
    [alert release];
}

-(void)setDeviceUsername
{
   [self showAlert:@"请输入设备用户名" tag:DEVICE_USERNAME];
}

-(void)setDevicePassword
{
    [self showAlert:@"请输入设备密码" tag:DEVICE_PASSWORD];

}
-(void)setDeviceSsid
{
    [self showAlert:@"请输入设备WiFi ssid" tag:DEVICE_SSID];}

-(void)setDeviceWiFiPwd
{
    [self showAlert:@"请输入设备WiFi密码" tag:DEVICE_WIFI_PASSWORD];
}

- (void)initItems
{
    self.items = [NSMutableArray array];
    
    CellItem *usernameItem = [CellItem itemWithTitle:@"设备用户名" target:self action:@selector(setDeviceUsername)];
    usernameItem.subTitle = @"root";
    [self.items addObject:usernameItem];
    
    CellItem *passwordItem = [CellItem itemWithTitle:@"设备密码" target:self action:@selector(setDevicePassword)];
    passwordItem.subTitle = @"root";
    [self.items addObject:passwordItem];
    
    CellItem *ssidItem = [CellItem itemWithTitle:@"Wi-Fi ssid" target:self action:@selector(setDeviceSsid)];
    ssidItem.subTitle = mSsid;
    [self.items addObject:ssidItem];
    
    CellItem *wifipwdItem = [CellItem itemWithTitle:@"Wi-Fi密码" target:self action:@selector(setDeviceWiFiPwd)];
    [self.items addObject:wifipwdItem];
    
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickSaveBtn
{
    CellItem *username = [self.items objectAtIndex:DEVICE_USERNAME];
    if(username.subTitle == nil || [username.subTitle isEqualToString:@""])
    {
        [[iToast makeText:@"设备用户名不能为空"]show];
        return;
    }
    CellItem *pwd = [self.items objectAtIndex:DEVICE_PASSWORD];
    if(pwd.subTitle == nil || [pwd.subTitle isEqualToString:@""])
    {
        [[iToast makeText:@"设备密码不能为空"]show];
        return;
    }
    CellItem *ssid = [self.items objectAtIndex:DEVICE_SSID];
    if(ssid.subTitle == nil || [ssid.subTitle isEqualToString:@""])
    {
        [[iToast makeText:@"设备ssid不能为空"]show];
        return;
    }
    CellItem *wifi_pwd = [self.items objectAtIndex:DEVICE_WIFI_PASSWORD];
    if(wifi_pwd.subTitle == nil || [wifi_pwd.subTitle isEqualToString:@""])
    {
        [[iToast makeText:@"设备Wi-Fi密码不能为空"]show];
        return;
    }
    mHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self sendSetWiFiCmd];
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
        [_apInfoTableView reloadData];
    }
}

#pragma mark - CGDAsyncSocket
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"%s,连接到:%@",__func__,host);
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"%s,断开连接:%@, error:%@",__func__,sock.connectedHost,err);
    if (err.code == 60)
    {
        SetStatus = CONNECT_FAIL;
        [self setWifi];
    }
}

-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%s:tag:%d:%@", __func__, (int)tag , [[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    NSRange range = [str rangeOfString:@"404"];
    if (range.length > 0) {
        SetStatus = CONNECT_FAIL;
        [self setWifi];
        return;
    }
    
    if(1 < tag)
    {
        NSRange range = [str rangeOfString:@"Unauthorized"];
        if (range.length > 0) {
            SetStatus = UNAUTHORIZED;
            [self setWifi];
            return;
        }
    }
    
    if (SetStatus == SET_WIFI)
    {
        sleep(1);
        [self sendSetDHCPCmd];
        return;
    }
    else if(SetStatus == SET_DHCP_ENABLE)
    {
        sleep(1);
        [self sendSetRebootCmd];
        return;
    }
}
@end
