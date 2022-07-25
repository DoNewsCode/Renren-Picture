//
//  DRMEGetTopicsModel.h
//  Renren-EditImage
//
//  Created by 李晓越 on 2020/2/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface DRMERecentFiveTopic :NSObject
@property (nonatomic , copy) NSString              *count;

@end

@interface DRMETopicList :NSObject
@property (nonatomic , copy) NSString              *topic_id;
@property (nonatomic , copy) NSString              *title;
@property (nonatomic , copy) NSString              *suffix;
@property (nonatomic , copy) NSString              *create_time;
@property (nonatomic , copy) NSString              *summary_thumb_url;
@property (nonatomic , copy) NSString              *share_description;

@end

@interface DRMEGetTopicsModel :NSObject
@property (nonatomic , copy) NSString              *size;
@property (nonatomic , strong) DRMERecentFiveTopic     *recentFiveTopic;
@property (nonatomic , copy) NSString              *show_count;
@property (nonatomic , copy) NSArray<DRMETopicList *>             *topic_list;

@end

NS_ASSUME_NONNULL_END
