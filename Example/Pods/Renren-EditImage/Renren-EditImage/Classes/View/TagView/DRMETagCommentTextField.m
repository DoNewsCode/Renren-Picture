//
//  DRIImageTagCommentTextField.m
//

#import "DRMETagCommentTextField.h"


static const UIEdgeInsets kDRIInsets = {0, 10, 0, 20};

@implementation DRMETagCommentTextField

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
