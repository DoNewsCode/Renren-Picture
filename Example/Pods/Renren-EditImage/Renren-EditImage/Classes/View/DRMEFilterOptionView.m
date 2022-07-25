//
//  DRMEFilterOptionView.m
//  Renren-EditImage
//
//  Created by 李晓越 on 2020/3/16.
//

#import "DRMEFilterOptionView.h"
#import "DRMEFilterOptionCell.h"

#import "DRFTFilterManager.h"
#import "DRFTFilterModel.h"

#import "DRFTFilterModel+DRMEExtension.h"

@interface DRMEFilterOptionView ()<UICollectionViewDelegate, UICollectionViewDataSource,DRMEFilterOptionCellDelegate>

@property(nonatomic,strong) NSMutableArray<DRFTFilterModel*> *dataList;
@property(nonatomic,weak) UICollectionView *collectionView;
@property(nonatomic,strong) DRFTFilterModel *lastSeletedModel;

@end

@implementation DRMEFilterOptionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        [self setupSubviews];
    }
    return self;
}

- (void)loadFilterData
{

    @weakify(self)
    
    self.dataList = [DRFTFilterManager manager].filterArray.copy;
    
    if (self.dataList.count) {
        [self loadDataSuccess];
    } else {
        [[DRFTFilterManager manager] refreshFilterListSuccess:^{
            @strongify(self)
            [self loadDataSuccess];
        } failureBlock:^(NSString * _Nonnull errorStr) {
            @strongify(self)
            [self loadDataSuccess];
        }];
    }
    
}

- (void)loadDataSuccess
{
    self.dataList = [DRFTFilterManager manager].filterArray.copy;
    
    for (NSInteger i = 0; i < self.dataList.count; ++i) {
        DRFTFilterModel *model = self.dataList[i];
        model.selected = NO;
        model.currentIntensity = model.intensity;
    }
    
    [self.collectionView reloadData];
    
    if ([self.delegate respondsToSelector:@selector(filterLodaSuccess:)]) {
        [self.delegate filterLodaSuccess:self.dataList.count];
    }
}

- (void)setupSubviews
{
    
    // 取消
    UIButton *cancelBtn = [[UIButton alloc] init];
    [cancelBtn setImage:[UIImage me_imageWithName:@"me_cancel"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(clickCancelBtn)
        forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
    self.cancelBtn = cancelBtn;

    cancelBtn.sd_layout.leftSpaceToView(self, 10)
    .bottomSpaceToView(self, 28)
    .widthIs(44).heightIs(44);
    
    // 确定
    UIButton *sureBtn = [[UIButton alloc] init];
    [sureBtn setImage:[UIImage me_imageWithName:@"me_sure"] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(clickSureBtn)
        forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sureBtn];
    self.sureBtn = sureBtn;
    
    sureBtn.sd_layout.rightSpaceToView(self, 10)
    .bottomSpaceToView(self, 28)
    .widthIs(44).heightIs(44);
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    /**
     设置item的大小
     */
    layout.itemSize = CGSizeMake(70, 100);
    layout.minimumInteritemSpacing = 5;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                          collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;

    [collectionView registerNib:[UINib nibWithNibName:@"DRMEFilterOptionCell" bundle:[NSBundle me_Bundle]] forCellWithReuseIdentifier:@"DRMEFilterOptionCell"];
    
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    
    collectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 15);
    collectionView.sd_layout.leftEqualToView(self)
    .rightEqualToView(self)
    .topEqualToView(self)
    .bottomSpaceToView(cancelBtn, 10);
    
    [collectionView updateLayout];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataList.count == 0) {
        return [UICollectionViewCell new];
    }
    NSInteger row = indexPath.row;
    
    DRMEFilterOptionCell *cell = [DRMEFilterOptionCell filterOptionCellWithCollectionView:collectionView atIndexPath:indexPath];
    DRFTFilterModel *model = self.dataList[row];
    cell.filterModel = model;
    cell.delegate = self;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    DRFTFilterModel *model = self.dataList[row];
    NSLog(@"model == %@", model.name);
    if ([self.delegate respondsToSelector:@selector(filterOptionView:clickFilterIndex:filterModel:)]) {
        [self.delegate filterOptionView:self clickFilterIndex:row filterModel:model];
    }
    
    [self scrollToIndex:row animated:YES];
}

// 根据index滚动UICollectionView到合适的位置
- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animated];
    
    // 改变模型，更新选择状态
    DRFTFilterModel *model = self.dataList[index];
    
    if (model != self.lastSeletedModel) {
        self.lastSeletedModel.selected = NO;
        
//        if (index == 0) {
//            // 原图不需要有滑杆
//        } else {
            model.selected = YES;
//        }
        self.lastSeletedModel = model;
    }
    
    [self.collectionView reloadData];
    
}

#pragma mark - DRMEFilterOptionCellDelegate
- (void)filterOptionCellDidClick:(DRMEFilterOptionCell *)cell
{
    // 显示参数设置view
    if ([self.delegate respondsToSelector:@selector(filterOptionIntensityDidClick)]) {
        [self.delegate filterOptionIntensityDidClick];
    }
}

#pragma mark - 事件
- (void)clickCancelBtn
{
    if ([self.delegate respondsToSelector:@selector(filterOptionViewClickCancel)]) {
        [self.delegate filterOptionViewClickCancel];
    }
}

- (void)clickSureBtn
{
    if ([self.delegate respondsToSelector:@selector(filterOptionViewClickSure)]) {
        [self.delegate filterOptionViewClickSure];
    }
}

@end
