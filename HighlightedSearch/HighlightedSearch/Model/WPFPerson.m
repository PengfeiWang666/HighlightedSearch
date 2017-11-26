//
//  WPFPerson.m
//  HighlightedSearch
//
//  Created by Leon on 2017/11/22.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import "WPFPerson.h"

@implementation WPFPerson

+ (instancetype)personWithName:(NSString *)name hanyuPinyinOutputFormat:(HanyuPinyinOutputFormat *)pinyinFormat {
    WPFPerson *person = [[WPFPerson alloc] init];
    
    NSString *phoneticSpelling = [PinyinHelper toHanyuPinyinStringWithNSString:name withHanyuPinyinOutputFormat:pinyinFormat withNSString:@""];
    
    NSString *firstLetterString = @"";
    NSMutableArray *phoneticSpellingArray = [[NSMutableArray alloc] init];
    NSMutableArray *pinyinFirstLetterLocationArray = [[NSMutableArray alloc] init];
    
    for (NSInteger x =0; x<name.length; x++) {
        NSRange range = NSMakeRange(x, 1);
        NSString* hanyuCharString = [name substringWithRange:range];
        
        if ([WPFPinYinTools isChinese:hanyuCharString]) {
            // hanyu
            NSString *firstLetter = [WPFPinYinTools firstCharactor:hanyuCharString withFormat:pinyinFormat];
            NSString *pinyinString = [PinyinHelper toHanyuPinyinStringWithNSString:hanyuCharString withHanyuPinyinOutputFormat:pinyinFormat withNSString:@""];
            for (NSInteger j= 0 ;j<pinyinString.length ; j++) {
                [phoneticSpellingArray addObject:@(x)];
            }
            [pinyinFirstLetterLocationArray addObject:@(x)];
            firstLetterString = [firstLetterString stringByAppendingString:firstLetter];
        } else {
            [phoneticSpellingArray addObject:@(x)];
            [pinyinFirstLetterLocationArray addObject:@(x)];
            firstLetterString = [firstLetterString stringByAppendingString:hanyuCharString];
        }
    }
    person.name = name;
    person.phoneticSpelling = phoneticSpelling;
    person.firstLetterString = firstLetterString;
    person.pinyinLocationString = [phoneticSpellingArray componentsJoinedByString:@","];
    person.pinyinFirstLetterLocationString = [pinyinFirstLetterLocationArray componentsJoinedByString:@","];
    
    return person;
}

@end
