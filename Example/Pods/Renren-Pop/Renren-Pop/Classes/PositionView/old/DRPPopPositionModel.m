//
//  DRPPopPositionModel.m
//  Renren-Pop
//
//  Created by 李晓越 on 2019/9/3.
//

#import "DRPPopPositionModel.h"

//@implementation DRPPopPositionChoiceModel
//
//
//@end

@implementation DRPPopPositionModel

- (NSString *)classification
{
    NSArray *array = [_classification componentsSeparatedByString:@":"];
    if (array.count >= 2 ) {
        return array[1];
    }
    return _classification;
}


@end
