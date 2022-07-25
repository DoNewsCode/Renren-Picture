//
//  DRMESearchTagViewController.m
//  Renren-EditImage
//
//  Created by 李晓越 on 2020/1/2.
//

#import "DRMESearchTagViewController.h"
#import "DRMESearchTopicCell.h"
#import "DRMESearchTopicModel.h"

@interface DRMESearchTagViewController ()
<UITextFieldDelegate,
UITableViewDelegate,
UITableViewDataSource>

@property(nonatomic,weak) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *topicArray;

@end

@implementation DRMESearchTagViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (NSMutableArray *)topicArray
{
    if (!_topicArray) {
        _topicArray = [NSMutableArray array];
        
        DRMESearchTopicModel *model1 = [DRMESearchTopicModel new];
        model1.topicStr = @"1111111";
        [_topicArray addObject:model1];
        
        DRMESearchTopicModel *model2 = [DRMESearchTopicModel new];
        model2.topicStr = @"222222";
        [_topicArray addObject:model2];
        
        DRMESearchTopicModel *model3 = [DRMESearchTopicModel new];
        model3.topicStr = @"3333333";
        [_topicArray addObject:model3];
        
    }
    return _topicArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
    
    // 取消按钮
    UIButton *cancelBtn = [[UIButton alloc] init];
    cancelBtn.titleLabel.font = kFontRegularSize(15);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#3580F9"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    cancelBtn.sd_layout.topSpaceToView(self.view, kStatusBarHeight + 10)
    .rightEqualToView(self.view)
    .widthIs(52).heightIs(44);
    
    // 搜索条
    UIImageView *searchBarBg = [[UIImageView alloc] init];
    searchBarBg.userInteractionEnabled = YES;
    searchBarBg.image = [UIImage me_imageWithName:@"me_searchbar_bg"];
    [self.view addSubview:searchBarBg];
    
    searchBarBg.sd_layout.leftSpaceToView(self.view, 15)
    .rightSpaceToView(cancelBtn, 15)
    .topSpaceToView(self.view, kStatusBarHeight + 10)
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
    searchField.returnKeyType = UIReturnKeySearch;
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
    
    tableView.sd_layout.topSpaceToView(searchBarBg, 25)
    .leftSpaceToView(self.view, 15)
    .rightSpaceToView(self.view, 15)
    .bottomSpaceToView(self.view, kSafeAreaHeight);
    
    [tableView registerNib:[UINib nibWithNibName:@"DRMESearchTopicCell" bundle:[NSBundle me_Bundle]] forCellReuseIdentifier:@"DRMESearchTopicCell"];
    
}

#pragma mark - UITableViewDelegate  UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.topicArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.topicArray.count == 0) {
        return [UITableViewCell new];
    }
    
    DRMESearchTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DRMESearchTopicCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    DRMESearchTopicModel *model = self.topicArray[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // 搜索
    [textField resignFirstResponder];
    
    DRMESearchTopicModel *model = [DRMESearchTopicModel new];
    model.topicStr = textField.text;
    model.isShowCreate = YES;
    [self.topicArray insertObject:model atIndex:0];
    
    [self.tableView reloadData];
    
    return YES;
}

#pragma mark - 事件
- (void)clickCancelBtn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
