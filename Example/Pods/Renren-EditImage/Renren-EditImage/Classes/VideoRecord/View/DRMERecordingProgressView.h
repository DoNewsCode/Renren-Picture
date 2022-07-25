//
//  DRMERecordingProgressView.h
//  Renren-EditImage
//
//  Created by Madjensen on 2019/11/5.
//

#import <UIKit/UIKit.h>

#define TotalTime 600000000
#define MinRecordTime 4000000

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DRMERecordingProgressStatus) {
    UnKnow,
    Start,
    Progressing,
    End,
    Prepare,
};

@interface DRMERecordingProgressView : UIView

@property (assign, nonatomic) DRMERecordingProgressStatus status;
//获取录制有几段
@property (assign, nonatomic, readonly) NSUInteger getCount;
//获取当前值（0-15000000）
@property (assign, nonatomic, readonly) int64_t value;

//开始录制
- (void)beginProgress;
//录制中传递当前的时间占总时间的百分比
- (void)currentValue:(int64_t)value;
//结束录制
- (void)endProgress;
//准备删除
- (void)prepareDelete;
//删除
- (void)deleteProgress;
//获取上一段结束value毫秒
- (int64_t)getValue;
//是否只有一段并且达到了15秒
- (BOOL)singleRecordingOverFifteen;

- (int64_t)getMinRecordTime;

@end

NS_ASSUME_NONNULL_END
