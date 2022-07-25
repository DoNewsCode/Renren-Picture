//
//  DRFTFilterModel+DRMEExtension.h
//  Renren-EditImage
//
//  Created by 李晓越 on 2020/3/17.
//

#import "DRFTFilterModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRFTFilterModel (DRMEExtension)

@property(nonatomic,assign, getter=isSelected) BOOL selected;
@property(nonatomic,assign) CGFloat currentIntensity;
/** 是否是原图 */
@property(nonatomic,assign, getter=isOriginalImage) BOOL originalImage;

@end

NS_ASSUME_NONNULL_END
