//
//  DRMEAddressViewController.m
//  Renren-EditImage
//
//  Created by 李晓越 on 2019/11/21.
//

#import "DRMEAddressViewController.h"
#import "DRMEAddressCell.h"
#import "DRMETagModel.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

@interface DRMEAddressViewController ()
<UITextFieldDelegate,
UITableViewDelegate,
UITableViewDataSource,
AMapSearchDelegate,
AMapLocationManagerDelegate>

@property(nonatomic,weak) UITableView *tableView;

@property(nonatomic,strong) AMapSearchAPI *searchApi;
@property(nonatomic, strong) AMapLocationManager *locationManager;

@property(nonatomic,strong) NSMutableArray *poisArray;

@end

@implementation DRMEAddressViewController

- (NSMutableArray *)poisArray
{
    if (!_poisArray) {
        _poisArray = [NSMutableArray array];
    }
    return _poisArray;
}

- (AMapSearchAPI *)searchApi
{
    if (!_searchApi) {
        _searchApi = [[AMapSearchAPI alloc] init];
        _searchApi.delegate = self;
    }
    return _searchApi;
}

- (AMapLocationManager *)locationManager{
    if (!_locationManager) {
        
        _locationManager = [[AMapLocationManager alloc] init];
            
        _locationManager.delegate = self;
        
        //设置期望定位精度
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        
        //设置不允许系统暂停定位
        [_locationManager setPausesLocationUpdatesAutomatically:NO];
        
        //设置定位超时时间
        [_locationManager setLocationTimeout:10];
        
        //设置逆地理超时时间
        [_locationManager setReGeocodeTimeout:5];
    }
    return _locationManager;
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
    
    // 位置
    UILabel *addressLabel = [[UILabel alloc] init];
    addressLabel.text = @"位置";
    addressLabel.font = kFontMediumSize(25);
    addressLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:addressLabel];
    
    addressLabel.sd_layout.leftSpaceToView(self.view, 12)
    .topSpaceToView(closeBtn, 17)
    .widthIs(80).heightIs(25);
    
    // 搜索条
    UIImageView *searchBarBg = [[UIImageView alloc] init];
    searchBarBg.userInteractionEnabled = YES;
    searchBarBg.image = [UIImage me_imageWithName:@"me_searchbar_bg"];
    [self.view addSubview:searchBarBg];
    
    searchBarBg.sd_layout.topSpaceToView(addressLabel, 17)
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
    searchField.placeholder = @"搜索地点";
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
    tableView.rowHeight = 68;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    tableView.tableHeaderView = [self getHeaderView];
    
    [tableView registerNib:[UINib nibWithNibName:@"DRMEAddressCell" bundle:[NSBundle me_Bundle]] forCellReuseIdentifier:@"DRMEAddressCell"];
    
    tableView.sd_layout.topSpaceToView(searchBarBg, 20)
    .leftSpaceToView(self.view, 15)
    .rightSpaceToView(self.view, 15)
    .bottomSpaceToView(self.view, kSafeAreaHeight);
    
    [self startSearch];
}

- (UIView *)getHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 68)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth - 30, 68)];
    [button setTitle:@"不显示位置" forState:UIControlStateNormal];
    [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    button.titleLabel.font = kFontMediumSize(16);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [headerView addSubview:button];
    
    // 底线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, button.bottom, kScreenWidth - 30, 1)];
    lineView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
    [headerView addSubview:lineView];
    return headerView;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.poisArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.poisArray.count == 0) {
        return [UITableViewCell new];
    }
    DRMEAddressCell *cell = [DRMEAddressCell addressCellWithTableView:tableView];
    AMapPOI *poi = self.poisArray[indexPath.row];
    cell.poi = poi;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AMapPOI *poi = self.poisArray[indexPath.row];
    
    DRMETagModel *model = [DRMETagModel new];
    model.recentUsedType = DRMETagTypeAddress;
    model.text = poi.name;
    
    if (self.selectAddressBlock) {
        self.selectAddressBlock(model);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - 开始检索周边POI
- (void)startSearch
{
    // 先进行定位，再根据经纬度检索POI
    @weakify(self)
    [self.locationManager requestLocationWithReGeocode:NO completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        @strongify(self)
        if (!error) {
            AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
            
            request.location            = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
            //    request.keywords            = @"电影院";
            /* 按照距离排序. */
            //    request.sortrule            = 0;
            request.requireExtension    = YES;
            
            [self.searchApi AMapPOIAroundSearch:request];
        }
    }];
}

#pragma mark - AMapSearchDelegate
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"-- %s, %d", __func__, __LINE__);
}

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    NSLog(@"response = %@", response);
    [self.poisArray addObjectsFromArray:response.pois];
    [self.tableView reloadData];
    
}

#pragma mark - AMapLocationManagerDelegate
- (void)amapLocationManager:(AMapLocationManager *)manager doRequireLocationAuth:(CLLocationManager *)locationManager
{
    [locationManager requestAlwaysAuthorization];
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
