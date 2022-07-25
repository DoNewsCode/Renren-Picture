//
//  DRPActionSheetView.h
//  Pods
//
//  Created by 李晓越 on 2019/8/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRPActionSheetView : UIView


- (instancetype)initWithTitleArray:(NSArray<NSString *>*)titleArray
                lastBtnShowRedFont:(BOOL)lastBtnShowRedFont
                       handleBlock:(void(^)(NSString *title))handleBlock;

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                numberOfLines:(NSInteger)numberOfLines
                   titleArray:(NSArray<NSString *>*)titleArray
           lastBtnShowRedFont:(BOOL)lastBtnShowRedFont
                  handleBlock:(void(^)(NSString *title))handleBlock;



- (instancetype)initWithTitleArray:(NSArray<NSString *>*)titleArray
               firstBtnShowRedFont:(BOOL)firstBtnShowRedFont
                       handleBlock:(void(^)(NSString *title))handleBlock;



@end

NS_ASSUME_NONNULL_END
