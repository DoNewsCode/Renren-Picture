//
//  DRPNowExperience.m
//  DNPop
//
//  Created by 李晓越 on 2019/8/15.
//

#import "DRPUserInfoCheckView.h"
#import "DRPCheckTypeView.h"
#import "UIImage+Pop.h"
#import <YYCategories/YYCategories.h>

typedef void(^ClickCheckTypeBlock)(DRPCheckType checkType);
typedef void(^ClickContinueBlock)(void);

@interface DRPUserInfoCheckView ()

@property(nonatomic,copy) ClickCheckTypeBlock clickCheckTypeBlock;
@property(nonatomic,copy) ClickContinueBlock clickContinueBlock;

@property(nonatomic,assign) DRPCheckType checkType;
@property(nonatomic,assign) DRPCheckTypeState checkTypeState;
@property(nonatomic,weak) UIButton *continueBtn;

@property(nonatomic,strong) NSMutableArray<DRPCheckTypeView*> *viewArr;

@end

@implementation DRPUserInfoCheckView

- (NSMutableArray<DRPCheckTypeView *> *)viewArr
{
    if (!_viewArr) {
        _viewArr = [NSMutableArray array];
    }
    return _viewArr;
}

- (instancetype)initWithCheckType:(DRPCheckType)checkType
                   checkTypeState:(DRPCheckTypeState)checkTypeState
              clickCheckTypeBlock:(void(^)(DRPCheckType checkType))clickCheckTypeBlock
               clickContinueBlock:(void(^)(void))clickContinueBlock
{
    self = [super init];
    if (self) {
        
        
    
        self.checkType = checkType;
        self.checkTypeState = checkTypeState;
        
        self.clickCheckTypeBlock = clickCheckTypeBlock;
        self.clickContinueBlock = clickContinueBlock;

        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(0, 0, kScreenWidth - 66, 0);
        CGFloat imgW = self.width;
        CGFloat imgH = imgW * 0.67;

        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgW, imgH)];
        imageView.image = [UIImage pop_imageWithName:@"pop_protect_bg"];
        imageView.centerX = self.centerX;
        [self addSubview:imageView];

        
        UIView *lastView = imageView;
        
        if ((self.checkType & DRPCheckTypeAccount) == DRPCheckTypeAccount) {
            // 添加用户名项
            DRPCheckTypeView *userNameView = [DRPCheckTypeView checkTypeView];
            userNameView.checkType = DRPCheckTypeAccount;
            userNameView.titleLabel.text = @"帐号格式有风险";
            userNameView.descLabel.text = @"您使用了纯数字作为帐号名称，这会增大帐号被窃取的风险。";
            userNameView.frame = CGRectMake(0, lastView.bottom + 15, self.width, userNameView.selfHeight);
            [self addSubview:userNameView];
            [self.viewArr addObject:userNameView];
            
            lastView = userNameView;
            
            @weakify(self)
            userNameView.clickButton = ^(DRPCheckType checkType) {
                @strongify(self)
                if (self.clickCheckTypeBlock) {
                    self.clickCheckTypeBlock(checkType);
                }
            };
            
            if ((self.checkTypeState & DRPCheckTypeAccountDone) == DRPCheckTypeAccountDone) {
                [userNameView setCompletedUI];
            }
        }
        
        if ((self.checkType & DRPCheckTypeNickName) == DRPCheckTypeNickName) {
            // 添加昵称项
            DRPCheckTypeView *nickNameView = [DRPCheckTypeView checkTypeView];
            nickNameView.checkType = DRPCheckTypeNickName;
            nickNameView.titleLabel.text = @"昵称包含违禁词";
            nickNameView.descLabel.text = @"您的昵称不符合当前的审核规则。";
            nickNameView.frame = CGRectMake(0, lastView.bottom + 10, self.width, nickNameView.selfHeight);
            [self addSubview:nickNameView];
            
            [self.viewArr addObject:nickNameView];
            
            lastView = nickNameView;
            @weakify(self)
            nickNameView.clickButton = ^(DRPCheckType checkType) {
                @strongify(self)
                if (self.clickCheckTypeBlock) {
                    self.clickCheckTypeBlock(checkType);
                }
            };
            
            if ((self.checkTypeState & DRPCheckTypeNickNameDone) == DRPCheckTypeNickNameDone) {
                [nickNameView setCompletedUI];
            }
        }
        
        DRPCheckTypeView *_lastView = (DRPCheckTypeView*)lastView;
        _lastView.lineView.hidden = YES;
        
        NSLog(@"lastView = %@", lastView);

        self.height = CGRectGetMaxY(lastView.frame) + 20 ;
        
        [self isDoneCheckType];
    }
    return self;
}

// 查看是否完成了检测项
- (void)isDoneCheckType
{
    // 如果两个都有，都完成了才标识
    BOOL isCompleteCheck = YES;
    
    for (DRPCheckTypeView *view in self.viewArr) {
        if (!view.isCompleteCheck) {
            isCompleteCheck = NO;
        }
    }
    
    if (isCompleteCheck) {
        
        self.continueBtn.backgroundColor = [UIColor colorWithHexString:@"#3580F9"];
        self.continueBtn.enabled = YES;
    } else {
        
        self.continueBtn.backgroundColor = [UIColor colorWithHexString:@"#E8E8E8"];
        self.continueBtn.enabled = NO;
    }
}

- (void)clickContinueBtn
{
    if (self.clickContinueBlock) {
        self.clickContinueBlock();
    }
}


@end
