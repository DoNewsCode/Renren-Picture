//
//  NSBundle+RRFilter.m
//  Renren-Filter
//
//  Created by 张健康 on 2020/3/9.
//

#import "NSBundle+RRFilter.h"

@interface RRFilterController : NSObject

@end

@implementation RRFilterController

@end
@implementation NSBundle (RRFilter)
+ (NSBundle *)drft_filterBundle {
    NSBundle *bundle = [NSBundle bundleForClass:[RRFilterController class]];
    NSURL *url = [bundle URLForResource:@"Renren-Filter" withExtension:@"bundle"];
    bundle = [NSBundle bundleWithURL:url];
    return bundle;
}
@end
