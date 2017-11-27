//
//  WPFPinYinTools.h
//  HighlightedSearch
//
//  Created by Leon on 2017/11/22.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PinYin4Objc.h"

@interface WPFSearchResultModel : NSObject

@property (nonatomic, assign) NSRange highlightRang; // 高亮位置
@property (nonatomic, assign) NSInteger matchType; // 搜索到的类型

@end

@interface WPFPinYinTools : NSObject

/** 判断传入的字符串是否是纯中文 */
+ (BOOL)isChinese:(NSString *)string;
/** 判断传入的字符串是否包含英文 */
+ (BOOL)includeChinese:(NSString *)string;
/** 获取传入字符串的第一个拼音字母 */
+ (NSString *)firstCharactor:(NSString *)aString withFormat:(HanyuPinyinOutputFormat *)pinyinFormat;

+ (HanyuPinyinOutputFormat *)getOutputFormat;

+ (WPFSearchResultModel *)searchEffectiveResultWithSearchString:(NSString *)searchStrLower
                                                     nameString:(NSString *)nameStrStrLower
                                               phoneticSpelling:(NSString *)phoneticSpelling
                                              firstLetterString:(NSString *)firstLetterString
                                           pinyinLocationString:(NSString *)pinyinLocationString
                                pinyinFirstLetterLocationString:(NSString *)pinyinFirstLetterLocationString;

+ (NSArray *)sortingRules;

@end
