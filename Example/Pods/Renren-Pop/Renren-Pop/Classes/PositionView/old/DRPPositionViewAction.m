//
//  DRPPositionViewAction.m
//  Renren-Pop
//
//  Created by 李晓越 on 2019/9/3.
//

#import "DRPPositionViewAction.h"
#import "DRPPositionView.h"

@implementation DRPPositionViewAction

+ (instancetype)actionWithResultBlock:(void(^)(NSString *classification,
                                               NSString *positionName,
                                               NSString *positionId))resultBlock
                          HandleBlock:(void(^)(NSString *title))handleBlock
{
    DRPPositionViewAction *customAlertAction = [[DRPPositionViewAction alloc] init];
    
    //    customAlertAction.customHandler = handler;
    
    DRPPositionView *positionView = [[DRPPositionView alloc] initWithhResultBlock:resultBlock HandleBlock:handleBlock];
    customAlertAction.style = DNPopActionStyleCustom;
    customAlertAction.item = positionView;
    
    return customAlertAction;
}

@end
