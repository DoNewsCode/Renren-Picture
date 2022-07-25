//
//  TCProfessionSheetView.m
//  Characters
//
//  Created by LiYue on 2018/4/23.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "DRPCitiesSheetView.h"
#import "DRPCitiesModel.h"
#import <YYModel/YYModel.h>
#import <YYCategories/YYCategories.h>
#import <SDAutoLayout/SDAutoLayout.h>

#define kSheetViewHeight 280



typedef void(^SelecCitiesResult)(NSString *province,
                                 NSString *cityName,
                                 NSString *cityId,
                                 NSString *result);
typedef void(^CancelBlock)(void);

@interface DRPCitiesSheetView()<UIPickerViewDelegate, UIPickerViewDataSource>


@property (nonatomic,copy) NSString *province;

@property (nonatomic,copy) NSString *cityName;

@property (nonatomic,copy) NSString *cityId;

@property (nonatomic,strong) NSArray *dataArray;

@property (nonatomic,assign) NSInteger provinceIndex;
@property (nonatomic,assign) NSInteger cityIndex;

@property (nonatomic,copy) SelecCitiesResult selecCitiesResult;
@property(nonatomic,copy) CancelBlock cancelBlock;



@end

@implementation DRPCitiesSheetView

- (NSArray *)dataArray
{
    if (!_dataArray) {
        
        NSBundle *curBundle = [NSBundle bundleForClass:[self class]];
        NSURL *url = [curBundle URLForResource:@"Renren-Pop" withExtension:@"bundle"];
        NSBundle *bundle = [NSBundle bundleWithURL:url];
        
        NSArray *provinces = [[NSArray alloc] initWithContentsOfFile:[bundle pathForResource:@"hometown" ofType:@"plist"]];
        
        NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:20];
        
        for (NSDictionary *dict in provinces) {
            DRPCitiesModel *pModel = [DRPCitiesModel yy_modelWithDictionary:dict];
            if (pModel) {
                [tempArray addObject:pModel];
            }
        }
        _dataArray = tempArray;
    }
    return _dataArray;
}

- (instancetype)initWithSelectProvince:(NSString *)selectProvince
                            selectCity:(NSString *)selectCity
                             doneBlock:(void(^)(NSString *province,
                                                NSString *cityName,
                                                NSString *cityId,
                                                NSString *result))doneBlock
                           cancelBlock:(void (^)(void))cancelBlock
{
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kSheetViewHeight);
        
        self.selecCitiesResult = doneBlock;
        self.cancelBlock = cancelBlock;
        
        
        __block NSInteger selectProvinceIndex = 0;
        __block NSInteger selectCityIndex = 0;
        
        // 已经选中的 城市  和  区域 逻辑处理
        if ([selectProvince isNotBlank] && [selectCity isNotBlank]) {
            
            
            [self.dataArray enumerateObjectsUsingBlock:^(DRPCitiesModel *citiesModel, NSUInteger provinceIndex, BOOL * _Nonnull stop) {
                
                if ([selectProvince containsString:citiesModel.province]) {
                    selectProvinceIndex = provinceIndex;
                    
                    self.province = citiesModel.province;
                    [citiesModel.cities enumerateObjectsUsingBlock:^(DRPCityModel *cityModel, NSUInteger cityIndex, BOOL * _Nonnull stop) {
                        
                        if ([selectCity containsString:cityModel.cityName]) {
                            selectCityIndex = cityIndex;
                            
                            self.cityId = cityModel.cityID;
                            self.cityName = cityModel.cityName;
                            *stop = YES;
                        }
                    }];
                    *stop = YES;
                }
            }];
//            self.provinceIndex = 0;
            
            
            self.provinceIndex = selectProvinceIndex;
            self.cityIndex = selectCityIndex;
            
//            self.province = citiesModel.province;
//            self.cityId = cityModel.cityID;
//            self.cityName = cityModel.cityName;
            
        } else {
        
            // 默认值
            DRPCitiesModel *citiesModel = self.dataArray.firstObject;
            DRPCityModel *cityModel = citiesModel.cities.firstObject;
            self.provinceIndex = 0;
            
            self.cityIndex = 0;
            
            self.province = citiesModel.province;
            self.cityId = cityModel.cityID;
            self.cityName = cityModel.cityName;
        }
        
        
        UIView *toolView = [[UIView alloc] init];
        toolView.backgroundColor = [UIColor whiteColor];
        [self addSubview:toolView];
        
        toolView.sd_layout.topEqualToView(self)
        .leftEqualToView(self)
        .rightEqualToView(self).heightIs(60);
        
        UIButton *leftButon = [[UIButton alloc] init];
        leftButon.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        [leftButon setTitle:@"取消" forState:UIControlStateNormal];
        [leftButon setTitleColor:[UIColor colorWithHexString:@"#4D8AF6"] forState:UIControlStateNormal];
        [leftButon addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
        [toolView addSubview:leftButon];
        
        leftButon.sd_layout.topEqualToView(toolView).leftSpaceToView(toolView, 20).
        bottomEqualToView(toolView).widthIs(50);
        
        UIButton *rightButon = [[UIButton alloc] init];
        rightButon.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        [rightButon setTitle:@"确认" forState:UIControlStateNormal];
        [rightButon setTitleColor:[UIColor colorWithHexString:@"#4D8AF6"] forState:UIControlStateNormal];
        [rightButon addTarget:self action:@selector(clickDone) forControlEvents:UIControlEventTouchUpInside];
        [toolView addSubview:rightButon];
        
        rightButon.sd_layout.topEqualToView(toolView).rightSpaceToView(toolView, 20).
        bottomEqualToView(toolView).widthIs(50);
        
        UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, kSheetViewHeight)];
        pickerView.backgroundColor = [UIColor whiteColor];
        pickerView.delegate = self;
        pickerView.dataSource = self;
        
        [self addSubview:pickerView];
        
        [pickerView selectRow:selectProvinceIndex inComponent:0 animated:NO];
        [self pickerView:pickerView didSelectRow:selectProvinceIndex inComponent:0];
        [pickerView selectRow:selectCityIndex inComponent:1 animated:NO];
        
    }
    return self;
}

- (void)clickCancel
{
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (void)clickDone
{
    
    NSString *result = self.province;
    if ([self.cityName isNotBlank]) {
        result = [result stringByAppendingFormat:@"%@",self.cityName];
    }
    
    if (self.selecCitiesResult) {
        self.selecCitiesResult(self.province, self.cityName, self.cityId, result);
    }
}

#pragma mark - UIPickerViewDataSource UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.dataArray.count;
    }
    
    DRPCitiesModel *citiesModel = self.dataArray[self.provinceIndex];
    return  citiesModel.cities.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 34;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    //设置分割线的颜色
    for(UIView *singleLine in pickerView.subviews) {
        if (singleLine.height < 1) {
            singleLine.backgroundColor = [UIColor colorWithHexString:@"DDDEE3"];
        }
    }
    
    NSString *title = @"";
    
    if (component == 0) {
        DRPCitiesModel *citiesModel = self.dataArray[row];
        title = citiesModel.province;
    } else {
        DRPCitiesModel *citiesModel = self.dataArray[self.provinceIndex];
        DRPCityModel *cityModel = citiesModel.cities[row];
        title = cityModel.cityName;
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
        [pickerView selectRow:self.cityIndex inComponent:1 animated:YES];
        
        
        DRPCitiesModel *citiesModel = self.dataArray[self.provinceIndex];
        self.province = citiesModel.province;
        
//        NSInteger index = [pickerView selectedRowInComponent:1];
        
        DRPCityModel *cityModel = citiesModel.cities[self.cityIndex];
        self.cityName = cityModel.cityName;
        self.cityId = cityModel.cityID;
        
        if (![self.cityName isNotBlank]) {
            self.cityName = @"";
        }
        self.cityIndex = 0;
        
    } else {
        
        DRPCitiesModel *citiesModel = self.dataArray[self.provinceIndex];

        NSArray *array  = citiesModel.cities;
        NSInteger index = [pickerView selectedRowInComponent:1];
        
        if (array.count == 0) {
            self.cityName = @"";
        } else if (index > array.count) {
            DRPCityModel *model = [array objectAtIndex:array.count - 1];
            self.cityName = model.cityName;
        } else {
            DRPCityModel *model = [array objectAtIndex:index];
            self.cityName = model.cityName;
        }
    }
}

@end
