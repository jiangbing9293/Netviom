//
//  AlertDetailViewController.m
//  Supereye
//
//  Created by jiang bing on 15/6/25.
//  Copyright (c) 2015年 Netviom. All rights reserved.
//

#import "AlertDetailViewController.h"
#import "MyPageViewController.h"
#import "MBProgressHUD.h"
@interface AlertDetailViewController ()
{
    CGFloat mHeight;
    CGFloat mWidth;
    MBProgressHUD *mHud;
}

@end

@implementation AlertDetailViewController

NSMutableArray *imagesArray;

@synthesize alertRecord = _alertRecord;
@synthesize labDevName = _labDevName;
@synthesize labDevId = _labDevId;
@synthesize labAlertType = _labAlertType;
@synthesize labRespType = _labRespType;
@synthesize labAlertTime = _labAlertTime;
@synthesize labHasPic = _labHasPic;
@synthesize fileView = _fileView;
@synthesize scrollView = _scrollView;
/**
 *  初始化UI
 */
-(void)initView
{
     mHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
    if(mCurrent >= 0 && mCurrent < [mListData count])
    {
        _alertRecord = [mListData objectAtIndex:mCurrent];
        [self setData];
    }
    else
    {
        NSLog(@"%s:数据出错",__func__);
    }
}
/**
 *  配置数据
 */
-(void)setData
{
    if(mHud != nil)
    {
        [mHud setHidden:NO];
        [mHud setLabelText:@"正在加载中..."];
    }
    _labDevName.text = [NSString stringWithFormat:@"报警设备：%@",_alertRecord.devName];
    _labDevId.text = [NSString stringWithFormat:@"设备ID：%@",_alertRecord.cameraID];
    _labAlertType.text = [NSString stringWithFormat:@"报警类型：%@",[_alertRecord getWarnType:YES]];
    _labRespType.text = [NSString stringWithFormat:@"响应方式：%@",[_alertRecord getRespType]];
    _labAlertTime.text = [NSString stringWithFormat:@"报警时间：%@",[_alertRecord getWarnTime]];
    
    [_alertRecord sortFiles];
    for(UIView *view in [_fileView subviews])
    {
        [view removeFromSuperview];
    }
    [imagesArray removeAllObjects];
    for(int i = 0; i < [[_alertRecord files]count]; ++i)
    {
        [_fileView setFrame:CGRectMake(0.0f, CGRectGetMaxY(_labAlertTime.frame), mWidth, ((i+1)*(mWidth*3/4)))];
        [_scrollView setContentSize:CGSizeMake(mWidth, (CGRectGetMaxY(_fileView.frame)+200.0f))];
        
        NSDictionary *dic = [[_alertRecord files]objectAtIndex:i];
        NSString *model = [dic objectForKey:@"model"];
        dispatch_queue_t loadImage = dispatch_queue_create("loadImage", nil);
        dispatch_async(loadImage, ^(void){
            if(model && [model isEqualToString:@"0"])
            {
                NSURL *url = [[NSURL alloc]initWithString:[dic objectForKey:@"url"]];
                UIImage *image = [[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:url]];
                BOOL image_error = NO;
                if (!image)
                {
                    image_error = YES;
                    image = [UIImage imageNamed:@"delete"];
                }
                if (image)
                {
                     [imagesArray addObject:image];
                }
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(5.0f, (i*mWidth*3/4+20.0f), (mWidth-10.0f), (mWidth*3/4))];
                    [btn setTag:i];
                    [btn.layer setMasksToBounds:YES];
                    [btn.layer setCornerRadius:10.0f];
                    [btn.layer setBorderWidth:2.0f];
                    [btn setTitle:[NSString stringWithFormat:@"第%d张",(i+1)] forState:UIControlStateNormal];
                    [btn setBackgroundImage:image forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    if(image_error)
                    {
                        [btn setTitle:[NSString stringWithFormat:@"url资源有问题"] forState:UIControlStateNormal];
                        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                    }
                    //[btn setImage:image forState:UIControlStateNormal];
                    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
                    [_fileView addSubview:btn];
                    [btn release];
                    [mHud setHidden:YES];
                });
            }
        });
        dispatch_release(loadImage);
        if(model && [model isEqualToString:@"1"])
        {
            [mHud setHidden:YES];
            NSURL *url = [[NSURL alloc]initWithString:[dic objectForKey:@"url"]];
            // create MPMoviePlayerViewController
            MPMoviePlayerViewController *playerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
            NSLog(@"******MPMoviePlayerViewController ****\n%@",url);
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDidFinish) name:MPMoviePlayerPlaybackDidFinishNotification object:[playerViewController moviePlayer]];
            // add to view
            [_fileView addSubview:playerViewController.view];
            // play movie
            MPMoviePlayerController *player = [playerViewController moviePlayer];
            player.controlStyle = MPMovieControlStyleEmbedded;
            [player.view setFrame:CGRectMake(5.0f, (i*mWidth*3/4+20.0f), (mWidth-10.0f), (mWidth*3/4))];
            [player play];
        }
    }
}
/**
 *  处理点击事件
 *
 *  @param sender UIButton
 */
-(IBAction)btnClicked:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    NSInteger tag = [btn tag];
    NSLog(@"%s,tag:%d",__func__,(int)tag);
    MyPageViewController *pageView = [[MyPageViewController alloc]init];
    pageView.startingIndex = tag;
    [self.navigationController pushViewController:pageView animated:YES];
    [pageView release];
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
    [self dismissModalViewControllerAnimated:YES];
}
/**
 *  转至下一条数据
 */
-(void)clickNextBtn
{
    mCurrent++;
    [self getData];
}

-(void)moviePlayBackDidFinish
{
    NSLog(@"%s",__FUNCTION__);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    imagesArray = [[NSMutableArray alloc]init];
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
