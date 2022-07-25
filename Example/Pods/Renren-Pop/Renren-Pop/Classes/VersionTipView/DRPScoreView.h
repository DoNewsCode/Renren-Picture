//
//  DRPScoreView.h
//  DNPop
//
//  Created by 李晓越 on 2019/8/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRPScoreView : UIView

- (instancetype)initWithGoScoreBlock:(void(^)(void))goScoreBlock
                       feedbackBlock:(void(^)(void))feedbackBlock
                          closeBlock:(void(^)(void))closeBlock;

@end

NS_ASSUME_NONNULL_END
