//
//  NSBundle+DRPExtension.m
//  AFNetworking
//
//  Created by lixiaoyue on 2019/2/22.
//

#import "NSBundle+DRMEExtension.h"
#import "DRMECameraViewController.h"

@implementation NSBundle (DRMEExtension)

+ (instancetype)me_Bundle
{
    NSBundle *curBundle = [NSBundle bundleForClass:[DRMECameraViewController class]];
    NSBundle *xibBundle = [NSBundle bundleWithPath:[curBundle pathForResource:@"Renren-EditImage" ofType:@"bundle"]];
    
    if (!xibBundle) {
        xibBundle = [NSBundle mainBundle];
    }
    return xibBundle;
}

@end
