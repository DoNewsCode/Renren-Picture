//
//  DRPAbnormalView.h
//  Renren-Pop
//
//  Created by 李晓越 on 2019/11/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRPAbnormalView : UIView

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                    btnString:(NSString *)btnString
                  showBackBtn:(BOOL)showBackBtn
                clickBtnBlock:(void (^)(void))clickBtnBlock
                   closeBlock:(void(^)(void))closeBlock;

@end

NS_ASSUME_NONNULL_END
