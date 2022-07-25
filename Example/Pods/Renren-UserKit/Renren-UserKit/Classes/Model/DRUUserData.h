//
// DRUUserData.h
// Renren-UserKit
//
// Created by 李晓越 on 2020/6/10.
// 重构使用的新的用户模型数据

#import <Foundation/Foundation.h>
#import "DRUUser.h"


NS_ASSUME_NONNULL_BEGIN

@interface DRUWorkplaceInfo :NSObject

@property (nonatomic , assign) NSInteger _id;
/// 工作类别
@property (nonatomic , copy) NSString * jobTitle;
/// 职位类别
@property (nonatomic , copy) NSString * position;
/// 用户id
@property (nonatomic , assign) NSInteger userid;
/// 公司id 如果没有则填0
@property (nonatomic , assign) NSInteger workplaceId;
/// 加入时间年
@property (nonatomic , assign) NSInteger joinYear;
/// 认证情况
@property (nonatomic , assign) NSInteger auth;
/// 离开时间年
@property (nonatomic , assign) NSInteger quitYear;
/// 工作类别id
@property (nonatomic , assign) NSInteger jobTitleId;
/// 是否在职 0离职 1在职
@property (nonatomic , assign) NSInteger type;
/// 离开时间月
@property (nonatomic , assign) NSInteger quitMonth;
/// 职位类别id
@property (nonatomic , assign) NSInteger positionId;
/// 公司名称
@property (nonatomic , copy) NSString * name;
/// 加入时间月
@property (nonatomic , assign) NSInteger joinMonth;

@end

@interface DRUUserInfoModel :NSObject
/// 生日年
@property (nonatomic , assign) NSInteger birthYear;
/// 家乡所在低省份id
@property (nonatomic , assign) NSInteger provinceCode;
/// 昵称
@property (nonatomic , copy) NSString * nickname;
/// 生日天
@property (nonatomic , assign) NSInteger birthDay;
/// 生日月
@property (nonatomic , assign) NSInteger birthMonth;
/// 头像小图
@property (nonatomic , copy) NSString * tinyUrl;
/// 家乡所在省份名称
@property (nonatomic , copy) NSString * homeProvince;
/// 现居住地城市id
@property (nonatomic , copy) NSString * regionId;
/// 真实姓名
@property (nonatomic , copy) NSString * name;
/// 头像主图
@property (nonatomic , copy) NSString * mainUrl;
/// 家乡所在城市名称
@property (nonatomic , copy) NSString * homeCity;
/// 用户id
@property (nonatomic , copy) NSString *userId;
/// 头像
@property (nonatomic , copy) NSString * headUrl;
/// 性别 1男 2女
@property (nonatomic , copy) NSString * gender;
/// 现居住地省份id
@property (nonatomic , assign) NSInteger provinceId;
/// 现居住地省份名称
@property (nonatomic , copy) NSString * provinceName;
/// 头像大图
@property (nonatomic , copy) NSString * largeUrl;
/// 家乡所在地城市id
@property (nonatomic , assign) NSInteger cityCode;
/// 年纪
@property (nonatomic , assign) NSInteger age;
/// 现居住地城市名称
@property (nonatomic , copy) NSString * cityName;
/// 简介
@property (nonatomic , copy, nullable) NSString * content;

@end

@interface DRUCollegeInfoList :NSObject
/// 用户id
@property (nonatomic , copy) NSString * userid;
///
@property (nonatomic , assign) NSInteger _id;
/// 中专学校id
@property (nonatomic , copy) NSString * collegeId;
/// 学制
@property (nonatomic , assign) NSInteger program;
/// 中专学校名称
@property (nonatomic , copy) NSString * collegeName;
/// 学院
@property (nonatomic , copy) NSString * department;
/// 入学年份
@property (nonatomic , assign) NSInteger enrollYear;

@end

@interface DRUHighSchoolInfoList :NSObject

/// 用户id
@property (nonatomic , copy) NSString * userid;
/// 高中名称
@property (nonatomic , copy) NSString * highSchoolName;
/// 高一所在班级
@property (nonatomic , assign) NSInteger hClass1;
///
@property (nonatomic , assign) NSInteger _id;
/// 高三所在班级
@property (nonatomic , assign) NSInteger hClass3;
/// 高二所在班级
@property (nonatomic , assign) NSInteger hClass2;
/// 高中id
@property (nonatomic , copy) NSString * highSchoolId;
/// 高中名称
@property (nonatomic , assign) NSInteger enrollYear;

@end

@interface DRUUniversityInfoList :NSObject

@property (nonatomic , assign) NSInteger _id;
/// 专业名称
@property (nonatomic , copy) NSString * major;
/// 入学年
@property (nonatomic , assign) NSInteger enrollYear;
/// 宿舍名称
@property (nonatomic , copy) NSString * dorm;
/// 学校名称
@property (nonatomic , copy) NSString * universityName;
/// 用户id
@property (nonatomic , copy) NSString * userid;
/// 宿舍id
@property (nonatomic , copy) NSString * dormId;
/// 院系id
@property (nonatomic , copy) NSString * departmentId;
/// 专业id
@property (nonatomic , copy) NSString * majorId;
/// 学历
@property (nonatomic , assign) NSInteger typeOfCourse;
/// 学制
@property (nonatomic , assign) NSInteger program;
/// 学院名称
@property (nonatomic , copy) NSString * department;
/// 学校 id
@property (nonatomic , copy) NSString * universityId;

@end

@interface DRUElementarySchoolInfoList :NSObject

@property (nonatomic , assign) NSInteger _id;
/// 用户id
@property (nonatomic , copy) NSString * userid;
/// 小学id
@property (nonatomic , copy) NSString * elementarySchoolId;
/// 入学年
@property (nonatomic , assign) NSInteger elementarySchoolYear;
/// 小学名称
@property (nonatomic , copy) NSString * elementarySchoolName;
/// 学制
@property (nonatomic , assign) NSInteger program;

@end

@interface DRUJuniorHighSchoolInfoList :NSObject

/// id 编辑id=0为新增,!0为修改
@property (nonatomic , assign) NSInteger _id;
/// 用户id
@property (nonatomic , copy) NSString * userid;
/// 学制
@property (nonatomic , assign) NSInteger program;
/// 初中学校id
@property (nonatomic , copy) NSString * juniorHighSchoolId;
/// 初中学校名称
@property (nonatomic , copy) NSString * juniorHighSchoolName;
/// 入学年
@property (nonatomic , assign) NSInteger juniorHighSchoolYear;

@end

@interface DRUSchoolInfo :NSObject

/// 中专信息列表
@property (nonatomic , copy) NSArray<DRUCollegeInfoList *> * collegeInfoList;
/// 高中信息列表
@property (nonatomic , copy) NSArray<DRUHighSchoolInfoList *> * highSchoolInfoList;
/// 大学信息列表
@property (nonatomic , copy) NSArray<DRUUniversityInfoList *> * universityInfoList;
/// 小学信息列表
@property (nonatomic , copy) NSArray<DRUElementarySchoolInfoList *> * elementarySchoolInfoList;
/// 初中信息列表
@property (nonatomic , copy) NSArray<DRUJuniorHighSchoolInfoList *> * juniorHighSchoolInfoList;

@end

@interface DRURecentEducationWork : NSObject

//"id": 348320883,
@property(nonatomic,assign) NSInteger _id;
//"name": "兔兔",
@property(nonatomic,copy) NSString *name;
//"type": 0
@property(nonatomic,assign) NSInteger type;

@end

@interface DRUUserData :NSObject

/// 关注数
@property (nonatomic , assign) NSInteger followerCount;
/// 访问数
@property (nonatomic , assign) NSInteger visitedCount;
/// 访问权限 0公开 1仅好友可见 2仅自己可见
@property (nonatomic , assign) NSInteger visible;
/// 粉丝数
@property (nonatomic , assign) NSInteger fanCount;
/**
 0, "无关系
 1, "自己
 2, "好友
 3, "申请
 4, "被申请
 5, "拉黑
 6, "被拉黑
 7, "双向拉黑
 8, "未知关系(异常关系)
 */
@property (nonatomic , assign) NSInteger relation;
/// 基本用户信息
@property (nonatomic , strong) DRUUserInfoModel * userInfo;
/// 学校信息
@property (nonatomic , strong) DRUSchoolInfo * schoolInfo;
/// 工作信息
@property (nonatomic , copy) NSArray<DRUWorkplaceInfo *> * workplaceInfo;
/// 最近的工作或教育经历
@property(nonatomic,strong) DRURecentEducationWork *recentEducationWork;

/// 关注关系 0 未关注，1已关注，2被关注，3互相关注
@property(nonatomic,assign) NSInteger followed;
/// 实名认证字段 0未认证  1审核中  2不通过  3认证成功
@property (nonatomic , assign) NSInteger realnameAuthStatus;
/// 新鲜事 0未屏蔽 1屏蔽
@property(nonatomic,assign) NSInteger banFriend;
/// 黑名单 0未加入 1已加入
@property(nonatomic,assign) NSInteger blocked;


#warning TODO 张聪说，裂变没数据，先不管
/** 裂变步骤 -1需要裂变 1已阅动画，2已导入通讯录，3已发布一条新鲜事 0或无值表示不需要裂变
 * -1 需要走裂变流程，进入裂变1，h5流程
 * 0 不需要走裂变流程，进入首页
 * 1 裂变1走完，需要进入裂变2--通讯录页面
 * 2 裂变2走完，需要进入裂变3--发布话题页面
 * 3 裂变3走完，进入首页
*/
@property(nonatomic,assign) DRUFissionStep fissionStep;

/// -1 关 0 或不传或其它为开 浮窗开关
#warning TODO 浮窗开关， 可能需要走另一个查询接口得到
@property(nonatomic,assign) NSInteger notify_pop_open_status;

@end


NS_ASSUME_NONNULL_END
