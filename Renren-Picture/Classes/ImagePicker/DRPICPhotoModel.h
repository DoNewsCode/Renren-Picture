//
//  DRPICPhotoModel.h
//  Renren-Picture
//
//  Created by Luis on 2020/3/2.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

typedef void(^DRPICFetchPhotoModelCompletion)(void);

@interface DRPICPhotoModel : NSObject
/**相片*/
@property(nonatomic, strong)PHAsset *asset;
/**高清相片*/
@property(nonatomic, strong)UIImage *highDefinitionImage;
@property(nonatomic, copy)DRPICFetchPhotoModelCompletion fetchPhotoModelCompletion;

@end


