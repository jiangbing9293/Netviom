//
//  FAlertBoxAlertInfoViewController.m
//  Supereye
//
//  Created by jiang bing on 15/10/19.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import "FAlertBoxAlertInfoViewController.h"
#import "FAlertBoxAlarmInfoReq.h"
#import "MBProgressHUD.h"
#import "ASISEHttpRequest.h"
#import "AppData.h"
#import "Tools.h"
#import "LogCell.h"
#import "FAlertBoxAlertInfo.h"
#import "FAlertBoxAlarmInfoRes.h"
#import "FAlertBoxListReq.h"
#import "FAlertBoxListRes.h"
#import "FAlertBox.h"
#import "FAlertBoxAlertDetailViewController.h"

@interface FAlertBoxAlertInfoViewController ()

@end

@implementation FAlertBoxAlertInfoViewController

static NSString *kHttpUserinfoKey = @"Userinfo";
MBProgressHUD *hud;
NSMutableArray *eAlertBoxArray;
NSMutableArray *_events;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [Tools backgroundColor];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initFlags];
     hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setHidden:YES];
    [self addRefreshView];
    _events = [[NSMutableArray alloc] init];
    eAlertBoxArray = [[ NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
    [self syncAlertBoxFromServer];
}
- (void)addRefreshView
{
    if (_refreshHeaderView == nil) {
        
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
        view.delegate = self;
        [self.tableView addSubview:view];
        _refreshHeaderView = view;
        [view release];
        
    }
    
    //  update the last update date
    [_refreshHeaderView refreshLastUpdatedDate];
}
/***
 * 根据报警盒id获取报警名称
 ***/
- ( NSString *)getDeviceNameByID:(NSString *)boxID{
    
    for (FAlertBox *box in eAlertBoxArray) {
        if ( [box.boxID isEqualToString:boxID]){
            return [[ NSString alloc]initWithString:[ box boxName]];
        }
    }
    return boxID;
}
- (void)initFlags
{
    _reloading = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- ( void)syncDataFromServer:(NSString *)boxID :( NSString *) startDate :(NSString *)endDate :( NSString *)pageNo :( NSString *) pageSize{
    if ( hud){
        [hud setLabelText:@"正在获取数据..."];
        [hud setHidden:NO];
    }
    FAlertBoxAlarmInfoReq *req = [FAlertBoxAlarmInfoReq requestWithAuth:[Tools currentAuth]];
    ASISEClient *asiseClient = [ASISEClient requestWithUrlString:[AppData getInstance].platform.mobile_url];
    req.boxID = boxID;
    req.pageNo = pageNo;
    req.pageSize = pageSize;
    req.startDate = startDate;
    req.endDate = endDate;
    asiseClient.delegate = self;
    asiseClient.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:req, kHttpUserinfoKey, nil];
    [asiseClient doPostString:[req getXML] timeout:HTTP_TIME_OUT];
   
}
/***
 * 同步报警盒信息
 ***/
- ( void)syncAlertBoxFromServer{
    FAlertBoxListReq *boxListReq = [FAlertBoxListReq requestWithAuth:[Tools currentAuth]];
    ASISEClient *asiseClient = [ASISEClient requestWithUrlString:[AppData getInstance].platform.mobile_url];
    asiseClient.delegate = self;
    asiseClient.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:boxListReq, kHttpUserinfoKey, nil];
    [asiseClient doPostString:[boxListReq getXML] timeout:HTTP_TIME_OUT];
}
#pragma ASIHTTPRequest
- (void)requestFinished:(ASIHTTPRequest *)request
{
    [Tools log:[NSString stringWithFormat:@"%s:\n%@", __FUNCTION__,request.responseString]];
   
    id userinfo = [request.userInfo objectForKey:kHttpUserinfoKey];
    if ([userinfo isKindOfClass:[FAlertBoxAlarmInfoReq class]]){
        if (hud) {
            [hud setHidden:YES];
        }
        if ( [request responseStatusCode] == 200){
            FAlertBoxAlarmInfoRes *resp = [ FAlertBoxAlarmInfoRes initWithXMLString:request.responseString];
            if ( [resp isSuccess]){
                [_events removeAllObjects];
                [_events addObjectsFromArray:resp.alertInfoArray];
            }
            [self doneLoadingTableViewData];
        }else{
            [Tools showAlert:@"请求失败"];
        }
    }else if( [userinfo isKindOfClass:[FAlertBoxListReq class]]){
        if ([request responseStatusCode] == 200)
        {
            FAlertBoxListRes *respond = [FAlertBoxListRes initWithXMLString:request.responseString];
            
            if ([respond isSuccess])
            {
                [eAlertBoxArray removeAllObjects];
                [eAlertBoxArray addObjectsFromArray:respond.deviceArray];
                [self.tableView reloadData];
            }
            else
            {
                [Tools showAlert:[respond errorDesc]];
            }
        }
    }
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [Tools log:[NSString stringWithFormat:@"%s:请求失败\n", __FUNCTION__]];
    if (hud) {
        [hud setHidden:YES];
    }
    [Tools showAlert:@"请求失败"];
}

#pragma mark - Table view data source
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([_events count] == 0) {
        return @"没有任何记录";
    }
    return [NSString stringWithFormat:@"共%d条记录",(int)[_events count]];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LogCell *cell = (LogCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return [cell height];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_events count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    
    //  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    //    if (cell == nil) {
    //        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    //    }
    
    LogCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LogCell" owner:self options:nil] lastObject];
    }
    // Configure the cell...
    
    
    FAlertBoxAlertInfo *event = (FAlertBoxAlertInfo *)[_events objectAtIndex:[indexPath row]];
    
    //    cell.textLabel.text = event.operaDesc;
    event.boxName = [self getDeviceNameByID:event.boxID];
    cell.clientLabel.text = event.boxName?event.boxName:event.boxID;
    cell.dateLabel.text = event.alertTime;
    cell.contentLabel.text = event.alertContent;
    return cell;
}
- ( void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%s,%d",__func__, (int)[ indexPath row]);
    FAlertBoxAlertDetailViewController *viewController = [[ FAlertBoxAlertDetailViewController alloc]init];
    viewController.mCurrent = [ indexPath row];
    viewController.alertInfo  = (FAlertBoxAlertInfo *)[ _events objectAtIndex:[ indexPath row]];
    [_rootViewController.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}
- (void)doneLoadingTableViewData{
    
    //  model should call this when its done loading
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    [self.tableView reloadData];
    
}
#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    
    //	[self reloadTableViewDataSource];
    //	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
    
//    [self reloadEvents];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *startDate = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:-7*24*60*60]] ;
    NSString *endDate = [formatter stringFromDate:[NSDate date]];
    [self syncDataFromServer:@"" :startDate :endDate :@"1" :@"100"];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)vie{
    return _reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    return [NSDate date]; // should return date data source was last changed
    
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
