//
//  DRPActivityViewAction.m
//  Pods
//

#import "DRPActivityViewAction.h"
#import "DRPActivityView.h"

@implementation DRPActivityViewAction

+ (instancetype)actionWithImage:(UIImage *)image
                   handlerBlock:(void(^)(void))handlerBlock
                     closeBlock:(void(^)(void))closeBlock
{
    DRPActivityViewAction *customAlertAction = [[DRPActivityViewAction alloc] init];
    
    DRPActivityView *realNameView = [[DRPActivityView alloc] initWithWithImage:image handlerBlock:handlerBlock closeBlock:closeBlock];
    customAlertAction.style = DNPopActionStyleCustom;
    customAlertAction.item = realNameView;
    
    return customAlertAction;
}

@end
