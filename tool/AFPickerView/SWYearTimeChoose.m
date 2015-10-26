//
//  SWYearTimeChoose.m
//  IntelligentWaterSystem
//
//  Created by geimin on 15/1/21.
//  Copyright (c) 2015年 Palmtrends. All rights reserved.
//

#import "SWYearTimeChoose.h"
@interface SWYearTimeChoose () <UIPickerViewDelegate , UIPickerViewDataSource>
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;    //选择器
@property (strong, nonatomic) NSMutableArray        *yearOneArr;    //年份列表_起
@property (strong, nonatomic) NSMutableArray        *montOnehArr;   //月份列表_起
@property (strong, nonatomic) NSMutableArray        *yearTwoArr;    //年份列表_止
@property (strong, nonatomic) NSMutableArray        *montTwohArr;   //月份列表_止
@property (strong, nonatomic) NSMutableArray        *valuewYTwoArr;
@property (strong, nonatomic) NSMutableArray        *valuewMTwoArr;
@property (strong, nonatomic) NSString              *yearOneStr;    //年份_起
@property (strong, nonatomic) NSString              *montOneStr;    //月份_起
@property (strong, nonatomic) NSString              *yearTwoStr;    //年份_止
@property (strong, nonatomic) NSString              *montTwoStr;    //月份_止

@end


@implementation SWYearTimeChoose
@synthesize yearOneArr  = _yearOneArr;
@synthesize montOnehArr = _montOnehArr;
@synthesize yearTwoArr  = _yearTwoArr;
@synthesize montTwohArr = _montTwohArr;
@synthesize yearOneStr  = _yearOneStr;
@synthesize montOneStr  = _montOneStr;
@synthesize yearTwoStr  = _yearTwoStr;
@synthesize montTwoStr  = _montTwoStr;
@synthesize valuewYTwoArr= _valuewYTwoArr;
@synthesize valuewMTwoArr = _valuewMTwoArr;


//当前时间的时间戳
-(long int)cNowTimestamp{
    NSDate *newDate = [NSDate date];
    long int timeSp = (long)[newDate timeIntervalSince1970];
    return timeSp;
}

//时间戳——字符串时间
-(NSString *)cStringFromTimestamp:(NSString *)timestamp{
    NSDate *timeData = [NSDate dateWithTimeIntervalSince1970:[timestamp intValue]];
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"yyyy年M月d日 H:mm"];
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *strTime = [dateFormatter stringFromDate:timeData];
    return strTime;
}

//当前月份
-(NSString *)cMontFromTimestamp:(NSString *)timestamp{
    NSDate *timeData = [NSDate dateWithTimeIntervalSince1970:[timestamp intValue]];
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM"];
    NSString *strTime = [dateFormatter stringFromDate:timeData];
    return strTime;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    if(!_yearOneArr){
        _yearOneArr = [[NSMutableArray alloc] initWithObjects:@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",nil];
    }
    
    if(!_montOnehArr){
        _montOnehArr = [[NSMutableArray alloc] initWithObjects:@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",nil];
    }
    
    if(!_valuewYTwoArr){
        _valuewYTwoArr = [[NSMutableArray alloc] initWithObjects:@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",nil];
    }
    
    if(!_valuewMTwoArr){
        _valuewMTwoArr = [[NSMutableArray alloc] initWithObjects:@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",nil];

    }

    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    
    [self valueChangeYear:[_valuewYTwoArr lastObject] andMonth:[_valuewMTwoArr firstObject]];

    //初始默认选择
    for(NSInteger i = 0;i < 4;i ++){
        NSInteger row = 0;
        if(i == 0){
            row = [_yearOneArr count]-1;
            _yearOneStr = [_yearOneArr objectAtIndex:row];
        }else if(i == 1){
            row = 0;
            _montOneStr = [_montOnehArr objectAtIndex:row];
        }else if(i == 2){
            row = [_yearTwoArr count]-1;
            _yearTwoStr = [_yearTwoArr objectAtIndex:row];
        }else if(i == 3){
            NSString *monStr = [self cMontFromTimestamp:[NSString stringWithFormat:@"%ld",[self cNowTimestamp]]];
            NSInteger theRow = [_montTwohArr indexOfObject:monStr];
            row = theRow;
            _montTwoStr = [_montTwohArr objectAtIndex:row];
        }
        [_pickerView selectRow:row inComponent:i animated:NO];
    }
    
}

-(void)valueChangeYear:(NSString *)theYear andMonth:(NSString *)theMonth{
    NSInteger yInt = [_valuewYTwoArr indexOfObject:theYear];
    NSInteger mInt = [_valuewMTwoArr indexOfObject:theMonth];
    
    if(!_yearTwoArr){
        _yearTwoArr = [[NSMutableArray alloc] init];
    }
    [_yearTwoArr removeAllObjects];
    for (NSInteger i = yInt; i < _valuewYTwoArr.count ; i ++) {
        [_yearTwoArr addObject:[_valuewYTwoArr objectAtIndex:i]];
    }
    
    if(!_montTwohArr){
        _montTwohArr = [[NSMutableArray alloc] init];
    }
    [_montTwohArr removeAllObjects];
    for (NSInteger j = mInt; j < _valuewMTwoArr.count ; j ++) {
        [_montTwohArr addObject:[_valuewMTwoArr objectAtIndex:j]];
    }
    
    [_pickerView reloadAllComponents];
}

//返回
- (IBAction)returnAction:(id)sender {
    [self removeFromSuperview];
}

//查询
- (IBAction)queryAction:(id)sender{
    //缓存选择时间
    NSString *userDefau = [NSString stringWithFormat:@"%@:%@-%@:%@",_yearOneStr,_montOneStr,_yearTwoStr,_montTwoStr];
    
//    NSUserDefaults *isLoginDefaults = [NSUserDefaults standardUserDefaults];
//    [isLoginDefaults setObject:userDefau forKey:@"timeChooseOne"];
//    [isLoginDefaults synchronize];
    [_delegate hourAndMunite:userDefau];
    //返回
    [self returnAction:nil];
}

#pragma mark UIPickerViewDataSource
//几列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 4;
}
//几行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(component == 0)
        return [_yearOneArr count];
    else if(component == 1)
        return [_montOnehArr count];
    else if(component == 2)
        return [_yearTwoArr count];
    else if(component == 3)
        return [_montTwohArr count];
    
    return -1;
}

#pragma mark UIPickerViewDelegate
//component宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    if(component == 0)
        return 75.0f;
    else if(component == 1)
        return 65.0f;
    else if(component == 2)
        return 75.0f;
    else if(component == 3)
        return 55.0f;
    
    return 0.0f;
}
//row高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 50.0f;
}

//专门为定制UIPickerView用的一个函数，返回component列row行所在的定制的View，不自定义的话会有一个系统默认的格式
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    //得到Component对应的宽和高
    CGFloat width = [self pickerView:pickerView widthForComponent:component];
    CGFloat height = [self pickerView:pickerView rowHeightForComponent:component];
    
    //返回UIView
    UIView *returnView = [[UIView alloc] init];
    [returnView setFrame:CGRectMake(0, 0, width, height-10)];
    
    //添加UILabel到UIView上,传递数据
    UIColor *color = [UIColor colorWithRed:25/255.0 green:135/255.0 blue:246/255.0 alpha:1];
    UILabel *label = [[UILabel alloc] init];
    label.frame = returnView.frame;
    [label setFont:[UIFont systemFontOfSize:20]];
    [label setTextColor:color];
    label.tag = 1000;
    [returnView addSubview:label];
    
    //对Label附加数据
    if(component == 0){
        label.text = [_yearOneArr  objectAtIndex:row];
        [label setTextAlignment:NSTextAlignmentLeft];

    }else if(component == 1){
        label.text = [_montOnehArr objectAtIndex:row];
        [label setTextAlignment:NSTextAlignmentLeft];

    }else if(component == 2){
        label.text = [_yearTwoArr  objectAtIndex:row];
        [label setTextAlignment:NSTextAlignmentCenter];

    }else if(component == 3){
        label.text = [_montTwohArr objectAtIndex:row];
        [label setTextAlignment:NSTextAlignmentCenter];

    }

    //隐藏选择器横线
    NSArray *picArr = pickerView.subviews;
    for(int i = 0; i < picArr.count ; i ++){
        UIView *tempView = (UIView *)[picArr objectAtIndex:i];
        [tempView setBackgroundColor:[UIColor clearColor]];
    }
    
    return returnView;
}

//关联UILabel 和 UIPickerView
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    //取得选择的Row
    NSInteger rowZero,rowOne,rowTwo,rowThree;
    rowZero  = [pickerView selectedRowInComponent:0];
    rowOne   = [pickerView selectedRowInComponent:1];
    rowTwo   = [pickerView selectedRowInComponent:2];
    rowThree = [pickerView selectedRowInComponent:3];
    
    //从选择的Row取得View
    UIView *viewZero,*viewOne,*viewTwo,*viewThree;
    viewZero  = [pickerView viewForRow:rowZero   forComponent:0];
    viewOne   = [pickerView viewForRow:rowOne    forComponent:1];
    viewTwo   = [pickerView viewForRow:rowTwo    forComponent:2];
    viewThree = [pickerView viewForRow:rowThree  forComponent:3];
    
    //从取得的View取得上面UILabel
    UILabel *labZero,*labOne,*labTwo,*labThree;
    labZero  = (UILabel *)[viewZero   viewWithTag:1000];
    labOne   = (UILabel *)[viewOne    viewWithTag:1000];
    labTwo   = (UILabel *)[viewTwo    viewWithTag:1000];
    labThree = (UILabel *)[viewThree  viewWithTag:1000];
    
    //将从三列分别取得的，字体，大小，颜色，传递给在界面上显示的UILabel
    _yearOneStr = labZero.text;
    _montOneStr = labOne.text;
    _yearTwoStr = labTwo.text;
    _montTwoStr = labThree.text;
    
    if([_yearOneStr isEqualToString:_yearTwoStr]){
        [self valueChangeYear:_yearOneStr andMonth:_montOneStr];
    }else{
        [self valueChangeYear:_yearOneStr andMonth:@"01"];
    }
   
    for(NSInteger i = 0;i < 4;i ++){
        NSInteger index = 0;
        if (row == i) {
            break;
        }
        if(i == 0){
            index = [_yearOneArr indexOfObject:_yearOneStr];
            _yearOneStr = [_yearOneArr objectAtIndex:index];
            
        }else if(i == 1){
            index = [_montOnehArr indexOfObject:_montOneStr];
            _montOneStr = [_montOnehArr objectAtIndex:index];
            
        }else if(i == 2){
            if([_yearOneStr integerValue] > [_yearTwoStr integerValue]){
                index = [_yearTwoArr indexOfObject:_yearOneStr];
            }else{
                index = [_yearTwoArr indexOfObject:_yearTwoStr];
            }
            _yearTwoStr = [_yearTwoArr objectAtIndex:index];
            
        }else if(i == 3){
            if([_yearOneStr isEqualToString:_yearTwoStr] && [_montOneStr integerValue]>[_montTwoStr integerValue]){
                index = [_montTwohArr indexOfObject:_montOneStr];
            }else{
                index = [_montTwohArr indexOfObject:_montTwoStr];
            }
            _montTwoStr = [_montTwohArr objectAtIndex:index];
            
        }
        [_pickerView selectRow:index inComponent:i animated:NO];
    }
    
}

@end
