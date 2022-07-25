//
//  DRIImagePreviewTagsViewController.h
//  RenrenOfficial-iOS-Concept
//
//  Created by 张健康 on 2019/3/19.
//  Copyright © 2019 renren. All rights reserved.
//

#import "DRIImagePreviewTagsView.h"
#import <Photos/Photos.h>
NS_ASSUME_NONNULL_BEGIN
@interface DRIImagePreviewTagsViewController : UIViewController
@property (nonatomic, copy) void(^dismissBlock)(BOOL done,NSMutableArray *tagsData);
@property (nonatomic, copy) void(^addTagBlock)(NSDictionary *tagData);
@property (nonatomic, copy) void(^deleteTagBlock)(NSDictionary *tagData);

- (instancetype)initWithPHAsset:(PHAsset *)asset;
- (instancetype)initWithTagsRect:(CGRect)tagsRect;
- (instancetype)initWithImage:(UIImage *)image;
- (void)addExistTags:(NSMutableArray *)array;
- (void)doneButtonClick;
@end

NS_ASSUME_NONNULL_END
