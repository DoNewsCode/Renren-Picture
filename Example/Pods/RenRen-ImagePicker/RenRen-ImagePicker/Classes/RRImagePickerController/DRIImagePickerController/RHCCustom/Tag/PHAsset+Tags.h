//
//  PHAsset+Tags.h
//  RenrenOfficial-iOS-Concept
//
//  Created by 张健康 on 2019/3/18.
//  Copyright © 2019 renren. All rights reserved.
//

#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN
/*
 tag4参数
 @"center_left_to_photo" 标签距离图片左边的距离，数字*1000，NSNumber
 @"center_top_to_photo" 标签距离图片上边的距离，数字*1000，NSNumber
 @"tagDirections"        标签方向，DRITagViewDirection类型0左1右
 @"target_name"          标签内容
 */
@interface PHAsset (Tags)
@property (nonatomic, strong) NSMutableArray *tagsArray;
- (void)addTag:(NSDictionary *)tag;
@end

NS_ASSUME_NONNULL_END
