//
//  DRMEGlobalModuleRouter.h
//
//  Created by Ming on 2019/5/6.
//

#import <Foundation/Foundation.h>

/// 照片编辑页
/// @"navigationVC" : 导航控制器
/// @"originImage" : UIImage 原图
/// DNRouterParameterCompletion，会返回编辑后的UIImage

static NSString * RRMEPhotoEdit = @"RR://MaterialEditor/PhotoEdit";

@interface DRMEGlobalModuleRouter : NSObject

@end
