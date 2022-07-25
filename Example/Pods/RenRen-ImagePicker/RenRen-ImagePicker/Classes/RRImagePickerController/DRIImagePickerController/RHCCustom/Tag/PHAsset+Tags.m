//
//  PHAsset+Tags.m
//  RenrenOfficial-iOS-Concept
//
//  Created by 张健康 on 2019/3/18.
//  Copyright © 2019 renren. All rights reserved.
//

#import "PHAsset+Tags.h"
#import <objc/runtime.h>
@implementation PHAsset (Tags)
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tagsArray = [[NSMutableArray alloc] init];
    }
    return self;
}
- (void)addTag:(NSDictionary *)tag{
    [self.tagsArray addObject:tag];
}

- (NSMutableArray *)tagsArray{
   return objc_getAssociatedObject(self, @selector(observer));
}

- (void)setTagsArray:(NSMutableArray *)tagsArray {
    objc_setAssociatedObject(self, @selector(observer), tagsArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
