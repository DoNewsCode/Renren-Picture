//
//  DRUChangeAccountRequest.m
//  Renren-UserKit
//
//  Created by 李晓越 on 2020/3/11.
//

#import "DRUChangeAccountRequest.h"

@implementation DRUChangeAccountRequest

- (NSString *)requestUrl
{
    return MCS_HOST(@"/userbase/v1/setAccount");
}
@end
