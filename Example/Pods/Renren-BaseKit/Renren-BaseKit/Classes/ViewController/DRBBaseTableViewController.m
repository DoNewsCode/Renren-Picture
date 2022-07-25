//
//  DRBBaseTableViewController.m
//  Pods
//
//  Created by Ming on 2019/4/16.
//

#import "DRBBaseTableViewController.h"


@interface DRBBaseTableViewController ()

@end

@implementation DRBBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(UITableView *)tableView{
    
    if (_tableView==nil) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, DNNavHeight, self.view.ct_width, SCREEN_HEIGHT - DNNavHeight) style:(UITableViewStylePlain)];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    return _tableView;
}


@end
