//
//  DRPPositionView.h
//  Renren-Pop
//
//  Created by 李晓越 on 2019/9/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



@interface DRPPositionView : UIView

- (instancetype)initWithhResultBlock:(void(^)(NSString *classification,
                                              NSString *positionName,
                                              NSString *positionId))resultBlock
                         HandleBlock:(void(^)(NSString *title))handleBlock;

@end

NS_ASSUME_NONNULL_END
