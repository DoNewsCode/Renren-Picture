//
//  DRMEEditVideoOptionView.m
//  Renren-EditImage
//
//  Created by 李晓越 on 2019/10/22.
//

#import "DRMEEditVideoOptionView.h"
#import "DRMEEditOptionModel.h"
#import "DRMEEditOptionCell.h"

@interface DRMEEditVideoOptionView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property(nonatomic,strong) NSMutableArray *dataList;

@end

@implementation DRMEEditVideoOptionView

- (NSMutableArray *)dataList
{
    if (!_dataList) {
        
        _dataList = [NSMutableArray array];
        
        DRMEEditOptionModel *tailor = [[DRMEEditOptionModel alloc] init];
        tailor.editOption = DRMEEditOptionVideoTailor;
        tailor.titleStr = @"剪视频";
        tailor.imageStr = @"me_video_tailor_btn";
        
        DRMEEditOptionModel *filter = [[DRMEEditOptionModel alloc] init];
        filter.editOption = DRMEEditOptionFilter;
        filter.titleStr = @"滤镜";
        filter.imageStr = @"me_filter_btn";
        
        [_dataList addObjectsFromArray:@[tailor, filter]];
        
    }
    return _dataList;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor blackColor];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    /**
     设置item的大小
     */
    layout.itemSize = CGSizeMake(50, 60);
    layout.minimumInteritemSpacing = 0;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                          collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;

    [collectionView registerNib:[UINib nibWithNibName:@"DRMEEditOptionCell"
                                               bundle:[NSBundle me_Bundle]]
     forCellWithReuseIdentifier:@"DRMEEditOptionCell"];
    
    [self addSubview:collectionView];
    collectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
    collectionView.sd_layout.leftEqualToView(self)
    .rightEqualToView(self)
    .topEqualToView(self)
    .bottomEqualToView(self);
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DRMEEditOptionCell *cell = [DRMEEditOptionCell editOptionCellWithCollectionView:collectionView
                                                                        atIndexPath:indexPath];
    
    DRMEEditOptionModel *model = self.dataList[indexPath.item];
    cell.editOptionModel = model;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    DRMEEditOptionModel *model = self.dataList[indexPath.item];
    
    if ([self.delegate respondsToSelector:@selector(editPhotoOptionView:clickOptionModel:)]) {
        [self.delegate editPhotoOptionView:self clickOptionModel:model];
    }
}

@end
