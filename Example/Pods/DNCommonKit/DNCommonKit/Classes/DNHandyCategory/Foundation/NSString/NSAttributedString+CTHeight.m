//
//  NSAttributedString+CTHeight.m
//  DNCommonKit
//
//  Created by Ming on 2020/5/12.
//

#import "NSAttributedString+CTHeight.h"

@implementation NSAttributedString (CTHeight)

- (CGFloat)ct_heightParagraphSpeace:(CGFloat)lineSpeace withFont:(UIFont*)font width:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    /** 行高 */
    paraStyle.lineSpacing = lineSpeace;
    // NSKernAttributeName字体间距
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f };
    CGSize size = [self.string boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

@end
