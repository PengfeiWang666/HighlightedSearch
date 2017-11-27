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
                                                     nameString:(NSString *)nameStrLower
                                               completeSpelling:(NSString *)completeSpelling
                                                  initialString:(NSString *)initialString
                                           pinyinLocationString:(NSString *)pinyinLocationString
                                          initialLocationString:(NSString *)initialLocationString {
    
    WPFSearchResultModel *searchModel = [[WPFSearchResultModel alloc] init];
    
    NSArray *completeSpellingArray = [pinyinLocationString componentsSeparatedByString:@","];
    NSArray *pinyinFirstLetterLocationArray = [initialLocationString componentsSeparatedByString:@","];
    
    NSRange rang = [nameStrLower rangeOfString:searchStrLower]; // 完全匹配位置
    NSRange rangTwo = [completeSpelling rangeOfString:searchStrLower]; // 拼音全拼匹配位置
    NSRange rangThree = [initialString rangeOfString:searchStrLower]; // 拼音首字母匹配位置
    
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
            NSRange finalRange = NSMakeRange(0, [completeSpellingArray[rangTwo.length-1] integerValue] +1);
            searchModel.highlightRang = finalRange;
            searchModel.matchType = 2;
            if (finalRange.length!=0) {
                return searchModel;
            }
        } else {
            if ([completeSpellingArray[rangTwo.location] integerValue] != [completeSpellingArray[rangTwo.location-1] integerValue]) {
                // MARK: 拼音全拼匹配
                NSRange finalRange = NSMakeRange([completeSpellingArray[rangTwo.location] integerValue], [completeSpellingArray[rangTwo.length+rangTwo.location -1] integerValue] - [completeSpellingArray[rangTwo.location] integerValue] +1);
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

+ (NSArray *)sortingRules {
    NSSortDescriptor *desType = [NSSortDescriptor sortDescriptorWithKey:@"matchType" ascending:YES];
    NSSortDescriptor *desLocation = [NSSortDescriptor sortDescriptorWithKey:@"highlightLoaction" ascending:YES];
    return @[desType,desLocation];
}

@end
