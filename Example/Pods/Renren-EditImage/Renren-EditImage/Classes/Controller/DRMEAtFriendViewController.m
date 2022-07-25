//
//  DRMEAtFriendViewController.m
//  Renren-EditImage
//
//  Created by 李晓越 on 2019/11/20.
//

#import "DRMEAtFriendViewController.h"
#import "DRMEAtFriendCell.h"

@interface DRMEAtFriendViewController ()
<UITextFieldDelegate,
UITableViewDelegate,
UITableViewDataSource>

@property(nonatomic,strong) NSArray *sectionArray;

@end

@implementation DRMEAtFriendViewController

- (NSArray *)sectionArray
{
    if (!_sectionArray) {
        _sectionArray = @[@"最近联系好友", @"A", @"B", @"C"];
    }
    return _sectionArray;
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
    
    UIButton *closeBtn = [[UIButton alloc] init];
    [closeBtn setImage:[UIImage me_imageWithName:@"me_close_btn"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(clickCloseBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    
    closeBtn.sd_layout.leftSpaceToView(self.view, 12)
    .topSpaceToView(self.view, kStatusBarHeight + 36)
    .widthIs(26).heightIs(26);
    
    // @好友
    UILabel *atFriendLabel = [[UILabel alloc] init];
    atFriendLabel.text = @"@好友";
    atFriendLabel.font = kFontMediumSize(25);
    atFriendLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:atFriendLabel];
    
    atFriendLabel.sd_layout.leftSpaceToView(self.view, 12)
    .topSpaceToView(closeBtn, 17)
    .widthIs(80).heightIs(25);
    
    // 搜索条
    UIImageView *searchBarBg = [[UIImageView alloc] init];
    searchBarBg.userInteractionEnabled = YES;
    searchBarBg.image = [UIImage me_imageWithName:@"me_searchbar_bg"];
    [self.view addSubview:searchBarBg];
    
    searchBarBg.sd_layout.topSpaceToView(atFriendLabel, 17)
    .leftSpaceToView(self.view, 15)
    .rightSpaceToView(self.view, 15)
    .heightIs(44);
    
    // 搜索  放大镜
    UIImageView *searchIcon = [[UIImageView alloc] init];
    searchIcon.image = [UIImage me_imageWithName:@"me_searchbar_iccon"];
    [searchBarBg addSubview:searchIcon];
    searchIcon.sd_layout.leftSpaceToView(searchBarBg, 10)
    .centerYEqualToView(searchBarBg)
    .widthIs(27).heightIs(26);
    
    // 输入框
    UITextField *searchField = [[UITextField alloc] init];
    searchField.placeholder = @"搜索";
    searchField.textColor = [UIColor whiteColor];
    searchField.font = kFontRegularSize(15);
    searchField.returnKeyType = UIReturnKeyDone;
    searchField.delegate = self;
    [searchBarBg addSubview:searchField];
    NSDictionary *dict = @{NSFontAttributeName : kFontRegularSize(15),
                           NSForegroundColorAttributeName :
                               [UIColor colorWithWhite:1 alpha:0.5f]};
    NSAttributedString *attr = [[NSAttributedString alloc]
                                initWithString:searchField.placeholder
                                    attributes:dict];
    searchField.attributedPlaceholder = attr;
    
    searchField.sd_layout.leftSpaceToView(searchIcon, 3)
    .topEqualToView(searchBarBg).bottomEqualToView(searchBarBg)
    .rightSpaceToView(searchBarBg, 10);
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 60;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    tableView.sectionIndexColor = [UIColor whiteColor];
    [self.view addSubview:tableView];
    
    
    [tableView registerClass:[DRMEAtFriendCell class] forCellReuseIdentifier:@"DRMEAtFriendCell"];
    
    tableView.sd_layout.topSpaceToView(searchBarBg, 17)
    .leftEqualToView(self.view).rightEqualToView(self.view)
    .bottomSpaceToView(self.view, kSafeAreaHeight + 70);
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DRMEAtFriendCell *cell = [DRMEAtFriendCell atFriendCellWithTableView:tableView];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *title = self.sectionArray[section];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)];
    headerView.backgroundColor = [UIColor blackColor];

    if (section == 0) {
        // 最近联系好友
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, kScreenWidth - 30, 25)];
        label.text = title;
        label.textColor = [UIColor colorWithHexString:@"#3580F9"];
        label.font = kFontRegularSize(15);
        label.textAlignment = NSTextAlignmentLeft;
        [headerView addSubview:label];
        
    } else {
    
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 35, 25)];
        titleLabel.text = title;
        titleLabel.textColor = [UIColor colorWithHexString:@"#24A3FD"];
        titleLabel.font = kFontMediumSize(16);
        titleLabel.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1f];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:titleLabel];
        titleLabel.layer.cornerRadius = 25/2;
        titleLabel.layer.masksToBounds = YES;
    }
    
    return headerView;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.sectionArray];
//    if (有最近联系好友) {
        [array replaceObjectAtIndex:0 withObject:@""];
//    }
    return array;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // 点击了完成
    return YES;
}

#pragma mark - 事件
- (void)clickCloseBtn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc
{
    NSLog(@"-- %s, %d", __func__, __LINE__);
}

@end
