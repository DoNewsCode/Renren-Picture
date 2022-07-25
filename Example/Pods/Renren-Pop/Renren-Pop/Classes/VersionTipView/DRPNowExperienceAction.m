//
//  DRPNowExperienceAction.m
//  Pods
//
//  Created by 李晓越 on 2019/8/15.
//

#import "DRPNowExperienceAction.h"
#import "DRPNowExperience.h"

@implementation DRPNowExperienceAction

+ (instancetype)actionWithTitle:(NSString *)title
                      tipString:(NSString *)tipString
             nowExperienceBlock:(void(^)(void))nowExperienceBlock
                     closeBlock:(void(^)(void))closeBlock
{
    DRPNowExperienceAction *customAlertAction = [[DRPNowExperienceAction alloc] init];
    
    DRPNowExperience *realNameView = [[DRPNowExperience alloc] initWithTitle:title tipString:tipString nowExperienceBlock:nowExperienceBlock closeBlock:closeBlock];
    
    customAlertAction.style = DNPopActionStyleCustom;
    customAlertAction.item = realNameView;
    
    return customAlertAction;
}

@end
