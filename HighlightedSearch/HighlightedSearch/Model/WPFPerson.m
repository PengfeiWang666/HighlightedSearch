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
    
    // 拼音全拼
    NSMutableString *completeSpelling = [[NSMutableString alloc] init];
    NSMutableString *polyPhoneCompleteSpelling;
    
    // 首字母所组成的字符串
    NSString *initialString = @"";
    NSString *polyPhoneInitialString;
    // 全拼拼音数组
    NSMutableArray *completeSpellingArray = [[NSMutableArray alloc] init];
    NSMutableArray *polyPhoneCompleteSpellingArray;
    // 拼音首字母的位置数组
    NSMutableArray *pinyinFirstLetterLocationArray = [[NSMutableArray alloc] init];
    NSMutableArray *polyPhonePinyinFirstLetterLocationArray;
   
    
    
    for (NSInteger i = 0; i < name.length; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString *hanyuChar = [name substringWithRange:range];
        NSString *mainPinyinStrOfChar;
        NSString *polyPhonePinyinStrOfChar;
        BOOL isPolyPhoneChar = NO;
        
        /** 将单个汉字转化为拼音的类方法
         *  name : 需要转换的汉字
         *  pinyinFormat : 拼音的格式化器
         *  @"" :  seperator 分隔符
         */
        NSArray *pinyinStrArrayOfChar = [PinyinHelper getFormattedHanyuPinyinStringArrayWithChar:[name characterAtIndex:i] withHanyuPinyinOutputFormat:pinyinFormat];
        // 获取每个字符所对应的拼音数组，如果包含多音字，则匹配
        if ((nil != pinyinStrArrayOfChar) && ((int) [pinyinStrArrayOfChar count] > 0)) {
            mainPinyinStrOfChar = [pinyinStrArrayOfChar objectAtIndex:0];
            if (pinyinStrArrayOfChar.count > 1) {
                polyPhonePinyinStrOfChar = [pinyinStrArrayOfChar objectAtIndex:1];
                person.isContainPolyPhone = YES;
                isPolyPhoneChar = YES;
            }
        }
        
        if (nil != mainPinyinStrOfChar) {
            if (person.isContainPolyPhone) {
                NSString *appendString = isPolyPhoneChar ? polyPhonePinyinStrOfChar : mainPinyinStrOfChar;
                if (polyPhoneCompleteSpelling.length) {
                    [polyPhoneCompleteSpelling appendString:appendString];
                } else {
                    polyPhoneCompleteSpelling = [NSMutableString stringWithFormat:@"%@%@", completeSpelling, appendString];
                }
            }
            [completeSpelling appendString:mainPinyinStrOfChar];
            // 如果该字符是中文
            if ([WPFPinYinTools isChinese:hanyuChar]) {
                // 获取该字符的第一个拼音字母，如 wang 的 firstLetter 就是 w
                NSString *firstLetter = [mainPinyinStrOfChar substringToIndex:1];

                
                // 多音字的处理
                if (person.isContainPolyPhone) {
                    // 获取该字符多音字的第一个拼音字母
                    NSString *polyPhoneFirstLetter = [polyPhonePinyinStrOfChar substringToIndex:1];
                    
                    //                NSString *pinyinString = [PinyinHelper toHanyuPinyinStringWithNSString:hanyuChar withHanyuPinyinOutputFormat:pinyinFormat withNSString:@""];
                    /** 获取该字符的拼音在整个字符串中的位置，如 "wang peng fei"
                     * "wang" 对应的四个拼音字母是 0,0,0,0,
                     * "peng" 对应的四个拼音字母是 1,1,1,1
                     * "fei"  对应的三个拼音字母是 2,2,2
                     */
                    for (NSInteger j= 0 ;j < polyPhonePinyinStrOfChar.length ; j++) {
                        [polyPhoneCompleteSpellingArray addObject:@(i)];/////////
                    }
                    // 拼接 多音字 首字母字符串
                    NSString *appendString = isPolyPhoneChar ? polyPhoneFirstLetter : firstLetter;
                    if (polyPhoneInitialString.length) {
                        polyPhoneInitialString = [polyPhoneInitialString stringByAppendingString:appendString];
                    } else {
                        polyPhoneInitialString = [initialString stringByAppendingString:appendString];
                    }
                    
                    // 拼接 多音字 首字母位置字符串
                    [polyPhonePinyinFirstLetterLocationArray addObject:@(i)];
                }
                
                /** 获取该字符的拼音在整个字符串中的位置，如 "wang peng fei"
                 * "wang" 对应的四个拼音字母是 0,0,0,0,
                 * "peng" 对应的四个拼音字母是 1,1,1,1
                 * "fei"  对应的三个拼音字母是 2,2,2
                 */
                for (NSInteger j= 0 ;j < mainPinyinStrOfChar.length ; j++) {
                    [completeSpellingArray addObject:@(i)];
                }
                // 拼接首字母字符串，如 "王鹏飞" 对应的首字母字符串就是 "wpf"
                initialString = [initialString stringByAppendingString:firstLetter];
                // 拼接首字母位置字符串，如 "王鹏飞" 对应的首字母位置就是 "0,1,2"
                [pinyinFirstLetterLocationArray addObject:@(i)];
                
            } else {
                [completeSpellingArray addObject:@(i)];
                [pinyinFirstLetterLocationArray addObject:@(i)];
                initialString = [initialString stringByAppendingString:hanyuChar];
            }
        } else {
            [completeSpelling appendFormat:@"%C",[name characterAtIndex:i]];
        }
        
        
    }
    
    person.name = name;
    person.completeSpelling = completeSpelling;
    person.initialString = initialString;
    person.pinyinLocationString = [completeSpellingArray componentsJoinedByString:@","];
    person.initialLocationString = [pinyinFirstLetterLocationArray componentsJoinedByString:@","];
    if (person.isContainPolyPhone) {
        person.polyPhoneCompleteSpelling = polyPhoneCompleteSpelling;
        person.polyPhoneInitialString = polyPhoneInitialString;
        person.polyPhonePinyinLocationString = [polyPhoneCompleteSpellingArray componentsJoinedByString:@","];
        person.polyPhoneInitialLocationString = [polyPhonePinyinFirstLetterLocationArray componentsJoinedByString:@","];
    }
    
    return person;
}


//+ (instancetype)personWithName:(NSString *)name hanyuPinyinOutputFormat:(HanyuPinyinOutputFormat *)pinyinFormat {
//    WPFPerson *person = [[WPFPerson alloc] init];
//
//    /** 将汉字转化为拼音的类方法
//     *  name : 需要转换的汉字
//     *  pinyinFormat : 拼音的格式化器
//     *  @"" :  seperator 分隔符
//     */
//    NSString *completeSpelling = [PinyinHelper toHanyuPinyinStringWithNSString:name withHanyuPinyinOutputFormat:pinyinFormat withNSString:@""];
//
//    // 首字母所组成的字符串
//    NSString *initialString = @"";
//    // 全拼拼音数组
//    NSMutableArray *completeSpellingArray = [[NSMutableArray alloc] init];
//    // 拼音首字母的位置数组
//    NSMutableArray *pinyinFirstLetterLocationArray = [[NSMutableArray alloc] init];
//
//    // 遍历每一个字符
//    for (NSInteger x =0; x<name.length; x++) {
//        NSRange range = NSMakeRange(x, 1);
//        // 获取字符
//        NSString* hanyuCharString = [name substringWithRange:range];
//
//        // 如果该字符是中文
//        if ([WPFPinYinTools isChinese:hanyuCharString]) {
//            // 获取该字符的第一个拼音字母，如 wang 的 firstLetter 就是 w
//            NSString *firstLetter = [WPFPinYinTools firstCharactor:hanyuCharString withFormat:pinyinFormat];
//            // 获取该字符的拼音全拼，如 王 的 pinyinString就是 wang
//            NSString *pinyinString = [PinyinHelper toHanyuPinyinStringWithNSString:hanyuCharString withHanyuPinyinOutputFormat:pinyinFormat withNSString:@""];
//            /** 获取该字符的拼音在整个字符串中的位置，如 "wang peng fei"
//             * "wang" 对应的四个拼音字母是 0,0,0,0,
//             * "peng" 对应的四个拼音字母是 1,1,1,1
//             * "fei"  对应的三个拼音字母是 2,2,2
//             */
//            for (NSInteger j= 0 ;j<pinyinString.length ; j++) {
//                [completeSpellingArray addObject:@(x)];
//            }
//            // 拼接首字母字符串，如 "王鹏飞" 对应的首字母字符串就是 "wpf"
//            initialString = [initialString stringByAppendingString:firstLetter];
//            // 拼接首字母位置字符串，如 "王鹏飞" 对应的首字母位置就是 "0,1,2"
//            [pinyinFirstLetterLocationArray addObject:@(x)];
//
//        } else {
//            [completeSpellingArray addObject:@(x)];
//            [pinyinFirstLetterLocationArray addObject:@(x)];
//            initialString = [initialString stringByAppendingString:hanyuCharString];
//        }
//    }
//    person.name = name;
//    person.completeSpelling = completeSpelling;
//    person.initialString = initialString;
//    person.pinyinLocationString = [completeSpellingArray componentsJoinedByString:@","];
//    person.initialLocationString = [pinyinFirstLetterLocationArray componentsJoinedByString:@","];
//
//    return person;
//}


@end
