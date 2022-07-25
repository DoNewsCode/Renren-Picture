//
//  DRIImageRequestOperation.h
//  DRIImagePickerControllerFramework
//
//  Created by 谭真 on 2018/12/20.
//  Copyright © 2018 谭真. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRIImageRequestOperation : NSOperation

typedef void(^DRIImageRequestCompletedBlock)(UIImage *photo, NSDictionary *info, BOOL isDegraded);
typedef void(^DRIImageRequestProgressBlock)(double progress, NSError *error, BOOL *stop, NSDictionary *info);

@property (nonatomic, copy, nullable) DRIImageRequestCompletedBlock completedBlock;
@property (nonatomic, copy, nullable) DRIImageRequestProgressBlock progressBlock;
@property (nonatomic, strong, nullable) PHAsset *asset;

@property (assign, nonatomic, getter = isExecuting) BOOL executing;
@property (assign, nonatomic, getter = isFinished) BOOL finished;

- (instancetype)initWithAsset:(PHAsset *)asset completion:(DRIImageRequestCompletedBlock)completionBlock progressHandler:(DRIImageRequestProgressBlock)progressHandler;
- (void)done;
@end

NS_ASSUME_NONNULL_END
