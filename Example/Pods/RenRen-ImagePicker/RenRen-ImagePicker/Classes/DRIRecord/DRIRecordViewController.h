//
//  DRIRecordViewController.h
//  短视频录制
//
//  Created by lihaohao on 2017/5/19.
//  Copyright © 2017年 低调的魅力. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DRIRecordDelegate <NSObject>
- (void)recordViewController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
@end

@interface DRIRecordViewController : UIViewController
@property (nonatomic, assign) BOOL onlyTakePhoto;
@property (nonatomic, assign) BOOL onlyTakeVideo;
@property (nonatomic, weak) id<DRIRecordDelegate> delegate;
@end
