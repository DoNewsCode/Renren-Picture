//
//  DRMETagTagsModel.h
//  Renren-EditImage
//
//  Created by 李晓越 on 2019/11/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSUInteger, DRMETagDirection) {
    DRMETagDirectionRight = 0,  // 文字朝右
    DRMETagDirectionLeft = 1,   // 文字朝左
};

typedef NS_ENUM(NSUInteger, DRMETagType) {
    DRMETagTypeDefault = 1, // 默认
    DRMETagTypeAt,          // @ 好友
    DRMETagTypeTopic,       // 话题
    DRMETagTypeAddress,     // 地址
};

@interface DRMETagModel : NSObject

@property(nonatomic,assign) DRMETagType recentUsedType;
@property(nonatomic,assign) DRMETagDirection tagDirection;

@property(nonatomic,copy) NSString *text;
@property(nonatomic,assign) CGPoint tagPoint;

@end

NS_ASSUME_NONNULL_END
