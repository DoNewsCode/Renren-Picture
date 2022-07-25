//
//  NSBundle+DRPExtension.m
//  AFNetworking
//
//  Created by lixiaoyue on 2019/2/22.
//

#import "NSBundle+Pop.h"
#import "DRPPop.h"

@implementation NSBundle (Pop)

+ (instancetype)pop_Bundle
{
    NSBundle *curBundle = [NSBundle bundleForClass:[DRPPop class]];
    NSBundle *xibBundle = [NSBundle bundleWithPath:[curBundle pathForResource:@"Renren-Pop" ofType:@"bundle"]];
    
    if (!xibBundle) {
        xibBundle = [NSBundle mainBundle];
    }
    return xibBundle;
}

@end
