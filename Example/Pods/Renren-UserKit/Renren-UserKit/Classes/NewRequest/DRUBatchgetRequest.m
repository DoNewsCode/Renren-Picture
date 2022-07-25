//
//  DRUBatchgetRequest.m
//  Renren-UserKit
//
//  Created by 李晓越 on 2020/7/3.
//

#import "DRUBatchgetRequest.h"

@implementation DRUBatchgetRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        /**
         0   新鲜事可见时间设置
         1   好友申请设置
         2   评论推送通知设置接口
         3   评论应用内消息浮窗设置接口
         4   视频自动播放设置
         5   通讯录自动上传设置
         6   人人运动上报设置
         7   添加关注设置
         8   视频默认高清设置
         9   个人信息是否可见设置
         10  点赞应用内通知设置
         11  点赞应用内消息浮窗设置接口
         12  转发应用内通知设置
         13  转发应用内消息浮窗设置接口
         */
        
        self.userConfigTypeList = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7",
                                    @"8", @"9", @"10", @"11", @"12", @"13"];
        
    }
    return self;
}

- (NSString *)requestUrl
{
    return MCS_HOST(@"/setting/v1/batchget");
}

@end
