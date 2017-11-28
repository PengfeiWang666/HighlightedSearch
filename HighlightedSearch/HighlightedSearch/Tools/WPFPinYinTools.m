//
//  WPFPinYinTools.m
//  HighlightedSearch
//
//  Created by Leon on 2017/11/22.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import "WPFPinYinTools.h"

@implementation WPFSearchResultModel

@end

@implementation WPFPinYinTools

+ (BOOL)isChinese:(NSString *)string {
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:string];
}

+ (BOOL)includeChinese:(NSString *)string {
    for (int i=0; i< [string length];i++) {
        int a =[string characterAtIndex:i];
        if ( a >0x4e00&& a <0x9fff){
            return YES;
        }
    }
    return NO;
}

+ (NSString *)firstCharactor:(NSString *)aString withFormat:(HanyuPinyinOutputFormat *)pinyinFormat {
    NSString *pinYin = [PinyinHelper toHanyuPinyinStringWithNSString:aString withHanyuPinyinOutputFormat:pinyinFormat withNSString:@""];
    return [pinYin substringToIndex:1];
}

// 获取格式化器
+ (HanyuPinyinOutputFormat *)getOutputFormat {
    HanyuPinyinOutputFormat *pinyinFormat = [[HanyuPinyinOutputFormat alloc] init];
    /** 设置大小写
     *  CaseTypeLowercase : 小写
     *  CaseTypeUppercase : 大写
     */
    [pinyinFormat setCaseType:CaseTypeLowercase];
    /** 声调格式 ：如 王鹏飞
     * ToneTypeWithToneNumber : 用数字表示声调 wang2 peng2 fei1
     * ToneTypeWithoutTone    : 无声调表示 wang peng fei
     * ToneTypeWithToneMark   : 用字符表示声调 wáng péng fēi
     */
    [pinyinFormat setToneType:ToneTypeWithoutTone];
    /** 设置特殊拼音ü的显示格式：
     * VCharTypeWithUAndColon : 以U和一个冒号表示该拼音，例如：lu:
     * VCharTypeWithV         : 以V表示该字符，例如：lv
     * VCharTypeWithUUnicode  : 以ü表示
     */
    [pinyinFormat setVCharType:VCharTypeWithV];
    return pinyinFormat;
}

+ (WPFSearchResultModel *)searchEffectiveResultWithSearchString:(NSString *)searchStrLower
                                                     nameString:(NSString *)nameStrLower
                                               completeSpelling:(NSString *)completeSpelling
                                                  initialString:(NSString *)initialString
                                           pinyinLocationString:(NSString *)pinyinLocationString
                                          initialLocationString:(NSString *)initialLocationString {
    
    WPFSearchResultModel *searchModel = [[WPFSearchResultModel alloc] init];
    
    NSArray *completeSpellingArray = [pinyinLocationString componentsSeparatedByString:@","];
    NSArray *pinyinFirstLetterLocationArray = [initialLocationString componentsSeparatedByString:@","];
    
    // 完全中文匹配范围
    NSRange chineseRange = [nameStrLower rangeOfString:searchStrLower];
    // 拼音全拼匹配范围
    NSRange complateRange = [completeSpelling rangeOfString:searchStrLower];
    // 拼音首字母匹配范围
    NSRange initialRange = [initialString rangeOfString:searchStrLower];
    NSRange finalRange = NSMakeRange(0, 0);
    
    // 完全匹配
    if (chineseRange.length!=0) {
        searchModel.highlightRang = chineseRange;
        searchModel.matchType = MatchTypeChinese;
        return searchModel;
    }
    
    // 拼音全拼匹配
    if (complateRange.length!=0) {
        if (complateRange.location ==0) {
            // MARK: 拼音首字母匹配从0开始
            finalRange = NSMakeRange(0, [completeSpellingArray[complateRange.length-1] integerValue] +1);
            
        } else {
            if ([completeSpellingArray[complateRange.location] integerValue] != [completeSpellingArray[complateRange.location-1] integerValue]) {
                // MARK: 拼音全拼匹配
                finalRange = NSMakeRange([completeSpellingArray[complateRange.location] integerValue], [completeSpellingArray[complateRange.length+complateRange.location -1] integerValue] - [completeSpellingArray[complateRange.location] integerValue] +1);
            }
        }
        searchModel.highlightRang = finalRange;
        searchModel.matchType = MatchTypeComplate;
        if (finalRange.length!=0) {
            return searchModel;
        }
    }
    
    // 拼音首字母匹配
    if (initialRange.length!=0) {
        if (initialRange.location ==0) {
            // MARK: 拼音首字母匹配从0开始
            finalRange = NSMakeRange(0, [pinyinFirstLetterLocationArray[initialRange.length-1] integerValue]-[pinyinFirstLetterLocationArray[initialRange.location] integerValue] +1);
        } else {
            // MARK: 拼音首字母匹配
            if ([pinyinFirstLetterLocationArray[initialRange.location] integerValue] != [pinyinFirstLetterLocationArray[initialRange.location - 1] integerValue]) {
                finalRange = NSMakeRange([pinyinFirstLetterLocationArray[initialRange.location] integerValue], [pinyinFirstLetterLocationArray[initialRange.length+initialRange.location-1] integerValue]-[pinyinFirstLetterLocationArray[initialRange.location] integerValue] +1);
            }
        }
        searchModel.highlightRang = finalRange;
        searchModel.matchType = MatchTypeInitial;
        if (finalRange.length!=0) {
            return searchModel;
        }
    }
    
    searchModel.highlightRang = NSMakeRange(0, 0);
    searchModel.matchType = NSIntegerMax;
    return searchModel;
}

+ (NSArray *)sortingRules {
    NSSortDescriptor *desType = [NSSortDescriptor sortDescriptorWithKey:@"matchType" ascending:YES];
    NSSortDescriptor *desLocation = [NSSortDescriptor sortDescriptorWithKey:@"highlightLoaction" ascending:YES];
    return @[desType,desLocation];
}

@end
