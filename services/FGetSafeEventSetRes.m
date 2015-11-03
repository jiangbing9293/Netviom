//
//  FGetSafeEventSetRes.m
//  Supereye
//
//  Created by jiang bing on 15/7/10.
//  Copyright (c) 2015年 Netviom. All rights reserved.
//

#import "FGetSafeEventSetRes.h"
#import "GDataXMLNode.h"

@implementation FGetSafeEventSetRes
/**
 *解析获取的安全设置状态信息
 **/
- (void)parse
{
    [super parse];
    
    self.setList = [NSMutableArray array];
    
    if ([self isSuccess]) {
        
        NSError *error;
        GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithXMLString:self.responseString options:0 error:&error];
        
        if (document != nil) {
            NSError *error;
            
            NSArray *mobileElements = [document.rootElement nodesForXPath:@"//response/datas" error:&error];
            
            for (GDataXMLElement *element in mobileElements)
            {
                NSString *email_notify = [[element attributeForName:@"email_notify"] stringValue];
                /**
                 * 是否邮件通知：0 关闭 1 通知
                 **/
                if (email_notify) {
                    [self.setList addObject:email_notify];
                }
                NSString *sms_notify = [[element attributeForName:@"sms_notify"] stringValue];
                /**
                 * 是否短信通知：0 关闭 1 通知
                 **/
                if (sms_notify) {
                    [self.setList addObject:sms_notify];
                }
                /**
                 * 是否推送
                 **/
                NSString *push_notify = [[ element attributeForName:@"push_notify"] stringValue];
                if ( push_notify){
                    [self.setList addObject:push_notify];
                }
                /**
                 *  是否微信通知
                 **/
                NSString *wechat_notify = [[ element attributeForName:@"wechat_notify"] stringValue];
                if ( wechat_notify){
                    [self.setList addObject:wechat_notify];
                }
                
                NSString *safeLevel = [[element attributeForName:@"safeLevel"] stringValue];
                /**
                 *事件安全级别：0 关闭 1 登录事件 2 视频观看事件
                 */
                if (safeLevel) {
                    [self.setList addObject:safeLevel];
                }
                
            }
            [document release];
        }
    }
    
}

+ (FGetSafeEventSetRes *)initWithXMLString:(NSString *)xmlString
{
    FGetSafeEventSetRes *response = [[FGetSafeEventSetRes alloc] init];
    response.responseString = xmlString;
    [response parse];
    return [response autorelease];
}
@end
