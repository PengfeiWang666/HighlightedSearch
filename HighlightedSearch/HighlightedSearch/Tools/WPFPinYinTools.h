//
//  WPFPinYinTools.h
//  HighlightedSearch
//
//  Created by Leon on 2017/11/22.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PinYin4Objc.h"

typedef NS_ENUM(NSUInteger, MatchType) {
    MatchTypeChinese,  // 中文完全匹配
    MatchTypeComplate, // 拼音全拼匹配
    MatchTypeInitial,  // 拼音简拼匹配
};

@interface WPFSearchResultModel : NSObject

/** 高亮范围 */
@property (nonatomic, assign) NSRange highlightRang;
/** 匹配类型 */
@property (nonatomic, assign) MatchType matchType;

@end

@interface WPFPinYinTools : NSObject

/** 判断传入的字符串是否是纯中文 */
+ (BOOL)isChinese:(NSString *)string;
/** 判断传入的字符串是否包含英文 */
+ (BOOL)includeChinese:(NSString *)string;
/** 获取传入字符串的第一个拼音字母 */
+ (NSString *)firstCharactor:(NSString *)aString withFormat:(HanyuPinyinOutputFormat *)pinyinFormat;

/** 获取格式化器 */
+ (HanyuPinyinOutputFormat *)getOutputFormat;

+ (WPFSearchResultModel *)searchEffectiveResultWithSearchString:(NSString *)searchStrLower
                                                     nameString:(NSString *)nameStrStrLower
                                               completeSpelling:(NSString *)completeSpelling
                                                  initialString:(NSString *)initialString
                                           pinyinLocationString:(NSString *)pinyinLocationString
                                          initialLocationString:(NSString *)initialLocationString;

+ (NSArray *)sortingRules;

@end
