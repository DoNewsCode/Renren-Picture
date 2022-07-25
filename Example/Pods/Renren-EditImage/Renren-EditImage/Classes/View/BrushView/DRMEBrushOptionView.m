//
//  DRMEBrushOptionView.m
//  Renren-EditImage
//
//  Created by 李晓越 on 2020/4/9.
//

#import "DRMEBrushOptionView.h"

@implementation DRMEBrushModel
@end

@implementation DRMEBrushColorCell

+ (instancetype)brushColorCellWith:(UICollectionView *)collectionView
                         indexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"DRMEBrushColorCell";
    
    DRMEBrushColorCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.layer.cornerRadius = 28/2;
        self.layer.masksToBounds = YES;
        
        self.colorView = [[UIView alloc] initWithFrame:CGRectMake(3, 3, 22, 22)];
        [self.contentView addSubview:self.colorView];
        self.colorView.layer.cornerRadius = 11;
        self.colorView.layer.masksToBounds = YES;
        
    }
    return self;
}

- (void)setBrushModel:(DRMEBrushModel *)brushModel
{
    _brushModel = brushModel;
    self.colorView.backgroundColor = brushModel.color;
    
    if (brushModel.isSelected) {
        self.contentView.backgroundColor = UIColor.whiteColor;
    } else {
        self.contentView.backgroundColor = UIColor.clearColor;
    }
    
    if (brushModel.isBlackColor) {
        
        self.colorView.layer.borderWidth = 1;
        self.colorView.layer.borderColor = [UIColor colorWithHexString:@"#333333"].CGColor;
        
    } else {
        self.colorView.layer.borderWidth = 0;
        self.colorView.layer.borderColor = [UIColor clearColor].CGColor;
    }

}

@end


@interface DRMEBrushOptionView()
<UICollectionViewDataSource,
UICollectionViewDelegate>

@property(nonatomic,strong) NSMutableArray<DRMEBrushModel*> *colorArray;
@property(nonatomic,strong) DRMEBrushModel *currentModel;

@end


@implementation DRMEBrushOptionView

- (NSMutableArray<DRMEBrushModel*> *)colorArray
{
    if (!_colorArray) {
        
        _colorArray = [NSMutableArray array];
        
        DRMEBrushModel *model1 = [DRMEBrushModel new];
        model1.selected = YES;
        model1.color = [UIColor colorWithHexString:@"#FFFFFF"];
        [_colorArray addObject:model1];
        self.currentModel = model1;
        
        DRMEBrushModel *model2 = [DRMEBrushModel new];
        model2.isBlackColor = YES;
        model2.color = [UIColor colorWithHexString:@"#000000"];
        [_colorArray addObject:model2];
        
        DRMEBrushModel *model3 = [DRMEBrushModel new];
        model3.color = [UIColor colorWithHexString:@"#FF0000"];
        [_colorArray addObject:model3];
        
        DRMEBrushModel *model4 = [DRMEBrushModel new];
        model4.color = [UIColor colorWithHexString:@"#FF6400"];
        [_colorArray addObject:model4];
        
        DRMEBrushModel *model5 = [DRMEBrushModel new];
        model5.color = [UIColor colorWithHexString:@"#00B7FF"];
        [_colorArray addObject:model5];
        
        DRMEBrushModel *model6 = [DRMEBrushModel new];
        model6.color = [UIColor colorWithHexString:@"#00FFB2"];
        [_colorArray addObject:model6];
        
        DRMEBrushModel *model7 = [DRMEBrushModel new];
        model7.color = [UIColor colorWithHexString:@"#FFD600"];
        [_colorArray addObject:model7];
        
    }
    return _colorArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    
    self.backgroundColor = [UIColor blackColor];
    
    // 取消
    UIButton *cancelBtn = [[UIButton alloc] init];
    [cancelBtn setImage:[UIImage me_imageWithName:@"me_cancel"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(clickCancelBtn)
        forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];

    cancelBtn.sd_layout.leftSpaceToView(self, 10)
    .bottomSpaceToView(self, 28)
    .widthIs(44).heightIs(44);
    
    // 确定
    UIButton *sureBtn = [[UIButton alloc] init];
    [sureBtn setImage:[UIImage me_imageWithName:@"me_sure"] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(clickSureBtn)
        forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sureBtn];
    
    sureBtn.sd_layout.rightSpaceToView(self, 10)
    .bottomSpaceToView(self, 28)
    .widthIs(44).heightIs(44);
    
    // 撤销
    UIButton *resetBtn = [[UIButton alloc] init];
    [resetBtn setImage:[UIImage me_imageWithName:@"me_reset_mosaic_no"] forState:UIControlStateNormal];
    [resetBtn setImage:[UIImage me_imageWithName:@"me_reset_mosaic_yes"] forState:UIControlStateSelected];
    [resetBtn addTarget:self action:@selector(clickResetBtn)
        forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:resetBtn];
    self.resetBtn = resetBtn;
    
    resetBtn.sd_layout.rightSpaceToView(self, 10)
    .bottomSpaceToView(sureBtn, 20)
    .widthIs(44).heightIs(44);
    
    
    // 这里替换为 color 选择器
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    /**
     设置item的大小
     */
    layout.itemSize = CGSizeMake(28, 28); // itemW + 60
    layout.minimumLineSpacing = 18;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                          collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    [collectionView registerClass:[DRMEBrushColorCell class] forCellWithReuseIdentifier:@"DRMEBrushColorCell"];
    
    [self addSubview:collectionView];
    collectionView.contentInset = UIEdgeInsetsMake(0, 30, 0, 0);
    collectionView.sd_layout.leftEqualToView(self)
    .rightSpaceToView(resetBtn, 20)
    .centerYEqualToView(resetBtn)
    .heightIs(28);
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.colorArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    DRMEBrushColorCell *cell = [DRMEBrushColorCell brushColorCellWith:collectionView indexPath:indexPath];
    NSInteger row = indexPath.row;
    DRMEBrushModel *model = self.colorArray[row];
    cell.brushModel = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger row = indexPath.row;
    DRMEBrushModel *model = self.colorArray[row];
    
    if (self.currentModel != model) {
        self.currentModel.selected = NO;
        self.currentModel = model;
        self.currentModel.selected = YES;
        
        [collectionView reloadData];
        
        if ([self.delegate respondsToSelector:@selector(brushOptionView:didClickBrushModel:)]) {
            [self.delegate brushOptionView:self didClickBrushModel:self.currentModel];
        }
        
    }
    
}

- (void)clickResetBtn
{
    if (self.resetButtonButtonTapped) {
        self.resetButtonButtonTapped();
    }
}

- (void)clickSureBtn
{
    if (self.sureButtonButtonTapped) {
        self.sureButtonButtonTapped();
    }
}

- (void)clickCancelBtn
{
    if (self.cancelButtonButtonTapped) {
        self.cancelButtonButtonTapped();
    }
}

@end
