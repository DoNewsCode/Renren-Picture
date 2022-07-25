//
//  DRMEMosaicOptionView.m
//  Renren-EditImage
//
//  Created by 李晓越 on 2019/10/28.
//

#import "DRMEMosaicOptionView.h"

@interface DRMEMosaicOptionView()

@property (weak, nonatomic) IBOutlet UIButton *defautMosaic;

@end

@implementation DRMEMosaicOptionView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.currentMosaicBnt = self.defautMosaic;
}

+ (instancetype)mosaicOptionView
{
    DRMEMosaicOptionView *view = [[[NSBundle me_Bundle] loadNibNamed:@"DRMEMosaicOptionView" owner:nil options:nil] firstObject];
    return view;
}

- (IBAction)clickResetBtn:(id)sender {

    if (self.clickResetBlock) {
        self.clickResetBlock();
    }
}

- (IBAction)clickCancelBtn:(id)sender {
    
    if (self.clickCancelBlock) {
        self.clickCancelBlock();
    }
}

- (IBAction)clickSureBtn:(id)sender {
    
    if (self.clickSureBlock) {
        self.clickSureBlock();
    }
}

- (IBAction)clickMosaicBtn:(UIButton*)mosaicBtn {
    
    if (self.currentMosaicBnt == mosaicBtn) {
        return;
    }
    
    self.currentMosaicBnt.selected = NO;
    self.currentMosaicBnt = mosaicBtn;
    self.currentMosaicBnt.selected = YES;
    
    if (self.clickMosaicBlock) {
        self.clickMosaicBlock(mosaicBtn);
    }
}

- (void)dealloc
{
    NSLog(@"--- 马赛克选项视图 销毁");
}

@end
