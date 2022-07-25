//
//  DRPScoreViewAction.m
//  Pods
//
//  Created by 李晓越 on 2019/8/15.
//

#import "DRPScoreViewAction.h"
#import "DRPScoreView.h"

@implementation DRPScoreViewAction

+ (instancetype)actionWithGoScoreBlock:(void(^)(void))goScoreBlock
                         feedbackBlock:(void(^)(void))feedbackBlock
                            closeBlock:(void(^)(void))closeBlock
{
    DRPScoreViewAction *customAlertAction = [[DRPScoreViewAction alloc] init];
    
    DRPScoreView *realNameView = [[DRPScoreView alloc] initWithGoScoreBlock:goScoreBlock feedbackBlock:feedbackBlock closeBlock:closeBlock];
    
    customAlertAction.style = DNPopActionStyleCustom;
    customAlertAction.item = realNameView;
    
    return customAlertAction;
}

@end
