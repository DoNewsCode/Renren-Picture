//
//  DRPPickerView.h
//  Pods
//
//  Created by 李晓越 on 2019/7/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRPPickerView : UIView

- (instancetype)initWithTitle:(NSString *)title
                  cancelTitle:(NSString *)cancelTitle
                    doneTitle:(NSString *)doneTitle
                    listArray:(NSArray *)listArray
                 handlerBlock:(void (^)(NSInteger index, NSString *title))handlerBlock
                  cancelBlock:(void (^)(void))cancelBlock;

@end

NS_ASSUME_NONNULL_END
