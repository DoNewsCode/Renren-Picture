//
//  DRLLogBrowseViewController.m
//  Renren-Library
//
//  Created by 陈金铭 on 2019/8/10.
//

#import "DRLLogBrowseViewController.h"

#import "DRLLogBrowseNavigationController.h"
#import "DRLLogBrowseViewModel.h"
#import "DRLLogBrowseFooter.h"

#import "DRLLog.h"

#import "DRLLogDetailViewController.h"

#import "UIView+CTLayout.h"
#import "UIColor+CTHex.h"

#import "DNBrowsePresentAnimator.h"
#import "DNBrowseDismissAnimator.h"
#import <Social/Social.h>

#import "SSZipArchive.h"

static NSString *cellIdentifier = @"DRLLogBrowseCell";


@interface DRLLogBrowseViewController ()<DRLLogDelegate,UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UISearchControllerDelegate>

@property(nonatomic, strong) DRLLog *logManager;

@property (nonatomic, strong) DRLLogBrowseViewModel *viewModel;

@property(nonatomic, strong) NSMutableArray<DRLLogMessage *> *messages;
@property(nonatomic, strong) NSMutableArray<DRLLogMessage *> *apiMessages;
@property(nonatomic, strong) NSMutableArray<DRLLogMessage *> *apiErrorMessages;
@property(nonatomic, strong) NSMutableArray<DRLLogMessage *> *normalMessages;
@property(nonatomic, strong) NSMutableArray<DRLLogMessage *> *statisticMessages;

@property(nonatomic, strong) NSDateFormatter *timeDateFormatter;

@property(nonatomic, assign) BOOL loading;
@property(nonatomic, assign) BOOL historicalData;

@property(nonatomic, strong) DRLLogBrowseFooter *tableViewFooter;
@property(nonatomic, strong) UISegmentedControl *segmentedControl;
@property(nonatomic, strong) UISearchController *searchController;

@property(nonatomic, strong) UIBarButtonItem *actionBarButtonItem;
@property(nonatomic, strong) UIBarButtonItem *cancelBarButtonItem;
@property(nonatomic, strong) UIBarButtonItem *toolBarActionBarButtonItem;
@property(nonatomic, strong) UIBarButtonItem *toolBarTrashBarButtonItem;
@property(nonatomic, strong) NSOperationQueue *zipArchiveOperationQueue;
@property(nonatomic, strong) NSMutableArray<DRLLogMessage *> *selectMessages;
@end

@implementation DRLLogBrowseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createContent];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self createNavigation];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)createNavigation {
    self.navigationItem.rightBarButtonItems = nil;
    UIBarButtonItem *actionBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(eventActionBarButtonItemClick:)];
    self.actionBarButtonItem = actionBarButtonItem;
    UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(eventCancelBarButtonItemClick:)];
    self.cancelBarButtonItem = cancelBarButtonItem;
    self.navigationItem.rightBarButtonItem = self.actionBarButtonItem;
    if (@available(iOS 11.0, *)) {
        self.navigationItem.hidesSearchBarWhenScrolling = NO;
    } else {
        // Fallback on earlier versions
    }
    
}

- (void)createContent {
    
    self.logManager = [DRLLog sharedLog];
    if (self.logManager.delegate && [self.logManager.delegate isKindOfClass:[DRLLogBrowseViewController class]]) {
        DRLLogBrowseViewController *delegate = (DRLLogBrowseViewController *)self.logManager.delegate;
        [delegate eventNavigationLeftItemClick];
    }
    self.logManager.delegate = self;
    if (self.master) {
        self.logManager.masterDelegate = self;
    }
    self.messages = [NSMutableArray<DRLLogMessage *> array];
    self.tableView.tableHeaderView = self.segmentedControl;
    self.segmentedControl.selectedSegmentIndex = self.segmentedControl.numberOfSegments - 1;
    if (@available(iOS 11.0, *)) {
        self.navigationItem.searchController = self.searchController;
    } else {
        self.tableView.tableHeaderView = self.searchController.searchBar;
        // Fallback on earlier versions
    }
    //
    [self.view addSubview:self.tableView];
    [self createFirstData];
}

- (void)createFirstData {
    __weak typeof(self) weakSelf = self;
    [self.logManager obtainMessagesWithResultBlock:^(NSArray<DRLLogMessage *> * _Nonnull messages) {
        if (messages && messages.count >= 50) {
            weakSelf.historicalData = YES;
        }
        [weakSelf.messages addObjectsFromArray:messages.copy];
        [weakSelf.tableView reloadData];
    }];
}

- (void)eventNavigationLeftItemClick {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)eventToolBarActionBarButtonItemClick:(UIBarButtonItem *)barButtonItem {
    __block NSArray<NSIndexPath *> *indexPathsForSelectedRows = self.tableView.indexPathsForSelectedRows;
    __weak typeof(self) weakSelf = self;
    NSBlockOperation *zipOperation = [NSBlockOperation blockOperationWithBlock:^{
        [weakSelf processExportLogFileWithMessageIndexPath:indexPathsForSelectedRows];
    }];
    
    [self.zipArchiveOperationQueue addOperation:zipOperation];
    
}

- (void)eventToolBarTrashBarButtonItemClick:(UIBarButtonItem *)barButtonItem {
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    for (NSIndexPath *indexPath in self.tableView.indexPathsForSelectedRows) {
        [indexSet addIndex:indexPath.row];
    }
    [self.messages removeObjectsAtIndexes:indexSet];
    [self.tableView beginUpdates];
    
    [self.tableView deleteRowsAtIndexPaths:self.tableView.indexPathsForSelectedRows withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
}

- (void)eventCancelBarButtonItemClick:(UIBarButtonItem *)barButtonItem {
    
    [self.tableView setEditing:NO animated:YES];
    self.tableView.allowsMultipleSelection = NO;
    [self.navigationController setToolbarHidden:YES animated:YES];
    self.navigationItem.rightBarButtonItem = self.actionBarButtonItem;
    
}

- (void)eventActionBarButtonItemClick:(UIBarButtonItem *)barButtonItem {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *selectAction = [UIAlertAction actionWithTitle:@"选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.tableView setEditing:YES animated:YES];
        self.tableView.allowsMultipleSelection = YES;
        [self.navigationController setToolbarHidden:NO animated:YES];
        UIBarButtonItem *spaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [self.navigationController.toolbar setItems:@[self.toolBarActionBarButtonItem,spaceBarButtonItem,self.toolBarTrashBarButtonItem]];
        self.navigationItem.rightBarButtonItem = self.cancelBarButtonItem;
    }];
    
    UIAlertAction *allAction = [UIAlertAction actionWithTitle:@"导出全部" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        UIActivityViewController *activityController=[[UIActivityViewController alloc]initWithActivityItems:@[@"asdasds"] applicationActivities:nil];
        [self.navigationController presentViewController:activityController animated:YES completion:nil];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:selectAction];
    [alertController addAction:allAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)eventSegmentedControlEventValueChanged:(UISegmentedControl *)segmentedControl {
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            [self.logManager obtainAllMessagesWithResultBlock:^(NSArray<DRLLogMessage *> * _Nonnull messages) {
                
            }];
            break;
            
        case 1:
            
            break;
            
        case 2:
            
            break;
        case 3:
            
            break;
        case 4:
            
            break;
            
        default:
            break;
    }
}

- (void)newLogMessage:(DRLLogMessage *)logMessage {
    if (logMessage == nil) {
        return;
    }
    if (@available(iOS 11.0, *)) {
        [self.messages insertObject:logMessage atIndex:0];
        [self.tableView performBatchUpdates:^{
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
        } completion:^(BOOL finished) {
            
        }];
    } else {
        // Fallback on earlier versions
        [self.tableView beginUpdates];
        [self.messages insertObject:logMessage atIndex:0];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
        
        [self.tableView endUpdates];
    }
    
}

- (void)updateLogMessage:(DRLLogMessage *)logMessage {
    if (logMessage == nil) {
        return;
    }
    if (@available(iOS 11.0, *)) {
        [self.tableView performBatchUpdates:^{
            NSUInteger index = 0;
            for (DRLLogMessage *message in self.messages) {
                if (logMessage.localID == message.localID) {
                    [self.messages replaceObjectAtIndex:index withObject:logMessage];
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                    break;
                }
                index ++;
            }
        } completion:^(BOOL finished) {
            
        }];
    } else {
        [self.tableView beginUpdates];
        NSUInteger index = 0;
        for (DRLLogMessage *message in self.messages) {
            if (logMessage.localID == message.localID) {
                [self.messages replaceObjectAtIndex:index withObject:logMessage];
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
            }
            index ++;
        }
        
        [self.tableView endUpdates];
    }
    
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.textLabel.textColor = [UIColor ct_colorWithHexString:@"#333333"];
        cell.textLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        cell.detailTextLabel.numberOfLines = 2;
        cell.detailTextLabel.textColor = [UIColor ct_colorWithHexString:@"#8F8F8F"];
        cell.detailTextLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        
    }
    DRLLogMessage *message = self.messages[indexPath.row];
    cell.textLabel.text = message.title;
    
    NSString *detail = [NSString stringWithFormat:@"No:%06ld Type:%03ld Time:%@\nDesc:%@",(long)message.localID,(long)message.type,[self.timeDateFormatter stringFromDate:message.createTime],message.desc];
    cell.detailTextLabel.text = detail;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.isEditing) {
        if (tableView.indexPathsForSelectedRows.count > 0) {
            self.toolBarActionBarButtonItem.enabled = YES;
            self.toolBarTrashBarButtonItem.enabled = YES;
        } else {
            self.toolBarActionBarButtonItem.enabled = NO;
            self.toolBarTrashBarButtonItem.enabled = NO;
        }
        return;
    }
    DRLLogDetailViewController *detailViewController = [DRLLogDetailViewController new];
    detailViewController.message = self.messages[indexPath.row];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.isEditing) {
        if (tableView.indexPathsForSelectedRows.count > 0) {
            self.toolBarActionBarButtonItem.enabled = YES;
            self.toolBarTrashBarButtonItem.enabled = YES;
        } else {
            self.toolBarActionBarButtonItem.enabled = NO;
            self.toolBarTrashBarButtonItem.enabled = NO;
        }
        return;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (self.loading == NO && self.historicalData == YES) {
        self.tableViewFooter.titleLabel.text = @"更多历史日志加载中...";
        self.loading = YES;
        [self processAppendMessages];
    }
    if (self.historicalData == NO) {
        self.tableViewFooter.titleLabel.text = @"无更多历史日志";
    }
    
    return self.tableViewFooter;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return self.tableViewFooter.ct_height;
}

// 当增减按钮按下时，用来处理数据和UI的回调。
// 8.0版本后加入的UITableViewRowAction不在这个回调的控制范围内，UITableViewRowAction有单独的回调Block。
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

// 这个回调实现了以后，就会出现更换位置的按钮，回调本身用来处理更换位置后的数据交换。
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
}

// 这个回调决定了在当前indexPath的Cell是否可以编辑。
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// 这个回调决定了在当前indexPath的Cell是否可以移动。
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)processExportLogFileWithMessageIndexPath:(NSArray<NSIndexPath *> *)indexPathArray {
    NSMutableArray *activityitems = [NSMutableArray array];
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    if (indexPathArray.count == 1) {
        NSString *logPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-Log %@.txt",appName,[self.timeDateFormatter stringFromDate:[NSDate date]]]];
        DRLLogMessage *message = [self.messages objectAtIndex:indexPathArray.firstObject.row];
        NSString *string = [self processMessageToString:message];
        NSError *error;
        [string writeToFile:logPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        NSURL *zipFileURL = [NSURL fileURLWithPath:logPath];
        [activityitems addObject:zipFileURL];
    } else {
        NSMutableArray *tempLogPaths = [NSMutableArray arrayWithCapacity:indexPathArray.count];
        //        NSMutableArray *tempLogPaths = [NSMutableArray arrayWithCapacity:self.tableView.indexPathsForSelectedRows.count];
        for (NSInteger i = 0; i < indexPathArray.count; i++) {
            NSIndexPath *indexPath = indexPathArray[i];
            NSString *logPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-Log%ld %@.txt",appName,(long)i,[self.timeDateFormatter stringFromDate:[NSDate date]]]];
            DRLLogMessage *message = [self.messages objectAtIndex:indexPath.row];
            NSString *string = [self processMessageToString:message];
            NSError *error;
            [string writeToFile:logPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
            [tempLogPaths addObject:logPath];
        }
        NSString *logZipPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-Log %@.zip",appName,[self.timeDateFormatter stringFromDate:[NSDate date]]]];
        if ([SSZipArchive createZipFileAtPath:logZipPath withFilesAtPaths:tempLogPaths]) {
            NSLog(@"压缩成功");
        } else {
            NSLog(@"压缩失败");
        }
        NSURL *zipFileURL = [NSURL fileURLWithPath:logZipPath];
        [activityitems addObject:zipFileURL];
    }
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        UIActivityViewController *activityController=[[UIActivityViewController alloc]initWithActivityItems:activityitems.copy applicationActivities:nil];
        [self.navigationController presentViewController:activityController animated:YES completion:nil];
    }];
}

- (NSString *)processMessageToString:(DRLLogMessage *)message {
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:[NSString stringWithFormat:@"localID:%lu",(unsigned long)message.localID]];
    [array addObject:[NSString stringWithFormat:@"type:%lu",(unsigned long)message.type]];
    [array addObject:[NSString stringWithFormat:@"appVersion:%@",message.appVersion]];
    [array addObject:[NSString stringWithFormat:@"appBuild:%@",message.appBuild]];
    [array addObject:[NSString stringWithFormat:@"createTime:%@",message.createTime]];
    [array addObject:[NSString stringWithFormat:@"modifiedTime:%@",message.modifiedTime]];
    [array addObject:[NSString stringWithFormat:@"title:%@",message.title]];
    [array addObject:[NSString stringWithFormat:@"desc:\n%@",message.desc]];
    [array addObject:[NSString stringWithFormat:@"content:\n%@",message.content]];
    [array addObject:[NSString stringWithFormat:@"remark:\n%@",message.remark]];
    NSString *string = [array componentsJoinedByString:@"\n"];
    return string;
}


- (void)processAppendMessages {
    __weak typeof(self) weakSelf = self;
    [self.logManager obtainMessagesWithCurrentMessage:weakSelf.messages.lastObject resultBlock:^(NSArray<DRLLogMessage *> * _Nonnull messages) {
        [weakSelf.messages addObjectsFromArray:messages.copy];
        NSMutableArray<NSIndexPath *> *indexs = [NSMutableArray<NSIndexPath *> array];
        for (DRLLogMessage *currentMessage in messages) {
            if ([weakSelf.messages containsObject:currentMessage]) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[weakSelf.messages indexOfObject:currentMessage] inSection:0];
                [indexs addObject:indexPath];
            }
        }
        
        [weakSelf.tableView insertRowsAtIndexPaths:indexs withRowAnimation:UITableViewRowAnimationBottom];
        if (messages == nil || messages.count < 50) {
            weakSelf.historicalData = NO;
        }
        weakSelf.loading = NO;
    }];
}

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        tableView.allowsMultipleSelectionDuringEditing = YES;
        tableView.dataSource = self;
        tableView.delegate = self;
        _tableView = tableView;
    }
    return _tableView;
}

- (UISegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"接口",@"常规",@"统计",@"接口异常",@"全部"]];
        [segmentedControl addTarget:self action:@selector(eventSegmentedControlEventValueChanged:) forControlEvents:UIControlEventValueChanged];
        //        segmentedControl.apportionsSegmentWidthsByContent = YES;
        _segmentedControl = segmentedControl;
    }
    return _segmentedControl;
}

- (NSMutableArray<DRLLogMessage *> *)messages {
    if (!_messages) {
        NSMutableArray<DRLLogMessage *> *message = [NSMutableArray<DRLLogMessage *> array];
        _messages = message;
    }
    return _messages;
}

- (NSMutableArray<DRLLogMessage *> *)apiMessages {
    if (!_apiMessages) {
        NSMutableArray<DRLLogMessage *> *apiMessages = [NSMutableArray<DRLLogMessage *> array];
        _apiMessages = apiMessages;
    }
    return _apiMessages;
}

- (NSMutableArray<DRLLogMessage *> *)apiErrorMessages {
    if (!_apiErrorMessages) {
        NSMutableArray<DRLLogMessage *> *apiErrorMessages = [NSMutableArray<DRLLogMessage *> array];
        _apiErrorMessages = apiErrorMessages;
    }
    return _apiErrorMessages;
}

- (NSMutableArray<DRLLogMessage *> *)normalMessages {
    if (!_normalMessages) {
        NSMutableArray<DRLLogMessage *> *normalMessages = [NSMutableArray<DRLLogMessage *> array];
        _normalMessages = normalMessages;
    }
    return _normalMessages;
}

- (NSMutableArray<DRLLogMessage *> *)statisticMessages {
    if (!_statisticMessages) {
        NSMutableArray<DRLLogMessage *> *statisticMessages = [NSMutableArray<DRLLogMessage *> array];
        _statisticMessages = statisticMessages;
    }
    return _statisticMessages;
}

- (NSMutableArray<DRLLogMessage *> *)selectMessages {
    if (!_selectMessages) {
        NSMutableArray<DRLLogMessage *> *selectMessages = [NSMutableArray<DRLLogMessage *> array];
        _selectMessages = selectMessages;
    }
    return _selectMessages;
}

- (UIBarButtonItem *)toolBarActionBarButtonItem {
    if (!_toolBarActionBarButtonItem) {
        UIBarButtonItem *toolBarActionBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(eventToolBarActionBarButtonItemClick:)];
        toolBarActionBarButtonItem.enabled = NO;
        _toolBarActionBarButtonItem = toolBarActionBarButtonItem;
    }
    return _toolBarActionBarButtonItem;
}

- (UIBarButtonItem *)toolBarTrashBarButtonItem {
    if (!_toolBarTrashBarButtonItem) {
        UIBarButtonItem *toolBarTrashBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(eventToolBarTrashBarButtonItemClick:)];
        toolBarTrashBarButtonItem.enabled = NO;
        _toolBarTrashBarButtonItem = toolBarTrashBarButtonItem;
    }
    return _toolBarTrashBarButtonItem;
}


- (NSDateFormatter *)timeDateFormatter {
    if (!_timeDateFormatter) {
        NSDateFormatter *timeDateFormatter = [NSDateFormatter new];
        [timeDateFormatter setDateFormat:@"MM-dd HH:mm:ss.sss z"];
        timeDateFormatter.timeZone = [NSTimeZone systemTimeZone];
        _timeDateFormatter = timeDateFormatter;
    }
    return _timeDateFormatter;
}

- (NSOperationQueue *)zipArchiveOperationQueue {
    if (!_zipArchiveOperationQueue) {
        NSOperationQueue *zipArchiveOperationQueue = [NSOperationQueue new];
        zipArchiveOperationQueue.maxConcurrentOperationCount = 1;
        _zipArchiveOperationQueue = zipArchiveOperationQueue;
    }
    return _zipArchiveOperationQueue;
}

- (DRLLogBrowseFooter *)tableViewFooter {
    if (!_tableViewFooter) {
        DRLLogBrowseFooter *tableViewFooter = [[DRLLogBrowseFooter alloc] initWithFrame:CGRectMake(0, 0, self.tableView.ct_width, 50)];
        _tableViewFooter = tableViewFooter;
    }
    return _tableViewFooter;
}

- (UISearchController *)searchController {
    if (!_searchController) {
        
        UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        searchController.searchResultsUpdater = self;
        searchController.delegate = self;
        searchController.searchBar.barTintColor = [UIColor yellowColor];
        searchController.searchBar.placeholder= @"请输入关键字搜索";
        //        searchController.searchBar.text = @"我是周杰伦";
        searchController.searchBar.frame = CGRectMake(searchController.searchBar.frame.origin.x, searchController.searchBar.frame.origin.y, searchController.searchBar.frame.size.width, 44.0);
        searchController.dimsBackgroundDuringPresentation = NO;
        [searchController.searchBar sizeToFit];
        searchController.definesPresentationContext = YES;
        self.definesPresentationContext = YES;
        _searchController = searchController;
    }
    return _searchController;
}

- (void)updateSearchResultsForSearchController:(nonnull UISearchController *)searchController {
    
}

#pragma mark - UISearchControllerDelegate代理
//测试UISearchController的执行过程

- (void)willPresentSearchController:(UISearchController *)searchController{
    NSLog(@"willPresentSearchController");
}

- (void)didPresentSearchController:(UISearchController *)searchController{
    NSLog(@"didPresentSearchController");
    
    //    [self.view addSubview:self.searchController.searchBar];
}

- (void)willDismissSearchController:(UISearchController *)searchController{
    NSLog(@"willDismissSearchController");
}

- (void)didDismissSearchController:(UISearchController *)searchController{
    NSLog(@"didDismissSearchController");
}

- (void)presentSearchController:(UISearchController *)searchController{
    NSLog(@"presentSearchController");
}


@end
