//
//  DRPICAlbumView.h
//  Renren-Picture
//
//  Created by Luis on 2020/3/2.
//

#import <UIKit/UIKit.h>

@class DRPICAlbumModel;

typedef void(^SelectAlbumCompletion)(DRPICAlbumModel *albumModel);

@interface DRPICAlbumView : UIView

+ (void)showAlbumView:(NSMutableArray<DRPICAlbumModel *> *)assetCollectionList navigationBarMaxY:(CGFloat)navigationBarMaxY completion:(SelectAlbumCompletion)completion;

@end


