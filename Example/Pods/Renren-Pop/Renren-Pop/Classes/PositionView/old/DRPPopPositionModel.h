//
//  DRPPopPositionModel.h
//  Renren-Pop
//
//  Created by 李晓越 on 2019/9/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//
//@interface DRPPopPositionChoiceModel : NSObject
//
//// 职位/岗位的id
//@property (nonatomic, copy) NSString *pId;
//// 职位/岗位的值
//@property (nonatomic, copy) NSString *pValue;
//
//@end

@interface DRPPopPositionModel : NSObject


@property (nonatomic, copy) NSArray <NSString *> *positon; // 岗位数组
@property (nonatomic, copy) NSString *classification; // 职位

@end

NS_ASSUME_NONNULL_END
