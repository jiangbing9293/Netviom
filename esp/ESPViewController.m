//
//  ESPViewController.m
//  EspTouchDemo
//
//  Created by 白 桦 on 3/23/15.
//  Copyright (c) 2015 白 桦. All rights reserved.
//

#import "ESPViewController.h"
#import "ESPTouchTask.h"
#import "ESPTouchResult.h"
#import "MBProgressHUD.h"
#import "iToast.h"
#import "Tools.h"
#import <SystemConfiguration/CaptiveNetwork.h>

// the three constants are used to hide soft-keyboard when user tap Enter or Return
#define HEIGHT_KEYBOARD 216
#define HEIGHT_TEXT_FIELD 30
#define HEIGHT_SPACE (6+HEIGHT_TEXT_FIELD)

@interface ESPViewController ()

@property (assign, nonatomic) MBProgressHUD *_spinner;
@property (assign, nonatomic) UITextField *_pwdTextView;
// without the condition, if the user tap confirm/cancel quickly enough,
// the bug will arise. the reason is follows:
// 0. task is starting created, but not finished
// 1. the task is cancel for the task hasn't been created, it do nothing
// 2. task is created
// 3. Oops, the task should be cancelled, but it is running
@property (nonatomic, strong) NSCondition *_condition;
// to cancel ESPTouchTask when
@property (atomic, strong) ESPTouchTask *_esptouchTask;

@end

@implementation ESPViewController

- (IBAction)tapConfirmCancelBtn:(UIButton *)sender
{
    NSString *ssid = self.ssidTextView.text;
    NSString *pwd = self._pwdTextView.text;
    
    if (ssid == nil || [ssid isEqualToString:@""]) {
        [[iToast makeText:@"ssid不能为空"]show];
        return;
    }
    
    if (pwd == nil || [pwd length] < 8) {
        [[iToast makeText:@"Wi-Fi密码不合法"]show];
        return;
    }
    
    [self._spinner setLabelText:@"正在广播Wi-Fi信息..."];
    [self._spinner show:YES];
    NSLog(@"do confirm action...");
    dispatch_queue_t  queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSLog(@"do the execute work...");
        // execute the task
//        ESPTouchResult *esptouchResult = [self executeForResult];
        
        NSArray *esptouchResultArray = [self executeForResults];
        
        [self._spinner setLabelText:@"Wi-Fi信息广播完成..."];
        [self._spinner hide:YES];
        // show the result to the user in UI Main Thread
//        NSLog(@"****** Execute Result:%@",[esptouchResult description]);
        dispatch_async(dispatch_get_main_queue(), ^{
            //                [self._spinner hide:YES];
            // when canceled by user, don't show the alert view again
//            if (!esptouchResult.isCancelled && esptouchResult.isSuc)
//            {
//                [self goBack];
//                //                    [[[UIAlertView alloc] initWithTitle:@"Execute Result" message:[esptouchResult description] delegate:nil cancelButtonTitle:@"I know" otherButtonTitles: nil] show];
//            }
//            if ([esptouchResult description] == nil) {
//                [[[UIAlertView alloc] initWithTitle:@"提示" message:@"Wi-Fi信息广播失败,请重新配置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
//            }
            ESPTouchResult *firstResult = [esptouchResultArray objectAtIndex:0];
            // check whether the task is cancelled and no results received
            if (!firstResult.isCancelled)
            {
                NSMutableString *mutableStr = [[NSMutableString alloc]init];
                NSUInteger count = 0;
                // max results to be displayed, if it is more than maxDisplayCount,
                // just show the count of redundant ones
                const int maxDisplayCount = 5;
                if ([firstResult isSuc])
                {
                    
                    for (int i = 0; i < [esptouchResultArray count]; ++i)
                    {
                        ESPTouchResult *resultInArray = [esptouchResultArray objectAtIndex:i];
                        [mutableStr appendString:[resultInArray description]];
                        [mutableStr appendString:@"\n"];
                        count++;
                        if (count >= maxDisplayCount)
                        {
                            break;
                        }
                    }
                    
                    if (count < [esptouchResultArray count])
                    {
                        [mutableStr appendString:[NSString stringWithFormat:@"\nthere's %lu more result(s) without showing\n",(unsigned long)([esptouchResultArray count] - count)]];
                    }
                    [self goBack];
                    [[[UIAlertView alloc]initWithTitle:@"提示" message:@"该报警盒已成功配置Wi-Fi无需配置，请重启报警盒" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil]show];
                }
                
                else
                {
                    [self goBack];
                    [Tools showAlert:@"配置完成"];
//                    [[[UIAlertView alloc]initWithTitle:@"Execute Result" message:@"Esptouch fail" delegate:nil cancelButtonTitle:@"I know" otherButtonTitles:nil]show];
                }
            }

        });
    });
}

#pragma mark - the example of how to cancel the executing task

- (void) cancel
{
    [self._condition lock];
    if (self._esptouchTask != nil)
    {
        [self._esptouchTask interrupt];
    }
    [self._condition unlock];
}

#pragma mark - the example of how to use execute

//- (BOOL) execute
//{
//    NSString *apSsid = [self.ssidTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    NSString *apPwd = [self._pwdTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];    NSLog(@"apssid:%@,appwd:%@", apSsid, apPwd);
//    self._esptouchTask = [[ESPTouchTask alloc]initWithApSsid:apSsid andApPwd:apPwd];
//    BOOL result = [self._esptouchTask execute];
//    NSLog(@"execute() result is: %@",result?@"YES":@"NO");
//    return result;
//}
#pragma mark - the example of how to use executeForResults
- (NSArray *) executeForResults
{
    [self._condition lock];
    NSString *apSsid = [self.ssidTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *apPwd = [self._pwdTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];    NSLog(@"apssid:%@,appwd:%@", apSsid, apPwd);
    NSString *apBssid = self.bssid;
    self._esptouchTask =
    [[ESPTouchTask alloc]initWithApSsid:apSsid andApBssid:apBssid andApPwd:apPwd andIsSsidHiden:NO];
    [self._condition unlock];
    NSArray * esptouchResults = [self._esptouchTask executeForResults:1];
    NSLog(@"ESPViewController executeForResult() result is: %@",esptouchResults);
    return esptouchResults;
}

#pragma mark - the example of how to use executeForResult

- (ESPTouchResult *) executeForResult
{
    NSString *apSsid = [self.ssidTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *apPwd = [self._pwdTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSLog(@"apssid:%@,appwd:%@", apSsid, apPwd);
    [self._condition lock];
    NSString *apBssid = self.bssid;
    self._esptouchTask =
    [[ESPTouchTask alloc]initWithApSsid:apSsid andApBssid:apBssid andApPwd:apPwd andIsSsidHiden:NO];
    [self._condition unlock];
    ESPTouchResult * esptouchResult = [self._esptouchTask executeForResult];
    NSLog(@"ESPViewController executeForResult() result is: %@",esptouchResult);

    return esptouchResult;
}

//初始化UI
-(void)initView{
    [self initNavBar];
    self.title = @"配置报警盒Wi-Fi";
    self._spinner = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self._spinner hide:YES];
    CGFloat mWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat cHeight = 50.0f;
    
    UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 80.0f, mWidth, 1)];
    lable1.backgroundColor = [ UIColor grayColor];
    UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 130.0f, mWidth, 1)];
    lable2.backgroundColor = [ UIColor grayColor];
    UILabel *lable3 = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 180.0f, mWidth, 1)];
    lable3.backgroundColor = [ UIColor grayColor];
    
    self.ssidLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, mWidth/2-20.0f, cHeight)];
    self.ssidTextView = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.ssidLabel.frame), 5.0f, mWidth/2, cHeight-5.0f)];
    [self.ssidLabel setTextAlignment:NSTextAlignmentCenter];
    self.pwdLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, mWidth/2-20.0f, cHeight)];
    [self.pwdLabel setTextAlignment:NSTextAlignmentCenter];
    self._pwdTextView = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.pwdLabel.frame), 5.0f, mWidth/2, cHeight-5.0f)];

    [self.ssidLabel setText:@"Wi-Fi名称:"];
    [self.pwdLabel setText:@"Wi-Fi密码:"];
    [self.ssidTextView setText:_ssid];
    
    UIView *ssidView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 80.0f, mWidth, cHeight)];
    UIView *pwdView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(ssidView.frame), mWidth, cHeight)];
    
    [self._pwdTextView becomeFirstResponder];
    
    [ssidView addSubview:self.ssidLabel];
    [ssidView addSubview:self.ssidTextView];
    [pwdView addSubview:self.pwdLabel];
    [pwdView addSubview:self._pwdTextView];
    
    [self.view addSubview:ssidView];
    [self.view addSubview:pwdView];
    
    [self.view addSubview:lable1];
    [self.view addSubview:lable2];
    [self.view addSubview:lable3];
}

- (void)initNavBar
{
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = leftBar;
    [leftBar release];
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStyleBordered target:self action:@selector(tapConfirmCancelBtn:)];
    self.navigationItem.rightBarButtonItem = rightBar;
    [rightBar release];
}
- (void)goBack
{
    NSLog(@"%s",__FUNCTION__);
//    [self.navigationController popToViewController:self animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self initView];
    self._condition = [[NSCondition alloc]init];
    self._pwdTextView.delegate = self;
    self.ssidTextView.delegate = self;
    self._pwdTextView.keyboardType = UIKeyboardTypeASCIICapable;
}

#pragma mark - the follow codes are just to make soft-keyboard disappear at necessary time

// when out of pwd textview, resign the keyboard
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (![self._pwdTextView isExclusiveTouch])
    {
        [self._pwdTextView resignFirstResponder];
    }
}

#pragma mark -  the follow three methods are used to make soft-keyboard disappear when user finishing editing

// when textField begin editing, soft-keyboard apeear, do the callback
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y - (self.view.frame.size.height - (HEIGHT_KEYBOARD+HEIGHT_SPACE));
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    if(offset > 0)
    {
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    [UIView commitAnimations];
}

// when user tap Enter or Return, disappear the keyboard
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

// when finish editing, make view restore origin state
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}


@end
