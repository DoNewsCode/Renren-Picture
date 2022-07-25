//
//  DNMoreActionViewController.m
//  Pods
//
//  Created by 李晓越 on 2019/7/8.
//

#import "DNBottomShareView.h"
#import <YYCategories/YYCategories.h>

#import "UIImage+Pop.h"

const static CGFloat kMoreActionBtnWidth = 70;
const static CGFloat kMoreActionBtnHeight = 70;

typedef void(^ClickCancelBlock)(void);

@interface DNBottomShareView ()

/// 标题视图  --- 分享到
@property(nonatomic,strong) UILabel *titleLable;

/// 第一排的分享视图
@property (nonatomic, strong) UIScrollView *shareScrollView;

/// 第二排的选项视图
@property (nonatomic, strong) UIScrollView *optionScrollView;

/// 两排按钮中间的分隔线
@property(nonatomic,strong) UIView *seperationView;

/// 取消按钮视图 -- 包含一条分隔线
//@property(nonatomic,strong) UIButton *cancelButton;

@property(nonatomic,copy) ClickCancelBlock clickCancelBlock;

@property(nonatomic,assign) kMoreActionType moreActionType;
@property(nonatomic,assign) kMoreActionButtonType moreActionButtonType;
/// 弹窗标题
@property(nonatomic,copy) NSString *popTitle;

@property(nonatomic,assign) BOOL setByArray;
@property(nonatomic,strong) NSArray *shareTypes;
@property(nonatomic,strong) NSArray *optionTypes;

@end


@implementation DNBottomShareView

/// 1的时候为牛耳奖，将按钮顺序修改
NSString *DRPopShareViewNiuErString = @"";

- (NSArray *)shareTypes
{
    if (!_shareTypes) {
        _shareTypes = [NSArray array];
    }
    return _shareTypes;
}

- (NSArray *)optionTypes
{
    if (!_optionTypes) {
        _optionTypes = [NSArray array];
    }
    return _optionTypes;
}

- (UILabel *)titleLable
{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(28, 20, kScreenWidth - 56, 0)];
        _titleLable.text = self.popTitle;
        _titleLable.textColor = [UIColor colorWithHexString:@"#080808"];
        _titleLable.font = [UIFont systemFontOfSize:16];
        _titleLable.textAlignment = NSTextAlignmentCenter;
        
    }
    return _titleLable;
}


- (UIScrollView *)shareScrollView
{
    if (!_shareScrollView) {
        
        _shareScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 85)];
        _shareScrollView.backgroundColor = [UIColor whiteColor];
        _shareScrollView.showsVerticalScrollIndicator = NO;
        _shareScrollView.showsHorizontalScrollIndicator = NO;
       
        NSMutableArray *shareTypes = [NSMutableArray array];
        if (self.setByArray) {
            shareTypes = [self.shareTypes copy];
        } else {
            
            if ([DRPopShareViewNiuErString isEqualToString:@"1"]) {
                
                if ((self.moreActionButtonType & kMoreActionButtonTypePublish) == kMoreActionButtonTypePublish) {
                    NSLog(@"添加发布新鲜事按钮");
                    [shareTypes addObject:@(kMoreActionButtonTypePublish)];
                }
                
                if ((self.moreActionButtonType & kMoreActionButtonTypeShareToRenren) ==
                    kMoreActionButtonTypeShareToRenren ) {
                    NSLog(@"添加 转发 按钮");
                    [shareTypes addObject:@(kMoreActionButtonTypeShareToRenren)];
                }
                
                if ((self.moreActionButtonType & kMoreActionButtonTypeSendToFriend) ==
                    kMoreActionButtonTypeSendToFriend ) {
                    NSLog(@"添加 发给好友 按钮");
                    [shareTypes addObject:@(kMoreActionButtonTypeSendToFriend)];
                }
                
                if ((self.moreActionButtonType & kMoreActionButtonTypeShareToPengYouQuan) == kMoreActionButtonTypeShareToPengYouQuan ) {
                    NSLog(@"添加 朋友圈 按钮");
                    [shareTypes addObject:@(kMoreActionButtonTypeShareToPengYouQuan)];
                }
                
                if ((self.moreActionButtonType & kMoreActionButtonTypeShareToWeibo) ==
                    kMoreActionButtonTypeShareToWeibo ) {
                    NSLog(@"添加 微博 按钮");
                    [shareTypes addObject:@(kMoreActionButtonTypeShareToWeibo)];
                }
                
                if ((self.moreActionButtonType & kMoreActionButtonTypeShareToWeChat) == kMoreActionButtonTypeShareToWeChat ) {
                    NSLog(@"添加 微信好友 按钮");
                    [shareTypes addObject:@(kMoreActionButtonTypeShareToWeChat)];
                }
                
                if ((self.moreActionButtonType & kMoreActionButtonTypeShareToQQ) ==
                    kMoreActionButtonTypeShareToQQ ) {
                    NSLog(@"添加 QQ 按钮");
                    [shareTypes addObject:@(kMoreActionButtonTypeShareToQQ)];
                }
                
                if ((self.moreActionButtonType & kMoreActionButtonTypeShareToQZone) ==
                    kMoreActionButtonTypeShareToQZone ) {
                    NSLog(@"添加 QQ空间 按钮");
                    [shareTypes addObject:@(kMoreActionButtonTypeShareToQZone)];
                }
                
            } else {
                
                if ((self.moreActionButtonType & kMoreActionButtonTypePublish) == kMoreActionButtonTypePublish) {
                    NSLog(@"添加发布新鲜事按钮");
                    [shareTypes addObject:@(kMoreActionButtonTypePublish)];
                }
                
                if ((self.moreActionButtonType & kMoreActionButtonTypeShareToRenren) ==
                    kMoreActionButtonTypeShareToRenren ) {
                    NSLog(@"添加 转发 按钮");
                    [shareTypes addObject:@(kMoreActionButtonTypeShareToRenren)];
                }
                
                if ((self.moreActionButtonType & kMoreActionButtonTypeSendToFriend) ==
                    kMoreActionButtonTypeSendToFriend ) {
                    NSLog(@"添加 发给好友 按钮");
                    [shareTypes addObject:@(kMoreActionButtonTypeSendToFriend)];
                }
                
                if ((self.moreActionButtonType & kMoreActionButtonTypeShareToPengYouQuan) == kMoreActionButtonTypeShareToPengYouQuan ) {
                    NSLog(@"添加 朋友圈 按钮");
                    [shareTypes addObject:@(kMoreActionButtonTypeShareToPengYouQuan)];
                }
                
                if ((self.moreActionButtonType & kMoreActionButtonTypeShareToWeChat) == kMoreActionButtonTypeShareToWeChat ) {
                    NSLog(@"添加 微信好友 按钮");
                    [shareTypes addObject:@(kMoreActionButtonTypeShareToWeChat)];
                }
                
                if ((self.moreActionButtonType & kMoreActionButtonTypeShareToQQ) ==
                    kMoreActionButtonTypeShareToQQ ) {
                    NSLog(@"添加 QQ 按钮");
                    [shareTypes addObject:@(kMoreActionButtonTypeShareToQQ)];
                }
                
                if ((self.moreActionButtonType & kMoreActionButtonTypeShareToQZone) ==
                    kMoreActionButtonTypeShareToQZone ) {
                    NSLog(@"添加 QQ空间 按钮");
                    [shareTypes addObject:@(kMoreActionButtonTypeShareToQZone)];
                }
                
                if ((self.moreActionButtonType & kMoreActionButtonTypeShareToWeibo) ==
                    kMoreActionButtonTypeShareToWeibo ) {
                    NSLog(@"添加 微博 按钮");
                    [shareTypes addObject:@(kMoreActionButtonTypeShareToWeibo)];
                }
                
            }
            
        }
        
        CGFloat leftMargin = 0;
        CGFloat itemSpacing = 0;
        
        for (NSInteger i = 0; i < shareTypes.count; i++) {
            kMoreActionButtonType type = (kMoreActionButtonType)[shareTypes[i] integerValue];
            
            UIButton *btn = [self getCustomedStyleBtnWithActionType:type isOpitonBtn:NO];
            btn.left = leftMargin + i * (itemSpacing + kMoreActionBtnWidth);
            btn.centerY = _shareScrollView.height/2;
            
            [_shareScrollView addSubview:btn];
            
            if (i == shareTypes.count  - 1) {
                CGFloat maxWidth = btn.right;
                
                if (btn.right < self.width) {
                    maxWidth = self.width;
                }
                
                _shareScrollView.contentSize = CGSizeMake(maxWidth, _shareScrollView.height);
            }
        }
    }
    return _shareScrollView;
}

- (UIScrollView *)optionScrollView
{
    if (!_optionScrollView) {
        
        _optionScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 85)];
        _optionScrollView.backgroundColor = [UIColor whiteColor];
        _optionScrollView.showsVerticalScrollIndicator = NO;
        _optionScrollView.showsHorizontalScrollIndicator = NO;
        
        NSMutableArray *optionTypes = [NSMutableArray array];
        if (self.setByArray) {
            optionTypes = [self.optionTypes copy];
        } else {
            if ((self.moreActionButtonType & kMoreActionButtonTypeGoToAlbum) ==
                kMoreActionButtonTypeGoToAlbum ) {
                NSLog(@"添加 查看相册 按钮");
                [optionTypes addObject:@(kMoreActionButtonTypeGoToAlbum)];
            }
            if ((self.moreActionButtonType & kMoreActionButtonTypeSaveToLocal) ==
                kMoreActionButtonTypeSaveToLocal ) {
                NSLog(@"添加 保存图片 按钮");
                [optionTypes addObject:@(kMoreActionButtonTypeSaveToLocal)];
            }
            if ((self.moreActionButtonType & kMoreActionButtonTypeCollection) ==
                kMoreActionButtonTypeCollection ) {
                NSLog(@"添加 收藏 按钮");
                [optionTypes addObject:@(kMoreActionButtonTypeCollection)];
            }
            if ((self.moreActionButtonType & kMoreActionButtonTypeBlock) ==
                kMoreActionButtonTypeBlock ) {
                NSLog(@"添加 屏蔽 按钮");
                [optionTypes addObject:@(kMoreActionButtonTypeBlock)];
            }
            if ((self.moreActionButtonType & kMoreActionButtonTypeReport) ==
                kMoreActionButtonTypeReport ) {
                NSLog(@"添加 举报 按钮");
                [optionTypes addObject:@(kMoreActionButtonTypeReport)];
            }
            if ((self.moreActionButtonType & kMoreActionButtonTypeDelete) ==
                kMoreActionButtonTypeDelete ) {
                NSLog(@"添加 删除 按钮");
                [optionTypes addObject:@(kMoreActionButtonTypeDelete)];
            }
            if ((self.moreActionButtonType & kMoreActionButtonTypeStamp) ==
                kMoreActionButtonTypeStamp ) {
                NSLog(@"添加 标记 按钮");
                [optionTypes addObject:@(kMoreActionButtonTypeStamp)];
            }
            if ((self.moreActionButtonType & kMoreActionButtonTypeEditAlbums) ==
                kMoreActionButtonTypeEditAlbums ) {
                NSLog(@"添加 编辑 按钮");
                [optionTypes addObject:@(kMoreActionButtonTypeEditAlbums)];
            }
            if ((self.moreActionButtonType & kMoreActionButtonTypeCancelCollect) ==
                kMoreActionButtonTypeCancelCollect ) {
                NSLog(@"添加 取消收藏 按钮");
                [optionTypes addObject:@(kMoreActionButtonTypeCancelCollect)];
            }
            
            if ((self.moreActionButtonType & kMoreActionButtonTypeAddBanned) ==
                kMoreActionButtonTypeAddBanned ) {
                NSLog(@"添加 禁言此人 按钮");
                [optionTypes addObject:@(kMoreActionButtonTypeAddBanned)];
            }
            
            if ((self.moreActionButtonType & kMoreActionButtonTypeRemoveBanned) ==
                kMoreActionButtonTypeRemoveBanned ) {
                NSLog(@"添加 解除禁言 按钮");
                [optionTypes addObject:@(kMoreActionButtonTypeRemoveBanned)];
            }
            
            if ((self.moreActionButtonType & kMoreActionButtonTypeRefresh) ==
                kMoreActionButtonTypeRefresh ) {
                NSLog(@"添加 刷新 按钮");
                [optionTypes addObject:@(kMoreActionButtonTypeRefresh)];
            }
            if ((self.moreActionButtonType & kMoreActionButtonTypeSendItToFriend) ==
                kMoreActionButtonTypeSendItToFriend ) {
                NSLog(@"添加 发送给按钮 按钮");
                [optionTypes addObject:@(kMoreActionButtonTypeSendItToFriend)];
            }
            if ((self.moreActionButtonType & kMoreActionButtonTypeShareLinks) ==
                kMoreActionButtonTypeShareLinks ) {
                NSLog(@"添加 分享链接 按钮");
                [optionTypes addObject:@(kMoreActionButtonTypeShareLinks)];
            }
            if ((self.moreActionButtonType & kMoreActionButtonTypeCopyLink) ==
                kMoreActionButtonTypeCopyLink ) {
                NSLog(@"添加 复制链接 按钮");
                [optionTypes addObject:@(kMoreActionButtonTypeCopyLink)];
            }
            if ((self.moreActionButtonType & kMoreActionButtonTypeUsingSafariOpen) ==
                kMoreActionButtonTypeUsingSafariOpen ) {
                NSLog(@"添加 用safari打开 按钮");
                [optionTypes addObject:@(kMoreActionButtonTypeUsingSafariOpen)];
            }
            if ((self.moreActionButtonType & kMoreActionButtonTypeManager) ==
                kMoreActionButtonTypeManager ) {
                NSLog(@"添加 管理 按钮");
                [optionTypes addObject:@(kMoreActionButtonTypeManager)];
            }
            if ((self.moreActionButtonType & kMoreActionButtonTypeEssence) ==
                kMoreActionButtonTypeEssence ) {
                NSLog(@"添加 精华 按钮");
                [optionTypes addObject:@(kMoreActionButtonTypeEssence)];
            }
            if ((self.moreActionButtonType & kMoreActionButtonTypeShielding) == kMoreActionButtonTypeShielding) {
                NSLog(@"添加 封禁此人 按钮");
                [optionTypes addObject:@(kMoreActionButtonTypeShielding)];
            }
            if ((self.moreActionButtonType & kMoreActionButtonTypePlacedTop) ==
                kMoreActionButtonTypePlacedTop ) {
                NSLog(@"添加 置顶 按钮");
                [optionTypes addObject:@(kMoreActionButtonTypePlacedTop)];
            }
            
            
            if ((self.moreActionButtonType & kMoreActionButtonTypeCancelPlacedTop) ==
                kMoreActionButtonTypeCancelPlacedTop ) {
                NSLog(@"添加 取消置顶 按钮");
                [optionTypes addObject:@(kMoreActionButtonTypeCancelPlacedTop)];
            }
            
            if ((self.moreActionButtonType & kMoreActionButtonTypeCancelEssence) == kMoreActionButtonTypeCancelEssence) {
                NSLog(@"添加 取消精华 按钮");
                [optionTypes addObject:@(kMoreActionButtonTypeCancelEssence)];
            }
            
            if ((self.moreActionButtonType & kMoreActionButtonTypeDeleteShielding) == kMoreActionButtonTypeDeleteShielding) {
                NSLog(@"添加 解除封禁 按钮");
                [optionTypes addObject:@(kMoreActionButtonTypeDeleteShielding)];
            }
        }
        
        CGFloat leftMargin = 0;
        CGFloat itemSpacing = 0;
        
        for (NSInteger i = 0; i < optionTypes.count; i++) {
            kMoreActionButtonType type = (kMoreActionButtonType)[optionTypes[i] integerValue];
            
            UIButton *btn = [self getCustomedStyleBtnWithActionType:type isOpitonBtn:YES];
            btn.left = leftMargin + i * (itemSpacing + kMoreActionBtnWidth);
            btn.centerY = _optionScrollView.height/2;
            
            [_optionScrollView addSubview:btn];
            
            if (i == optionTypes.count  - 1) {
                CGFloat maxWidth = btn.right;
                
                if (btn.right < self.width) {
                    maxWidth = self.width;
                }
                
                _optionScrollView.contentSize = CGSizeMake(maxWidth, _optionScrollView.height);
            }
        }
    }
    return _optionScrollView;
}

- (UIView *)seperationView
{
    if (!_seperationView) {
        _seperationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
        _seperationView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    }
    return _seperationView;
}

- (instancetype)initWithMoreActionType:(kMoreActionType)moreActionType
                  moreActionButtonType:(kMoreActionButtonType)moreActionButtonType
                              popTitle:(NSString *)popTitle
{
    if (self == [super init]) {
        
        self.frame = CGRectMake(0, 0, kScreenWidth, 0);
        self.backgroundColor = [UIColor whiteColor];
        self.moreActionType = moreActionType;
        self.moreActionButtonType = moreActionButtonType;
        self.popTitle = popTitle;
        
        [self setupSubviews];
        
    }
    
    return self;
}


- (instancetype)initWithMoreActionType:(kMoreActionType)moreActionType
                            shareTypes:(NSArray *)shareTypes
                           optionTypes:(NSArray *)optionTypes
                              popTitle:(NSString *)popTitle
{
    if (self == [super init]) {
        self.frame = CGRectMake(0, 0, kScreenWidth, 0);
        self.backgroundColor = [UIColor whiteColor];
        self.moreActionType = moreActionType;
        self.popTitle = popTitle;
        self.shareTypes = [shareTypes copy];
        self.optionTypes = [optionTypes copy];
        self.setByArray = YES;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews
{
    
    if (self.popTitle.length > 0) {
        // 添加标题
        [self addSubview:self.titleLable];
        // 需要添加标题的时候，再设置高度
        // 然后其它控件参数标题往下排
        // 初始为0，是处理有些没有标题的情况下，布局不会出错
        self.titleLable.height = 25;
    }
    
    if (self.moreActionType == kMoreActionTypeShareView) {
        
        // 只加载第一排的分享按钮
        self.shareScrollView.top = self.titleLable.bottom;
        [self addSubview:self.shareScrollView];
        
        self.height = CGRectGetMaxY(self.shareScrollView.frame);
        
    } else if (self.moreActionType == kMoreActionTypeOptionView) {
        
        // 只加载第二排的选项按钮
        [self addSubview:self.optionScrollView];
        self.optionScrollView.top = self.titleLable.bottom;
        self.height = CGRectGetMaxY(self.optionScrollView.frame);
        
    } else {
        
        [self addSubview:self.shareScrollView];
        self.shareScrollView.top = self.titleLable.bottom;
        [self addSubview:self.optionScrollView];
        self.optionScrollView.top = self.shareScrollView.bottom;
        self.height = CGRectGetMaxY(self.optionScrollView.frame);
    }
}

#pragma mark - 获取分享视图上 button 的图片和标题，并创建一个button后返回button
- (UIButton *)getCustomedStyleBtnWithActionType:(kMoreActionButtonType)type isOpitonBtn:(BOOL)isOpitonBtn
{
    
    NSString *title = nil;
    NSString *imgPath = nil;
    switch (type) {
        case kMoreActionButtonTypePublish:
            title = @"发布新鲜事";
            imgPath = @"feed_more_action_publish_icon";
            break;
        case kMoreActionButtonTypeShareToRenren:
            title = @"转发";
            imgPath = @"feed_more_action_share_to_renren_icon";
            break;
        case kMoreActionButtonTypeSendToFriend:
            title = @"发给好友";
            imgPath = @"feed_more_action_send_to_friend_icon";
            break;
        case kMoreActionButtonTypeShareToWeChat:
            title = @"微信好友";
            imgPath = @"feed_more_action_share_to_weChat_icon";
            break;
        case kMoreActionButtonTypeShareToPengYouQuan:
            title = @"朋友圈";
            imgPath = @"feed_more_action_share_to_pengYouQuan_icon";
            break;
        case kMoreActionButtonTypeShareToWeibo:
            title = @"微博";
            imgPath = @"feed_more_action_share_to_weibo_icon";
            break;
        case kMoreActionButtonTypeShareToQQ:
            title = @"QQ";
            imgPath = @"feed_more_action_share_to_qq_icon";
            break;
        case kMoreActionButtonTypeShareToQZone:
            title = @"QQ空间";
            imgPath = @"feed_more_action_share_to_QZone_icon";
            break;
            
        case kMoreActionButtonTypeGoToAlbum:
            title = @"查看相册";
            imgPath = @"feed_more_action_go_to_album_icon";
            break;
        case kMoreActionButtonTypeSaveToLocal:
            title = @"保存图片";
            imgPath = @"feed_more_action_save_to_local_icon";
            break;
        case kMoreActionButtonTypeDelete:
            title = @"删除";
            imgPath = @"feed_more_action_delete_icon";
            break;
        case kMoreActionButtonTypeCollection:
            title = @"收藏";
            imgPath = @"feed_more_action_collection_icon";
            break;
        case kMoreActionButtonTypeEditAlbums:
            title = @"编辑";
            imgPath = @"feed_more_action_edit_icon";
            break;
        case kMoreActionButtonTypeBlock:
            title = @"屏蔽";
            imgPath = @"feed_more_action_block_icon";
            break;
        case kMoreActionButtonTypeReport:
            title = @"举报";
            imgPath = @"feed_more_action_report_icon";
            break;
        case kMoreActionButtonTypeStamp:
            title = @"标记";
            imgPath = @"feed_more_action_stamp_icon";
            break;
        case kMoreActionButtonTypeCancelCollect:
            title = @"取消收藏";
            imgPath = @"feed_more_action_cancel_collect";
            break;
            
        case kMoreActionButtonTypeAddBanned:
            title = @"禁言此人";
            imgPath = @"feed_more_action_add_banned";
            break;
            
        case kMoreActionButtonTypeRemoveBanned:
            title = @"解除禁言";
            imgPath = @"feed_more_action_remove_banned";
            break;
            
        case kMoreActionButtonTypeRefresh:
            title = @"刷新";
            imgPath = @"shared_btn_refresh";
            break;
        case kMoreActionButtonTypeSendItToFriend:
            title = @"发送给好友";
            imgPath = @"shared_btn_sendToFriend";
            break;
        case kMoreActionButtonTypeShareLinks:
            title = @"分享链接";
            imgPath = @"shared_btn_ShareLinks";
            break;
        case kMoreActionButtonTypeCopyLink:
            title = @"复制链接";
            imgPath = @"shared_btn_copyLinks";
            break;
        case kMoreActionButtonTypeUsingSafariOpen:
            title = @"Safari打开";
            imgPath = @"shared_btn_safariOpen";
            break;
            
        case kMoreActionButtonTypeManager:
            title = @"管理";
            imgPath = @"shared_btn_manager";
            break;
        case kMoreActionButtonTypeEssence:
            title = @"设为精华";
            imgPath = @"shared_btn_essence";
            break;
        case kMoreActionButtonTypeShielding:
            title = @"封禁此人";
            imgPath = @"shared_btn_shielding";
            break;
        case kMoreActionButtonTypePlacedTop:
            title = @"置顶";
            imgPath = @"shared_btn_placedTop";
            break;
        case kMoreActionButtonTypeCancelPlacedTop:
            title = @"取消置顶";
            imgPath = @"shared_btn_canelplacedTop";
            break;
        case kMoreActionButtonTypeCancelEssence:
            title = @"取消精华";
            imgPath = @"shared_btn_cancelEssence";
            break;
        case kMoreActionButtonTypeDeleteShielding:
            title = @"解除封禁";
            imgPath = @"shared_btn_deleteShielding";
            break;
        default:
            break;
    }
    if (!title && !imgPath) {
        return nil;
    }
    
    UIButton *customedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [customedBtn setFrame:CGRectMake(0, 0, kMoreActionBtnWidth, kMoreActionBtnHeight)];
    [customedBtn setImage:[UIImage pop_imageWithName:imgPath] forState:UIControlStateNormal];
    customedBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 15, 0);
    customedBtn.adjustsImageWhenHighlighted = NO;
    customedBtn.tag = type;
    [customedBtn addTarget:self action:@selector(handleClickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, customedBtn.width, 15)];
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    // 如果是第二排的选项按钮 间距更小
    if (isOpitonBtn) {
        titleLabel.top = kMoreActionBtnHeight - 20;
    } else {
        titleLabel.top = kMoreActionBtnHeight - 10;
    }
    
    [customedBtn addSubview:titleLabel];
    
    return customedBtn;
}

- (void)handleClickAction:(UIButton *)button
{
    kMoreActionButtonType type = button.tag;
    if (self.clickButtonBlock) {
        self.clickButtonBlock(type);
    }
}

@end
