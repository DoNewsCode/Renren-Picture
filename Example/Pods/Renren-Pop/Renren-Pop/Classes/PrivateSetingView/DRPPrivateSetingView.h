//
//  DRPPrivateSetingView.h
//  Renren-Pop
//
//  Created by 李晓越 on 2019/11/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRPPrivateSetingView : UIView

- (instancetype)initWithTitle:(NSString *)title
                   attrString:(NSMutableAttributedString *)attrString  
                    btnString:(NSString *)btnString
                 toSetUpBlock:(void(^)(void))toSetUpBlock
               clickLinkBlock:(void(^)(NSURL *URL))clickLinkBlock
                   closeBlock:(void(^)(void))closeBlock;

@end

NS_ASSUME_NONNULL_END
