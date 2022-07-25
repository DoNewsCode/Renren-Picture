//
//  DRPJoinGroupAction.m
//  Renren-Pop
//
//  Created by 李晓越 on 2019/11/15.
//

#import "DRPJoinGroupAction.h"
#import "DRPJoinGroupView.h"

@implementation DRPJoinGroupAction

+ (instancetype)actionWith:(NSString *)groupName
                 groupDesc:(NSString *)groupDesc
              groupIconUrl:(NSString *)groupIconUrl
               placeholder:(NSString *)placeholder
                 joinBlock:(void (^)(NSString *joinReason))joinBlock
                closeBlock:(void(^)(void))closeBlock
{
    DRPJoinGroupAction *customAlertAction = [[DRPJoinGroupAction alloc] init];
       
    DRPJoinGroupView *realNameView = [[DRPJoinGroupView alloc] initWith:groupName groupDesc:groupDesc groupIconUrl:groupIconUrl placeholder:placeholder joinBlock:joinBlock closeBlock:closeBlock];
       customAlertAction.style = DNPopActionStyleCustom;
       customAlertAction.item = realNameView;
       
       return customAlertAction;
}

@end
