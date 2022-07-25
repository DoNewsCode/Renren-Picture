//
//  DRMEGetTopicsReqeust.m
//  Renren-EditImage
//
//  Created by 李晓越 on 2020/2/21.
//

#import "DRMEGetTopicsReqeust.h"

@implementation DRMEGetTopicsReqeust

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.page = 1;
        self.page_size = 20;
    }
    return self;
}

- (NSString *)requestUrl
{
    return MCS_HOST(@"/topic/getTopics");
}

@end
