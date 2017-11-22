//
//  WPFPinYinTools.m
//  HighlightedSearch
//
//  Created by Leon on 2017/11/22.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import "WPFPinYinTools.h"

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

@end
