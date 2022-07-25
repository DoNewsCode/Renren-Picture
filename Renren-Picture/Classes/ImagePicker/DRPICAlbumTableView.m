//
//  DRPICAlbumTableView.m
//  Renren-Picture
//
//  Created by Luis on 2020/3/2.
//

#import "DRPICAlbumTableView.h"
#import "DRPICAlbumTableViewCell.h"
#import "UIView+DRPICCorner.h"

static NSString *albumTableViewCellIdentifier = @"DRPICAlbumTableViewCell";

@interface DRPICAlbumTableView()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation DRPICAlbumTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        [self setupTableView];
    }
    return self;
}
- (void)setupTableView{
    [self registerClass:[DRPICAlbumTableViewCell class] forCellReuseIdentifier:albumTableViewCellIdentifier];
    self.delegate = self;
    self.dataSource = self;
    self.tableFooterView = [[UIView alloc]init];
    [self drpic_setCornerOnBottomWithRadius:20];


}
- (void)setAssetCollectionList:(NSMutableArray<DRPICAlbumModel *> *)assetCollectionList{
    _assetCollectionList = assetCollectionList;
    [self reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.assetCollectionList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DRPICAlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:albumTableViewCellIdentifier];
    cell.albumModel = self.assetCollectionList[indexPath.row];
    [cell loadImage:indexPath];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.selectedAlbumBlock) {
        self.selectedAlbumBlock(self.assetCollectionList[indexPath.row]);
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.f;
}


@end
