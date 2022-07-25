//
//  NSData+SafeKit.m
//  RenRenRecallModule
//
//  Created by donews on 2019/1/22.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "NSData+SafeKit.h"

/** AES加密位数 */
static NSInteger const kEHIAESMode = 16;

@implementation NSData (SafeKit)


/** AES解密：CFB模式 */
- (NSData *)aes256ByCFBModeWithOperation:(CCOperation)operation key:(NSString *)keyStr iv:(NSString *)ivStr {
    NSData *originData = self;
    if (operation == kCCEncrypt) {
        // 加密:位数不够的补全
        originData = [self fullData:originData mode:kEHIAESMode];
    }
    
    const char *iv = [[ivStr dataUsingEncoding:NSUTF8StringEncoding] bytes];
    const char *key = [[keyStr dataUsingEncoding:NSUTF8StringEncoding] bytes];
    
    // 加密/解密
    CCCryptorRef cryptor = NULL;
    CCCryptorStatus status = CCCryptorCreateWithMode(operation,
                                                     kCCModeCBC,
                                                     kCCAlgorithmAES,
                                                     ccNoPadding,
                                                     iv,
                                                     key,
                                                     keyStr.length,
                                                     NULL,
                                                     0,
                                                     0,
                                                     0,
                                                     &cryptor);
    if (status != kCCSuccess) {
        NSLog(@"AES加密/解密失败 error: %@", @(status));
        return nil;
    }
    
    // 输出加密/解密数据
    NSUInteger inputLength = originData.length;
    char *outData = malloc(inputLength);
    memset(outData, 0, inputLength);
    
    size_t outLength = 0;
    CCCryptorUpdate(cryptor, originData.bytes, inputLength, outData, inputLength, &outLength);
    NSData *resultData = [NSData dataWithBytes:outData length:outLength];
    
    CCCryptorRelease(cryptor);
    free(outData);
    
    if (operation == kCCDecrypt) {
        // 解密:位数多的删除
        resultData = [self deleteData:resultData mode:kEHIAESMode];
    }
    return resultData;
}

/** 加密:位数不够的补全
 补位规则：1.length=13,补5位05
 2.length=16,补16位ff */
- (NSData *)fullData:(NSData *)originData mode:(NSUInteger)mode {
    NSMutableData *tmpData = [[NSMutableData alloc] initWithData:originData];
    // 确定要补全的个数
    NSUInteger shouldLength = mode * ((tmpData.length / mode) + 1);
    NSUInteger diffLength = shouldLength - tmpData.length;
    uint8_t *bytes = malloc(sizeof(*bytes) * diffLength);
    for (NSUInteger i = 0; i < diffLength; i++) {
        // 补全缺失的部分
        bytes[i] = diffLength;
    }
    [tmpData appendBytes:bytes length:diffLength];
    return tmpData;
}

/** 解密:位数多的删除
 删位规则：最后一位数字在1-16之间,且连续n位相同n数字 */
- (NSData *)deleteData:(NSData *)originData mode:(NSUInteger)mode {
    NSMutableData *tmpData = [[NSMutableData alloc] initWithData:originData];
    Byte *bytes = (Byte *)tmpData.bytes;
    Byte lastNo = bytes[tmpData.length - 1];
    if (lastNo >= 1 && lastNo <= mode) {
        NSUInteger count = 0;
        // 确定多余的部分正确性
        for (NSUInteger i = tmpData.length - lastNo; i < tmpData.length; i++) {
            if (lastNo == bytes[i]) {
                count ++;
            }
        }
        if (count == lastNo) {
            // 截取正常的部分
            NSRange replaceRange = NSMakeRange(0, tmpData.length - lastNo);
            return [tmpData subdataWithRange:replaceRange];
        }
    }
    return originData;
}

@end
