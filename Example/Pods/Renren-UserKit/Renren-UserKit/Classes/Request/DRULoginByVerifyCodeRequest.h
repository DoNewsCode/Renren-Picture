//
//  DRULoginByVerifyCodeRequest.h
//  Renren-Personal
//
//  Created by 李晓越 on 2019/9/11.
//

#import "DRUUserBaseGlobalRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRULoginByVerifyCodeRequest : DRUUserBaseGlobalRequest

@property(nonatomic,copy) NSString *user;
@property(nonatomic,copy) NSString *sms_verify_code;
@property(nonatomic,assign) NSInteger isverify;
@property(nonatomic,copy) NSString *verifycode;
@property(nonatomic,copy) NSString *ick;
@property(nonatomic,copy) NSString *is_confirm_unfreeze;
@property(nonatomic,assign) NSInteger is_mine;

@property(nonatomic,copy) NSString *client_info;

- (NSString *)UUIDString;


@end

NS_ASSUME_NONNULL_END
