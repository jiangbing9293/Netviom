//
//  AlertDetailViewController.h
//  Supereye
//
//  Created by jiang bing on 15/6/25.
//  Copyright (c) 2015年 Netviom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "DataTypeDefine.h"
extern NSMutableArray *mListData;
extern int mCurrent;
extern NSMutableArray *imagesArray;

@interface AlertDetailViewController : UIViewController
{
    AlertRecord *alertRecord;
}

@property (nonatomic ,assign) AlertRecord *alertRecord;
@property(nonatomic,assign)UILabel *labDevName;
@property(nonatomic,assign)UILabel *labDevId;
@property(nonatomic,assign)UILabel *labAlertType;
@property(nonatomic,assign)UILabel *labRespType;
@property(nonatomic,assign)UILabel *labAlertTime;
@property(nonatomic,assign)UILabel *labHasPic;
@property(nonatomic,assign)UIView *fileView;
@property(nonatomic, assign)UIScrollView *scrollView;

@end
