//
//  DRUProfileGetInfoRequest.h
//  AFNetworking
//
//  Created by lixiaoyue on 2019/6/3.
//

#import "DRUUserBaseGlobalRequest.h"

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(long long ,DRUProfileInfoType){
    //    DRUProfileInfoTypeNetwork                                 = 0x1,              // 所在网络
    DRUProfileInfoTypeGender                                  = 0x2,              // 性别
    DRUProfileInfoTypeBirth                                   = 0x4,              // 生日
    DRUProfileInfoTypeHometownProvince                        = 0x8,              // 家乡所在省市
    DRUProfileInfoTypeHometownCity                            = 0x10,             // 家乡资料
    DRUProfileInfoTypeRecentEducationWork                     = 0x2000000,        // 查看最近的学历或者工作
    DRUProfileInfoTypeIsFriend                                = 0x40,             // 是否为好友
    DRUProfileInfoTypeVistorCount                             = 0x80,             // 来访数
    DRUProfileInfoTypeFriendCount                             = 0x400,            // 好友数
    DRUProfileInfoTypeSignatureWithVoice                      = 0x200000,         // 个性签名包含语音
    DRUProfileInfoTypeSchoolList                              = 0x10000,          // 学校列表
    DRUProfileInfoTypeWorkplaceInfo                           = 0x80000,          // 工作地点信息
    DRUProfileInfoTypeRegion                                  = 0x400000,         // 所在地
    DRUProfileInfoTypeFansCount                               = 0x40000000,       // 粉丝数
    DRUProfileInfoTypePubCount                                = 0x80000000,       // 关注数
    DRUProfileInfoTypeUserSignature                           = 0x8000000,        // 用户个性id
    DRUProfileInfoTypeUserBlocked                             = 0x800000,         // 查看的人是否在我的黑名单中(0|1)和我是否在查看的人黑名单中    in_block_list,blocked
    DRUProfileInfoTypeRealName                                = 0x8000000000000L, // 是否获得真实姓名
    DRUProfileInfoTypeIsBanFriend                             = 0x2000000000000L, // 是否需要新鲜事屏蔽与否字段
    DRUProfileInfoTypeRealnameAuthStatus                      = 0x4000000000000L, // 是否需要新人人网app实名认证状态字段
    DRUProfileInfoTypeFissionStep                             = 0x10000000000000L, // 裂变步骤进行到哪一步了
    
};

@interface DRUProfileGetInfoRequest : DRUUserBaseGlobalRequest

@property(nonatomic,assign) DRUProfileInfoType type;

/** 登录用户的session_key. 用于验证是否为当前用户发出的请求 */
@property(nonatomic,copy) NSString *session_key;

/** 需要查询的用户id */
@property(nonatomic,copy) NSString *uid;

@end

NS_ASSUME_NONNULL_END
