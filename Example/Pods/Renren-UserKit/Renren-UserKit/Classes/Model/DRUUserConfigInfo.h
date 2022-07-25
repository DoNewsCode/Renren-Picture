//
// DRUUserConfigInfo.h
// Renren-UserKit
//
// Created by 李晓越 on 2020/7/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRUUserConfigDetails :NSObject
/// 0 关  1 开
@property (nonatomic , assign) NSInteger configChoose;
/// 具体见 http://wiki.yunwei.infinities.com.cn/pages/viewpage.action?pageId=92569608
@property (nonatomic , assign) NSInteger configType;

@end

@interface DRUUserConfigDetail :NSObject
@property (nonatomic , assign) NSInteger userId;
@property (nonatomic , copy) NSArray<DRUUserConfigDetails *> * userConfigDetails;

@end

@interface DRUUserConfigInfo : NSObject

@property (nonatomic , copy) NSArray<DRUUserConfigDetail *> * userConfigDetail;


// 以下是自己实现的获取方法跟接口无关
/// 加我为好友时需要验证  状态
@property(nonatomic,strong) DRUUserConfigDetails *validationConfig;
/// 可以关注我   状态
@property(nonatomic,strong) DRUUserConfigDetails *followmeConfig;
/// 我的资料对谁可见    状态
@property(nonatomic,strong) DRUUserConfigDetails *lookMeInfo;
/// 允许非好友与我聊天   状态
@property(nonatomic,strong) DRUUserConfigDetails *nonFriendChat;
/// 仅公开最近半年的新鲜事 状态
@property(nonatomic,strong) DRUUserConfigDetails *halfSwitch;
/// wifi下自动播放视频 状态
@property(nonatomic,strong) DRUUserConfigDetails *autoPlayVideo;

@end

NS_ASSUME_NONNULL_END
