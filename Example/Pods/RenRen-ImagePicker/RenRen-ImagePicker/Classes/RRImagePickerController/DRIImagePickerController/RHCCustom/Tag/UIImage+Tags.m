//
//  UIImage+Tags.m
//  DNCommonKit
//
//  Created by 张健康 on 2019/8/16.
//

#import "UIImage+Tags.h"
#import <objc/runtime.h>
@implementation UIImage (Tags)
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
