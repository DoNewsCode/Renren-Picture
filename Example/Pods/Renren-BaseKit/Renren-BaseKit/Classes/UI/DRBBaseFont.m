//
//  DRBBaseFont.m
//  Pods-Renren-BaseKit_Example
//
//  Created by Ming on 2019/3/23.
//

#import "DRBBaseFont.h"

NSString *const DRBNotice_MutableFontDidChange  = @"DRBNotificationNotice_MutableFontDidChange";

@interface DRBBaseFont ()

@property (nonatomic,copy ) NSString *filePath;
/** 字体缩放系数,默认0 标准 */
@property (nonatomic, assign ,readwrite) CGFloat coefficient;

@end
@implementation DRBBaseFont

static DRBBaseFont *_instance = nil;

#pragma mark - Intial Methods
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        
    });
    return _instance;
}

- (void)createCoefficient:(CGFloat)coefficient {
    if (coefficient < -10 || coefficient > 10) {
        return;
    }
    if (_coefficient != coefficient) {
        _coefficient = coefficient;
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setObject:@0 forKey:@"coefficient"];
        self.coefficient = 0.;
        [NSKeyedArchiver archiveRootObject:dictionary toFile:self.filePath];
        [[NSNotificationCenter defaultCenter] postNotificationName:DRBNotice_MutableFontDidChange object:self userInfo:nil];
    }
}


#pragma mark - Override Methods
- (instancetype)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

#pragma mark - Private Methods
- (void)initialize {
    self.filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:[NSString stringWithFormat:@"/renrenFont.plist"]];
    
     NSDictionary *dictionary = [NSKeyedUnarchiver unarchiveObjectWithFile:self.filePath];
    if (dictionary) {
        NSNumber *coefficient = dictionary[@"coefficient"];
        if (coefficient) {
            self.coefficient = coefficient.floatValue;
        } else {
            [dictionary setValue:@0 forKey:@"coefficient"];
            self.coefficient = 0.;
            [NSKeyedArchiver archiveRootObject:dictionary toFile:self.filePath];
        }
    } else {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setObject:@0 forKey:@"coefficient"];
        self.coefficient = 0.;
        [NSKeyedArchiver archiveRootObject:dictionary toFile:self.filePath];
    }
}



/**
 改变可变字体系数(取值范围：-10～10)
 
 @param coefficient 字体系数
 */
+ (void)createCoefficient:(CGFloat)coefficient {
    [_instance createCoefficient:coefficient];
}


/**
 获取当前字体缩放系数
 
 @return 字体缩放系数
 */
+ (CGFloat)currentCoefficient {
    return _instance.coefficient;
}


@end
