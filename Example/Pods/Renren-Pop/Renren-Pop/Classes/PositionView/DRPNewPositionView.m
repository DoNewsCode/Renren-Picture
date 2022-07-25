//
//  DRPNewPositionView.m
//  Renren-Pop
//
//  Created by 李晓越 on 2019/9/3.
//

#import "DRPNewPositionView.h"
#import <YYCategories/YYCategories.h>
#import "DRPNewPositionModel.h"
#import <YYModel/YYModel.h>

#define kPickerViewHeight 280
#define kButtonHeight 44

typedef void(^ResultBlock)(NSString *classification, NSString *positionName, NSString *positionId);
typedef void(^HandleBlock)(NSString *title);

@interface DRPNewPositionView ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) UIPickerView *pickerView;
@property(nonatomic,strong) NSArray *dataList;
@property (nonatomic,assign) NSInteger provinceIndex;

@property(nonatomic,copy) NSString *classification;
@property(nonatomic,copy) NSString *positionName;
@property(nonatomic,copy) NSString *positionId;

@property(nonatomic,copy) ResultBlock resultBlock;
@property(nonatomic,copy) HandleBlock handleBlock;

@end

@implementation DRPNewPositionView

- (void)setDataList:(NSArray *)dataList
{
    
    // 转成pop中的模型
    id data = dataList.yy_modelToJSONObject;
    
    NSArray *array = [NSArray yy_modelArrayWithClass:DRPNewPositionModel.class json:data];
    
    _dataList = array;
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

- (instancetype)initWithPositionList:(NSArray *)positionList
                         resultBlock:(void(^)(NSString *classification,
                                              NSString *positionName,
                                              NSString *positionId))resultBlock
                         HandleBlock:(void(^)(NSString *title))handleBlock
{
    self = [super init];
    
    if (self) {
        
        self.provinceIndex = 0;
        
        self.dataList = positionList;
        
        DRPNewPositionModel *firstModel = self.dataList.firstObject;
        
        self.classification = firstModel.type;
        DRPNewPositionList *firstPosition = firstModel.positionList.firstObject;
        self.positionName = firstPosition.name;
        self.positionId = firstPosition._id;
        
        self.resultBlock = resultBlock;
        self.handleBlock = handleBlock;
        
        self.frame = CGRectMake(0, 0, kScreenWidth, kPickerViewHeight);
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, kButtonHeight, kButtonHeight)];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#4D8AF6"] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        [cancelBtn addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
        
        
        UIButton *doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, kButtonHeight, kButtonHeight)];
        doneBtn.right = self.width - 20;
        [doneBtn setTitle:@"确认" forState:UIControlStateNormal];
        [doneBtn setTitleColor:[UIColor colorWithHexString:@"#4D8AF6"] forState:UIControlStateNormal];
        doneBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        [doneBtn addTarget:self action:@selector(clickDoneBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:doneBtn];
        
        
        [self addSubview:self.pickerView];
        
    }
    
    return self;
}

#pragma mark - UIPickerViewDelegate, UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.dataList.count;
    }
    DRPNewPositionModel *model = self.dataList[self.provinceIndex];
    return model.positionList.count;
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
        DRPNewPositionModel *model = self.dataList[row];
        title = model.type;

    } else {
        DRPNewPositionModel *model = self.dataList[self.provinceIndex];
        DRPNewPositionList *positonModel = model.positionList[row];
        title = positonModel.name;
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
        self.provinceIndex = [pickerView selectedRowInComponent:0];
        
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        
        
        DRPNewPositionModel *model = self.dataList[self.provinceIndex];
        self.classification = model.type;
        DRPNewPositionList *postionModel = model.positionList.firstObject;
        self.positionName = postionModel.name;
        self.positionId = postionModel._id;
    
    } else {
        
        DRPNewPositionModel *model = self.dataList[self.provinceIndex];
        NSInteger index = [pickerView selectedRowInComponent:1];
        
        if (index > model.positionList.count) {
            DRPNewPositionList *postionModel = model.positionList[model.positionList.count - 1];
            self.positionName = postionModel.name;
            self.positionId = postionModel._id;
        }  else {
            DRPNewPositionList *postionModel = model.positionList[index];
            self.positionName = postionModel.name;
            self.positionId = postionModel._id;
        }
    }
}

#pragma mark - 事件
- (void)clickCancelBtn
{
    if (self.handleBlock) {
        self.handleBlock(@"");
    }
}

- (void)clickDoneBtn
{
    
    if (self.resultBlock) {
        self.resultBlock(self.classification, self.positionName, self.positionId);
    }
}

@end
