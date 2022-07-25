//
//  DRPJobDatePickerView.m
//  Pods
//
//  Created by 李晓越 on 2019/7/22.
//

#import "DRPJobDatePickerView.h"
#import <YYCategories/YYCategories.h>

#define kPickerViewHeight 280
#define kButtonHeight 44

typedef void(^HandlerBlock)(NSString *resulString);
typedef void(^CancelBlock)(void);

@interface DRPJobDatePickerView()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) UIPickerView *pickerView;

/// 拼接最终结果
@property(nonatomic,copy) NSString *resulString;

@property(nonatomic,copy) NSString *yearString;
@property(nonatomic,copy) NSString *monthString;

@property(nonatomic,copy) HandlerBlock handlerBlock;
@property(nonatomic,copy) CancelBlock cancelBlock;

@property(nonatomic,strong) NSMutableArray *yearsArray;
@property(nonatomic,strong) NSMutableArray *monthsArray;

/// 是否显示结束时间数据
@property(nonatomic,assign) BOOL isEndTime;
@property(nonatomic,assign) NSInteger startYear;

/// 第一次打开后默认选中的月的行数
@property(nonatomic,assign) NSInteger monthIndex;

@property(nonatomic,assign) NSInteger componentOneRow;

@end

@implementation DRPJobDatePickerView



- (NSMutableArray *)yearsArray
{
    if (!_yearsArray) {
        _yearsArray = [[NSMutableArray alloc] init];
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *component = [calendar components:NSCalendarUnitYear fromDate:[NSDate date]];
        NSInteger lastYear = [component year];
        
        
        if (self.isEndTime) {
            [_yearsArray insertObject:[NSString stringWithFormat:@"至今"] atIndex:0];
            
            for (NSInteger i = lastYear; i >= self.startYear; i--) {
                [_yearsArray addObject:[NSString stringWithFormat:@"%zd年", i]];
            }
        } else {
            for (NSInteger i = lastYear; i >= 1900; i--) {
                [_yearsArray addObject:[NSString stringWithFormat:@"%zd年", i]];
            }
            
        }
    }
    return _yearsArray;
}

- (NSMutableArray *)monthsArray
{
    if (!_monthsArray) {
        _monthsArray = [[NSMutableArray alloc] init];
        
        for (NSInteger i = 12; i >= 1; --i) {
            NSString *month = [NSString stringWithFormat:@"%zd月", i];
            [_monthsArray addObject:month];
        }
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *component = [calendar components:NSCalendarUnitMonth fromDate:[NSDate date]];
        NSInteger month = [component month];
        
        NSString *currentMonth = [NSString stringWithFormat:@"%zd月", month];
        
        NSInteger monthIndex = [_monthsArray indexOfObject:currentMonth];
        self.monthIndex = monthIndex;
        
    }
    return _monthsArray;
}

- (UIPickerView *)pickerView {
    
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, kPickerViewHeight - kButtonHeight)];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.tintColor = [UIColor greenColor];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
    }
    return _pickerView;
}

- (instancetype)initWithTitle:(NSString *)title
                  cancelTitle:(NSString *)cancelTitle
                    doneTitle:(NSString *)doneTitle
                    isEndTime:(BOOL)isEndTime
                    startYear:(NSInteger)startYear
                 handlerBlock:(void (^)(NSString *resulString))handlerBlock
                  cancelBlock:(void (^)(void))cancelBlock
{
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 0, kScreenWidth, kPickerViewHeight);

        self.isEndTime = isEndTime;
        self.handlerBlock = handlerBlock;
        self.cancelBlock = cancelBlock;
        self.componentOneRow = 0;
        self.startYear = startYear;
                
        // 默认结果
        self.yearString = self.yearsArray.firstObject;
        if (self.isEndTime) {
            self.monthString = @"";
        } else {
            self.monthString = [self.monthsArray objectAtIndex:self.monthIndex];
        }
        
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
        
        
        [self addSubview:self.pickerView];
        
        // 显示的是结束日期的话，没有默认选中月的操作，因为第二列是空的
        if (self.isEndTime) {
            
        } else {
            [self.pickerView selectRow:self.monthIndex inComponent:1 animated:NO];
        }
        
        
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
        self.resulString = [NSString stringWithFormat:@"%@%@", self.yearString, self.monthString];
        self.handlerBlock(self.resulString);
    }
}

#pragma mark - UIPickerViewDelegate, UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (component == 0) {
        // 返回第一列个数
        return self.yearsArray.count;
    }
    // 返回第二列个数
    // 如果是结束时间，并且第一列选中的是 至今，则第二列没有数据
    if (self.isEndTime && self.componentOneRow == 0) {
        return 0;
    }
    return self.monthsArray.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 34;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    //设置分割线的颜色
    for (UIView *singleLine in pickerView.subviews) {
        if (singleLine.height < 1) {
            singleLine.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
        }
    }
    NSString *title = @"";
    if (component == 0) {
        title = self.yearsArray[row];
        
    } else {
        title = self.monthsArray[row];
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    label.textColor = [UIColor colorWithHexString:@"#020202"];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        self.yearString = self.yearsArray[row];
        // 记录是第一列的第几行
        self.componentOneRow = [pickerView selectedRowInComponent:component];
        [pickerView reloadComponent:1];
        [pickerView selectRow:self.monthIndex inComponent:1 animated:YES];
        
        // 哎呀呀，大概意思是，滑动第一列时，如果是0行，也就是至今，mothstring 为空，否则 monthstring 为取monthsArray中的结果
        // 好绕啊
        if (self.isEndTime) {
            if (self.componentOneRow == 0) {
                self.monthString = @"";
            } else {
                self.monthString = self.monthsArray[self.monthIndex];
            }
        }
        
    } else {
        // 记录第二列的index，防止再次滑动第一列时，第二列的index还是默认的
        self.monthIndex = [pickerView selectedRowInComponent:component];
        if (self.isEndTime && self.componentOneRow == 0) {
            self.monthString = @"";
        } else {
            self.monthString = self.monthsArray[row];
        }
    }
    
    NSLog(@"------- %@", [NSString stringWithFormat:@"%@%@", self.yearString, self.monthString]);
}

@end
