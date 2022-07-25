//
//  NSString+SafeKit.m
//  Renren-SafeKit
//
//  Created by 陈金铭 on 2019/11/14.
//

#import "NSString+SafeKit.h"

#import "NSString+CTHash.h"
#import "YYModel.h"

@implementation NSString (SafeKit)

// 把 请求参数 进行 签名， 生成 sig 参数
+ (NSString *)signatureWithQuery:(NSDictionary *)query opSecretKey:(NSString *)opSecretKey {
    if ( ( nil == query ) || ( nil == opSecretKey ) ) {
        return nil;
    }
    NSInteger valueLenLimit = 50;
    // 计算Signature.
    NSMutableArray* unsorted = [NSMutableArray arrayWithCapacity:query.count];
    for (id key in query) {
        NSString *value = [query objectForKey:key];
        NSString *value2 = value;
        if (valueLenLimit > 0) {
            if (value2
                && [value2 isKindOfClass:[NSString class]]
                && value2.length > valueLenLimit)
            {
                NSString* strTemp = [NSString stringWithUTF8String:[value2 UTF8String]];
                value2 = [strTemp substringToIndex:valueLenLimit];
                
                // 如果编码失败,修改内容值.
                if ( [value2 lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 0) {
                    //编码失败，暂时处理未nil
                    NSRange curStrRange = [strTemp rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, valueLenLimit)];
                    
                    NSString *value4 = [strTemp substringWithRange:curStrRange];
                    //                    int tempLen = valueLenLimit;
                    NSInteger tempLen = valueLenLimit;
                    const char * value333 = [value4 UTF8String];
                    //                    int len = strlen(value3);
                    NSInteger len = strlen(value333);
                    while( len > valueLenLimit && tempLen > 1 )
                    {
                        tempLen--;
                        curStrRange = [strTemp rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, tempLen)];
                        value4 = [strTemp substringWithRange:curStrRange];
                        value333 = [value4 UTF8String];
                        len = strlen(value333);
                    }
                    
                    value = value4;
                    //return nil;
                }
                else {
                    value = value2;
                }
            }
        }
        [unsorted addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
    }
    
    NSArray *sortedArray = [unsorted
                            sortedArrayUsingFunction:strEmotionCompareTwoString context:NULL];
    NSMutableString *buffer = [[NSMutableString alloc] initWithCapacity:0];
    NSEnumerator *i = [sortedArray objectEnumerator];
    id theObject;
    while (theObject = [i nextObject]) {
        [buffer appendString:theObject];
    }
    [buffer appendString:opSecretKey];
    NSString* signature = [buffer ct_MD5String]; // 签名.
    
    return signature;
}

NSInteger strEmotionCompareTwoString(id str1, id str2, void *context)
{
    return [((NSString*)str1) compare:str2 options:NSLiteralSearch];
}



// 把 请求参数 进行 签名， 生成 sig 参数
+ (NSString *)ct_signatureWithQuery:(NSDictionary *)query opSecretKey:(NSString *)opSecretKey {
    if ( ( nil == query ) || ( nil == opSecretKey ) ) {
        return nil;
    }
    NSInteger valueLenLimit = 50;
    
    NSArray *keyArr = [query allKeys];
    
    NSArray *sortedKeyArray = [keyArr
    sortedArrayUsingFunction:strEmotionCompareTwoString context:NULL];
    
    // 计算Signature.
    NSMutableArray* unsorted = [NSMutableArray arrayWithCapacity:query.count];
    for (id key in sortedKeyArray) {
        NSString *value = [query objectForKey:key];
        
        // 6.16，重构后，将生成sig的规则进行修改，如果value的值是字典或数组类型，给它转成json串
        if ([value isKindOfClass:[NSDictionary class]] ||
            [value isKindOfClass:[NSArray class]]) {
            value = value.yy_modelToJSONString;
            
            // 对转义符做特殊处理,去除转义符
            
            if ([value containsString:@"\\/"]) {
                NSArray *arr = [value componentsSeparatedByString:@"\\/"];
                value = [arr componentsJoinedByString:@"/"];
            }
            
        }
        
        NSString *value2 = value;
        if (valueLenLimit > 0) {
            if (value2
                && [value2 isKindOfClass:[NSString class]]
                && value2.length > valueLenLimit)
            {
                NSString* strTemp = [NSString stringWithUTF8String:[value2 UTF8String]];
                value2 = [strTemp substringToIndex:valueLenLimit];
                
                // 如果编码失败,修改内容值.
                if ( [value2 lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 0) {
                    //编码失败，暂时处理未nil
                    NSRange curStrRange = [strTemp rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, valueLenLimit)];
                    
                    NSString *value4 = [strTemp substringWithRange:curStrRange];
                    //                    int tempLen = valueLenLimit;
                    NSInteger tempLen = valueLenLimit;
                    const char * value333 = [value4 UTF8String];
                    //                    int len = strlen(value3);
                    NSInteger len = strlen(value333);
                    while( len > valueLenLimit && tempLen > 1 )
                    {
                        tempLen--;
                        curStrRange = [strTemp rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, tempLen)];
                        value4 = [strTemp substringWithRange:curStrRange];
                        value333 = [value4 UTF8String];
                        len = strlen(value333);
                    }
                    
                    value = value4;
                    //return nil;
                }
                else {
                    value = value2;
                }
            }
        }
        
        if ([value isKindOfClass:[NSNumber class]]) {
            
            NSNumber *numValue = (NSNumber *)value;
            if (strcmp([numValue objCType], @encode(char)) == 0) {
                if (numValue.boolValue) {
                    value = @"true";
                }else {
                    value = @"false";
                }
            }
            
            NSLog(@"=====");
        }
        
        [unsorted addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
    }
    
    
    NSMutableString *buffer = [[NSMutableString alloc] initWithCapacity:0];
    NSEnumerator *i = [unsorted objectEnumerator];
    id theObject;
    while (theObject = [i nextObject]) {
        [buffer appendString:theObject];
    }
    [buffer appendString:opSecretKey];
    NSString* signature = [buffer ct_MD5String]; // 签名.
    
    return signature;
}

@end
