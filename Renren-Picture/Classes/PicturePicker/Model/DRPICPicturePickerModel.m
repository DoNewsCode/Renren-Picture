//
//  DRPICPicturePickerModel.m
//  Renren-Picture
//
//  Created by Ming on 2020/3/11.
//

#import "DRPICPicturePickerModel.h"

@implementation DRPICPicturePickerModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.allowPickingVideo = YES;
        self.allowPickingImage = YES;
    }
    return self;
}

- (NSMutableArray<DRPICPicture *> *)selectedPictures {
    if (!_selectedPictures) {
        NSMutableArray<DRPICPicture *> *selectedPictures = [NSMutableArray<DRPICPicture *> array];
        _selectedPictures = selectedPictures;
    }
    return _selectedPictures;
}

@end
