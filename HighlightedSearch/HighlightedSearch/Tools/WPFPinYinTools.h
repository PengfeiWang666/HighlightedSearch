//
//  WPFPinYinTools.h
//  HighlightedSearch
//
//  Created by Leon on 2017/11/22.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PinYin4Objc.h"

@interface WPFPinYinTools : NSObject

/** 判断传入的字符串是否是纯中文 */
+ (BOOL)isChinese:(NSString *)string;
/** 判断传入的字符串是否包含英文 */
+ (BOOL)includeChinese:(NSString *)string;
/** 获取传入字符串的第一个拼音字母 */
+ (NSString *)firstCharactor:(NSString *)aString withFormat:(HanyuPinyinOutputFormat *)pinyinFormat;

+ (HanyuPinyinOutputFormat *)getOutputFormat;

@end
