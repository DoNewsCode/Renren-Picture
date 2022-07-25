//
//  DRMEGlobalModuleRouter.m
//
//  Created by Ming on 2019/5/6.
//

#import "DRMEGlobalModuleRouter.h"
#import "DNRouter.h"

#import "DRMEPhotoEditViewController.h" // 照片编辑页

@implementation DRMEGlobalModuleRouter

+ (void)load {
    
    // 确认router是有的
    // 注册照片编辑页
    [DNRouter registerURLPattern:RRMEPhotoEdit toHandler:^(NSDictionary *routerParameters) {
        
        UINavigationController *navigationVC = routerParameters[DNRouterParameterUserInfo][@"navigationVC"];
        UIImage *originImage = routerParameters[DNRouterParameterUserInfo][@"originImage"];
        NSArray *tagsDict = routerParameters[DNRouterParameterUserInfo][@"tagsDict"];
        BOOL isFromChat = [routerParameters[DNRouterParameterUserInfo][@"isFromChat"] boolValue];
        
        void(^completeBlock)(id result) = routerParameters[DNRouterParameterCompletion];
                
        DRMEPhotoEditViewController *photoEditVc = [[DRMEPhotoEditViewController alloc] init];
        photoEditVc.originImage = originImage;
        photoEditVc.tagsDict = tagsDict;
        photoEditVc.isFromChat = isFromChat;
        [navigationVC pushViewController:photoEditVc animated:YES];
        
        photoEditVc.photoEditTagCompleteBlock = ^(UIImage * _Nonnull editImage, NSMutableArray * _Nonnull tagsArray) {
          
            tagsArray = tagsArray;
            
            if (completeBlock) {
                NSDictionary *result = @{@"editImage" : editImage,
                                         @"tagsArray" : tagsArray};
                completeBlock(result);
            }
        };
    }];
    
}

@end
