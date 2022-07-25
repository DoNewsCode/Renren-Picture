//
//  DRIPictureBrowseTransitionParameter.m
//  LYCustomTransitionDemo
//
//  Created by liyang on 2017/12/5.
//  Copyright © 2017年 liyang. All rights reserved.
//

#import "DRIPictureBrowseTransitionParameter.h"
#import "DRIImagePickerController.h"
@implementation DRIPictureBrowseTransitionParameter

- (void)setTransitionImage:(UIImage *)transitionImage{
    _transitionImage = transitionImage;
    
    _secondVCImgFrame = [self backScreenImageViewRectWithImage:transitionImage];
}
- (void)setTransitionImgIndex:(NSInteger)transitionImgIndex{
    if (transitionImgIndex < _firstVCImgFrames.count) {
        _transitionImgIndex = transitionImgIndex;
    }else{
        _transitionImgIndex = _firstVCImgFrames.count - 1;
    }
    _firstVCImgFrame = [_firstVCImgFrames[_transitionImgIndex] CGRectValue];
}

//返回imageView在window上全屏显示时的frame
- (CGRect)backScreenImageViewRectWithImage:(UIImage *)image{
    CGFloat statusBarHeight = [DRICommonTools dri_statusBarHeight];
    CGFloat statusBarHeightInterval = statusBarHeight - 20;
    CGFloat naviBarHeight = statusBarHeight + 44;
    CGFloat toolBarHeight = [DRICommonTools dri_isIPhoneX] ? 44 + (83 - 49) : 44;
    if (_imageViewFullScreen){
        CGRect nextViewFrame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
//        if (!_imageViewFullScreen) {
//            nextViewFrame = CGRectMake(0, naviBarHeight, SCREENWIDTH, SCREENHEIGHT - naviBarHeight - toolBarHeight);
//        }
        CGSize size = image.size;
        CGSize newSize;
        newSize.width = SCREENWIDTH;
        newSize.height = newSize.width / size.width * size.height;
        if (newSize.height > nextViewFrame.size.height) {
            newSize.height = nextViewFrame.size.height;
        }
        if (isnan(newSize.height)) {
            newSize.height = 0;
        }
        if (isnan(newSize.width)) {
            newSize.width = 0;
        }
        CGFloat imageY = nextViewFrame.origin.y + (nextViewFrame.size.height - newSize.height) * 0.5;
        
        if (imageY < 0) {
            imageY = 0;
        }
        CGRect rect;
        rect = CGRectMake(0, imageY, newSize.width, newSize.height);
        //    if (_imageViewFullScreen) {
        //    } else{
        //        rect =  CGRectMake(0, naviBarHeight + imageY, newSize.width, newSize.height);
        //    }
        return rect;
    }else{
        CGSize size = image.size;
        CGSize newSize;
        newSize.width = SCREENWIDTH;
        newSize.height = newSize.width / size.width * size.height;

        CGFloat imageY = (SCREENHEIGHT - newSize.height) * 0.5;

        if (imageY < 0) {
            imageY = 0;
        }
        CGRect rect =  CGRectMake(0, naviBarHeight, SCREENWIDTH, SCREENHEIGHT - naviBarHeight - toolBarHeight);
        return rect;
    }
    
}

@end
