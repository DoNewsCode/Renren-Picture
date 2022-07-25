//
//  DRIAlbumListPopViewController.m
//  RenrenOfficial-iOS-Concept
//
//  Created by 张健康 on 2019/3/16.
//  Copyright © 2019 renren. All rights reserved.
//

#import "DRIAlbumListPopViewController.h"
#import "DRIAlbumListPopCell.h"
#import "DRIAlbumListPopDataSource.h"
#import "DRIImageManager.h"
#import "UIView+BinAdd.h"
#import <DNCommonKit/UIView+CTLayout.h>
#import <DNCommonKit/DNBaseMacro.h>
#import <DNCommonKit/UIColor+CTHex.h>
#import "SDAutoLayout.h"
#define ALBUM_PAGE_SIZE 2000  //设置一个极大数目
static NSString *kDRIAlbumListCellIdentitfier = @"kDRIAlbumListCellIdentitfier";


@interface DRIAlbumListPopViewController () <UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    int _currentPageIndex;
}

@property(nonatomic, strong)UIView *bgView;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)DRIAlbumListPopDataSource *dataSource;

@end


@implementation DRIAlbumListPopViewController

- (id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.opaque = NO;
    self.view.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.4];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(onTapOverlayView:)];
    singleTap.delegate = self;
    [self.view addGestureRecognizer:singleTap];
    self.navigationController.navigationBarHidden = YES;
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, DNNavHeight, self.view.ct_width, 260)];
    CGRect rect = self.bgView.bounds;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10,10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    _bgView.layer.mask = maskLayer;
    self.tableView.frame = CGRectMake(0, 0, self.bgView.ct_width, 260);
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.tableView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _bgView.ct_width, 1)];
    view.backgroundColor = [UIColor ct_colorWithHex:0xE6E6E6];
    [self.bgView addSubview:view];
    [self loadData];
}

- (void)showAlbumListInView:(UIView *)view fromRect:(CGRect)fromRect animated:(BOOL)animated{
    CGFloat bgViewLeft = 0;
    CGFloat bgViewTop  = fromRect.origin.y;
    self.bgView.top = 0;
    [self.view addSubview:self.bgView];
    //    [self.view addSubview:self.tableView];
    self.view.top = bgViewTop;
    [view addSubview:self.view];
    
    if (animated) {
//        const CGRect toFrame = self.bgImageView.frame;
//        self.bgImageView.alpha = 0.f;
////        self.bgImageView.frame = (CGRect){self.bgImageView.centerX, self.bgImageView.top, 1, 1};
//        self.tableView.hidden = YES;
//        [UIView animateWithDuration:0.2
//                         animations:^(void) {
//                             self.bgImageView.alpha = 1;
//                             self.bgImageView.frame = toFrame;
//                         } completion:^(BOOL completed) {
//                             self.tableView.hidden = NO;
//                             [self.tableView reloadData];
//                         }];
    } else {
        [_tableView reloadData];
    }
    
    [view bringSubviewToFront:self.view];
}

- (void)dismissAlbumList:(BOOL)animated{
    if (animated) {
//        self.tableView.hidden = YES;
//        const CGRect toFrame = (CGRect){self.bgImageView.centerX, self.bgImageView.top, 1, 1};
        [UIView animateWithDuration:0.2
                         animations:^(void) {
//                             self.bgImageView.alpha = 0;
//                             self.bgImageView.frame = toFrame;
                         } completion:^(BOOL finished) {
                             if (self.view.superview != nil)
                                 [self.view removeFromSuperview];
                         }];
    } else {
        if (self.view.superview != nil)
            [self.view removeFromSuperview];
    }
    
    if (_delegate != nil &&
        [_delegate respondsToSelector:@selector(albumListDismissed)]) {
        [_delegate albumListDismissed];
    }
}

- (void)loadData{
    [self.dataSource getSystemAlbums:^(NSArray<DRIAlbumModel *> * _Nonnull mdoels) {
        [self.tableView reloadData];
    }];
}

- (void)loadLocalData{
//    NSDictionary *info = [RHCFilePlistDAO getDicDataForKey:kAlbumPath];
//    NSArray *albumArray = [info objectForKey:@"album_list"];
//    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
//
//    [albumArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        AlbumObject *albumObj = [AlbumObject objWithDictionary:obj];
//        [resultArray addObject:albumObj];
//    }];
//    if (resultArray) {
//        [((DRIAlbumListPopDataSource *)self.dataSource) resetAlbum:resultArray];
//    }
}

#pragma mark --DRIAlbumSelectDelegate
- (void)selectAlbum:(NSMutableDictionary *)albumInfo{
    if (!albumInfo) {
        [self.delegate didSelectAlbum:nil];
        [self dismissAlbumList:YES];
        return;
    }
    [self loadData];
    if ([self.delegate respondsToSelector:@selector(didSelectAlbum:)]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:albumInfo];
        if ([albumInfo objectForKey:@"password"]) {
            [dic setObject:[NSNumber numberWithBool:NO] forKey:@"visible"];
        }
        else {
            if ([[dic objectForKey:@"visible"] integerValue] == -1)
                [dic setObject:[NSNumber numberWithBool:NO] forKey:@"visible"];
            else
                [dic setObject:[NSNumber numberWithBool:YES] forKey:@"visible"];
        }
        [self.delegate didSelectAlbum:dic];
        [self dismissAlbumList:YES];
    }
}

#pragma mark - UI Actions
- (void)onTapOverlayView:(UITapGestureRecognizer *)recognizer{
    [self dismissAlbumList:YES];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    CGPoint touchPoint = [touch locationInView:self.view];
//    touchPoint.y -= DNNavHeight;
    if (CGRectContainsPoint(_tableView.frame, touchPoint)) {
        return NO;
    }
    return YES;
}

#pragma mark -- uitableview
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DRIAlbumModel *item = [self.dataSource.dataArray objectAtIndex:indexPath.row];
//    if (indexPath.row == 0) {
//        [self addAlbumAction];
//        return;
//    }
//    if ([self.delegate respondsToSelector:@selector(selectAlbum:)]) {
//        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//        [dict setObject:item.id forKey:@"id"];
//        [dict setObject:item.title forKey:@"title"];
//
//        //将sourceControl添加到可变字典中，对应的key为“sourceControl”，方便其获取
//        [dict setObject:[NSNumber numberWithInteger:item.sourceControl] forKey:@"sourceControl"];
//        [dict setObject:[NSNumber numberWithBool:item.has_passwprd] forKey:@"has_passwprd"];
        [self.delegate didSelectAlbum:item];
    [self dismissAlbumList:YES];
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DRIAlbumListPopCell *cell = [tableView dequeueReusableCellWithIdentifier:kDRIAlbumListCellIdentitfier];
    if (cell == nil) {
        cell = [[DRIAlbumListPopCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kDRIAlbumListCellIdentitfier];
    }
    DRIAlbumModel *item = [self.dataSource.dataArray objectAtIndex:indexPath.row];
    if ([item.name isEqualToString:self.model.name]) {
        cell.backgroundColor = [UIColor ct_colorWithHex:0xF1F1F1];
        cell.line.hidden = YES;
    }else{
        cell.backgroundColor = UIColor.whiteColor;
        cell.line.hidden = NO;
    }
    [cell setObject:item];
    return cell;
}

#pragma mark --property
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[DRIAlbumListPopCell class] forCellReuseIdentifier:kDRIAlbumListCellIdentitfier];
    }
    return _tableView;
}

- (DRIAlbumListPopDataSource *)dataSource{
    if (!_dataSource) {
        _dataSource = [[DRIAlbumListPopDataSource alloc] init];
    }
    return _dataSource;
}

@end
