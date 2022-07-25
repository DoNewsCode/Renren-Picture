//
//  DRIPhototPreviewToolsView.m
//  RenRen-ImagePicker
//
//  Created by leejiaolong on 2020/3/13.
//

#import "DRIPhototPreviewToolsView.h"
#import "DRIAssetModel.h"
#import "UIView+YYAdd.h"
#import "DRIImageManager.h"
#import "UIColor+CTHex.h"
#import "UIView+CTLayout.h"

#define ItemWitdth 62.f

@interface DRIPhototPreviewToolsView()
@property(nonatomic,nonnull)UIScrollView *bgScrollView;
@property(nonatomic,copy)NSArray *selectedModels;
@end

@implementation DRIPhototPreviewToolsView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
       self.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0/ 255.0 alpha:0.79];
       self.userInteractionEnabled = YES;
       UIBlurEffect *blurEffect =[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
       UIVisualEffectView *effectView =[[UIVisualEffectView alloc]initWithEffect:blurEffect];
       effectView.alpha = 0.9;
       effectView.frame = self.bounds;
       [self addSubview:effectView];
       [self addSubview:self.bgScrollView];
    }
    return self;
}

-(UIScrollView*)bgScrollView{
    if (!_bgScrollView) {
        _bgScrollView = [[UIScrollView alloc]init];
        _bgScrollView.frame = self.bounds;
        _bgScrollView.userInteractionEnabled = YES;
        _bgScrollView.showsVerticalScrollIndicator = NO;
        _bgScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _bgScrollView;
}


-(void)updateWithModels:(NSMutableArray<DRIAssetModel *> *)selectedModels currentIndex:(NSInteger)currentInde{
    [self.bgScrollView  removeAllSubviews];
    self.selectedModels = [selectedModels   copy];
    CGFloat baseX = 22;
    CGFloat padding = 0;
    CGFloat baseY = 13;
    BOOL flage = NO;
   int i  =0;
    for (DRIAssetModel *model in selectedModels) {
   DRIPhototPreviewToolsItemView * view =     [DRIPhototPreviewToolsItemView creatWithDRIAssetModel:model];
        view.frame = CGRectMake(baseX, baseY, view.width, view.height);
        baseX += ( padding + view.width);
        if (i == currentInde) {
            flage = YES;
        [view setSelectedStyle];
        }
        [view.actionButton addTarget:self action:@selector(itemBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        view.actionButton.tag = i;
        [self.bgScrollView addSubview:view];
        i++;
    }
    if (baseX+20 <= SCREEN_WIDTH) {
           self.bgScrollView.contentSize = CGSizeMake(SCREEN_WIDTH + 20, 0);
    }else{
          self.bgScrollView.contentSize = CGSizeMake(baseX + 20, 0);
    }

    if (currentInde < 0) {
    }else{
        //添加了新单元 或者点击某个单位 如果 flag 是yes 就说明点击了谋个单位
        if (flage == YES) {
            CGFloat x = 22 + ItemWitdth*currentInde;
        if (x  + ItemWitdth > SCREEN_WIDTH ) {
        [self.bgScrollView setContentOffset:CGPointMake((x + ItemWitdth ) - SCREEN_WIDTH + ItemWitdth , 0) animated:YES];
        }else{
        [self.bgScrollView setContentOffset:CGPointMake(0 , 0) animated:YES];
        }
     
        }else{
            [self.bgScrollView setContentOffset:CGPointMake(self.bgScrollView.contentSize.width - SCREEN_WIDTH , 0) animated:YES];
        }

    }
//    if (currentInde  >= 2 && ( (baseX + selectedModels.count *(62+padding)) > SCREEN_WIDTH) ) {
//        [self.bgScrollView setContentOffset:CGPointMake(padding + currentInde*62 + (currentInde - 1)*7 + 20  , 0) animated:YES];
//    }else{
//    [self.bgScrollView setContentOffset:CGPointMake(0 , 0) animated:YES];
//    }
    


}

-(void)itemBtnClick:(UIButton*)btn{
    if (!self.selectedModels.count) {
        return;
    }
    if (self.myBlock) {
    self.myBlock(btn.tag, [self.selectedModels objectAtIndex:btn.tag]);
    }
}

-(void)didTapItemAtIndex:(PreviewToolsViewBloack)block{
    self.myBlock = block;
}

@end

@interface DRIPhototPreviewToolsItemView ()

@property(nonatomic,strong)UIImageView *imageView;

@end

@implementation DRIPhototPreviewToolsItemView
+(id)creatWithDRIAssetModel:(DRIAssetModel*)model{
    DRIPhototPreviewToolsItemView *item = [[DRIPhototPreviewToolsItemView alloc]initWithFrame:CGRectMake(0, 0, 62+7, 62)];
    item.imageView.frame = CGRectMake(0, 0, 62, 62);
    item.model = model;
    [item addSubview:item.actionButton];
    return item;
}

-(UIButton*)actionButton{
    if (!_actionButton) {
        _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _actionButton.frame = self.bounds;
    }
    return _actionButton;
}
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.layer.cornerRadius = 2;
        _imageView.clipsToBounds = YES;
        _imageView.userInteractionEnabled = YES;
        [self addSubview:_imageView];
    }
    return _imageView;
}
- (void)setModel:(DRIAssetModel *)model {
    _model = model;

     [[DRIImageManager manager] getPhotoWithAsset:model.asset photoWidth:self.width completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        self.imageView.image = photo;
    } progressHandler:nil networkAccessAllowed:NO];
    
}
-(void)setSelectedStyle{
    self.imageView.layer.borderWidth = 3;
    self.imageView.layer.borderColor = [UIColor ct_colorWithHex:0x2A73EB].CGColor;
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}
@end
