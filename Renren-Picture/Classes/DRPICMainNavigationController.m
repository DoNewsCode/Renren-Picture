//
//  DRPICMainNavigationController.m
//  AFNetworking
//
//  Created by Ming on 2020/5/30.
//

#import "DRPICMainNavigationController.h"

@interface DRPICMainNavigationController ()

@end

@implementation DRPICMainNavigationController

- (instancetype)init{
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
   if (self = [super initWithRootViewController:rootViewController]) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



@end
