//
//  DRLLogMessage.h
//  Renren-Library
//
//  Created by 陈金铭 on 2019/8/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRLLogMessage : NSObject

@property(nonatomic,assign) NSUInteger localID;
@property (nonatomic,assign) NSUInteger type;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *desc;
@property(nonatomic,copy) NSString *content;
@property(nonatomic,copy) NSString *remark;

@property(nonatomic,copy) NSString *appVersion;
@property(nonatomic,copy) NSString *appBuild;

@property(nonatomic,strong) NSDate *createTime;
@property(nonatomic,strong) NSDate *modifiedTime;


@end


NS_ASSUME_NONNULL_END
