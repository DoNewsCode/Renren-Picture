//
//  DNPopStyle.m
//  DNPop
//
//  Created by 陈金铭 on 2019/7/3.
//

#import "DNPopStyle.h"

@implementation DNPopStyle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cornerRadii = CGSizeMake(20, 20);
        self.horizontalSpacing = 15.;
        self.verticalVSpacing = 10.;
        
        self.headerEdge = UIEdgeInsetsMake(30., 20., 30., 20.);
        self.headerInsetsMargin = 5.;
        self.alertWidth = 270.;
        self.backgroundColor = [UIColor whiteColor];
        self.dividingLineColor = [UIColor grayColor];
        
        self.dividingLine = YES;
        self.dividingLineRightMargin = 15.;
        self.dividingLineLeftMargin = 15.;
        self.dividingLineHeight = 1;
        
        self.headerLine = YES;
        self.headerLineRightMargin = 15.;
        self.headerLineLeftMargin = 15.;
        self.headerLineHeight = 1;
        
        self.titleTextColor = [UIColor blackColor];
        self.messageTextColor = [UIColor grayColor];
        
        self.titleFont = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        self.messageFont = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        
        self.defaultTextColor = [UIColor blackColor];
        self.defaultFont = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        
        self.cancelTextColor = [UIColor redColor];
        self.cancelFont = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    }
    return self;
}

@end
