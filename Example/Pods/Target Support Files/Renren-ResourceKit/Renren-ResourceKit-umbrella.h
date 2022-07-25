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

#import "DRRFile.h"
#import "NSBundle+DRRFile.h"
#import "NSBundle+Renren_ResourceKitUtils.h"
#import "NSString+DRRResourceKit.h"
#import "UIImage+DRRResourceKit.h"

FOUNDATION_EXPORT double Renren_ResourceKitVersionNumber;
FOUNDATION_EXPORT const unsigned char Renren_ResourceKitVersionString[];

