//
//  DRNUploadImageRequest.m
//  Renren-Network
//
//  Created by 张健康 on 2019/7/29.
//

#import "DRNUploadImageRequest.h"

#import "NSString+CTDate.h"

@implementation DRNUploadImageRequest
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.v = @"1.0";
    }
    return self;
}

- (NSString *)call_id
{
    return [NSString ct_timeStampForNow];
}

@end
