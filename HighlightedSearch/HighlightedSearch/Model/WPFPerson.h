//
//  WPFPerson.h
//  HighlightedSearch
//
//  Created by Leon on 2017/11/22.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPFPinYinTools.h"

@interface WPFPerson : NSObject

/** 人物名称，如：王鹏飞 */
@property (nonatomic, copy) NSString *name;
/** 拼音全拼（小写）如：@"wangpengfei" */
@property (nonatomic, copy) NSString *completeSpelling;
/** 拼音首字母（小写）如：@"wpf" */
@property (nonatomic, copy) NSString *initialString;
/**
 拼音全拼（小写）位置，如：@"0,0,0,0,1,1,1,1,2,2,2"
                        w a n g*p e n g*f e i
 */
@property (nonatomic, copy) NSString *pinyinLocationString;
/** 拼音首字母拼音（小写）数组字符串位置，如@"0,1,2" */
@property (nonatomic, copy) NSString *initialLocationString;
/** 高亮位置 */
@property (nonatomic, assign) NSInteger highlightLoaction;
/**  */
@property (nonatomic, assign) NSRange textRange;
/** 匹配类型 */
@property (nonatomic, assign) NSInteger matchType;


/**
 快速构建方法

 @param name 姓名
 @return 构建完毕的person
 */
+ (instancetype)personWithName:(NSString *)name hanyuPinyinOutputFormat:(HanyuPinyinOutputFormat *)pinyinFormat;

@end
