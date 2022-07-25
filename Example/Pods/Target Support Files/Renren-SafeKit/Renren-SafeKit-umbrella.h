#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "DRSAppInfo.h"
#import "DRSBase64.h"
#import "DRSDefines.h"
#import "DRSSafe.h"
#import "DRSSafeManager.h"
#import "NSData+SafeKit.h"

FOUNDATION_EXPORT double Renren_SafeKitVersionNumber;
FOUNDATION_EXPORT const unsigned char Renren_SafeKitVersionString[];

