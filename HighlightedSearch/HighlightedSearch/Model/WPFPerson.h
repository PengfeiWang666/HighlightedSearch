//
//  WPFPerson.h
//  HighlightedSearch
//
//  Created by Leon on 2017/11/22.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPFPerson : NSObject

/** 人物名称 */
@property (nonatomic, copy) NSString *name;
/** 拼音全拼（小写） */
@property (nonatomic, copy) NSString *phoneticSpelling;
/** 拼音首字母（小写） */
@property (nonatomic, copy) NSString *firstLetterString;
/** 拼音全拼（小写）位置 */
@property (nonatomic, copy) NSString *pinyinLocationString;
/** 拼音首字母拼音（小写）数组字符串位置 */
@property (nonatomic, copy) NSString *pinyinFirstLetterLocationString;
/** 高亮位置 */
@property (nonatomic, assign) NSInteger highlightLoaction;
/** 匹配类型 */
@property (nonatomic, assign) NSInteger matchType;

@end
