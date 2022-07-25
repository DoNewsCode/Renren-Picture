//
//  DRPICTestPickerViewController.m
//  Renren-Picture_Example
//
//  Created by Luis on 2020/3/2.
//  Copyright © 2020 418589912@qq.com. All rights reserved.
//

#import "DRPICTestPickerViewController.h"
#import "DRPICImagePickerController.h"

#import "DRPICPicturePickerViewController.h"

#import <Photos/Photos.h>
static NSString *cellIdentifier = @"DRPICViewControllerCell";


@interface DRPICTestPickerViewController ()
@property(nonatomic, strong) NSArray *pages;

@end

@implementation DRPICTestPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"图片选择器";
    self.pages = @[@"展示相册图片", @"相册单选", @"相册多选",@"PicturePicker"];
}
- (void)dealloc{
    NSLog(@"销毁了");
}
#pragma mark - Public Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.pages.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];

    }
    cell.textLabel.text = self.pages[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        DRPICImagePickerController *imagePickerViewController = [DRPICImagePickerController new];
        imagePickerViewController.maxCount = 7;
        imagePickerViewController.imagePickerDidFinishPickinghandler = ^(NSMutableArray<DRPICPhotoModel *> * _Nonnull photoList) {
            NSLog(@"%@", photoList);
        };
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:imagePickerViewController];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:nav animated:YES completion:nil];

    } else if (indexPath.row == 1) {

    } else if (indexPath.row == 2) {

    } else if (indexPath.row == 3) {
        DRPICPicturePickerViewController *picturePickerViewController = [DRPICPicturePickerViewController new];
        __weak typeof(self) weakSelf = self;
        [picturePickerViewController eventForEventBlock:^(id  _Nonnull eventObject) {
            if ([eventObject isKindOfClass:[NSMutableArray<DRPICPicture *> class]]) {
                NSMutableArray<DRPICPicture *> *selectedPictures = (NSMutableArray<DRPICPicture *> *)eventObject;
                [weakSelf fetchImageWithAsset:selectedPictures.firstObject.source.asset imageBlock:^(NSData *imageData) {
                    
                }];
            }
        }];
        [self.navigationController pushViewController:picturePickerViewController animated:YES];
//        UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:picturePickerViewController];
//        navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
//        [self presentViewController:navigationController animated:YES completion:nil];
    }
}

/**
 通过资源获取图片的数据

 @param mAsset 资源文件
 @param imageBlock 图片数据回传
 */
- (void)fetchImageWithAsset:(PHAsset*)mAsset imageBlock:(void(^)(NSData* imageData))imageBlock {
    @weakify(self);
//    NSLog(@"mAsset:%@, mAsset.className:%@", mAsset, mAsset.className);
    [[PHImageManager defaultManager] requestImageDataForAsset:mAsset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        @strongify(self);
        if (orientation != UIImageOrientationUp) {
            UIImage* image = [UIImage imageWithData:imageData];
            // 尽然弯了,那就板正一下
            image = [self fixOrientation:image];
            // 新的 数据信息 （不准确的）
            imageData = UIImageJPEGRepresentation(image, 1.0);
            //            NSString *filePath = [self getChooseImageDirWithFileName:@"test"];
            //            [self storageImageWithFilePath:filePath image:image];
        }

        // 直接得到最终的 NSData 数据
        if (imageBlock) {
            imageBlock(imageData);
//            UIImage* image = [UIImage imageWithData:imageData];
//            NSString *filePath = [self getChooseImageDirWithFileName:@"test"];
//            [self storageImageWithFilePath:filePath image:image];

        }

    }];
}

- (UIImage *)fixOrientation:(UIImage *)aImage {

    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;

    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;

    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;

        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;

        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }

    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;

        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }

    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;

        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }

    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end
