//
//  DRPPerfectInformationAction.m
//  Pods
//

#import "DRPPerfectInformationAction.h"
#import "DRPPerfectInformationView.h"

@implementation DRPPerfectInformationAction

+ (instancetype)actionWithHandlerBlock:(void(^)(void))handlerBlock
                            closeBlock:(void(^)(void))closeBlock
{
    DRPPerfectInformationAction *customAlertAction = [[DRPPerfectInformationAction alloc] init];
    
    DRPPerfectInformationView *realNameView = [[DRPPerfectInformationView alloc] initWithHandlerBlock:handlerBlock closeBlock:closeBlock];
    customAlertAction.style = DNPopActionStyleCustom;
    customAlertAction.item = realNameView;
    
    return customAlertAction;
}

@end
