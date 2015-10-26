//
//  FAlertBoxAlertDetailViewController.m
//  Supereye
//
//  Created by jiang bing on 15/10/19.
//  Copyright © 2015年 Netviom. All rights reserved.
//

#import "FAlertBoxAlertDetailViewController.h"

@interface FAlertBoxAlertDetailViewController ()
{
    CGFloat mHeight;
    CGFloat mWidth;
}
@end

@implementation FAlertBoxAlertDetailViewController

@synthesize alertInfo = _alertInfo;
@synthesize labDevName = _labDevName;
@synthesize labDevId = _labDevId;
@synthesize labAlertType = _labAlertType;
@synthesize labRespType = _labRespType;
@synthesize labAlertTime = _labAlertTime;
@synthesize labHasPic = _labHasPic;
@synthesize fileView = _fileView;
@synthesize scrollView = _scrollView;
@synthesize mCurrent = _mCurrent;

/**
 *  初始化UI
 */
-(void)initView
{
    _labDevName = [[UILabel alloc]init];
    _labDevId = [[UILabel alloc]init];
    _labAlertType = [[UILabel alloc]init];
    _labRespType = [[UILabel alloc]init];
    _labAlertTime = [[UILabel alloc]init];
    _labHasPic = [[UILabel alloc]init];
    _fileView = [[UIView alloc]init];
    _scrollView = [[UIScrollView alloc]init];
    
    [_scrollView addSubview:_labDevName];
    [_scrollView addSubview:_labDevId];
    [_scrollView addSubview:_labAlertType];
    [_scrollView addSubview:_labRespType];
    [_scrollView addSubview:_labAlertTime];
    [_scrollView addSubview:_labHasPic];
    [_scrollView addSubview:_fileView];
    [self.view addSubview:_scrollView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self initNavBar];
}
/**
 *  配置控件位置
 */
-(void)changePosition
{
    CGFloat lableHeight = 50.0f;
    [_labDevName setFrame:CGRectMake(0.0f, 0.0f, mWidth, lableHeight)];
    [_labDevId setFrame:CGRectMake(0.0f,CGRectGetMaxY(_labDevName.frame), mWidth, lableHeight)];
    [_labAlertType setFrame:CGRectMake(0.0f, CGRectGetMaxY(_labDevId.frame), mWidth, lableHeight)];
    [_labRespType setFrame:CGRectMake(0.0f, CGRectGetMaxY(_labAlertType.frame), mWidth, lableHeight)];
    [_labAlertTime setFrame:CGRectMake(0.0f, CGRectGetMaxY(_labRespType.frame), mWidth, lableHeight)];
    [_fileView setFrame:CGRectMake(0.0f, CGRectGetMaxY(_labAlertTime.frame), mWidth, (4*(mWidth*3/4)))];
    [_scrollView setFrame:CGRectMake(0.0f, 50.0f, mWidth, mHeight)];
    [_scrollView setContentSize:CGSizeMake(mWidth, (CGRectGetMaxY(_fileView.frame)+lableHeight))];
}
/**
 *  获取数据
 */
-(void)getData
{
    if(_mCurrent >= 0 && _mCurrent < [_events count])
    {
        _alertInfo = [_events objectAtIndex:_mCurrent];
        [self setData];
    }
    else
    {
        NSLog(@"%s:数据出错",__func__);
    }
}
- ( NSString *)getType:(NSString *)sensorID{
    if ( [@"300" isEqualToString:sensorID]){
        return @"紧急按钮报警";
    }
    if ( [@"100" isEqualToString:sensorID]){
        return @"外接报警";
    }
    return @"人体感应报警";
}
/**
 *  配置数据
 */
-(void)setData
{
    _labDevName.text = [NSString stringWithFormat:@"报警盒名称：%@",_alertInfo.boxName?_alertInfo.boxName:_alertInfo.boxID];
    _labDevId.text = [NSString stringWithFormat:@"报警盒ID：%@",_alertInfo.boxID];
    _labAlertType.text = [NSString stringWithFormat:@"报警类型：%@",[self getType:_alertInfo.sensorID]];
    _labRespType.text = [NSString stringWithFormat:@"报警内容：%@",_alertInfo.alertContent];
    _labAlertTime.text = [NSString stringWithFormat:@"报警时间：%@",_alertInfo.alertTime];
    
    for(UIView *view in [_fileView subviews])
    {
        [view removeFromSuperview];
    }
    if (_alertInfo.filePath) {
         NSArray *imageArray = [_alertInfo.filePath componentsSeparatedByString:@";"];
         NSString *pre = @"";
        if ( imageArray){
            for (int i = 0; i < [imageArray count]; ++i) {
                NSString *filepath = [imageArray objectAtIndex:i];
                if (i == 0) {
                    NSRange index = [filepath rangeOfString:@"/a"];
                    pre = [filepath substringToIndex:(index.location+index.length)];
                }
                if (i > 0) {
                    filepath = [@"" stringByAppendingFormat:@"%@%@",pre,filepath];
                }
                [_fileView setFrame:CGRectMake(0.0f, CGRectGetMaxY(_labAlertTime.frame)+5, mWidth, ((i+1)*(mWidth*3/4)))];
                [_scrollView setContentSize:CGSizeMake(mWidth, (CGRectGetMaxY(_fileView.frame)+200.0f))];
                
                dispatch_queue_t loadImage = dispatch_queue_create("loadImage", nil);
                dispatch_async(loadImage, ^(void){
                    NSLog(@"%s,filepath:%@\n", __func__, filepath);
                    NSURL *url = [[NSURL alloc]initWithString:filepath];
                    UIImage *image = [[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:url]];
                    if (image)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(5.0f, (i*mWidth*3/4+20.0f), (mWidth-10.0f), (mWidth*3/4))];
                            [imgView setImage:image];
                            [_fileView addSubview:imgView];
                            [imgView release];
                        });
                    }
                });
            }
        }
    }
}


/**
 *  创建顶部栏
 */
- (void)initNavBar
{
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithTitle:@"下一条" style:UIBarButtonItemStyleBordered target:self action:@selector(clickNextBtn)];
    self.navigationItem.rightBarButtonItem = rightBar;
    [rightBar release];
    
}
/**
 *  返回至上一界面
 */
- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  转至下一条数据
 */
-(void)clickNextBtn
{
    _mCurrent++;
    [self getData];
}

-(void)moviePlayBackDidFinish
{
    NSLog(@"%s",__FUNCTION__);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    mHeight = [UIScreen mainScreen].bounds.size.height;
    mWidth = [UIScreen mainScreen].bounds.size.width;
    
    [self initView];
    [self changePosition];
    [self getData];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
- (void)didReceiveMemoryWarning {
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

@end
