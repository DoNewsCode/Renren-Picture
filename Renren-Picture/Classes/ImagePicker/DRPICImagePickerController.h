//
//  DRPICImagePickerController.h
//  Pods
//
//  Created by Luis on 2020/3/2.
//

#import "DRBBaseViewController.h"

@class DRPICPhotoModel;

NS_ASSUME_NONNULL_BEGIN
typedef void(^DRPICImagePickerDidFinishPickingHandler)(NSMutableArray<DRPICPhotoModel *> *photoList);
typedef void(^DRPICImagePickerDidCancelPickingHandler)(void);


@interface DRPICImagePickerController : DRBBaseViewController
/**选完照片回调*/
@property(nonatomic, copy)DRPICImagePickerDidFinishPickingHandler imagePickerDidFinishPickinghandler;
@property(nonatomic, copy)DRPICImagePickerDidCancelPickingHandler imagePickerDidCancelPickinghandler;
/**最多选取照片数*/
@property(nonatomic, assign)NSInteger maxCount;
/**是否单选, 默认NO, 若为单选, 则maxCount值为1*/
@property(nonatomic, assign)BOOL isMultiSelection;


@end

NS_ASSUME_NONNULL_END
