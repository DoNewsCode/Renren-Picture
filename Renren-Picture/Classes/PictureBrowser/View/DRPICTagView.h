//
//  DRPICTagView.h
//  Renren-Picture
//
//  Created by 陈金铭 on 2019/9/24.
//

#import <UIKit/UIKit.h>

#import "DRPICPicture.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRPICTagView : UIView

@property(nonatomic, strong) DRPICPictureTag *pictureTag;
@property(nonatomic, assign) BOOL loaded;
@property (nonatomic, copy) NSString *tagTitle;

@property (nonatomic, strong) UIImageView *tagPositionImageView;

- (instancetype)initWithPictureTag:(DRPICPictureTag *)pictureTag;

@end

NS_ASSUME_NONNULL_END
