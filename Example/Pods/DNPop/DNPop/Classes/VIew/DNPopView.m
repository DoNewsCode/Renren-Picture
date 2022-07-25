//
//  DNPopView.m
//  DNPop
//
//  Created by 陈金铭 on 2019/7/3.
//

#import "DNPopView.h"

@interface DNPopView ()

@property (nonatomic, copy) NSArray<UIView *> *alertItems;

@property (nonatomic, copy) NSArray<DNPopAction *> *alertActions;
@property (nonatomic, strong) NSMutableArray<UIView *> *customAlertItems;
@property (nonatomic, strong) NSMutableArray<DNPopAction *> *customAlertActions;



@end

@implementation DNPopView

#pragma mark - Override Methods
- (instancetype)initWithStyle:(DNPopStyle *)style alertActions:(NSArray<DNPopAction *> *)alertActions {
    CGRect screenRect = [UIScreen mainScreen].bounds;
    self = [super initWithFrame:(CGRect){0.,0.,screenRect.size.width,screenRect.size.height - 300.}];
    if (self) {
        self.alertStyle = style;
        self.alertActions = alertActions;
        [self initialize];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message style:(DNPopStyle *)style alertActions:(NSArray<DNPopAction *> *)alertActions {
    CGRect screenRect = [UIScreen mainScreen].bounds;
    self = [super initWithFrame:(CGRect){0.,0.,screenRect.size.width,screenRect.size.height - 300.}];
    if (self) {
        self.alertStyle = style;
        self.alertActions = alertActions;
        self.title = title;
        self.message = message;
        [self initialize];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutBaseCustomSubviews];
}

#pragma mark - Public Methods
- (void)addAlertAction:(DNPopAction *)alertAction {
    UIView *alertBaseItem = alertAction.item;
    [self.customAlertItems addObject:alertBaseItem];
    self.alertItems = self.customAlertItems.copy;
}

#pragma mark - Private Methods
- (void)initialize {
    self.backgroundColor = self.alertStyle.backgroundColor;
    
    [self.alertActions enumerateObjectsUsingBlock:^(DNPopAction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *alertBaseItem = obj.item;
        [self addSubview:alertBaseItem];
        [self.customAlertItems addObject:alertBaseItem];
        
    }];
    
    self.alertItems = self.customAlertItems.copy;
    if (_title) {
        self.titleLabel.font = self.alertStyle.titleFont;
        self.titleLabel.textColor = self.alertStyle.titleTextColor;
    }
    
    if (_message) {
        self.messageLabel.font = self.alertStyle.messageFont;
        self.messageLabel.textColor = self.alertStyle.messageTextColor;
    }
    
}

- (void)layoutBaseCustomSubviews {
    
}

#pragma mark - Setter
- (void)setTitle:(NSString *)title {
    _title = title;
    if (title) {
        self.titleLabel.text = title;
    }
}

- (void)setMessage:(NSString *)message {
    _message = message;
    if (message) {
        self.messageLabel.text = message;
    }
}

#pragma mark - Getter
- (NSMutableArray<UIView *> *)customAlertItems {
    if (!_customAlertItems) {
        NSMutableArray<UIView *> *customAlertItems = [NSMutableArray<UIView *> new];
        _customAlertItems = customAlertItems;
    }
    return _customAlertItems;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *titleLabel = [UILabel new];
        titleLabel.font = [UIFont systemFontOfSize:16.];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.backgroundColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.userInteractionEnabled = YES;
        titleLabel.numberOfLines = 0;
        [self addSubview:titleLabel];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        UILabel *messageLabel = [UILabel new];
        messageLabel.font = [UIFont systemFontOfSize:14.];
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.backgroundColor = [UIColor whiteColor];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.userInteractionEnabled = YES;
        messageLabel.numberOfLines = 0;
        [self addSubview:messageLabel];
        _messageLabel = messageLabel;
    }
    return _messageLabel;
}

@end
