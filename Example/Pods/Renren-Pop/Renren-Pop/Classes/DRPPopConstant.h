//
//  DRPPopConstant.h
//  Pods
//
//  Created by 李晓越 on 2019/7/10.
//

#ifndef DRPPopConstant_h
#define DRPPopConstant_h

/// 显示几排按钮
typedef NS_ENUM(NSUInteger, kMoreActionType) {
    kMoreActionTypeShareView = 1,   // 只显示第一排的分享类型按钮
    kMoreActionTypeOptionView,      // 只显示第二排的选项类型按钮
    kMoreActionTypeAllView,         // 同时显示两排按钮
};

/// 各种按钮的类型
typedef NS_OPTIONS(NSUInteger, kMoreActionButtonType) {
    kMoreActionButtonTypeShareToRenren              = 1 << 0,       // 转发
    kMoreActionButtonTypeSendToFriend               = 1 << 1,       // 发给好友
    kMoreActionButtonTypeShareToWeChat              = 1 << 2,       // 分享到微信
    kMoreActionButtonTypeShareToPengYouQuan         = 1 << 3,       // 分享到朋友圈
    kMoreActionButtonTypeShareToWeibo               = 1 << 4,       // 分享到微博
    kMoreActionButtonTypeShareToQQ                  = 1 << 5,       // 分享到QQ
    kMoreActionButtonTypeShareToQZone               = 1 << 6,       // 分享到QQ空间
    
    kMoreActionButtonTypeGoToAlbum                  = 1 << 7,       // 查看相册
    kMoreActionButtonTypeSaveToLocal                = 1 << 8,       // 保存图片
    kMoreActionButtonTypeCollection                 = 1 << 9,       // 收藏
    kMoreActionButtonTypeBlock                      = 1 << 10,      // 屏蔽该人
    kMoreActionButtonTypeReport                     = 1 << 11,      // 举报
    kMoreActionButtonTypeDelete                     = 1 << 12,      // 删除
    kMoreActionButtonTypeStamp                      = 1 << 13,      // 标记
    kMoreActionButtonTypeEditAlbums                 = 1 << 14,      // 编辑相册
    kMoreActionButtonTypeCancelCollect              = 1 << 15,      // 取消收藏
    
    // 打开链接分享中的选项按钮
    kMoreActionButtonTypeRefresh                    = 1 << 16,      // 刷新
    kMoreActionButtonTypeSendItToFriend             = 1 << 17,      // 发送给好友
    kMoreActionButtonTypeShareLinks                 = 1 << 18,      // 分享链接
    kMoreActionButtonTypeCopyLink                   = 1 << 19,      // 复制链接
    kMoreActionButtonTypeUsingSafariOpen            = 1 << 20,      // 用safari打开
    
    kMoreActionButtonTypeAddBanned                  = 1 << 21,      // 禁言此人
    kMoreActionButtonTypeRemoveBanned               = 1 << 22,      // 取消禁言
    
    kMoreActionButtonTypeManager                    = 1 << 23,      // 管理
    kMoreActionButtonTypeEssence                    = 1 << 24,      // 精华
    kMoreActionButtonTypePlacedTop                  = 1 << 25,      // 置顶
    
    kMoreActionButtonTypePublish                    = 1 << 26,      // 发布新鲜事
    kMoreActionButtonTypeShielding                  = 1 << 27,      // 封禁此人
    
    kMoreActionButtonTypeCancelEssence              = 1 << 28,      // 取消精华
    kMoreActionButtonTypeDeleteShielding            = 1 << 29,      // 解除封禁
    kMoreActionButtonTypeCancelPlacedTop            = 1 << 30,      // 取消置顶
    
};

// 检测用户信息时的类型
typedef NS_ENUM(NSUInteger, DRPCheckType) {
    DRPCheckTypeAccount = 1 << 0,     // 账号格式有误
    DRPCheckTypeNickName = 1 << 1,    // 昵称包含违禁词
};

// 检测用户信息时的类型的完成状态
typedef NS_ENUM(NSUInteger, DRPCheckTypeState) {
    DRPCheckTypeAccountNone = 1 << 0,     // 用户名项 未完成
    DRPCheckTypeNickNameNone = 1 << 1,    // 昵称荐 未完成
    DRPCheckTypeAccountDone = 1 << 2,     // 用户名项 完成
    DRPCheckTypeNickNameDone = 1 << 3,    // 昵称荐 完成
};

#endif /* DRPPopConstant_h */
