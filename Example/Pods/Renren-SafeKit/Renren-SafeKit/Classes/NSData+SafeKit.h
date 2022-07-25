//
//  NSData+SafeKit.h
//  RenRenRecallModule
//
//  Created by donews on 2019/1/22.
//  Copyright © 2019年 donews. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>


NS_ASSUME_NONNULL_BEGIN

@interface NSData (SafeKit)

/** AES解密：CFB模式
    现在使用的是CBC模式
 */
- (NSData *)aes256ByCFBModeWithOperation:(CCOperation)operation
                                     key:(NSString *)keyStr iv:(NSString *)ivStr;


@end

NS_ASSUME_NONNULL_END
