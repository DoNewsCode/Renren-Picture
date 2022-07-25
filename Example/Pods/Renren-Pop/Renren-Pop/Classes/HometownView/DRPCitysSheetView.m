//
//  TCProfessionSheetView.m
//  Characters
//
//  Created by LiYue on 2018/4/23.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "DRPCitysSheetView.h"
#import "DRPNewProvinceModel.h"
#import <YYModel/YYModel.h>
#import <YYCategories/YYCategories.h>
#import <SDAutoLayout/SDAutoLayout.h>

#define kSheetViewHeight 280



typedef void(^SelecCitiesResult)(NSString *provinceName,
                                 NSString *cityName,
                                 NSString *provinceId,
                                 NSString *cityId,
                                 NSString *result);
typedef void(^CancelBlock)(void);

@interface DRPCitysSheetView()<UIPickerViewDelegate, UIPickerViewDataSource>


@property (nonatomic,copy) NSString *provinceName;

@property (nonatomic,copy) NSString *cityName;

@property (nonatomic,copy) NSString *provinceId;
@property (nonatomic,copy) NSString *cityId;

@property (nonatomic,strong) NSArray *dataArray;

@property (nonatomic,assign) NSInteger provinceIndex;
@property (nonatomic,assign) NSInteger cityIndex;

@property (nonatomic,copy) SelecCitiesResult selecCitiesResult;
@property(nonatomic,copy) CancelBlock cancelBlock;



@end

@implementation DRPCitysSheetView

//- (NSArray *)dataArray
//{
//    if (!_dataArray) {
//
//        NSBundle *curBundle = [NSBundle bundleForClass:[self class]];
//        NSURL *url = [curBundle URLForResource:@"Renren-Pop" withExtension:@"bundle"];
//        NSBundle *bundle = [NSBundle bundleWithURL:url];
//
//        NSArray *provinces = [[NSArray alloc] initWithContentsOfFile:[bundle pathForResource:@"hometown" ofType:@"plist"]];
//
//        NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:20];
//
//        for (NSDictionary *dict in provinces) {
//            DRPCitiesModel *pModel = [DRPCitiesModel yy_modelWithDictionary:dict];
//            if (pModel) {
//                [tempArray addObject:pModel];
//            }
//        }
//        _dataArray = tempArray;
//    }
//    return _dataArray;
//}

- (void)setDataArray:(NSArray *)dataArray
{
    // 转成pop中的模型
    id data = dataArray.yy_modelToJSONObject;
    
    NSArray *array = [NSArray yy_modelArrayWithClass:DRPNewProvinceModel.class json:data];
    
    _dataArray = array;
    
    
}

- (instancetype)initWith:(NSString *)selectProvince
              selectCity:(NSString *)selectCity
                cityList:(NSArray *)cityList
               doneBlock:(void(^)(NSString *provinceName,
                                  NSString *cityName,
                                  NSString *provinceId,
                                  NSString *cityId,
                                  NSString *result))doneBlock
             cancelBlock:(void (^)(void))cancelBlock
{
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kSheetViewHeight);
        
        self.selecCitiesResult = doneBlock;
        self.cancelBlock = cancelBlock;
        self.dataArray = cityList;
        
        
        __block NSInteger selectProvinceIndex = 0;
        __block NSInteger selectCityIndex = 0;

        // 已经选中的 城市  和  区域 逻辑处理
        if ([selectProvince isNotBlank] && [selectCity isNotBlank]) {


            [self.dataArray enumerateObjectsUsingBlock:^(DRPNewProvinceModel *citiesModel, NSUInteger provinceIndex, BOOL * _Nonnull stop) {

                if ([selectProvince containsString:citiesModel.name]) {
                    selectProvinceIndex = provinceIndex;

                    self.provinceId = citiesModel._id;
                    self.provinceName = citiesModel.name;
                    [citiesModel.regionList enumerateObjectsUsingBlock:^(DRPNewRegionModel *cityModel, NSUInteger cityIndex, BOOL * _Nonnull stop) {

                        if ([selectCity containsString:cityModel.name]) {
                            selectCityIndex = cityIndex;

                            self.cityId = cityModel._id;
                            self.cityName = cityModel.name;
                            *stop = YES;
                        }
                    }];
                    *stop = YES;
                }
            }];


            self.provinceIndex = selectProvinceIndex;
            self.cityIndex = selectCityIndex;

        } else {

            // 默认值
            DRPNewProvinceModel *citiesModel = self.dataArray.firstObject;
            DRPNewRegionModel *cityModel = citiesModel.regionList.firstObject;
            self.provinceIndex = 0;
            self.cityIndex = 0;

            self.provinceId = citiesModel._id;
            self.provinceName = citiesModel.name;
            self.cityId = cityModel._id;
            self.cityName = cityModel.name;
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

    NSString *result = self.provinceName;
    if ([self.cityName isNotBlank]) {
        result = [result stringByAppendingFormat:@"%@",self.cityName];
    }

    if (self.selecCitiesResult) {
        
        self.selecCitiesResult(self.provinceName, self.cityName, self.provinceId, self.cityId, result);
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

    DRPNewProvinceModel *citiesModel = self.dataArray[self.provinceIndex];
    return citiesModel.regionList.count;
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
        DRPNewProvinceModel *citiesModel = self.dataArray[row];
        title = citiesModel.name;
    } else {
        DRPNewProvinceModel *citiesModel = self.dataArray[self.provinceIndex];
        DRPNewRegionModel *cityModel = citiesModel.regionList[row];
        title = cityModel.name;
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


        DRPNewProvinceModel *citiesModel = self.dataArray[self.provinceIndex];

        self.provinceId = citiesModel._id;
        self.provinceName = citiesModel.name;

//        NSInteger index = [pickerView selectedRowInComponent:1];

        DRPNewRegionModel *cityModel = citiesModel.regionList[self.cityIndex];
        self.cityName = cityModel.name;
        self.cityId = cityModel._id;

        if (![self.cityName isNotBlank]) {
            self.cityName = @"";
        }
        self.cityIndex = 0;

    } else {

        DRPNewProvinceModel *citiesModel = self.dataArray[self.provinceIndex];

        NSArray *array  = citiesModel.regionList;
        NSInteger index = [pickerView selectedRowInComponent:1];

        if (array.count == 0) {
            self.cityName = @"";
        } else if (index > array.count) {
            DRPNewRegionModel *model = [array objectAtIndex:array.count - 1];
            self.cityName = model.name;
        } else {
            DRPNewRegionModel *model = [array objectAtIndex:index];
            self.cityName = model.name;
        }
    }
}

@end
