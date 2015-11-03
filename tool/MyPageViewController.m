/*
     File: MyPageViewController.m
 Abstract: The view controller used for displaying a list of photos.
  Version: 1.1
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2013 Apple Inc. All Rights Reserved.
 
 */

#import "MyPageViewController.h"
#import "PhotoViewController.h"
#import "iToast.h"

@implementation MyPageViewController

/**
 *@ date:2015-07-04
 *@ author:freelancer
 *@ function: 保存图片
 **/
-(void)savePicture
{
    UIImage *image = [imagesArray objectAtIndex:_startingIndex];
    if (image) {
        [[MediaManager defaultManger] saveImage:image];
        [[iToast makeText:@"图片已保存"]show];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // start by viewing the photo tapped by the user
    PhotoViewController *startingPage = [PhotoViewController photoViewControllerForPageIndex:self.startingIndex];
    NSString *str =  [NSString stringWithFormat:@"%d of %d", (int)(_startingIndex+1), (int)[imagesArray count]];
    self.navigationItem.title = str;
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithTitle:@"下载" style:UIBarButtonItemStyleBordered target:self action:@selector(savePicture)];
    self.navigationItem.rightBarButtonItem = rightBar;
    [rightBar release];

    
    if (startingPage != nil)
    {
        self.dataSource = self;
        [self setViewControllers:@[startingPage]
                       direction:UIPageViewControllerNavigationDirectionForward
                        animated:NO
                      completion:NULL];
    }
}

#pragma mark - UIPageViewControllerDelegate
- (UIViewController *)pageViewController:(UIPageViewController *)pvc viewControllerBeforeViewController:(PhotoViewController *)vc
{
    NSUInteger index = vc.pageIndex;
    if(index > 0)
    {
        NSString *str =  [NSString stringWithFormat:@"%d of %d", (int)(index), (int)[imagesArray count]];
        self.navigationItem.title = str;
        
    }
    return [PhotoViewController photoViewControllerForPageIndex:(index - 1)];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pvc viewControllerAfterViewController:(PhotoViewController *)vc
{
    NSUInteger index = vc.pageIndex;
    if((index +1) < [imagesArray count])
    {
        NSString *str =  [NSString stringWithFormat:@"%d of %d", (int)(index+2), (int)[imagesArray count]];
        self.navigationItem.title = str;
    }
    return [PhotoViewController photoViewControllerForPageIndex:(index + 1)];
}

@end
