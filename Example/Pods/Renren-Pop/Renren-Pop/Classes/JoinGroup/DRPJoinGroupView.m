//
//  DRPJoinGroupView.m
//  Renren-Pop
//
//  Created by 李晓越 on 2019/11/15.
//

#import "DRPJoinGroupView.h"
#import <YYCategories/YYCategories.h>
#import "UIImageView+WebCache.h"
#import "UIImage+Pop.h"
#import "YYTextView.h"
#import "IQKeyboardManager.h"

typedef void(^JoinBlock)(NSString *joinReason);
typedef void(^CloseBlock)(void);

@interface DRPJoinGroupView ()
<YYTextViewDelegate>

@property(nonatomic,copy) JoinBlock joinBlock;
@property(nonatomic,copy) CloseBlock closeBlock;
@property(nonatomic,weak) YYTextView *reasonTextView;

@property(nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *sendButon;

@end

@implementation DRPJoinGroupView


- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightRegular];
        [_cancelBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _cancelBtn;
}

-(UIButton *)sendButon{
    
    if (_sendButon==nil) {
        _sendButon = [[UIButton alloc] init];
        [_sendButon setTitle:@"发送" forState:UIControlStateNormal];
        _sendButon.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        [_sendButon setTitleColor:[UIColor colorWithHexString:@"#4A8CF9"] forState:UIControlStateNormal];
        [_sendButon addTarget:self action:@selector(clickJoinBtn) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _sendButon;
}


- (instancetype)initWith:(NSString *)groupName
               groupDesc:(NSString *)groupDesc
            groupIconUrl:(NSString *)groupIconUrl
             placeholder:(NSString *)placeholder
               joinBlock:(void (^)(NSString *joinReason))joinBlock
              closeBlock:(void(^)(void))closeBlock
{
    self = [super init];
    if (self) {
       
        self.joinBlock = joinBlock;
        self.closeBlock = closeBlock;
        
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, 0, kScreenWidth - 66, 0);
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 100)];
        contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:contentView];
        contentView.layer.cornerRadius = 15;
        contentView.layer.masksToBounds = YES;
        
        // 蓝背景
        UIView *blueView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 85)];
        blueView.backgroundColor = [UIColor colorWithHexString:@"#3580F9"];
        [contentView addSubview:blueView];
        
        
        // 头像
        UIImageView *groupIconImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 45, 45)];
        [groupIconImg sd_setImageWithURL:[NSURL URLWithString:groupIconUrl] placeholderImage:[UIImage pop_imageWithName:@"placeholderImage"]];
        [blueView addSubview:groupIconImg];
        
        groupIconImg.layer.cornerRadius = 15;
        groupIconImg.layer.masksToBounds = YES;
        
        // 名称
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(groupIconImg.right + 8, 25, self.width - groupIconImg.right - 16, 16)];
        nameLabel.text = groupName;
        nameLabel.textColor = UIColor.whiteColor;
        nameLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        [blueView addSubview:nameLabel];
        
        // 描述
        UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom + 10, nameLabel.width, 15)];
        descLabel.text = groupDesc;
        descLabel.textColor = UIColor.whiteColor;
        descLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        [blueView addSubview:descLabel];

        // 下半身部分
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, blueView.bottom, self.width, 204)];
        bottomView.backgroundColor = [UIColor whiteColor];
        [contentView addSubview:bottomView];
        
        // 原因
        YYTextView *reasonTextView = [[YYTextView alloc] initWithFrame:CGRectMake(10, 10, blueView.width - 20, 115)];
        reasonTextView.delegate = self;
        reasonTextView.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        reasonTextView.placeholderText = ([placeholder isNotBlank] ? placeholder : @"请输入您的申请理由，100字以内");
        reasonTextView.placeholderFont = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        reasonTextView.placeholderTextColor = [UIColor colorWithHexString:@"#999999"];
        reasonTextView.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        [bottomView addSubview:reasonTextView];
        self.reasonTextView = reasonTextView;
        
        // 解决使用 YYTextView 时，遮盖无反应问题
        [[IQKeyboardManager sharedManager] registerTextFieldViewClass:[YYTextView class] didBeginEditingNotificationName:YYTextViewTextDidBeginEditingNotification didEndEditingNotificationName:YYTextViewTextDidEndEditingNotification];


        CGFloat sendButtonWidth = self.width/2;
        CGFloat sendButtonHeight = 50;
        
        // 横线
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, reasonTextView.bottom + 18, self.width, 1)];
        line1.backgroundColor = [UIColor colorWithHexString:@"#EBEBEB"];
        [bottomView addSubview:line1];
        
        // 竖线
        CGFloat line2X = self.width/2;
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(line2X, line1.bottom, 1, sendButtonHeight)];
        line2.backgroundColor = [UIColor colorWithHexString:@"#EBEBEB"];
        [bottomView addSubview:line2];

        self.cancelBtn.frame = CGRectMake(0, line1.bottom, sendButtonWidth, sendButtonHeight);
        
        self.sendButon.frame = CGRectMake(line2.right, line1.bottom, sendButtonWidth, sendButtonHeight);
        
        [bottomView addSubview:self.cancelBtn];
        [bottomView addSubview:self.sendButon];
        
//        // 申请加入
//        UIButton *joinBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, reasonTextView.bottom + 20, 100, 36)];
//        joinBtn.centerX = reasonTextView.centerX;
//        joinBtn.backgroundColor = [UIColor colorWithHexString:@"#3580F9"];
//        [joinBtn setTitle:@"申请加入" forState:UIControlStateNormal];
//        joinBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
//        [joinBtn addTarget:self action:@selector(clickJoinBtn) forControlEvents:UIControlEventTouchUpInside];
//        [bottomView addSubview:joinBtn];
//
//        joinBtn.layer.cornerRadius = 18;
//        joinBtn.layer.masksToBounds = YES;
//
        contentView.height = bottomView.bottom;
//
//        // 关闭
//        UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, contentView.bottom + 30, 30, 30)];
//        UIImage * image = [UIImage pop_imageWithName:@"pop_activity_close"];
//        [cancelButton setImage:image forState:UIControlStateNormal];
//        [cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:cancelButton];
//        cancelButton.centerX = contentView.centerX;
        
        self.height = contentView.bottom;
        
        [IQKeyboardManager sharedManager].enable = YES;
        [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = self.height * 0.4f;
        
    }
    return self;
}

- (void)cancelAction
{
    if (self.closeBlock) {
        self.closeBlock();
    }
}

- (void)clickJoinBtn
{
    if (self.joinBlock) {
        self.joinBlock(self.reasonTextView.text);
    }
}

- (void)textViewDidChange:(YYTextView *)textView
{
    if (textView.text.length > 100) {
        NSString *s = [textView.text substringToIndex:100];
        [textView setText:s];
    }
}

- (void)dealloc
{
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 10;
}

@end
