//
//  DRPICPicturePreviewChannelModel.m
//  Renren-Picture
//
//  Created by Ming on 2020/3/17.
//

#import "DRPICPicturePreviewChannelModel.h"

@implementation DRPICPicturePreviewChannelModel

- (NSMutableArray<DRPICPicture *> *)pictures {
    if (!_pictures) {
        NSMutableArray<DRPICPicture *> *pictures = [NSMutableArray<DRPICPicture *> array];
        _pictures = pictures;
    }
    return _pictures;
}

@end
