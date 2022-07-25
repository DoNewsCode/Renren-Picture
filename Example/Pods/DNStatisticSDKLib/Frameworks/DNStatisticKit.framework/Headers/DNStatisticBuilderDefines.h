//
//  DNStatisticEventBuilder.h
//  DNStatisticSDK
//
//  Created by donews on 2019/1/21.
//  Copyright © 2019年 donews. All rights reserved.
//   Event事件构造器

#import <Foundation/Foundation.h>

@class DNStatisticEventModel;

@interface DNStatisticEventBuilder: NSObject

/// 自定义事件名称
@property (nonatomic, copy) NSString *eventName;
/// 自定义扩展参数 （以key-value字典传递）
@property (nonatomic, copy) NSDictionary *extParams;

- (DNStatisticEventModel *)build;

@end

@interface DNStatisticErrorBuilder : NSObject

/// Error描述
@property (nonatomic, copy) NSString *errorDetail;
/// 报错的文件名
@property (nonatomic, copy) NSString *fileName;
/// 报错的方法名
@property (nonatomic, copy) NSString *methodName;
/// 报错的行号
@property (nonatomic, copy) NSString *lineNum;

- (DNStatisticEventModel *)build;

@end

