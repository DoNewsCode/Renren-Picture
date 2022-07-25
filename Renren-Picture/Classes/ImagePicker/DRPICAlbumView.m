//
//  DRPICAlbumView.m
//  Renren-Picture
//
//  Created by Luis on 2020/3/2.
//

#import "DRPICAlbumView.h"
#import "DRPICAlbumModel.h"
#import "DRPICAlbumTableView.h"
#import "DNBaseMacro.h"
#import "UIView+DRPICCorner.h"


typedef void(^DRPICAlbumSelectedCompletion)(DRPICAlbumModel *model);
@interface DRPICAlbumView()

@property(nonatomic, strong)NSMutableArray<DRPICAlbumModel *> *assetCollectionList;
@property(nonatomic, strong)UIView *backgroundView;
@property(nonatomic, strong)DRPICAlbumTableView *tableView;
@property(nonatomic, assign) CGFloat albumHeight;
@property(nonatomic, assign) CGFloat navigationBarMaxY;
@property(nonatomic, strong) UIButton *greyTransparentButton;
@property(nonatomic, copy)DRPICAlbumSelectedCompletion albumSelectedCompletion;


@end

@implementation DRPICAlbumView

+ (void)showAlbumView:(NSMutableArray<DRPICAlbumModel *> *)assetCollectionList navigationBarMaxY:(CGFloat)navigationBarMaxY completion:(SelectAlbumCompletion)completion{
    DRPICAlbumView *albumView = [[DRPICAlbumView alloc]init];
    albumView.navigationBarMaxY = navigationBarMaxY;
    albumView.albumSelectedCompletion = completion;
    albumView.assetCollectionList = assetCollectionList;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self setupAlbumView];
    }
    return self;
}
- (void)setupAlbumView{
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [[UIApplication sharedApplication].keyWindow addSubview:self];

    [self greyTransparentButton];
    [self tableView];
}
- (void)showAnimation{
    [self layoutIfNeeded];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.75 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakSelf.greyTransparentButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        weakSelf.backgroundView.frame = CGRectMake(0, self.navigationBarMaxY, SCREEN_WIDTH, weakSelf.albumHeight);
    } completion:^(BOOL finished) {

    }];
}
- (void)hideAnimation{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.greyTransparentButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        weakSelf.backgroundView.frame = CGRectMake(0, self.navigationBarMaxY, SCREEN_WIDTH, 0.00001);
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}
- (void)setAssetCollectionList:(NSMutableArray<DRPICAlbumModel *> *)assetCollectionList{
    _assetCollectionList = assetCollectionList;

    self.albumHeight = assetCollectionList.count * 80.f;
    if (self.albumHeight > SCREEN_HEIGHT - DNNavHeight - DNTabbarHeight) {
        self.albumHeight = SCREEN_HEIGHT - DNNavHeight - DNTabbarHeight;
    }
    self.backgroundView.frame = CGRectMake(0, self.navigationBarMaxY, SCREEN_WIDTH, 0.0001);

    self.tableView.assetCollectionList = assetCollectionList;

    CGRect tableViewFrame = self.tableView.frame;
    tableViewFrame.size = CGSizeMake(tableViewFrame.size.width, self.albumHeight);
    self.tableView.frame = tableViewFrame;

    __weak typeof(self) weakSelf = self;
    self.tableView.selectedAlbumBlock = ^(DRPICAlbumModel *model) {
        if (weakSelf.albumSelectedCompletion) {
            weakSelf.albumSelectedCompletion(model);
        }
        [weakSelf hideAnimation];
    };
    [self showAnimation];
}
-(void)clickCancel:(UIButton *)sender{
    if (self.albumSelectedCompletion) {
        self.albumSelectedCompletion(nil);
    }
    [self hideAnimation];
}
- (DRPICAlbumTableView *)tableView{
    if (!_tableView) {
        _tableView = [[DRPICAlbumTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        [self.backgroundView addSubview:_tableView];
    }
    return _tableView;
}
- (UIView *)backgroundView{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc]init];
        _backgroundView.backgroundColor = [UIColor whiteColor];
        _backgroundView.layer.masksToBounds = YES;
        
//        [_backgroundView drpic_setCornerOnBottomWithRadius:15.f];

        [self addSubview:_backgroundView];
    }
    return _backgroundView;
}
-(UIButton *)greyTransparentButton {
    if (!_greyTransparentButton) {
        _greyTransparentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _greyTransparentButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        [_greyTransparentButton addTarget:self action:@selector(clickCancel:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_greyTransparentButton];
        _greyTransparentButton.frame = CGRectMake(0, DNNavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - DNNavHeight);
    }
    return _greyTransparentButton;
}
@end
