//
//  DRPICPicturePickerViewModel.m
//  Renren-Picture
//
//  Created by Ming on 2020/3/11.
//

#import <Photos/Photos.h>

#import "DRPICPicturePickerViewModel.h"

#import "DRPICPictureManager.h"

@interface DRPICPicturePickerViewModel ()

@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end

@implementation DRPICPicturePickerViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)createAlbumComplete:(DRPICPicturePickerViewModelCompleteBlock)complete {
    __weak typeof(self) weakSelf = self;
    [[DRPICPictureManager sharedPictureManager] obtainAlbumWithAllowPickingVideo:self.model.allowPickingVideo allowPickingImage:self.model.allowPickingImage complete:^(BOOL success, NSMutableArray<DRPICAlbum *> * _Nonnull albums) {
        weakSelf.model.albums = albums;
        weakSelf.model.currentAlbum = albums.firstObject;
        if (complete) {
            complete(YES);
        }
    }];
}




- (BOOL)processSelectedPicture:(DRPICPicture *)picture {
    if (self.model.selectedPictures.count >= self.model.selectedPicturesMaxCount) {
        return NO;
    }
    if (picture.status.selected == NO) {
        picture.status.selected = YES;
    }
    if ([self.model.selectedPictures containsObject:picture] == NO && picture) {
        [self.model.selectedPictures addObject:picture];
        picture.status.selectedIndex = self.model.selectedPictures.count;
    }
    
    self.levitateView.count = self.model.selectedPictures.count;
    if (self.model.selectedPictures.count > 0 && self.levitateView.hidden != NO) {
        [self.levitateView setHidden:NO animaed:YES];
    }
    
    if (self.model.selectedPictures.count >= self.model.selectedPicturesMaxCount) {
        for (DRPICAlbum *album in self.model.albums) {
            for (DRPICPicture *picture in album.pictures) {
                if (picture.status.selected == NO) {
                    picture.status.enabled = NO;
                }
            }
        }
    }
    
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
        for (NSInteger i = index; i < self.model.selectedPictures.count; i++) {
            DRPICPicture *subPicture = self.model.selectedPictures[i];
            subPicture.status.selectedIndex -= 1;
        }
    }
    self.levitateView.count = self.model.selectedPictures.count;
    if (self.model.selectedPictures.count > 0 && self.levitateView.hidden != NO) {
        [self.levitateView setHidden:NO animaed:YES];
    }
    return YES;
}

- (NSOperationQueue *)operationQueue {
    if (!_operationQueue) {
        NSOperationQueue *operationQueue = [NSOperationQueue new];
        operationQueue.maxConcurrentOperationCount = 1; // 并发数为1
        _operationQueue = operationQueue;
    }
    return _operationQueue;
}

- (DRPICPicturePickerModel *)model {
    if (!_model) {
        DRPICPicturePickerModel *model = [DRPICPicturePickerModel new];
        _model = model;
    }
    return _model;
}

- (DRPICPicturePickerLevitateView *)levitateView {
    if (!_levitateView) {
        CGFloat height = 82;
        if ([UIApplication sharedApplication].statusBarFrame.size.height > 20) {
            height += 34;
        }
        DRPICPicturePickerLevitateView *levitateView = [[DRPICPicturePickerLevitateView alloc] initWithFrame:CGRectMake(0, 0, [UIApplication sharedApplication].keyWindow.bounds.size.width, height)];
        _levitateView = levitateView;
    }
    return _levitateView;
}

@end
