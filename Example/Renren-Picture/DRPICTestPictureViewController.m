//
//  DRPICTestPictureViewController.m
//  Renren-Picture_Example
//
//  Created by 陈金铭 on 2019/8/26.
//  Copyright © 2019 418589912@qq.com. All rights reserved.
//

#import "DRPICTestPictureViewController.h"
#import <UIImageView+WebCache.h>
#import "DRPICPictureBrowserViewController.h"

#import "DRPICTimeLinePictureBrowserViewController.h"

#import "DNRouter.h"

@interface DRPICTestPictureViewController ()<UINavigationControllerDelegate, DRPictureBrowserViewControllerDelegate>

@property(nonatomic, strong) NSMutableArray<NSString *> *pictureUrlStrings;
@property(nonatomic, strong) NSMutableArray<UIImageView *> *pictureImageViews;
@end

@implementation DRPICTestPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    self.navigationController.delegate = self;
    UIColor *color = nil;
    if (@available(iOS 13.0, *)) {
        color = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            switch (traitCollection.userInterfaceStyle) {
                case UIUserInterfaceStyleLight:
                    return [UIColor whiteColor];
                case UIUserInterfaceStyleDark:
                    return [UIColor darkGrayColor];
                default:
                    return [UIColor whiteColor];
            }
            
        }];
        
    } else {
        color = [UIColor whiteColor];
    }
    self.view.backgroundColor = color;
    [self.pictureUrlStrings addObjectsFromArray:@[@"http://5b0988e595225.cdn.sohucs.com/images/20180523/93c796f46fd5417a9af7ba0b9ae87627.gif",
                                                  @"http://wx2.sinaimg.cn/orj360/005uHThBly1g93flbzlrpj30ku2zd7wh.jpg",
                                                  @"http://5b0988e595225.cdn.sohucs.com/images/20180211/e69a33d906614c628ccca14b72b3c6cd.gif",
                                                  @"http://wx4.sinaimg.cn/orj360/006jxyvWgy1gb4gk66u8lj30jwcmhkjv.jpg",
                                                  @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.soogif.com%2F7WlqblKuyOik2GvMkFSzhrMgx5zTe4ta.gif&refer=http%3A%2F%2Fimg.soogif.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1653029588&t=105c9d2d0be14e83a640860a4a518d0d",
                                                  @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fc-ssl.duitang.com%2Fuploads%2Fitem%2F202002%2F15%2F20200215151940_dnbpc.thumb.1000_0.gif&refer=http%3A%2F%2Fc-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1653029588&t=f2626eb7a414a39070f9f50e50a40435",
                                                  @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fhbimg.b0.upaiyun.com%2F0c27155f2a4f78a4d48d20e9b6305fdac53fa1c32d9a8-7BtqWm_fw658&refer=http%3A%2F%2Fhbimg.b0.upaiyun.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1653029588&t=463ab4e3c860bfb5c40ef6f82e2f673d",
                                                  @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F014e375d84fa16a801211d53de3c60.gif&refer=http%3A%2F%2Fimg.zcool.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1653029588&t=d432476ca40a0319033a289f8305e7e3",
                                                  @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fhiphotos.baidu.com%2Ffeed%2Fpic%2Fitem%2F3801213fb80e7beccd71ed8c242eb9389b506b30.jpg&refer=http%3A%2F%2Fhiphotos.baidu.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1653029588&t=df4ebef2857673f06318a7a820899791",
                                                  @"https://ww4.sinaimg.cn/bmiddle/006CXMjely1gbpcq01kicj30ku5cde81.jpg",
                                                  @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fpic.jj20.com%2Fup%2Fallimg%2F911%2F041316123518%2F160413123518-9.jpg&refer=http%3A%2F%2Fpic.jj20.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1653029472&t=eba7f59a0efa1c2d049b42e95cc99f06",
                                                  @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fc-ssl.duitang.com%2Fuploads%2Fitem%2F202004%2F29%2F20200429184837_RCaTN.thumb.400_0.jpeg&refer=http%3A%2F%2Fc-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1653029472&t=87dfd8bb74be818f7370149176795a79",
                                                  @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fpic.jj20.com%2Fup%2Fallimg%2F1011%2F0Q51G53052%2F1FQ5153052-9.jpg&refer=http%3A%2F%2Fpic.jj20.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1653029472&t=12c6e64db6922bd5e3daf8c2ffa372c1",
                                                  ]];
    CGFloat imageWidth = 100;
    CGFloat imageHeight = 100;
    CGFloat marginX = 15;
    CGFloat marginY = 15;
    NSInteger totalColumns = 3;
    for (NSInteger i = 0; i < self.pictureUrlStrings.count; i++) {
        UIImageView *imageView = [UIImageView new];
        imageView.backgroundColor = [UIColor redColor];
        //        [imageView sd_setImageWithURL:;
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.pictureUrlStrings[i]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            CGFloat rect = image.size.width / image.size.height;
            if (rect < 0.5) {
                imageView.layer.contentsRect = CGRectMake(0,0,1,rect);
            }
        }];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        NSInteger row = i / totalColumns;
        NSInteger col = i % totalColumns;
        CGFloat imageX = 15 + col * (imageWidth + marginX);
        CGFloat imageY = 100 + row * (imageHeight + marginY);
        imageView.frame = (CGRect){imageX,imageY,imageWidth,imageHeight};
        [imageView ct_addTarget:self action:@selector(eventPictureClick:)];
        [self.pictureImageViews addObject:imageView];
        [self.view addSubview:imageView];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"DRPICTestPictureViewController---viewWillAppear");
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"DRPICTestPictureViewController---viewDidAppear");
    //    [self createLeftBarButtonItem:DRBNavigationBarLeftTypeWhite image:nil target:self action:@selector(eventLeftLeftBarButtonClick:)];
    
}
/** 配合createLeftBar使用,点击返回事件，子类可重写 */
- (void)eventLeftLeftBarButtonClick:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)eventPictureClick:(UIGestureRecognizer*)gestureRecognizer {
    UIImageView *currentImageView = (UIImageView *)gestureRecognizer.view;
    NSMutableArray<DRPICPicture *> *tempPictues = [NSMutableArray<DRPICPicture *> array];
    for (NSInteger i = 0; i < self.pictureImageViews.count; i++) {
        NSString *url = self.pictureUrlStrings[i];
        UIImageView *imageView = self.pictureImageViews[i];
        DRPICPicture *picture = [DRPICPicture new];
        picture.source.thumbnailUrlString = url;
        picture.source.originUrlString = url;
        picture.source.sourceImageView = imageView;
        DRPICPictureTag *tagModel = [DRPICPictureTag new];
        tagModel.tagText = @"标签初始位置";
        tagModel.tagid = @"123123";
        tagModel.point = CGPointMake(0.5, 0.5);
        tagModel.type = DRPICPictureTagTypeLocation;
        tagModel.direction = DRPICPictureTagDirectionRight;
        picture.tags = [NSMutableArray arrayWithArray:@[tagModel]];
        [tempPictues addObject:picture];
    }
    
    switch (self.type) {
        case DRPICTestPictureViewControllerTypePush:
        {
            DRPICPictureBrowserViewController *pictureBrowserViewController = [DRPICPictureBrowserViewController new];
            pictureBrowserViewController.currentIndex = [self.pictureImageViews indexOfObject:currentImageView];
            pictureBrowserViewController.pictures = tempPictues;
            pictureBrowserViewController.fromViewController = self;
            pictureBrowserViewController.delegate = self;
            [self.navigationController pushViewController:pictureBrowserViewController animated:YES];
        }
            
            break;
        case DRPICTestPictureViewControllerTypePresent:
        {
            
            DRPICPictureBrowserViewController *pictureBrowserViewController = [DRPICPictureBrowserViewController new];
            pictureBrowserViewController.currentIndex = [self.pictureImageViews indexOfObject:currentImageView];
            pictureBrowserViewController.pictures = tempPictues;
            pictureBrowserViewController.fromViewController = self;
            pictureBrowserViewController.delegate = self;
            pictureBrowserViewController.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:pictureBrowserViewController animated:YES completion:nil];
        }
            
            break;
        case DRPICTestPictureViewControllerTypeTimeLine:
        {
            DRPICTimeLinePictureBrowserViewController *pictureBrowserViewController = [DRPICTimeLinePictureBrowserViewController new];
            pictureBrowserViewController.currentIndex = [self.pictureImageViews indexOfObject:currentImageView];
            pictureBrowserViewController.pictures = tempPictues;
            pictureBrowserViewController.fromViewController = self;
            pictureBrowserViewController.delegate = self;
            [self.navigationController pushViewController:pictureBrowserViewController animated:YES];
        }
            
            break;
        default:
            break;
    }
    
}

- (void)pictureBrowser:(DRPICPictureBrowserViewController *)pictureBrowser willAppearRowAtIndex:(NSInteger)index {
    
    
}

-(void)pictureBrowser:(DRPICPictureBrowserViewController *)pictureBrowser didAppearRowAtIndex:(NSInteger)index {
    if (index == pictureBrowser.pictures.count - 1) {
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSArray *tempPictureStrings = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583319959960&di=2ff6071e11fd0a6d6109fefae8294829&imgtype=0&src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fimages%2F20170915%2Fe87903446ca04b0689a0e2c0174fbb8e.gif",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583319959921&di=9a03b861bdd34f05476370b10b3801d5&imgtype=0&src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fimages%2F20171230%2Fecd4e57515cd460fa559654c0ca0f255.gif",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583320049095&di=068df697d5b457c48afec178b403d3de&imgtype=0&src=http%3A%2F%2Finews.gtimg.com%2Fnewsapp_match%2F0%2F5759429688%2F0",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583320049095&di=7ae34d87954e07ef9ff5ce93116e4e2d&imgtype=0&src=http%3A%2F%2Fwww.17qq.com%2Fimg_biaoqing%2F75643592.jpeg"];
            NSMutableArray<DRPICPicture *> *tempPictues = [NSMutableArray<DRPICPicture *> array];
            for (NSInteger i = 0; i < tempPictureStrings.count; i++) {
                NSString *url = tempPictureStrings[i];
//                UIImageView *imageView = self.pictureImageViews[i];
                DRPICPicture *picture = [DRPICPicture new];
                picture.source.thumbnailUrlString = url;
                picture.source.originUrlString = url;
//                picture.source.sourceImageView = imageView;
                DRPICPictureTag *tagModel = [DRPICPictureTag new];
                tagModel.tagText = @"大本钟华莱士";
                tagModel.tagid = @"123123";
                tagModel.point = CGPointMake(0.5, 0.5);
                tagModel.type = DRPICPictureTagTypeLocation;
                tagModel.direction = DRPICPictureTagDirectionRight;
                picture.tags = [NSMutableArray arrayWithArray:@[tagModel]];
                [tempPictues addObject:picture];
            }
            [pictureBrowser processAddPictures:tempPictues.copy];
        });
    }
}

- (void)pictureBrowser:(DRPICPictureBrowserViewController *)pictureBrowser didTagEventRowAtIndex:(NSInteger)index tag:(DRPICPictureTag *)tag {
    
}

#pragma mark 长按图片代理事件
- (void)pictureBrowser:(DRPICPictureBrowserViewController *)pictureBrowser longPressWithIndex:(NSInteger)index{
    NSLog(@"长按了图片");
    UIImage *image = pictureBrowser.pictures[index].source.showImage;
    [DNRouter openURL:@"RR://MaterialEditor/PhotoEdit" withUserInfo:@{@"navigationVC" : self.navigationController,@"originImage" : image } completion:^(id  _Nullable result) {
        if (result && [result isKindOfClass:[UIImage class]]) {
            UIImage *resultImage = (UIImage *)result;
        }
    }];
    
}

- (NSMutableArray *)pictureUrlStrings {
    if (!_pictureUrlStrings) {
        NSMutableArray *pictureUrlStrings = [NSMutableArray array];
        _pictureUrlStrings = pictureUrlStrings;
    }
    return _pictureUrlStrings;
}

- (NSMutableArray<UIImageView *> *)pictureImageViews {
    if (!_pictureImageViews) {
        NSMutableArray<UIImageView *> *pictureImageViews = [NSMutableArray<UIImageView *> array];
        _pictureImageViews = pictureImageViews;
    }
    return _pictureImageViews;
}

@end
