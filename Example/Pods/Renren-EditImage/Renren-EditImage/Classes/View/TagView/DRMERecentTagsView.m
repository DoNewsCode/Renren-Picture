
#import "DRMERecentTagsView.h"
#import "DRMETagModel.h"

@interface DRMERecentTagsView()

@property (nonatomic,strong) NSArray *tagsArr;

@end

@implementation DRMERecentTagsView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setTagsArray:(NSArray <DRMETagModel *>*)tagsArray
    labelHeightBlock:(LabelHeightBlock)labelHeightBlock
{
    _tagsArr = tagsArray;
    
    [self removeAllSubviews];
    
    int width = 15;
    int j = 0;
    int row = 0;
    
    // 这里减了两个 30，不知道为啥
    CGFloat maxWidth = kScreenWidth - 30 - 30;
    
    CGFloat labWidth = 0;
    
    for (int i = 0 ; i < tagsArray.count; i++) {
        
        DRMETagModel *model = tagsArray[i];
        UILabel *label = [[UILabel alloc] init];
        if (model.recentUsedType == DRMETagTypeAddress) {
            
            NSString *title = model.text;
            
            NSMutableAttributedString *attribuString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", title]];
            
            NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
            attachment.image = [UIImage me_imageWithName:@"me_tag_dd_icon"];
            attachment.bounds = CGRectMake(0, -2, 12, 13);
            NSAttributedString *attributed = [NSAttributedString attributedStringWithAttachment:attachment];
            [attribuString insertAttributedString:attributed atIndex:0];
            label.attributedText = attribuString;
            
            labWidth = [label.text widthForFont:kFontRegularSize(12)] + 30;
        } else {
            NSString *title = model.text;
            label.text = title;
            
            labWidth = [label.text widthForFont:kFontRegularSize(12)] + 20;
        }
        
        
        label.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1f];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = kFontRegularSize(12);
        label.numberOfLines = 1;
        label.layer.cornerRadius = 12;
        label.layer.masksToBounds = YES;
        label.textColor = [UIColor whiteColor];
        
        label.frame = CGRectMake(15*j + width, row * 50, labWidth, 24);
        
        [self addSubview:label];
        
        width = width + labWidth;
        j++;
        
//        if (width > (kScreenWidth - maxWidth)) {
        if (width > maxWidth) {
            j = 0;
            width = 15;
            row++;
            label.frame = CGRectMake(15 * j + width,row * 50, labWidth, 24);
            width = width + labWidth;
            j++;
        }
        
        // 如果是最后一个 label, 返回最后一个label的最大Y
        if (i == (tagsArray.count - 1)) {
            if (labelHeightBlock) {
                CGFloat maxY = CGRectGetMaxY(label.frame);
                labelHeightBlock(maxY);
            }
        }
        
        label.userInteractionEnabled = YES;
        label.tag = i;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTag:)];
        [label addGestureRecognizer:tap];
    }
}

- (void)clickTag:(UITapGestureRecognizer *)gesture
{
    UIView *view = gesture.view;
    
    NSLog(@" view.tag = %zd", view.tag);
    
    DRMETagModel *model = self.tagsArr[view.tag];
    
    if (self.clickRecentTag) {
        self.clickRecentTag(model);
    }
}

@end
