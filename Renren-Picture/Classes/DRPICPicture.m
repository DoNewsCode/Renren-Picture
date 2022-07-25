//
//  DRPICPicture.m
//  Renren-Picture
//
//  Created by 陈金铭 on 2019/9/24.
//

#import "DRPICPicture.h"

@implementation DRPICPicture



- (DRPICPictureStatus *)status {
    if (!_status) {
        DRPICPictureStatus *status = [DRPICPictureStatus new];
        _status = status;
    }
    return _status;
}

- (DRPICPictureSource *)source {
    if (!_source) {
        DRPICPictureSource *source = [DRPICPictureSource new];
        _source = source;
    }
    return _source;
}

- (NSMutableArray<DRPICPictureTag *> *)tags {
    if (!_tags) {
        NSMutableArray<DRPICPictureTag *> *tags = [NSMutableArray<DRPICPictureTag *>  array];
        _tags = tags;
    }
    return _tags;
}

@end

@implementation DRPICPictureStatus
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.enabled = YES;
    }
    return self;
}

@end

@implementation DRPICPictureSource

- (void)setOriginUrlString:(NSString *)originUrlString {
    _originUrlString = originUrlString;
    
}

- (void)setEditedImage:(UIImage *)editedImage {
    _editedImage = editedImage;
}

- (DRPICPictureExtension)extension {
    if (_extension == DRPICPictureExtensionNone) {
        DRPICPictureExtension extension = DRPICPictureExtensionNone;
        NSString *extensionString = [self.originUrlString pathExtension];
        if ([extensionString isEqualToString:@"png"]) {
            extension = DRPICPictureExtensionPNG;
        } else if ([extensionString isEqualToString:@"jpg"] || [extensionString isEqualToString:@"jpeg"]) {
            extension = DRPICPictureExtensionJPEG;
        } else if ([extensionString isEqualToString:@"gif"]) {
            extension = DRPICPictureExtensionGIF;
        } else {
           extension = DRPICPictureExtensionUnknown;
        }
        _extension = extension;
    }
    return _extension;
}
@end

@implementation DRPICPictureTag

@end
