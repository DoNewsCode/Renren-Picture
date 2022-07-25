//
//  DRPNowExperience.h
//  DNPop
//
//  Created by 李晓越 on 2019/8/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRPNowExperience : UIView

- (instancetype)initWithTitle:(NSString *)title
                    tipString:(NSString *)tipString
           nowExperienceBlock:(void(^)(void))nowExperienceBlock
                   closeBlock:(void(^)(void))closeBlock;

@end

NS_ASSUME_NONNULL_END
