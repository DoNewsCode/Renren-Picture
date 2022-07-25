//
//  DNPopAlertView.m
//  DNPop
//
//  Created by 陈金铭 on 2019/7/3.
//

#import "DNPopAlertView.h"

#import "DNPopItem.h"

@implementation DNPopAlertView

#pragma mark - Override Methods
-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message style:(DNPopStyle *)style alertActions:(NSArray<DNPopAction *> *)alertActions {
    self = [super initWithTitle:title message:message style:style alertActions:alertActions];
    if (self) {
        [self initialization];
    }
    return self;
}

#pragma mark - Intial Methods
- (void)initialization {
    [self createContent];
}

#pragma mark - Event Methods

#pragma mark - Public Methods

#pragma mark - Private Methods
- (void)createContent {
    [self layoutCustomSubviews];
}

- (void)layoutCustomSubviews {
    
    CGFloat previousItemMaxY = 0;
    if (self.title || self.message) {
        previousItemMaxY += self.alertStyle.headerEdge.top;
    }
    CGFloat maxWidth = self.alertStyle.alertWidth;
    for (DNPopAction *action in self.alertActions) {
        if (action.style == DNPopActionStyleCustom && maxWidth < action.item.frame.size.width) {
            maxWidth = action.item.frame.size.width;
        }
    }
    self.frame = (CGRect){self.frame.origin,maxWidth,previousItemMaxY};
    if (self.title) {
        CGSize titleSize =  [self.titleLabel.text boundingRectWithSize:CGSizeMake(maxWidth - 2 * self.alertStyle.horizontalSpacing, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.titleLabel.font} context:nil].size;
        self.titleLabel.frame = (CGRect){self.alertStyle.headerEdge.left,previousItemMaxY,maxWidth - self.alertStyle.headerEdge.left - self.alertStyle.headerEdge.right,titleSize.height};
        previousItemMaxY += (titleSize.height + self.alertStyle.headerInsetsMargin);
    }
    
    if (self.message) {
        CGSize messageSize =  [self.messageLabel.text boundingRectWithSize:CGSizeMake(maxWidth - 2 * self.alertStyle.horizontalSpacing, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.messageLabel.font} context:nil].size;
        self.messageLabel.frame = (CGRect){self.alertStyle.headerEdge.left,previousItemMaxY,maxWidth - self.alertStyle.headerEdge.left - self.alertStyle.headerEdge.right,messageSize.height};
        previousItemMaxY += (messageSize.height + self.alertStyle.headerEdge.bottom);
    }
    
    if ((self.message || self.title) && self.alertActions.count > 0 && self.alertStyle.headerLine) {
        CALayer *line = [CALayer new];
        line.backgroundColor = self.alertStyle.dividingLineColor.CGColor;
        CGFloat lineHeight = self.alertStyle.headerLineHeight;
        CGFloat lineX = self.alertStyle.headerLineRightMargin;
        if (self.alertStyle.actionSort == DNPopStyleActionSortByHorizontal) {
            DNPopAction *action = self.alertActions.firstObject;
            UIView *item = action.item;
            CGFloat actionHeight = item.frame.size.height;
            if (self.alertStyle.alertheight > 0 && (previousItemMaxY + actionHeight) < self.alertStyle.alertheight) {
                previousItemMaxY = self.alertStyle.alertheight - actionHeight - lineHeight;
            }
        }
        line.frame = (CGRect){lineX,previousItemMaxY,maxWidth - self.alertStyle.headerLineRightMargin - self.alertStyle.headerLineLeftMargin,lineHeight};
        [self.layer addSublayer:line];
        previousItemMaxY += (lineHeight);
    }
    
    if (self.alertStyle.actionSort == DNPopStyleActionSortByVertical) {
        for (NSInteger i = 0; i < self.alertActions.count; i++) {
            
            DNPopAction *action = self.alertActions[i];
            UIView *item = action.item;
            if (action.style == DNPopActionStyleDefault) {
                DNPopItem *defaultItem = (DNPopItem *)item;
                defaultItem.frame = (CGRect){self.alertStyle.horizontalSpacing,previousItemMaxY,maxWidth - self.alertStyle.horizontalSpacing * 2,item.frame.size.height};
                defaultItem.titleLabel.font = self.alertStyle.defaultFont;
                defaultItem.titleLabel.textColor = self.alertStyle.defaultTextColor;
                defaultItem.titleLabel.frame = defaultItem.bounds;
                
            } else if (action.style == DNPopActionStyleCancel) {
                DNPopItem *defaultItem = (DNPopItem *)item;
                defaultItem.frame = (CGRect){self.alertStyle.horizontalSpacing,previousItemMaxY,maxWidth - self.alertStyle.horizontalSpacing * 2,item.frame.size.height};
                defaultItem.titleLabel.font = self.alertStyle.cancelFont;
                defaultItem.titleLabel.textColor = self.alertStyle.cancelTextColor;
                defaultItem.titleLabel.frame = defaultItem.bounds;
                
            } else if (action.style == DNPopActionStyleCustom) {
                item.frame = (CGRect){0,previousItemMaxY,item.frame.size.width,item.frame.size.height};
                item.center = CGPointMake(self.center.x, item.center.y);
                
            } else {
                item.frame = (CGRect){0,previousItemMaxY,item.frame.size.width,item.frame.size.height};
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
    } else {
        DNPopAction *action = self.alertActions.firstObject;
        UIView *item = action.item;
        CGFloat actionHeight = item.frame.size.height;
        CGFloat actionWidth = (maxWidth - self.alertStyle.horizontalSpacing * 2 - self.alertStyle.dividingLineHeight) / self.alertActions.count;
        CGFloat actionX = self.alertStyle.horizontalSpacing;
        for (NSInteger i = 0; i < self.alertActions.count; i++) {
            
            DNPopAction *action = self.alertActions[i];
            UIView *item = action.item;
            if (action.style == DNPopActionStyleDefault) {
                DNPopItem *defaultItem = (DNPopItem *)item;
                defaultItem.frame = (CGRect){actionX,previousItemMaxY,actionWidth,item.frame.size.height};
                defaultItem.titleLabel.font = self.alertStyle.defaultFont;
                defaultItem.titleLabel.textColor = self.alertStyle.defaultTextColor;
                defaultItem.titleLabel.frame = defaultItem.bounds;
                
            } else if (action.style == DNPopActionStyleCancel) {
                DNPopItem *defaultItem = (DNPopItem *)item;
                defaultItem.frame = (CGRect){actionX,previousItemMaxY,actionWidth,item.frame.size.height};
                defaultItem.titleLabel.font = self.alertStyle.cancelFont;
                defaultItem.titleLabel.textColor = self.alertStyle.cancelTextColor;
                defaultItem.titleLabel.frame = defaultItem.bounds;
                
            } else if (action.style == DNPopActionStyleCustom) {
                item.frame = (CGRect){0,previousItemMaxY,item.frame.size.width,item.frame.size.height};
                item.center = CGPointMake(self.center.x, item.center.y);
                
            } else {
                item.frame = (CGRect){0,previousItemMaxY,item.frame.size.width,item.frame.size.height};
                item.center = CGPointMake(self.center.x, item.center.y);
            }
            actionX += item.frame.size.width;
            
            if (self.alertStyle.dividingLine && i < self.alertActions.count - 1) {
                CALayer *line = [CALayer new];
                line.backgroundColor = self.alertStyle.dividingLineColor.CGColor;
                CGFloat lineWidth = self.alertStyle.dividingLineHeight;
                CGFloat lineHeight = actionHeight * 0.3;
                CGFloat lineX = actionX;
                CGFloat lineY = previousItemMaxY + (actionHeight - lineHeight) * 0.5;
                actionX += lineWidth;
                line.frame = (CGRect){lineX,lineY,lineWidth,lineHeight};
                [self.layer addSublayer:line];
            }
        }
        
        previousItemMaxY += actionHeight;
    }
    
    
    CGFloat width = maxWidth;
    CGFloat height = previousItemMaxY;
    self.frame = (CGRect){0.,0.,width,height};
    self.center = [UIApplication sharedApplication].keyWindow.center;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:self.alertStyle.cornerRadii];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}


@end
