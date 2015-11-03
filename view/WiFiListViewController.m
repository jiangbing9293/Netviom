//
//  WiFiListViewController.m
//  Supereye
//
//  Created by jiang bing on 15/6/18.
//  Copyright (c) 2015年 Netviom. All rights reserved.
//

#import "WiFiListViewController.h"
#import "Tools.h"
#import "MBProgressHUD.h"
#import "ApSetWiFiViewController.h"

@interface WiFiListViewController ()

@end

@implementation WiFiListViewController

@synthesize tableView = _tableView;

NSString *mSsid;
MBProgressHUD *mHud;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    wifiListArray = [[NSMutableArray alloc]init];
    mSsid = [[NSString alloc]init];
    [self initView];
    [self initData];
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithTitle:@"刷新" style:UIBarButtonItemStyleBordered target:self action:@selector(clickReflushtn)];
    self.navigationItem.rightBarButtonItem = rightBar;
    [rightBar release];
}

-( void)clickReflushtn{
    if ( ![mHud isHidden]){
        return;
    }
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
    [mHud setHidden:NO];
    dispatch_queue_t queue_wifi = dispatch_queue_create("load_wifi", NULL);
    dispatch_async(queue_wifi, ^{
        NSError *error;
        //加载一个NSURL对象
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.50.1/cgi/wlan?action=list"]];
        //将请求的url数据放到NSData对象中
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        if([dataDic mutableArrayValueForKey:@"ssid"] !=nil)
        {
            [wifiListArray removeAllObjects];
            [wifiListArray addObjectsFromArray: [dataDic mutableArrayValueForKey:@"ssid"]];
            if (wifiListArray)
            {
                [mHud setHidden:YES];
                [_tableView reloadData];
                self.title = @"请选择ssid";
            }
        }
        
    });
    dispatch_release(queue_wifi);
}
/**
 *@ 初始化UI
 **/
-(void) initView
{
    self.title = @"Wi-Fi列表";
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = leftBar;
    [leftBar release];
    
    self.view.backgroundColor = [Tools backgroundColor];
    CGFloat mWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat mHeight = [UIScreen mainScreen].bounds.size.height;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0f, 20.0f, mWidth, mHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView reloadData];
    mHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [mHud setLabelText:@"正在加载wifi列表..."];

}
- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [wifiListArray count];
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
    
    cell.textLabel.text = [wifiListArray objectAtIndex:[indexPath row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    mSsid = [wifiListArray objectAtIndex:[indexPath row]];
    ApSetWiFiViewController *apSetView = [[ApSetWiFiViewController alloc]init];
    [self.navigationController pushViewController:apSetView animated:YES];
    [apSetView release];
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
