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

+ (HanyuPinyinOutputFormat *)getOutputFormat {
    HanyuPinyinOutputFormat *pinyinFormat = [[HanyuPinyinOutputFormat alloc] init];
    [pinyinFormat setCaseType:CaseTypeLowercase];
    [pinyinFormat setToneType:ToneTypeWithoutTone];
    [pinyinFormat setVCharType:VCharTypeWithV];
    return pinyinFormat;
}

+ (WPFSearchResultModel *)searchEffectiveResultWithSearchString:(NSString *)searchStrLower
                                                     nameString:(NSString *)nameStrStrLower
                                               phoneticSpelling:(NSString *)phoneticSpelling
                                              firstLetterString:(NSString *)firstLetterString
                                           pinyinLocationString:(NSString *)pinyinLocationString
                                pinyinFirstLetterLocationString:(NSString *)pinyinFirstLetterLocationString {
    
    WPFSearchResultModel *searchModel = [[WPFSearchResultModel alloc] init];
    
    NSArray *phoneticSpellingArray = [pinyinLocationString componentsSeparatedByString:@","];
    NSArray *pinyinFirstLetterLocationArray = [pinyinFirstLetterLocationString componentsSeparatedByString:@","];
    
    NSRange rang = [nameStrStrLower rangeOfString:searchStrLower]; // 完全匹配位置
    NSRange rangTwo = [phoneticSpelling rangeOfString:searchStrLower]; // 拼音全拼匹配位置
    NSRange rangThree = [firstLetterString rangeOfString:searchStrLower]; // 拼音首字母匹配位置
    
    // 完全匹配
    if (rang.length!=0) {
        searchModel.highlightRang = rang;
        searchModel.matchType = 1;
        return searchModel;
    }
    
    // 拼音全拼匹配
    if (rangTwo.length!=0) {
        if (rangTwo.location ==0) {
            // MARK: 拼音首字母匹配从0开始
            NSRange finalRange = NSMakeRange(0, [phoneticSpellingArray[rangTwo.length-1] integerValue] +1);
            searchModel.highlightRang = finalRange;
            searchModel.matchType = 2;
            if (finalRange.length!=0) {
                return searchModel;
            }
        } else {
            if ([phoneticSpellingArray[rangTwo.location] integerValue] != [phoneticSpellingArray[rangTwo.location-1] integerValue]) {
                // MARK: 拼音全拼匹配
                NSRange finalRange = NSMakeRange([phoneticSpellingArray[rangTwo.location] integerValue], [phoneticSpellingArray[rangTwo.length+rangTwo.location -1] integerValue] - [phoneticSpellingArray[rangTwo.location] integerValue] +1);
                searchModel.highlightRang = finalRange;
                searchModel.matchType = 2;
                if (finalRange.length!=0) {
                    return searchModel;
                }
            }
        }
    }
    
    // 拼音首字母匹配
    if (rangThree.length!=0) {
        if (rangThree.location ==0) {
            // MARK: 拼音首字母匹配从0开始
            NSRange finalRange = NSMakeRange(0, [pinyinFirstLetterLocationArray[rangThree.length-1] integerValue]-[pinyinFirstLetterLocationArray[rangThree.location] integerValue] +1);
            searchModel.highlightRang = finalRange;
            searchModel.matchType = 3;
            if (finalRange.length!=0) {
                return searchModel;
            }
        } else {
            // MARK: 拼音首字母匹配
            if ([pinyinFirstLetterLocationArray[rangThree.location] integerValue] != [pinyinFirstLetterLocationArray[rangThree.location - 1] integerValue]) {
                NSRange finalRange = NSMakeRange([pinyinFirstLetterLocationArray[rangThree.location] integerValue], [pinyinFirstLetterLocationArray[rangThree.length+rangThree.location-1] integerValue]-[pinyinFirstLetterLocationArray[rangThree.location] integerValue] +1);
                searchModel.highlightRang = finalRange;
                searchModel.matchType = 3;
                if (finalRange.length!=0) {
                    return searchModel;
                }
            }
        }
    }
    
    searchModel.highlightRang = NSMakeRange(0, 0);
    searchModel.matchType = NSIntegerMax;
    return searchModel;
}

@end
