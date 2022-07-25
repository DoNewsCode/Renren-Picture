//
//  DRPSearchTopicCell.m
//  Renren-EditImage
//
//  Created by 李晓越 on 2020/1/2.
//

#import "DRMESearchTopicCell.h"
#import "DRMESearchTopicModel.h"

@interface DRMESearchTopicCell ()

@property (weak, nonatomic) IBOutlet UILabel *topicLabel;
@property (weak, nonatomic) IBOutlet UIButton *createBtn;

@end

@implementation DRMESearchTopicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)clickCreate:(id)sender {
    
}

- (void)setModel:(DRMESearchTopicModel *)model
{
    _model = model;
    
    self.topicLabel.text = [NSString stringWithFormat:@"#%@#", model.topicStr];
    
    if (model.isShowCreate) {
        self.createBtn.hidden = NO;
    } else {
        self.createBtn.hidden = YES;
    }
    
}

@end
