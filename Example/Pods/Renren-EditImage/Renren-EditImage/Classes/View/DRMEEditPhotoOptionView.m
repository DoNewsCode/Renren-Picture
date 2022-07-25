//
//  DRMEEditPhotoOptionView.m
//  Renren-EditImage
//
//  Created by 李晓越 on 2019/10/22.
//

#import "DRMEEditPhotoOptionView.h"
#import "DRMEEditOptionModel.h"
#import "DRMEEditOptionCell.h"

@interface DRMEEditPhotoOptionView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property(nonatomic,strong) NSMutableArray *dataList;
@property(nonatomic,assign) BOOL isFromChat;

@end

@implementation DRMEEditPhotoOptionView

- (NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [NSMutableArray array];

        /**
         DRMEEditOptionTailor = 1,                   // 裁剪
         DRMEEditOptionMosaic,                       // 马赛克
         DRMEEditOptionStickers,                     // 贴纸
         DRMEEditOptionBrush,                        // 画笔
         DRMEEditOptionText,                         // 文字
         DRMEEditOptionTag,                          // 标签
         */
        // 只保留滤镜
        DRMEEditOptionModel *tailor = [[DRMEEditOptionModel alloc] init];
        tailor.editOption = DRMEEditOptionTailor;
        tailor.titleStr = @"裁剪";
        tailor.imageStr = @"me_tailor_btn";
        
        DRMEEditOptionModel *filter = [[DRMEEditOptionModel alloc] init];
        filter.editOption = DRMEEditOptionFilter;
        filter.titleStr = @"滤镜";
        filter.imageStr = @"me_filter_btn";
        
        DRMEEditOptionModel *mosaic = [[DRMEEditOptionModel alloc] init];
        mosaic.editOption = DRMEEditOptionMosaic;
        mosaic.imageStr = @"me_masaike_btn";
        mosaic.titleStr = @"马赛克";
        
       
        DRMEEditOptionModel *tag = [[DRMEEditOptionModel alloc] init];
        tag.editOption = DRMEEditOptionTag;
        tag.imageStr = @"me_tag_btn";
        tag.titleStr = @"标签";

        DRMEEditOptionModel *brush = [[DRMEEditOptionModel alloc] init];
        brush.editOption = DRMEEditOptionBrush;
        brush.imageStr = @"me_brush_btn";
        brush.titleStr = @"画笔";

        DRMEEditOptionModel *text = [[DRMEEditOptionModel alloc] init];
        text.editOption = DRMEEditOptionText;
        text.imageStr = @"me_text_btn";
        text.titleStr = @"文字";

        if (self.isFromChat) {
            [_dataList addObjectsFromArray:@[tailor,filter,mosaic,brush,text]];
        } else {
            [_dataList addObjectsFromArray:@[tailor,filter,tag,mosaic,brush,text]];
        }
        
        
    }
    return _dataList;
}

- (instancetype)initWithIsFromChat:(BOOL)isFromChat
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor blackColor];
        self.isFromChat = isFromChat;
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
    /// 以414计算 6 个按钮的width得到每个按钮的width
    CGFloat width = 414.0f / 6;
    layout.itemSize = CGSizeMake(width, 60);
//    layout.itemSize = CGSizeMake(50, 60);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
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
//    collectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
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
