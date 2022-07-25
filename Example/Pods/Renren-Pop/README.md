# 底部弹出分享控件示例 
```
kMoreActionButtonType type =    kMoreActionButtonTypeShareToRenren |
                                kMoreActionButtonTypeSendToFriend |
                                kMoreActionButtonTypeShareToWeChat |

                                kMoreActionButtonTypeSaveToLocal |
                                kMoreActionButtonTypeReport |
                                kMoreActionButtonTypeCollection |
                                kMoreActionButtonTypeDelete |
                                kMoreActionButtonTypeBlock;

[DRPPop showBottomShareViewWithMoreActionType:kMoreActionTypeAllView moreActionButtonType:type popTitle:@"分享到" handleBlock:^(kMoreActionButtonType moreActionButtonType) {
    NSLog(@"moreActionButtonType == %zd", moreActionButtonType);
    if (moreActionButtonType == kMoreActionButtonTypeShareToRenren) {
        NSLog(@" to do something ");
    }
}];

```

# HUD 提示框示例

```

1. 纯文字提示，2s后自动消失
[DRPPop showTextHUDWithMessage:@"纯文字2s自己消失"];

2. 带菊花加载环的，会一直提示，需要手动消失
[DRPPop showLoadingHUDWithMessage:@"一直提示，需要手动消失"];
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [DRPPop hideLoadingHUD];
});

3.显示错误信息，带图标 '错号'
[DRPPop showErrorHUDWithMessage:@"错误信息" completion:^{
    NSLog(@" to to something");
}];

4.显示完成信息，带图标 '对号'
[DRPPop showCompletionHUDWithMessage:@"完成操作" completion:^{
    NSLog(@" to do something ");
}];

```
