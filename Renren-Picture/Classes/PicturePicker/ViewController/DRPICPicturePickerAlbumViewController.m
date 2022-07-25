//
//  DRPICPicturePickerAlbumViewController.m
//  Renren-Picture
//
//  Created by Ming on 2020/3/10.
//

#import "DRPICPicturePickerAlbumViewController.h"

#import "UIView+CTLayout.h"

#import "DRPICPicturePickerAlbumTableViewCell.h"

#import "DRPICPicturePickerAlbumTableHeaderView.h"

#import <Photos/Photos.h>

@interface DRPICPicturePickerAlbumViewController ()<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, strong) UITapGestureRecognizer *backgroundTapGestureRecognizer;
@property (nonatomic, strong) DRPICPicturePickerAlbumTableHeaderView *tableHeaderView;
@property (nonatomic, strong) UIView *contentView;

@end

@implementation DRPICPicturePickerAlbumViewController

#pragma mark - Override Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    //    [self createContent];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self createNavigation];
}

#pragma mark - Intial Methods

#pragma mark - Create Methods
- (void)createContent {
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.contentView.frame = CGRectMake(0, 0, self.view.ct_width, 350);
    self.tableView.frame = CGRectMake(0, 50, self.contentView.ct_width, self.contentView.ct_height - 50);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.contentView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.contentView.layer.mask = maskLayer;
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.tableView];
    [self.view addSubview:self.tableHeaderView];
    self.contentView.ct_y = self.tableHeaderView.ct_height - self.contentView.ct_height;
    [self.view addGestureRecognizer:self.backgroundTapGestureRecognizer];
    self.view.clipsToBounds = YES;
    self.tableHeaderView.titleLabel.text = self.viewModel.model.currentAlbum.name;
}

- (void)createNavigation {
    
}

- (void)creatPrepare {
    
}

#pragma mark - Process Methods
- (void)processViewExpand:(BOOL)expand {
    if (self.expand == expand) {
        return;
    }
    //    self.contentView.ct_height = expand ? 0 : 300;
    self.expand = expand;
    self.tableHeaderView.expand = expand;
    CGFloat y = expand ? self.tableHeaderView.ct_height - 50 : self.tableHeaderView.ct_height - self.contentView.ct_height - 50;
    if (self.expand) {
        self.view.ct_height  = self.expandViewHeight;
    }
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.618
                          delay:0
         usingSpringWithDamping:0.618
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        weakSelf.tableHeaderView.titleLabel.text = weakSelf.viewModel.model.currentAlbum.name;
        [weakSelf.tableHeaderView layoutSubviews];
        weakSelf.contentView.ct_y = y;
        if (weakSelf.expand) {
            weakSelf.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
            weakSelf.contentView.alpha = 1;
        } else {
            weakSelf.view.backgroundColor = [UIColor clearColor];
            weakSelf.contentView.alpha = 0.7;
        }
    }completion:^(BOOL finished) {
        if (weakSelf.expand == NO) {
            weakSelf.view.ct_height  = weakSelf.stowedViewHeight;
        }
    }];
}

#pragma mark - Event Methods
- ( BOOL )gestureRecognizer:( UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:( UITouch *)touch {
    if (touch.view == self.view || touch.view == self.tableHeaderView) {
        return YES;
    }
    return NO;
    
}

- (void)eventBackgroundClick:(UIGestureRecognizer *)gestureRecognizer {
    [self processViewExpand:!self.expand];
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView  {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.model.albums.count;
}

-  (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DRPICPicturePickerAlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlbumTableViewCell"];
    if (cell == nil) {
        cell = [[DRPICPicturePickerAlbumTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AlbumTableViewCell"];
    }
    DRPICAlbum *album = self.viewModel.model.albums[indexPath.row];
    DRPICPicture *firstPicture = album.pictures.firstObject;
    cell.titleLabel.text = album.name;
    cell.countLabel.text = [NSString stringWithFormat:@"(%ld)",(long)album.count];
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc]init];
    //设置为同步, 只会返回1张图片
    options.synchronous = NO;
     [[PHCachingImageManager defaultManager]requestImageForAsset:firstPicture.source.asset targetSize:CGSizeMake(100, 100) contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            cell.previewIamgeView.image = result;
    //        weakSelf.picture.source.thumbnailImage = result;
        }];
    return cell;
}

#pragma mark - UITableViewDelegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self eventBackgroundClick:nil];
    DRPICAlbum *album = self.viewModel.model.albums[indexPath.row];
    self.viewModel.model.currentAlbum = album;
    self.tableHeaderView.titleLabel.text = album.name;
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.618
                          delay:0
         usingSpringWithDamping:0.618
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        
        [weakSelf.tableHeaderView layoutSubviews];
    }completion:^(BOOL finished) {
       
    }];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(albumViewController:didSelectAlbumAtIndex:album:)]) {
        [self.delegate albumViewController:self didSelectAlbumAtIndex:indexPath.row album:self.viewModel.model.currentAlbum];
    }
}

#pragma mark - LazyLoad Methods
- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.bounces = NO;
        _tableView = tableView;
    }
    return _tableView;
}

- (DRPICPicturePickerAlbumTableHeaderView *)tableHeaderView {
    if (!_tableHeaderView) {
        DRPICPicturePickerAlbumTableHeaderView *tableHeaderView = [[DRPICPicturePickerAlbumTableHeaderView alloc] initWithFrame:(CGRect){0.,0.,self.view.bounds.size}];
        _tableHeaderView = tableHeaderView;
    }
    return _tableHeaderView;
}

- (UIView *)contentView {
    if (!_contentView) {
        UIView *contentView = [UIView new];
        _contentView = contentView;
    }
    return _contentView;
}
- (UITapGestureRecognizer *)backgroundTapGestureRecognizer {
    if (!_backgroundTapGestureRecognizer) {
        UITapGestureRecognizer *backgroundTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(eventBackgroundClick:)];
        backgroundTapGestureRecognizer.delegate = self;
        _backgroundTapGestureRecognizer = backgroundTapGestureRecognizer;
    }
    return _backgroundTapGestureRecognizer;
}
@end
