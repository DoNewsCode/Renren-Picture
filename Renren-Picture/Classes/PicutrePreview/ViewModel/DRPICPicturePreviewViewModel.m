//
//  DRPICPicturePreviewViewModel.m
//  Renren-Picture
//
//  Created by Ming on 2020/3/17.
//

#import "DRPICPicturePreviewViewModel.h"

@implementation DRPICPicturePreviewViewModel



- (BOOL)processSelectedPicture:(DRPICPicture *)picture {
    if (self.model.selectedPictures.count >= self.model.selectedPicturesMaxCount) {
        return NO;
    }
    if (picture.status.selected == NO) {
        picture.status.selected = YES;
    }
    if ([self.model.selectedPictures containsObject:picture] == NO) {
        [self.model.selectedPictures addObject:picture];
        self.model.selectedPicturesCount += 1;
        picture.status.selectedIndex = self.model.selectedPictures.count;
    }
    
    [self processContent];
    return YES;
}

- (BOOL)processCancelSelectedPicture:(DRPICPicture *)picture {
    if (picture.status.selected == YES) {
        picture.status.selected = NO;
    }
    if (self.model.selectedPictures.count >= self.model.selectedPicturesMaxCount) {
             for (DRPICAlbum *album in self.model.albums) {
                 for (DRPICPicture *picture in album.pictures) {
                     if (picture.status.selected == NO) {
                         picture.status.enabled = YES;
                     }
                 }
             }
         }
    if ([self.model.selectedPictures containsObject:picture] == YES) {// 选中序号排序
           NSUInteger index = [self.model.selectedPictures indexOfObject:picture];
           [self.model.selectedPictures removeObject:picture];
        self.model.selectedPicturesCount -= 1;
           for (NSInteger i = index; i < self.model.selectedPictures.count; i++) {
               DRPICPicture *subPicture = self.model.selectedPictures[i];
               subPicture.status.selectedIndex -= 1;
           }
       }
    [self processContent];
    return YES;
}

- (void)processContent {
    if (self.model.selectedPictures.count > 0) {
        self.previewChannelViewController.view.hidden = NO;
    } else {
        self.previewChannelViewController.view.hidden = YES;
    }
    if (self.levitateView.orginalButton.selected) {
        self.levitateView.size = @"12.5M";
    } else {
        self.levitateView.size = @"";
    }
    self.levitateView.count = self.model.selectedPictures.count;
    [self.levitateView layoutSubviews];
}


	
- (DRPICPicturePreviewModel *)model {
    if (!_model) {
        DRPICPicturePreviewModel *model = [DRPICPicturePreviewModel new];
        _model = model;
    }
    return _model;
}

- (DRPICPicturePreviewLevitateView *)levitateView {
    if (!_levitateView) {
        CGFloat height = 49;
        if ([UIApplication sharedApplication].statusBarFrame.size.height > 20) {
            height += 34;
        }
        DRPICPicturePreviewLevitateView *levitateView = [[DRPICPicturePreviewLevitateView alloc] initWithFrame:CGRectMake(0, 0, [UIApplication sharedApplication].keyWindow.bounds.size.width, height)];
        levitateView.nextStepButton.title = @"完成";
        levitateView.nextStepButton.count = self.model.selectedPictures.count;
        _levitateView = levitateView;
    }
    return _levitateView;
}

- (DRPICPicturePreviewChannelViewController *)previewChannelViewController {
    if (!_previewChannelViewController) {
        DRPICPicturePreviewChannelViewController *previewChannelViewController = [DRPICPicturePreviewChannelViewController new];
        previewChannelViewController.view.hidden = self.model.selectedPicturesCount > 0 ? NO : YES;
        _previewChannelViewController = previewChannelViewController;
    }
    return _previewChannelViewController;
}

@end
