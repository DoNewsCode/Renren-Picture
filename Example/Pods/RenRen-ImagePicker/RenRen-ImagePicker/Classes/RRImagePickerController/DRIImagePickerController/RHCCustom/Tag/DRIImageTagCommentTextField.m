//
//  DRIImageTagCommentTextField.m
//  RenRen-ImagePicker
//
//  Created by 张健康 on 2019/7/2.
//

#import "DRIImageTagCommentTextField.h"


static const UIEdgeInsets kDRIInsets = {0, 10, 0, 20};

@implementation DRIImageTagCommentTextField

- (CGRect)editingRectForBounds:(CGRect)bounds;
{
    [super editingRectForBounds:bounds];
    return UIEdgeInsetsInsetRect(bounds, kDRIInsets);
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    [super textRectForBounds:bounds];
    return UIEdgeInsetsInsetRect(bounds, kDRIInsets);
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    [super placeholderRectForBounds:bounds];
    return UIEdgeInsetsInsetRect(bounds, kDRIInsets);
}

@end
