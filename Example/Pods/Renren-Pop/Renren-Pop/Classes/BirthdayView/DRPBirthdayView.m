//
//  DRPBirthdayView.m
//  Renren-Pop
//
//  Created by 李晓越 on 2019/8/23.
//

#import "DRPBirthdayView.h"
#import <YYCategories/YYCategories.h>

#define kPickerViewHeight 280
#define kButtonHeight 44

typedef void(^HandlerBlock)(NSString *dateString);
typedef void(^CancelBlock)(void);

@interface DRPBirthdayView ()

@property(nonatomic,copy) HandlerBlock handlerBlock;
@property(nonatomic,copy) CancelBlock cancelBlock;

@property(nonatomic,copy) NSString *dateString;
@property(nonatomic,strong) UIDatePicker *datePicker;

@property(nonatomic,strong) NSString *startDateStr;
@property(nonatomic,strong) NSString *selectDateStr;

@end

@implementation DRPBirthdayView

- (UIDatePicker *)datePicker
{
    if (!_datePicker) {
        
        _datePicker = [[UIDatePicker alloc] initWithFrame:self.bounds];
    
        
        _datePicker.top = 44;
        
        //设置地区: zh-中国
        _datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
        
        _datePicker.datePickerMode = UIDatePickerModeDate;
        if (@available(iOS 13.4, *)) {
            _datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
        } else {
            // Fallback on earlier versions
        }

        
        NSDate *currentDate = [NSDate date];
        [_datePicker setMaximumDate:currentDate];
        
        // 设置最小时间为：当前时间前推十年
        NSDate *minDate = nil;
        if (self.startDateStr) {
            minDate = [NSDate dateWithString:self.startDateStr format:@"yyyy年MM月dd日"];
        } else {
            minDate = [NSDate dateWithString:@"1900年01月01日" format:@"yyyy年MM月dd日"];
        }
        [_datePicker setMinimumDate:minDate];
        
        // 默认选中
        if ([self.selectDateStr isNotBlank]) {
            NSDate *selectDate = [NSDate dateWithString:self.selectDateStr format:@"yyyy年MM月dd日"];
            if (selectDate) {
                [_datePicker setDate:selectDate];
            }
        } else {
            
            // 无值时选中 2000 1 1
            NSDate *selectDate = [NSDate dateWithString:@"2000年01月01日" format:@"yyyy年MM月dd日"];
            if (selectDate) {
                [_datePicker setDate:selectDate];
            }
        }
        
    }
    return _datePicker;
}

- (instancetype)initWithCancelTitle:(NSString *)cancelTitle
                          doneTitle:(NSString *)doneTitle
                      selectDateStr:(NSString *)selectDateStr
                       handlerBlock:(void (^)(NSString *dateString))handlerBlock
                        cancelBlock:(void (^)(void))cancelBlock
{
    return [self initWithCancelTitle:cancelTitle doneTitle:doneTitle startDateStr:nil selectDateStr:selectDateStr handlerBlock:handlerBlock cancelBlock:cancelBlock];
}

- (instancetype)initWithCancelTitle:(NSString *)cancelTitle
                          doneTitle:(NSString *)doneTitle
                       startDateStr:(NSString *__nullable)startDateStr
                      selectDateStr:(NSString *)selectDateStr
                       handlerBlock:(void (^)(NSString *dateString))handlerBlock
                        cancelBlock:(void (^)(void))cancelBlock
{
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 0, kScreenWidth, kPickerViewHeight);
        
        self.handlerBlock = handlerBlock;
        self.cancelBlock = cancelBlock;
        self.startDateStr = startDateStr;
        
        self.selectDateStr = selectDateStr;
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, kButtonHeight, kButtonHeight)];
        [cancelBtn setTitle:cancelTitle forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#4D8AF6"] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        [cancelBtn addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
        
        
        UIButton *doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, kButtonHeight, kButtonHeight)];
        doneBtn.right = self.width - 20;
        [doneBtn setTitle:doneTitle forState:UIControlStateNormal];
        [doneBtn setTitleColor:[UIColor colorWithHexString:@"#4D8AF6"] forState:UIControlStateNormal];
        doneBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        [doneBtn addTarget:self action:@selector(clickDoneBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:doneBtn];
        
        [self addSubview:self.datePicker];
        
    }
    return self;
}

#pragma mark - 事件
- (void)clickCancelBtn
{
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (void)clickDoneBtn
{
    if (self.handlerBlock) {
        NSDate *date = self.datePicker.date;
        NSString *dateString = [date stringWithFormat:@"yyyy年MM月dd日"];
        self.handlerBlock(dateString);
    }
}

@end
