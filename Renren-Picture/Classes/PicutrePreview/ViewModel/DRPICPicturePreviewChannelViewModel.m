//
//  DRPICPicturePreviewChannelViewModel.m
//  Renren-Picture
//
//  Created by Ming on 2020/3/17.
//

#import "DRPICPicturePreviewChannelViewModel.h"

@implementation DRPICPicturePreviewChannelViewModel


- (DRPICPicturePreviewChannelModel *)model {
    if (!_model) {
        DRPICPicturePreviewChannelModel *model = [DRPICPicturePreviewChannelModel new];
        _model = model;
    }
    return _model;
}

@end
