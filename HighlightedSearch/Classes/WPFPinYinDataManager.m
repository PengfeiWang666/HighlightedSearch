  //
//  WPFPinYinDataManager.m
//  HighlightedSearch
//
//  Created by Leon on 2017/12/7.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import "WPFPinYinDataManager.h"
#import "WPFPerson.h"
#import "WPFPinYinTools.h"


@interface WPFPinYinDataManager ()

@property (nonatomic, strong) HanyuPinyinOutputFormat *outputFormat;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation WPFPinYinDataManager

#pragma mark - Public Method

+ (void)addInitializeString:(NSString *)string identifer:(NSString *)identifier {
    WPFPinYinDataManager *manager = [WPFPinYinDataManager _shareInstance];
    WPFPerson *person = [WPFPerson personWithId:identifier name:string hanyuPinyinOutputFormat:manager.outputFormat];
    [manager.dataSource addObject:person];
}

+ (NSArray *)getInitializedDataSource {
    return [WPFPinYinDataManager _shareInstance].dataSource;
}

#pragma mark Private Method
+ (WPFPinYinDataManager *)_shareInstance {
    static dispatch_once_t onceToken;
    static WPFPinYinDataManager *_instance;
    dispatch_once(&onceToken, ^{
        _instance = [[WPFPinYinDataManager alloc] init];
    });
    return _instance;
}

#pragma Setters && Getters
- (HanyuPinyinOutputFormat *)outputFormat {
    if (!_outputFormat) {
        _outputFormat = [WPFPinYinTools getOutputFormat];
    }
    return _outputFormat;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
