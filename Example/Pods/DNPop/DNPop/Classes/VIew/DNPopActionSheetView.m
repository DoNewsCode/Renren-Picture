//
//  DNPopActionSheetView.m
//  DNPop
//
//  Created by 陈金铭 on 2019/7/3.
//

#import "DNPopActionSheetView.h"

#import "DNPopItem.h"

@implementation DNPopActionSheetView

#pragma mark - Override Methods
-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message style:(DNPopStyle *)style alertActions:(NSArray<DNPopAction *> *)alertActions {
    self = [super initWithTitle:title message:message style:style alertActions:alertActions];
    if (self) {
        [self initialization];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //    [self layoutCustomSubviews];
}

#pragma mark - Intial Methods

#pragma mark - Public Methods

#pragma mark - Private Methods

- (void)initialization {
    [self createContent];
}

- (void)createContent {
    [self layoutCustomSubviews];
}

- (void)layoutCustomSubviews {
    
    CGFloat previousItemMaxY = 0;
    if (self.title || self.message) {
        previousItemMaxY += self.alertStyle.headerEdge.top;
    }
    if (self.title) {
        CGSize titleSize =  [self.titleLabel.text boundingRectWithSize:CGSizeMake(self.frame.size.width - 2 * self.alertStyle.horizontalSpacing, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.titleLabel.font} context:nil].size;
        self.titleLabel.frame = (CGRect){self.alertStyle.headerEdge.left,previousItemMaxY,self.frame.size.width - self.alertStyle.headerEdge.left - self.alertStyle.headerEdge.right,titleSize.height};
        previousItemMaxY += (titleSize.height + self.alertStyle.headerInsetsMargin);
    }
    
    if (self.message) {
        CGSize messageSize =  [self.messageLabel.text boundingRectWithSize:CGSizeMake(self.frame.size.width - 2 * self.alertStyle.horizontalSpacing, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.messageLabel.font} context:nil].size;
        self.messageLabel.frame = (CGRect){self.alertStyle.headerEdge.left,previousItemMaxY,self.frame.size.width - self.alertStyle.headerEdge.left - self.alertStyle.headerEdge.right,messageSize.height};
        previousItemMaxY += (messageSize.height + self.alertStyle.headerEdge.bottom);
    }
    if ((self.message || self.title) && self.alertActions.count > 0 && self.alertStyle.headerLine) {
        CALayer *line = [CALayer new];
        line.backgroundColor = self.alertStyle.dividingLineColor.CGColor;
        CGFloat lineHeight = self.alertStyle.headerLineHeight;
        CGFloat lineX = self.alertStyle.headerLineRightMargin;
        line.frame = (CGRect){lineX,previousItemMaxY,self.frame.size.width - self.alertStyle.headerLineRightMargin - self.alertStyle.headerLineLeftMargin,lineHeight};
        [self.layer addSublayer:line];
        previousItemMaxY += (lineHeight);
    }
    
    for (NSInteger i = 0; i < self.alertActions.count; i++) {
        
        DNPopAction *action = self.alertActions[i];
        UIView *item = action.item;
        if (action.style == DNPopActionStyleDefault) {
            DNPopItem *defaultItem = (DNPopItem *)item;
            defaultItem.frame = (CGRect){self.alertStyle.horizontalSpacing,previousItemMaxY,self.frame.size.width - self.alertStyle.horizontalSpacing * 2,item.frame.size.height};
            defaultItem.titleLabel.font = self.alertStyle.defaultFont;
            defaultItem.titleLabel.textColor = self.alertStyle.defaultTextColor;
            
        } else if (action.style == DNPopActionStyleCancel) {
            DNPopItem *defaultItem = (DNPopItem *)item;
            defaultItem.frame = (CGRect){self.alertStyle.horizontalSpacing,previousItemMaxY,self.frame.size.width - self.alertStyle.horizontalSpacing * 2,item.frame.size.height};
            defaultItem.titleLabel.font = self.alertStyle.cancelFont;
            defaultItem.titleLabel.textColor = self.alertStyle.cancelTextColor;
            
        } else if (action.style == DNPopActionStyleCustom) {
            item.frame = (CGRect){self.alertStyle.horizontalSpacing,previousItemMaxY,item.frame.size.width,item.frame.size.height};
            item.center = CGPointMake(self.center.x, item.center.y);
            
        } else {
            item.frame = (CGRect){self.alertStyle.horizontalSpacing,previousItemMaxY,item.frame.size.width,item.frame.size.height};
            item.center = CGPointMake(self.center.x, item.center.y);
        }
        
        previousItemMaxY += item.frame.size.height;
        
        if (self.alertStyle.dividingLine && i < self.alertActions.count - 1) {
            CALayer *line = [CALayer new];
            line.backgroundColor = self.alertStyle.dividingLineColor.CGColor;
            CGFloat lineHeight = self.alertStyle.dividingLineHeight;
            CGFloat lineX = self.alertStyle.dividingLineRightMargin;
            line.frame = (CGRect){lineX,previousItemMaxY,self.frame.size.width - self.alertStyle.dividingLineRightMargin - self.alertStyle.dividingLineLeftMargin,lineHeight};
            [self.layer addSublayer:line];
            previousItemMaxY += (lineHeight + self.alertStyle.verticalVSpacing);
        }
        
    }
    CGFloat safeHeight = 34.;
    BOOL needSafeHeight = [self analyzeWhetherNeedSafeHeight];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = previousItemMaxY + ( needSafeHeight ? safeHeight : 0);
    self.frame = (CGRect){0.,0.,width,height};
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:self.alertStyle.cornerRadii];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}


- (BOOL)analyzeWhetherNeedSafeHeight {//在iPhoneX/iPhoneXMax/iPhoneXR上设置安全高度
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if (screenHeight == 812. ||screenHeight == 896.) {
        return YES;
    }
    return NO;
}

#pragma mark - Setter

#pragma mark - Getter

@end
