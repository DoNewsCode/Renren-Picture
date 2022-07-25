//
//  RRError.m
//  xiaonei
//
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "extError.h"

//默认多语言表
#define RS_CURRENT_LANGUAGE_TABLE  [[NSUserDefaults standardUserDefaults] objectForKey:@"LanguageSwtich"]?[[NSUserDefaults standardUserDefaults] objectForKey:@"LanguageSwtich"]:@"zh-Hans"

@implementation extError

- (NSString*)description
{
    NSString* s = [self.userInfo objectForKey:@"error_msg"];
    if (s.length > 0) {
        return s;
    }
    else {
        return [super description];
    }
}
///////////////////////////////////////////////////////////////////////////////////////////////////
+ (extError*)errorWithRestInfo:(NSDictionary*)restInfo {
	
	NSNumber* errorCode = [restInfo objectForKey:@"error_code"];
	extError* error = [extError errorWithDomain:@"Renren" code:[errorCode intValue] userInfo:restInfo];
	return error;
}	

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (extError*)errorWithNSError:(NSError*)error {
    
	extError* myError = [extError errorWithDomain:error.domain code:error.code userInfo:error.userInfo];
	return myError;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
+ (extError*)errorWithCode:(NSInteger)code errorMessage:(NSString*)errorMessage {
	NSMutableDictionary* userInfo = [[NSMutableDictionary alloc] initWithCapacity:2];
	[userInfo setObject:[NSString stringWithFormat:@"%ld", (long)code] forKey:@"error_code"];
    if (errorMessage) {
        [userInfo setObject:errorMessage forKey:@"error_msg"];
    }
	
	extError* error = [extError errorWithDomain:@"Renren" code:code userInfo:userInfo];
	return error;
	
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDomain:(NSString *)domain code:(NSInteger)code userInfo:(NSDictionary *)dict {
	if (self = [super initWithDomain:domain code:code userInfo:dict]) {
		
	}
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)methodForRestApi {
    
	NSDictionary* userInfo = self.userInfo;
	if (!userInfo) {
		return nil;
	}
	
	NSArray* requestArgs = [userInfo objectForKey:@"request_args"];
	if (!requestArgs) {
		return nil;
	}
	
	for (NSDictionary* pair in requestArgs) {
		if (NSOrderedSame == [@"method" compare:[pair objectForKey:@"key"]]) {
			return [pair objectForKey:@"value"];
		}
	}
	
	return nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)titleForError {
    NSString* title = nil;
	if (NSOrderedSame == [self.domain compare:@"NSURLErrorDomain"]) {
		switch (self.code) {
			case NSURLErrorNotConnectedToInternet:
                title = NSLocalizedStringFromTable(@"网络不给力，请稍候再试",RS_CURRENT_LANGUAGE_TABLE,nil);
                break;
            case NSURLErrorTimedOut:
                title = NSLocalizedStringFromTable(@"连接超时",RS_CURRENT_LANGUAGE_TABLE,nil);
                break;
            case kCFURLErrorCancelled:
                title = NSLocalizedStringFromTable(@"网络不给力，请稍候再试",RS_CURRENT_LANGUAGE_TABLE,nil);
			default:
				break;
		}
	} else if (NSOrderedSame == [self.domain compare:@"NSPOSIXErrorDomain"] ||
               NSOrderedSame == [self.domain compare:@"kCFErrorDomainCFNetwork"]) {
		title = NSLocalizedStringFromTable(@"网络不给力，请稍候再试",RS_CURRENT_LANGUAGE_TABLE,nil);
	}
    else
    {
        
    }
	
    if (title == nil) {
        title = [self.userInfo objectForKey:@"error_msg"];
    }
    // 如果还没取到，就写死
    if (title == nil) {
        title = NSLocalizedStringFromTable(@"网络不给力，请稍候再试",RS_CURRENT_LANGUAGE_TABLE,nil);
    }
    
	return title;
}

+ (BOOL)isNeedLoginAgainError:(NSInteger)errCode
{
    return errCode == ELoginSessionKeyError
    || errCode == ELoginAccessTokenError
    || errCode == ELoginUserBand
    || errCode == ELoginUserSuicide
    || errCode == ELoginUserAudit;
}

@end
