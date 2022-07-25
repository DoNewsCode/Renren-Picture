//
//  DRPICAlbumTableViewCell.m
//  Renren-Picture
//
//  Created by Luis on 2020/3/2.
//

#import "DRPICAlbumTableViewCell.h"
#import "DRPICAlbumModel.h"
#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width

@interface DRPICAlbumTableViewCell()

@property(nonatomic, strong)UIImageView *albumImageView;
@property(nonatomic, strong)UILabel *albumNameLabel;

@end

@implementation DRPICAlbumTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupCell];
    }
    return self;
}
- (void)setupCell{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.albumImageView.frame = CGRectMake(15, 10, 60, 60);
    self.albumNameLabel.frame = CGRectMake(80, 30, 200, 20);
}
- (void)setAlbumModel:(DRPICAlbumModel *)albumModel{
    _albumModel = albumModel;
    self.albumNameLabel.text = [NSString stringWithFormat:@"%@(%@)", albumModel.collectionTitle, albumModel.collectionNumber];
}
- (void)loadImage:(NSIndexPath *)indexPath{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc]init];
    options.synchronous = YES;
    [[PHCachingImageManager defaultManager]requestImageForAsset:self.albumModel.firstAsset targetSize:CGSizeMake(kScreenWidth / 2, kScreenWidth / 2) contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        self.albumImageView.image = result;
    }];
}
- (UIImageView *)albumImageView{
    if (!_albumImageView) {
        _albumImageView = [[UIImageView alloc]init];
        _albumImageView.contentMode = UIViewContentModeScaleAspectFill;
        _albumImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_albumImageView];

    }
    return _albumImageView;
}
- (UILabel *)albumNameLabel{
    if (!_albumNameLabel) {
        _albumNameLabel = [[UILabel alloc]init];
        _albumNameLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_albumNameLabel];

    }
    return _albumNameLabel;
}
@end
