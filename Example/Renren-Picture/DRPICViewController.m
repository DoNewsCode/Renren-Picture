//
//  DRPICViewController.m
//  Renren-Picture
//
//  Created by 418589912@qq.com on 08/26/2019.
//  Copyright (c) 2019 418589912@qq.com. All rights reserved.
//

#import "DRPICViewController.h"

#import "DRPICTestPictureViewController.h"

#import "DRPICTimeLinePictureBrowserViewController.h"

static NSString *cellIdentifier = @"DRPICViewControllerCell";

@interface DRPICViewController ()

@property(nonatomic, strong) NSArray *pages;

@end

@implementation DRPICViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createContent];
    
}

#pragma mark - Private Methods
- (void)createContent {
    self.title = @"图像浏览组件-功能（Renren-Picture）";
    self.pages = @[@"图像浏览样式一（Push）",@"图像浏览样式二（Present）",@"图像浏览样式三（TimeLine）",  ];
    
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
    if (indexPath.row == 0) {
        DRPICTestPictureViewController *testPictureViewController = [DRPICTestPictureViewController new];
        [self.navigationController pushViewController:testPictureViewController animated:YES];
    } else if (indexPath.row == 1) {
        DRPICTestPictureViewController *testPictureViewController = [DRPICTestPictureViewController new];
        testPictureViewController.type = DRPICTestPictureViewControllerTypePresent;
        [self.navigationController pushViewController:testPictureViewController animated:YES];
    } else if (indexPath.row == 2) {
        DRPICTestPictureViewController *testPictureViewController = [DRPICTestPictureViewController new];
        testPictureViewController.type = DRPICTestPictureViewControllerTypeTimeLine;
        [self.navigationController pushViewController:testPictureViewController animated:YES];
    } else if (indexPath.row == 3) {
//        [self.navigationController pushViewController:[DNPageFourViewController new] animated:YES];
    }
    
    
}


@end
