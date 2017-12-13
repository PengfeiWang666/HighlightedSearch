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

#import "ChineseToPinyinResource.h"
#import "HanyuPinyinOutputFormat.h"
#import "NSString+PinYin4Cocoa.h"
#import "PinYin4Objc.h"
#import "PinyinFormatter.h"
#import "PinyinHelper.h"
#import "WPFPerson.h"
#import "WPFPinYinDataManager.h"
#import "WPFPinYinTools.h"

FOUNDATION_EXPORT double HighlightedSearchVersionNumber;
FOUNDATION_EXPORT const unsigned char HighlightedSearchVersionString[];

