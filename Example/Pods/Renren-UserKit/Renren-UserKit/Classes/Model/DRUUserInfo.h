//
// DRUUserInfo.h
// Renren-UserKit
//
// Created by 李晓越 on 2019/9/11.
// 用户登录后个人信息类

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface DRUProfileInfoBirth :NSObject
@property (nonatomic , assign) NSInteger  year;
@property (nonatomic , assign) NSInteger  month;
@property (nonatomic , assign) NSInteger  day;

@end

@interface DRUProfileInfoRegionInfo :NSObject
@property (nonatomic , assign) NSInteger  id;
@property (nonatomic , copy) NSString  * province_name;
@property (nonatomic , assign) NSInteger  user_id;
@property (nonatomic , copy) NSString  *region_id;
@property (nonatomic , copy) NSString  * city_name;

@end

@interface DRUProfileInfoUserSign :NSObject
@property (nonatomic , assign) NSInteger  voice_size;
@property (nonatomic , assign) NSInteger  voice_length;
@property (nonatomic , assign) NSInteger  voice_rate;
@property(nonatomic,copy) NSString *content;

@end

@interface DRUProfileInfoRecentEducationWork : NSObject

//"id": 0,
@property(nonatomic,assign) NSInteger id;
//"name": "北京吹牛股份有限公司",
@property(nonatomic,copy) NSString *name;
//"type": 0
@property(nonatomic,assign) NSInteger type;

@end


@interface DRUUserInfo : NSObject

/** 用户主播实名认证状态 0：没有进行实名认证 1：实名认证通过 2：正在进行审核 */
@property(nonatomic,assign) NSInteger AnchorAuthStatus;
/** 是否绑定手机号：true 需要绑定且已绑定或者根本不需要绑定 false需要绑定但是还没绑定 */
@property(nonatomic,assign) BOOL bindMobile;
/** 当前时间戳 毫秒级别 */
@property(nonatomic,assign) NSTimeInterval currentTime;
/** 是否有访问权限（0:有，1：没有） --- 貌似没有什么用*/
@property(nonatomic,assign) NSInteger has_right;
/** 100宽度 用户头像 */
@property(nonatomic,copy) NSString *head_url;
/** 用户头像 */
@property(nonatomic,copy) NSString *large_url;
/** 200宽度 用户头像 */
@property(nonatomic,copy) NSString *main_url;
/** 50宽度 用户头像 */
@property(nonatomic,copy) NSString *tiny_url;
/** 用户id */
@property(nonatomic,copy) NSString *userid;
/** 用户昵称 */
@property(nonatomic,copy) NSString *userName;
/** 用户设置了多久 新鲜事可见时长 */
@property(nonatomic,copy) NSString *owner_feed_limit_time;

@property(nonatomic,copy) NSString *realname;
@property(nonatomic,strong) DRUProfileInfoRecentEducationWork *recent_education_work;
@property (nonatomic , assign) BOOL  is_admin;
@property (nonatomic , copy) NSString  *friend_count;
@property (nonatomic , strong) DRUProfileInfoBirth  * birth;
@property (nonatomic , assign) NSInteger  is_default_head;
@property (nonatomic , assign) NSInteger  visitor_count;
@property (nonatomic , assign) BOOL  show_emotion;
//@property (nonatomic , copy) NSString  * user_name;
@property (nonatomic , assign) NSInteger pub_count;
@property (nonatomic , assign) NSInteger  anchorAuthStatus;
@property (nonatomic , assign) NSInteger  is_friend;
/** 0 未关注，1已关注 */
@property(nonatomic,assign) NSInteger has_followed;
@property (nonatomic , copy) NSString  *shortvideo_count;
//@property (nonatomic , strong) DRPProfileInfoSchoolList  * school_list;
//@property(nonatomic,strong) NSMutableArray *workplace_info;
@property (nonatomic , copy) NSString  * head_decoration;
//@property (nonatomic , strong) DRPProfileInfoNobilityAndSaleResponse *nobilityAndSaleResponse;
@property (nonatomic , copy) NSString  *vip_stat;
@property (nonatomic , copy) NSString  * vip_icon_url_new;
@property (nonatomic , assign) NSInteger  totalStar;
@property (nonatomic , assign) NSInteger  user_status;
@property (nonatomic , assign) BOOL  showTask;
@property (nonatomic , copy) NSString  * vip_icon_url;
@property (nonatomic , assign) NSInteger  liked_shortvideo_count;
@property (nonatomic , assign) NSInteger  is_star;
@property (nonatomic , copy) NSString  * specific_id;
@property (nonatomic , assign) NSInteger  sub_count;
@property (nonatomic , copy) NSString  * headFrameUrl;
/// 0未认证 1已认证 2审核中 -1认证失败
@property (nonatomic , assign) NSInteger  realnameAuthStatus;
/// 身份证认证状态 1已认证 0未认证
@property(nonatomic,assign) BOOL idcardStatus;
@property (nonatomic , copy) NSString  * user_id;
/** 性别（1：男，0：女）*/
@property(nonatomic,copy) NSString *gender;
@property (nonatomic , strong) DRUProfileInfoRegionInfo  * region_info;
@property (nonatomic , assign) NSInteger  vip_level;
@property (nonatomic , strong) DRUProfileInfoUserSign  * user_sign;
@property (nonatomic , assign) NSInteger  livevideo_count;

/// 家乡省份
@property(nonatomic,copy) NSString *hometown_province;
/// 家乡市
@property(nonatomic,copy) NSString *hometown_city;

/// 是否屏蔽了该人新鲜事 1屏蔽 0未屏蔽
@property(nonatomic,assign) NSInteger isBanFriend;

/**
 我 是否 被 对方 拉黑
 */
@property(nonatomic,assign) BOOL blocked;

/**
 对方 是否 被 我 拉黑
 */
@property(nonatomic,assign) BOOL in_block_list;

/** 裂变步骤 -1需要裂变 1已阅动画，2已导入通讯录，3已发布一条新鲜事 0或无值表示不需要裂变
 * -1 需要走裂变流程，进入裂变1，h5流程
 * 0 不需要走裂变流程，进入首页
 * 1 裂变1走完，需要进入裂变2--通讯录页面
 * 2 裂变2走完，需要进入裂变3--发布话题页面
 * 3 裂变3走完，进入首页
*/
@property(nonatomic,assign) DRUFissionStep fissionStep;

/// -1 关 0 或不传或其它为开 浮窗开关
@property(nonatomic,assign) NSInteger notify_pop_open_status;





@end


NS_ASSUME_NONNULL_END
