//
//  DRBBaseView.m
//  Pods-Renren-BaseKit_Example
//
//  Created by Ming on 2019/4/11.
//

#import "DRBBaseView.h"

@implementation DRBBaseView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sd_imageTransition =  [SDWebImageTransition flipFromLeftTransition];
    }
    return self;
}

@end
