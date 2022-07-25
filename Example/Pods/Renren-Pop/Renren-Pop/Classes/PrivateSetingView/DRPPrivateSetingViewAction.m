//
//  DRPPrivateSetingViewAction.m
//  Renren-Pop
//
//  Created by 李晓越 on 2019/11/5.
//

#import "DRPPrivateSetingViewAction.h"
#import "DRPPrivateSetingView.h"

@implementation DRPPrivateSetingViewAction

+ (instancetype)actionWithTitle:(NSString *)title
                     attrString:(NSMutableAttributedString *)attrString
                      btnString:(NSString *)btnString
                   toSetUpBlock:(void(^)(void))toSetUpBlock
                 clickLinkBlock:(void(^)(NSURL *URL))clickLinkBlock
                     closeBlock:(void(^)(void))closeBlock
{
    DRPPrivateSetingViewAction *customAlertAction = [[DRPPrivateSetingViewAction alloc] init];
       
    DRPPrivateSetingView *item = [[DRPPrivateSetingView alloc] initWithTitle:title attrString:attrString btnString:btnString toSetUpBlock:toSetUpBlock clickLinkBlock:clickLinkBlock closeBlock:closeBlock];

       customAlertAction.style = DNPopActionStyleCustom;
       customAlertAction.item = item;
       
       return customAlertAction;
}

@end
