//
//  DRMEChooseColorView.h
//  Renren-EditImage
//
//  Created by 李晓越 on 2019/11/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ChooseBackColorBlock)(BOOL isSelected);
typedef void(^ChooseColorBlock)(NSString *colorStr);

@interface DRMEChooseColorView : UIView

- (instancetype)initWithIsSelectedT:(BOOL)isSelectedT
                   selectedColorStr:(NSString *)selectedColorStr;

@property(nonatomic,copy) ChooseBackColorBlock chooseBackColorBlock;
@property(nonatomic,copy) ChooseColorBlock chooseColorBlock;

@end

NS_ASSUME_NONNULL_END
