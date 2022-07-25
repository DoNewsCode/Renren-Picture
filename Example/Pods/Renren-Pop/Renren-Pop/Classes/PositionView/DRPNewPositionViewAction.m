//
//  DRPNewPositionViewAction.m
//  Renren-Pop
//
//  Created by 李晓越 on 2019/9/3.
//

#import "DRPNewPositionViewAction.h"
#import "DRPNewPositionView.h"

@implementation DRPNewPositionViewAction

+ (instancetype)actionWithPositionList:(NSArray *)positionList
                           resultBlock:(void(^)(NSString *classification,
                                                NSString *positionName,
                                                NSString *positionId))resultBlock
                           handleBlock:(void(^)(NSString *title))handleBlock
{
    DRPNewPositionViewAction *customAlertAction = [[DRPNewPositionViewAction alloc] init];
    
    //    customAlertAction.customHandler = handler;
    
    DRPNewPositionView *positionView = [[DRPNewPositionView alloc] initWithPositionList:positionList resultBlock:resultBlock HandleBlock:handleBlock];
    customAlertAction.style = DNPopActionStyleCustom;
    customAlertAction.item = positionView;
    
    return customAlertAction;
}

@end
