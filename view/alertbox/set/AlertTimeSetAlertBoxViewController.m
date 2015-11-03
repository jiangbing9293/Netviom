//
//  AlertTimeSetAlertBoxViewController.m
//  Supereye
//
//  Created by jiang bing on 15/10/11.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import "AlertTimeSetAlertBoxViewController.h"
#import "Tools.h"
#import "SWYearTimeChoose.h"
#import "MBProgressHUD.h"
#import "SEBaseResponse.h"
#import "ASISEHttpRequest.h"
#import "FAlertBoxResponseCfgReq.h"

@interface AlertTimeSetAlertBoxViewController () < SWYTCDelegate>

@end

@implementation AlertTimeSetAlertBoxViewController

@synthesize tableView = _tableView;
@synthesize itemsTime = _itemsTime;
@synthesize itemsWeek = _itemsWeek;
@synthesize alertSet = _alertSet;

NSString *str_time1;
NSString *str_time2;
NSString *str_time3;
int select_index;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [[ NSString alloc] initWithString: @"报警时间设置"];
    
    self.view.backgroundColor = [Tools backgroundColor];
    CGFloat mWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat mHeight = [UIScreen mainScreen].bounds.size.height;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0f, 20.0f, mWidth, mHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    [self parseTimer];
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
    _itemsWeek = [[NSMutableArray alloc]init];
    _itemsTime = [[ NSMutableArray alloc]init];
    
    [_itemsWeek addObject:[[ NSString alloc] initWithString:@"星期一"]];
    [_itemsWeek addObject:[[ NSString alloc] initWithString:@"星期二"]];
    [_itemsWeek addObject:[[ NSString alloc] initWithString:@"星期三"]];
    [_itemsWeek addObject:[[ NSString alloc] initWithString:@"星期四"]];
    [_itemsWeek addObject:[[ NSString alloc] initWithString:@"星期五"]];
    [_itemsWeek addObject:[[ NSString alloc] initWithString:@"星期六"]];
    [_itemsWeek addObject:[[ NSString alloc] initWithString:@"星期日"]];
    
    [_itemsTime addObject:[[ NSString alloc] initWithString:@"时间段一："]];
    [_itemsTime addObject:[[ NSString alloc] initWithString:@"时间段二："]];
    [_itemsTime addObject:[[ NSString alloc] initWithString:@"时间段三："]];
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
    [self makeTimer];
    [self syncSetToServer];
}
/**
 *  返回按钮
 ***/
- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
/****
 * 全选按钮
 ****/
- ( IBAction)selectedALL:(id)sender{
    _alertSet.weekValue = [[NSString alloc] initWithString: @"1111111"];
    _alertSet.timeCfg = [[ NSString alloc] initWithString: @"111"];
    [_tableView reloadData];
}
/**
 *  switch 开关
 **/
- ( IBAction)switchChangeValue:(id)sender {
    if ( [_alertSet.isWeek isEqualToString:@"1"]) {
        _alertSet.isWeek = @"0";
    }else{
        _alertSet.isWeek = @"1";
    }
    [_tableView reloadData];
}
/***
 *  解析时间段
 ***/
-( void)parseTimer{
    NSArray *array = [_alertSet.timeValue componentsSeparatedByString:@";"];
    str_time1 = [[NSString alloc] initWithString:[ array objectAtIndex:0]];
    str_time2 = [[NSString alloc] initWithString:[ array objectAtIndex:1]];
    str_time3 = [[NSString alloc] initWithString:[ array objectAtIndex:2]];
}
/***
 * 打包时间段
 **/
- ( void)makeTimer{
    _alertSet.timeValue = [[NSString alloc] initWithFormat:@"%@;%@;%@",str_time1,str_time2,str_time3];
}

- ( void) syncSetToServer{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setLabelText:@"正在配置中..."];
    
    
    ASISEClient *asiseClient = [ASISEClient requestWithUrlString:[Tools mobileUrl]];
    
    asiseClient.delegate = self;
    
    FAlertBoxResponseCfgReq *req = [FAlertBoxResponseCfgReq requestWithAuth:[Tools currentAuth]];
    req.alertSet = _alertSet;
    
    [asiseClient doPostString:[req getXML] timeout:HTTP_TIME_OUT];
}
#pragma mark - UITableView
-( NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [_itemsWeek count];
    }
    return [_itemsTime count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell identify";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if ([ indexPath section] == 0 ) {
        
        cell.accessoryType = UITableViewCellAccessoryNone;

        NSString *value = [_itemsWeek objectAtIndex:[indexPath row]];
        cell.textLabel.text = value;
        if ( [[_alertSet.weekValue substringWithRange:NSMakeRange([ indexPath row], 1)] isEqualToString:@"1"]){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    
    if ([ indexPath section] == 1 ) {
        
        cell.accessoryType = UITableViewCellAccessoryDetailButton;

        NSString *value = [_itemsTime objectAtIndex:[indexPath row]];
        cell.textLabel.text = value;
        switch ([ indexPath row]) {
            case 0:
                cell.detailTextLabel.text = str_time1;
                break;
                
            case 1:
                cell.detailTextLabel.text = str_time2;
                break;
                
            case 2:
                cell.detailTextLabel.text = str_time3;
                break;
        }
       
        if ( [[_alertSet.timeCfg substringWithRange:NSMakeRange([ indexPath row], 1)] isEqualToString:@"1"]){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    
    return cell;
}
- ( CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50.0f;
}
- ( UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if ( section == 0){
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        UIView *headerView = [[ UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, 50.0f)];
        UILabel *lableType = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 10.0f, (width - 160.0f), 30.0f)];
        
        UISwitch *swt = [[ UISwitch alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lableType.frame) , 10.0f, 50.0f, 30.0f)];
        [swt addTarget:self action:@selector(switchChangeValue:) forControlEvents:UIControlEventValueChanged];
        UIButton *btn = [[ UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(swt.frame)+ 30.0 , 10.0f, 50.0f, 30.0f)];
        [btn setTitle:@"全选" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(selectedALL:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[ UIColor blueColor] forState:UIControlStateNormal];
        lableType.font = [ UIFont boldSystemFontOfSize:17.0f];
        if ( [_alertSet.isWeek isEqualToString:@"1"]){
            [swt setOn:YES];
        }
        [headerView addSubview:lableType];
        [headerView addSubview:swt];
        [headerView addSubview:btn];
        lableType.text = [[NSString alloc] initWithString: @"按星期报警"];
        return headerView;
    }
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    UIView *headerView = [[ UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, 50.0f)];
    UILabel *lableType = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 10.0f, (width - 100.0f), 30.0f)];
    
    UISwitch *swt = [[ UISwitch alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lableType.frame) , 10.0f, 50.0f, 30.0f)];
    [swt addTarget:self action:@selector(switchChangeValue:) forControlEvents:UIControlEventValueChanged];
    lableType.font = [ UIFont boldSystemFontOfSize:17.0f];
    if ( [_alertSet.isWeek isEqualToString:@"0"]){
        [swt setOn:YES];
    }
    [headerView addSubview:lableType];
    [headerView addSubview:swt];
    lableType.text = [[ NSString alloc] initWithString:@"按天报警"];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([ indexPath section] == 0) {
        if ( [[ _alertSet.weekValue substringWithRange:NSMakeRange([ indexPath row], 1)] isEqualToString:@"1"]){
            _alertSet.weekValue = [ _alertSet.weekValue stringByReplacingCharactersInRange:NSMakeRange([ indexPath row], 1) withString:@"0"];
        }else{
            _alertSet.weekValue = [ _alertSet.weekValue stringByReplacingCharactersInRange:NSMakeRange([ indexPath row], 1) withString:@"1"];
        }
    }
    if ([ indexPath section] == 1) {
        if ( [[ _alertSet.timeCfg substringWithRange:NSMakeRange([ indexPath row], 1)] isEqualToString:@"1"]){
            _alertSet.timeCfg = [ _alertSet.timeCfg stringByReplacingCharactersInRange:NSMakeRange([ indexPath row], 1) withString:@"0"];
        }else{
            _alertSet.timeCfg = [ _alertSet.timeCfg stringByReplacingCharactersInRange:NSMakeRange([ indexPath row], 1) withString:@"1"];
        }
    }
    [_tableView reloadData];
}
- ( void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    if ( [indexPath section] == 1){
        select_index = (int)[ indexPath row];
        //SWYearTimeChoose1ZZ
        CGRect bounds = [[UIScreen mainScreen] bounds];
        NSArray* yearArr = [[NSBundle mainBundle] loadNibNamed:@"SWYearTimeChoose" owner:nil options:nil];
        SWYearTimeChoose *timeChooseV = (SWYearTimeChoose*)[yearArr objectAtIndex:0];
        timeChooseV.delegate = self;
        [timeChooseV setFrame:CGRectMake(0, 0, bounds.size.width, bounds.size.height)];
        [self.view addSubview:timeChooseV];

    }
}

#pragma SWYTCDelegate

-( void)hourAndMunite:( NSString*)value{
    switch (select_index) {
        case 0:
            str_time1 = [[ NSString alloc] initWithString:value];
            break;
            
        case 1:
            str_time2 = [[ NSString alloc] initWithString:value];
            break;
        case 2:
            str_time3 = [[ NSString alloc] initWithString:value];
            break;
    }
    [_tableView reloadData];
}
#pragma mark - http
- (void)requestFinished:(ASIHTTPRequest *)request
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSLog(@"response:%s:%@",__func__,[request responseString]);
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
- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"response:%s:%@",__func__,[request responseString]);
    
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
