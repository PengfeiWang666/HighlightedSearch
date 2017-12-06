//
//  WPFViewController.m
//  HighlightedSearch
//
//  Created by Leon on 2017/11/21.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import "WPFViewController.h"
#import "WPFSearchResultViewController.h"
#import "WPFPerson.h"

@interface WPFViewController () <UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate>

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchController *searchVC;
@property (nonatomic, strong) WPFSearchResultViewController *searchResultVC;

@end

static NSString *kCellIdentifier = @"kCellIdentifier";

@implementation WPFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initializeData];
    
    [self _setupUI];
}

#pragma mark - Private Method
- (void)_initializeData {
    // 解析 json 假数据
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"PersonList" ofType:@".json"];
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:jsonPath]];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    NSArray *personArray = jsonDict[@"data"];
    
    // 将假数据按字母进行排序
    
    // 赋值
    HanyuPinyinOutputFormat *pinyinFormat = [WPFPinYinTools getOutputFormat];
    
    NSMutableArray *tempArray = [NSMutableArray array];
    NSDate *beginTime = [NSDate date];
    NSLog(@"开始解析数据了，开始时间：%@，数据条数：%ld", beginTime, (unsigned long)personArray.count);
    
    // 以下测试数据均为 iPhone SE（10.2） 真机测试
    /**
     2017-12-06 11:52:08.656280 HighlightedSearch[4397:1868099] 开始解析数据了，开始时间：2017-12-06 03:52:08 +0000，数据条数：1006
     2017-12-06 11:52:09.683399 HighlightedSearch[4397:1868099] 解析结束，结束时间：2017-12-06 03:52:09 +0000，耗时：1.0291 秒
     */
//    for (NSInteger i = 0; i < personArray.count; ++i) {
    
    
    
    /**
     2017-12-06 11:53:51.251045 HighlightedSearch[4407:1868685] 开始解析数据了，开始时间：2017-12-06 03:53:51 +0000，数据条数：1006
     2017-12-06 11:53:53.052466 HighlightedSearch[4407:1868685] 解析结束，结束时间：2017-12-06 03:53:53 +0000，耗时：1.8038 秒
     */
    // 使用容器的block版本的枚举器时，内部会自动添加一个AutoreleasePool：
//    NSLog(@"personArray-->%p", personArray);
//    dispatch_queue_t queue = dispatch_queue_create("wpf.initialize.test", DISPATCH_QUEUE_SERIAL);
//    [personArray enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    
    /** 耗时0.428
     2017-12-06 11:51:17.994211 HighlightedSearch[4387:1867649] 开始解析数据了，开始时间：2017-12-06 03:51:17 +0000，数据条数：1006
     2017-12-06 11:51:19.064917 HighlightedSearch[4387:1867649] 解析结束，结束时间：2017-12-06 03:51:19 +0000，耗时：1.0728 秒
     */
    for (NSString *name in personArray) {
        @autoreleasepool {
//                        NSString *name = personArray[i];
        WPFPerson *person = [WPFPerson personWithName:name hanyuPinyinOutputFormat:pinyinFormat];
//        dispatch_async(queue, ^{
            [tempArray addObject:person];
//        });
    
        }
        }
//    }];
    
    NSDate *endTime = [NSDate date];
    NSTimeInterval costTime = [endTime timeIntervalSinceDate:beginTime];
    NSLog(@"解析结束，结束时间：%@，耗时：%.4f 秒", endTime, costTime);
    self.dataSource = tempArray;
}

- (void)_setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    
    self.navigationItem.titleView = self.searchVC.searchBar;
    
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [self.searchVC.searchBar setShowsCancelButton:YES animated:NO];
    return YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
}

#pragma mark - UISearchResultsUpdating
// 更新搜索结果
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *keyWord = searchController.searchBar.text.lowercaseString;
    
    NSLog(@"%@", keyWord);
    
    NSDate *beginTime = [NSDate date];
    NSLog(@"开始匹配，开始时间：%@", beginTime);
    
    NSMutableArray *resultDataSource = [NSMutableArray array];
    // 遍历数据源，查看是否匹配，刷新结果列表
    
    /**
     2017-12-06 12:02:51.943006 HighlightedSearch[4459:1871193] w
     2017-12-06 12:02:51.943431 HighlightedSearch[4459:1871193] 开始匹配，开始时间：2017-12-06 04:02:51 +0000
     2017-12-06 12:02:51.980588 HighlightedSearch[4459:1871193] 匹配结束，结束时间：2017-12-06 04:02:51 +0000，耗时：0.0372
     2017-12-06 12:02:52.284488 HighlightedSearch[4459:1871193] wa
     2017-12-06 12:02:52.284771 HighlightedSearch[4459:1871193] 开始匹配，开始时间：2017-12-06 04:02:52 +0000
     2017-12-06 12:02:52.316536 HighlightedSearch[4459:1871193] 匹配结束，结束时间：2017-12-06 04:02:52 +0000，耗时：0.0318
     2017-12-06 12:02:52.516826 HighlightedSearch[4459:1871193] wan
     2017-12-06 12:02:52.517121 HighlightedSearch[4459:1871193] 开始匹配，开始时间：2017-12-06 04:02:52 +0000
     2017-12-06 12:02:52.545542 HighlightedSearch[4459:1871193] 匹配结束，结束时间：2017-12-06 04:02:52 +0000，耗时：0.0285
     2017-12-06 12:02:52.838220 HighlightedSearch[4459:1871193] wang
     2017-12-06 12:02:52.838602 HighlightedSearch[4459:1871193] 开始匹配，开始时间：2017-12-06 04:02:52 +0000
     2017-12-06 12:02:52.880200 HighlightedSearch[4459:1871193] 匹配结束，结束时间：2017-12-06 04:02:52 +0000，耗时：0.0417
     */
//    for (NSInteger i = 0; i < self.dataSource.count; i++) {
    
    /**
     2017-12-06 12:00:38.217187 HighlightedSearch[4439:1870645] w
     2017-12-06 12:00:38.217575 HighlightedSearch[4439:1870645] 开始匹配，开始时间：2017-12-06 04:00:38 +0000
     2017-12-06 12:00:38.253997 HighlightedSearch[4439:1870645] 匹配结束，结束时间：2017-12-06 04:00:38 +0000，耗时：0.0364
     2017-12-06 12:00:38.616430 HighlightedSearch[4439:1870645] wa
     2017-12-06 12:00:38.616807 HighlightedSearch[4439:1870645] 开始匹配，开始时间：2017-12-06 04:00:38 +0000
     2017-12-06 12:00:38.654969 HighlightedSearch[4439:1870645] 匹配结束，结束时间：2017-12-06 04:00:38 +0000，耗时：0.0383
     2017-12-06 12:00:38.948700 HighlightedSearch[4439:1870645] wan
     2017-12-06 12:00:38.949453 HighlightedSearch[4439:1870645] 开始匹配，开始时间：2017-12-06 04:00:38 +0000
     2017-12-06 12:00:38.986892 HighlightedSearch[4439:1870645] 匹配结束，结束时间：2017-12-06 04:00:38 +0000，耗时：0.0378
     2017-12-06 12:00:39.280979 HighlightedSearch[4439:1870645] wang
     2017-12-06 12:00:39.281563 HighlightedSearch[4439:1870645] 开始匹配，开始时间：2017-12-06 04:00:39 +0000
     2017-12-06 12:00:39.317743 HighlightedSearch[4439:1870645] 匹配结束，结束时间：2017-12-06 04:00:39 +0000，耗时：0.0365
     */
    for (WPFPerson *person in self.dataSource) {
    
    /**
     2017-12-06 11:56:55.565738 HighlightedSearch[4419:1869486] w
     2017-12-06 11:56:55.566287 HighlightedSearch[4419:1869486] 开始匹配，开始时间：2017-12-06 03:56:55 +0000
     2017-12-06 11:56:55.626184 HighlightedSearch[4419:1869486] 匹配结束，结束时间：2017-12-06 03:56:55 +0000，耗时：0.0601
     2017-12-06 11:56:55.937535 HighlightedSearch[4419:1869486] wa
     2017-12-06 11:56:55.937842 HighlightedSearch[4419:1869486] 开始匹配，开始时间：2017-12-06 03:56:55 +0000
     2017-12-06 11:56:55.983074 HighlightedSearch[4419:1869486] 匹配结束，结束时间：2017-12-06 03:56:55 +0000，耗时：0.0452
     2017-12-06 11:56:56.344808 HighlightedSearch[4419:1869486] wan
     2017-12-06 11:56:56.347350 HighlightedSearch[4419:1869486] 开始匹配，开始时间：2017-12-06 03:56:56 +0000
     2017-12-06 11:56:56.414215 HighlightedSearch[4419:1869486] 匹配结束，结束时间：2017-12-06 03:56:56 +0000，耗时：0.0690
     2017-12-06 11:56:56.711174 HighlightedSearch[4419:1869486] wang
     2017-12-06 11:56:56.712013 HighlightedSearch[4419:1869486] 开始匹配，开始时间：2017-12-06 03:56:56 +0000
     2017-12-06 11:56:56.774761 HighlightedSearch[4419:1869486] 匹配结束，结束时间：2017-12-06 03:56:56 +0000，耗时：0.0632
     */
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_apply(self.dataSource.count, queue, ^(size_t index) {
    
    /**
     2017-12-06 11:58:12.716606 HighlightedSearch[4428:1869917] w
     2017-12-06 11:58:12.717005 HighlightedSearch[4428:1869917] 开始匹配，开始时间：2017-12-06 03:58:12 +0000
     2017-12-06 11:58:12.780168 HighlightedSearch[4428:1869917] 匹配结束，结束时间：2017-12-06 03:58:12 +0000，耗时：0.0633
     2017-12-06 11:58:13.058590 HighlightedSearch[4428:1869917] wa
     2017-12-06 11:58:13.058841 HighlightedSearch[4428:1869917] 开始匹配，开始时间：2017-12-06 03:58:13 +0000
     2017-12-06 11:58:13.116964 HighlightedSearch[4428:1869917] 匹配结束，结束时间：2017-12-06 03:58:13 +0000，耗时：0.0581
     2017-12-06 11:58:13.397052 HighlightedSearch[4428:1869917] wan
     2017-12-06 11:58:13.397338 HighlightedSearch[4428:1869917] 开始匹配，开始时间：2017-12-06 03:58:13 +0000
     2017-12-06 11:58:13.460298 HighlightedSearch[4428:1869917] 匹配结束，结束时间：2017-12-06 03:58:13 +0000，耗时：0.0630
     2017-12-06 11:58:13.763888 HighlightedSearch[4428:1869917] wang
     2017-12-06 11:58:13.764263 HighlightedSearch[4428:1869917] 开始匹配，开始时间：2017-12-06 03:58:13 +0000
     2017-12-06 11:58:13.833888 HighlightedSearch[4428:1869917] 匹配结束，结束时间：2017-12-06 03:58:13 +0000，耗时：0.0697
     */
    
    
//    dispatch_queue_t queue = dispatch_queue_create("wpf.updateSearchResults.test", DISPATCH_QUEUE_SERIAL);
//    [self.dataSource enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    
//        WPFPerson *person = self.dataSource[i];
//        WPFPerson *person = (WPFPerson *)obj;
        
        WPFSearchResultModel *resultModel = [WPFPinYinTools
                                             searchEffectiveResultWithSearchString:keyWord
                                             nameString:person.name
                                             completeSpelling:person.completeSpelling
                                             initialString:person.initialString
                                             pinyinLocationString:person.pinyinLocationString
                                             initialLocationString:person.initialLocationString];
        
        if (resultModel.highlightedRange.length) {
            person.highlightLoaction = resultModel.highlightedRange.location;
            person.textRange = resultModel.highlightedRange;
            person.matchType = resultModel.matchType;
//            dispatch_async(queue, ^{
                [resultDataSource addObject:person];
//            });
        }
//    }];
//    });
    }

    self.searchResultVC.resultDataSource = [NSMutableArray arrayWithArray:resultDataSource];
    
    [self.searchResultVC.resultDataSource sortUsingDescriptors:[WPFPinYinTools sortingRules]];
    
    NSDate *endTime = [NSDate date];
    NSTimeInterval costTime = [endTime timeIntervalSinceDate:beginTime];
    NSLog(@"匹配结束，结束时间：%@，耗时：%.4f", endTime, costTime);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.searchResultVC.tableView reloadData];
    });
}

#pragma mark  UISearchControllerDelegate
- (void)willPresentSearchController:(UISearchController *)searchController {
    UITableView *resultTableView = self.searchResultVC.tableView;
    
    CGRect rect = resultTableView.frame;
    rect.origin.y = [UIApplication sharedApplication].statusBarFrame.size.height +self.navigationController.navigationBar.frame.size.height;
    rect.size.height = [UIScreen mainScreen].bounds.size.height - rect.origin.y;
    resultTableView.frame = rect;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    WPFPerson *person = self.dataSource[indexPath.row];
    cell.textLabel.text = person.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Setters && Getters
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
    }
    return _tableView;
}

- (WPFSearchResultViewController *)searchResultVC {
    if (!_searchResultVC) {
        _searchResultVC = [[WPFSearchResultViewController alloc] init];
    }
    return _searchResultVC;
}

- (UISearchController *)searchVC {
    if (!_searchVC) {
        _searchVC = [[UISearchController alloc] initWithSearchResultsController:self.searchResultVC];
        _searchVC.hidesNavigationBarDuringPresentation = NO;
        // 是否添加半透明遮罩；默认为YES
        _searchVC.dimsBackgroundDuringPresentation = NO;
        // NO表示UISearchController在present时，可以覆盖当前controller，默认为NO
        _searchVC.definesPresentationContext = NO;
        _searchVC.searchResultsUpdater = self;
        _searchVC.searchBar.delegate = self;
        _searchVC.delegate = self;
    }
    return _searchVC;
}

@end
