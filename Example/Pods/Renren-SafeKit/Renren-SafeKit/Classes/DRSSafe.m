//
//  DRSSafe.m
//  Renren-SafeKit
//
//  Created by 陈金铭 on 2019/7/8.
//

#import "DRSSafe.h"
#import "NSData+SafeKit.h"
#import "DRSBase64.h"


#define kAES_KEY    @"5de7e29919fad4d5"
#define kAESIv      @"1234567890123456"

@interface DRSSafe ()

@property(nonatomic, assign, readwrite) DRSSafeType type;

@end

@implementation DRSSafe
static DRSSafe *_instance = nil;

+ (instancetype)sharedSafe {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        [_instance initialization];
    });
    return _instance;
}

- (void)initialization {
    self.appInfo = [DRSAppInfo sharedInstance];
}

#pragma mark - Override Methods

#pragma mark - Intial Methods

#pragma mark - Event Methods

#pragma mark - Public Methods
+ (instancetype)sharedInstanceWithType:(DRSSafeType)type {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        _instance.type = type;
        [_instance initialization];
    });
    return _instance;
}

+ (void)changeType:(DRSSafeType)type {
    
}

/** 处理原始数据进行加密 */
- (NSString *)processingEncryptionWithEncryptedString:(NSString *)encryptedString
{
    
    NSData *originData = [encryptedString dataUsingEncoding:NSUTF8StringEncoding];
    // 1.Aes256 加密
    NSData *encodeData = [originData aes256ByCFBModeWithOperation:kCCEncrypt key:kAES_KEY iv:kAESIv];
    // 2.Base64 Encode
    NSString *base64EncodeStr = [DRSBase64 stringByWebSafeEncodingData:encodeData padded:YES];
    
    return base64EncodeStr;
}

/** 处理加密数据进行解密 */
- (NSString *)processingEncryptionWithDecryptString:(NSString *)decryptString
{
    NSData *base64OriginData = [decryptString dataUsingEncoding:NSUTF8StringEncoding];
    // 解密
    NSData *base64DecodeData = [DRSBase64 webSafeDecodeData:base64OriginData];
    // 2.Aes256 解密
    NSData *decodeData = [base64DecodeData aes256ByCFBModeWithOperation:kCCDecrypt key:kAES_KEY iv:kAESIv];
    NSString *decodeStr = [[NSString alloc] initWithData:decodeData encoding:NSUTF8StringEncoding];
    
    return decodeStr;
}

@end
