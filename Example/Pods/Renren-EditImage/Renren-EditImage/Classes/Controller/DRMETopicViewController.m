//
//  DRMETopicViewController.m
//  Renren-EditImage
//
//  Created by 李晓越 on 2019/11/20.
//

#import "DRMETopicViewController.h"
#import "DRMEGetTopicsViewModel.h"
#import "DRMETagModel.h"

@interface DRMETopicViewController ()
<UITextFieldDelegate,
UITableViewDelegate,
UITableViewDataSource>
@property(nonatomic,weak) UITableView *tableView;
@property(nonatomic,strong) NSArray *sectionArray;
@property(nonatomic,strong) DRMEGetTopicsViewModel *getTopicsViewModel;
@end

@implementation DRMETopicViewController

- (NSArray *)sectionArray
{
    if (!_sectionArray) {
        _sectionArray = @[@"热门话题"];
    }
    return _sectionArray;
}

- (DRMEGetTopicsViewModel *)getTopicsViewModel
{
    if (!_getTopicsViewModel) {
        _getTopicsViewModel = [[DRMEGetTopicsViewModel alloc] init];
    }
    return _getTopicsViewModel;
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
    
    // 话题
    UILabel *topicLabel = [[UILabel alloc] init];
    topicLabel.text = @"话题";
    topicLabel.font = kFontMediumSize(25);
    topicLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:topicLabel];
    
    topicLabel.sd_layout.leftSpaceToView(self.view, 12)
    .topSpaceToView(closeBtn, 17)
    .widthIs(80).heightIs(25);
    
    // 搜索条
    UIImageView *searchBarBg = [[UIImageView alloc] init];
    searchBarBg.userInteractionEnabled = YES;
    searchBarBg.image = [UIImage me_imageWithName:@"me_searchbar_bg"];
    [self.view addSubview:searchBarBg];
    
    searchBarBg.sd_layout.topSpaceToView(topicLabel, 17)
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
    searchField.placeholder = @"搜索标签";
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
    tableView.rowHeight = 46;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    tableView.sd_layout.topSpaceToView(searchBarBg, 17)
    .leftEqualToView(self.view).rightEqualToView(self.view)
    .bottomSpaceToView(self.view, kSafeAreaHeight);
    
    [self loadData];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionArray.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.getTopicsViewModel.topicsModel.topic_list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.getTopicsViewModel.topicsModel.topic_list.count <= 0) {
        return [UITableViewCell new];
    }
    NSString *ID = @"topicCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    DRMETopicList *topicList = [self.getTopicsViewModel.topicsModel.topic_list objectAtIndex:indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [NSString stringWithFormat:@"#%@#", topicList.title];
    cell.textLabel.font = kFontMediumSize(16);
    cell.textLabel.textColor = [UIColor whiteColor];
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
    
    // 最近联系好友
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, kScreenWidth - 30, 25)];
    label.text = title;
    label.textColor = [UIColor colorWithHexString:@"#3580F9"];
    label.font = kFontRegularSize(15);
    label.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:label];
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DRMETopicList *topicList = [self.getTopicsViewModel.topicsModel.topic_list objectAtIndex:indexPath.row];
    NSLog(@"选中的话题是  %@", topicList.title);
    
    DRMETagModel *tagModel = [[DRMETagModel alloc] init];
    tagModel.recentUsedType = DRMETagTypeTopic;
    tagModel.text = topicList.title;
    
    if (self.selectedTopicBlock) {
        self.selectedTopicBlock(tagModel);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
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

#pragma mark - 加载数据
- (void)loadData
{
    @weakify(self)
    [self.getTopicsViewModel getTopicsWithSuccessBlock:^{
        
        @strongify(self)
        [self.tableView reloadData];
    } failureBlock:^(NSString * _Nonnull errorStr) {
        [DRPPop showTextHUDWithMessage:errorStr];
    }];
}

- (void)dealloc
{
    NSLog(@"-- %s, %d", __func__, __LINE__);
}
@end
