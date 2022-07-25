//
//  DRUClientLoginModel.h
//  RenRenRecallModule
//
//  Created by donews on 2019/1/19.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "DRUUserBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRUClientLoginModel : DRUUserBaseModel

@property(nonatomic,copy) NSString *uniq_key;
@property(nonatomic,copy) NSString *uniq_id;


@property(nonatomic,assign) NSInteger fill_stage;


@property(nonatomic,assign) NSInteger *is_guide;

@property(nonatomic,copy) NSString *login_count;

/// now = 1547868953955;
@property(nonatomic,assign) NSTimeInterval now;

///  = 5a8e0563262e9145ae9e8a31236cc667;
@property(nonatomic,copy) NSString *secret_key;

/// = qed5Jnybi09vg6Oe;
@property(nonatomic,copy) NSString *session_key;

/// = 12NVbwfuY7QvZAb617e1QO;
@property(nonatomic,copy) NSString *ticket;

/// "" = "http://h_head_AOJs_13bc000f5f1a1986.jpg";
@property(nonatomic,copy) NSString *head_url;
//@property(nonatomic,copy) NSString *headUrl;

/// = 969231698;
@property(nonatomic,copy) NSString *user_id;
//@property(nonatomic,copy) NSString *uid;

/// user_name
@property(nonatomic,copy) NSString *user_name;
//@property(nonatomic,copy) NSString *name;

/// 账号信息
@property(nonatomic,strong) NSArray *accountInfo;

/// vip_icon_url
@property(nonatomic,copy) NSString *vip_icon_url;

/// http://i.renren.com/client/icon?uid=";
@property(nonatomic,copy) NSString *vip_url;

/// "web_ticket" = 2c7d92896786aaadd9610550a5d92cc18;
@property(nonatomic,copy) NSString *web_ticket;

/// "last_login_time" = 1547951013000; 毫秒值
@property(nonatomic,assign) NSTimeInterval last_login_time;

/// register_time 毫秒值
@property(nonatomic,assign) NSTimeInterval register_time;


/// ast_login_time_away_now = 16;
/// 最后登录时间距离现在多久 几年前/几月前等
@property(nonatomic,copy) NSString *last_login_time_away_now;
/// register_time_away_now = 27;
/// 注册时间距离现在多久 几年前/几月前等
@property(nonatomic,copy) NSString *register_time_away_now;

/// 3月5日新增  -------- 3.5前某个接口也用这个模型，也有此字段，共用一个
/// 重置密码成功返回，使用account + 重置密码调登录接口
@property(nonatomic,copy) NSString *account;

@property(nonatomic,copy) NSString *city;

@property(nonatomic,copy) NSString *schoolName;

@property(nonatomic,assign) NSTimeInterval registerTime;
@property(nonatomic,assign) NSTimeInterval lastLoginTime;

/// 貌似没有这俩
@property(nonatomic,copy) NSString *email;
@property(nonatomic,copy) NSString *mobilePhone;

/// 重置密码后，返回的几年前等描述
@property(nonatomic,copy) NSString *regTimeDes;
@property(nonatomic,copy) NSString *lastLoginTimeDes;


/// 以下信息需要保存在 cookie 里  ～～～～
@property(nonatomic,copy) NSString *t;
@property(nonatomic,copy) NSString *_uij;
@property(nonatomic,copy) NSString *Path;
@property(nonatomic,copy) NSString *Domain;

@property(nonatomic,assign) NSInteger maxAge;
@property(nonatomic,assign) NSInteger renren_id;
@property(nonatomic,copy) NSString *_rtk;




@end

NS_ASSUME_NONNULL_END
