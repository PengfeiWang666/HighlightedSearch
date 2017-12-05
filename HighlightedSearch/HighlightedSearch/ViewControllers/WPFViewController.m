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
    NSLog(@"开始解析数据了，数据条数：%ld", (unsigned long)personArray.count);
    
    // 以下测试数据均为 iPhone SE（10.2） 真机测试
    /** 耗时 0.249秒
     2017-12-04 16:53:10.034389 HighlightedSearch[3679:1755567] 开始解析数据了，数据条数：547
     2017-12-04 16:53:10.283026 HighlightedSearch[3679:1755567] 数据解析完毕！
     */
//    for (NSInteger i = 0; i < personArray.count; ++i) {
    
    /** 耗时0.278秒
     2017-12-04 16:50:10.360442 HighlightedSearch[3664:1754291] 开始解析数据了，数据条数：547
     2017-12-04 16:50:10.638785 HighlightedSearch[3664:1754291] 数据解析完毕！
     */
//    for (NSString *name in personArray) {
    
    /** 耗时 0.157秒
     2017-12-04 16:47:53.417648 HighlightedSearch[3657:1753487] 开始解析数据了，数据条数：547
     2017-12-04 16:47:53.564198 HighlightedSearch[3657:1753487] 数据解析完毕！
     */
    // 使用容器的block版本的枚举器时，内部会自动添加一个AutoreleasePool：
    [personArray enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        @autoreleasepool {
//                        NSString *name = personArray[i];
            WPFPerson *person = [WPFPerson personWithName:obj hanyuPinyinOutputFormat:pinyinFormat];
            [tempArray addObject:person];
//        }
    }];
    
    NSLog(@"数据解析完毕！");
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
    [self settingNavigationItemBarButtons:NO];
}

- (void)settingNavigationItemBarButtons:(BOOL)searchBarIsExpand {
    if (searchBarIsExpand) {
        
    } else {
       
    }
}

#pragma mark - UISearchResultsUpdating
// 更新搜索结果
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *keyWord = searchController.searchBar.text.lowercaseString;
    NSLog(@"%@", keyWord);
    
    [self.searchResultVC.resultDataSource removeAllObjects];
    
    NSDate *beginTime = [NSDate date];
    NSLog(@"开始匹配，开始时间：%@", beginTime);
    
    // 遍历数据源，查看是否匹配，刷新结果列表
    
    /**
     2017-12-04 18:16:54.695185 HighlightedSearch[3799:1778862] W
     2017-12-04 18:16:54.695585 HighlightedSearch[3799:1778862] 开始匹配，开始时间：2017-12-04 10:16:54 +0000
     2017-12-04 18:16:54.709602 HighlightedSearch[3799:1778862] 匹配结束，结束时间：2017-12-04 10:16:54 +0000，耗时：0.0142
     2017-12-04 18:16:55.106787 HighlightedSearch[3799:1778862] Wa
     2017-12-04 18:16:55.107167 HighlightedSearch[3799:1778862] 开始匹配，开始时间：2017-12-04 10:16:55 +0000
     2017-12-04 18:16:55.124627 HighlightedSearch[3799:1778862] 匹配结束，结束时间：2017-12-04 10:16:55 +0000，耗时：0.0175
     2017-12-04 18:16:55.422478 HighlightedSearch[3799:1778862] Wan
     2017-12-04 18:16:55.422841 HighlightedSearch[3799:1778862] 开始匹配，开始时间：2017-12-04 10:16:55 +0000
     2017-12-04 18:16:55.442540 HighlightedSearch[3799:1778862] 匹配结束，结束时间：2017-12-04 10:16:55 +0000，耗时：0.0197
     2017-12-04 18:16:55.643298 HighlightedSearch[3799:1778862] Wang
     2017-12-04 18:16:55.643666 HighlightedSearch[3799:1778862] 开始匹配，开始时间：2017-12-04 10:16:55 +0000
     2017-12-04 18:16:55.666194 HighlightedSearch[3799:1778862] 匹配结束，结束时间：2017-12-04 10:16:55 +0000，耗时：0.0226
     */
//    for (NSInteger i = 0; i < self.dataSource.count; i++) {
    
    /**
     2017-12-04 18:16:06.527385 HighlightedSearch[3796:1778484] W
     2017-12-04 18:16:06.527852 HighlightedSearch[3796:1778484] 开始匹配，开始时间：2017-12-04 10:16:06 +0000
     2017-12-04 18:16:06.544939 HighlightedSearch[3796:1778484] 匹配结束，结束时间：2017-12-04 10:16:06 +0000，耗时：0.0172
     2017-12-04 18:16:06.924011 HighlightedSearch[3796:1778484] Wa
     2017-12-04 18:16:06.924368 HighlightedSearch[3796:1778484] 开始匹配，开始时间：2017-12-04 10:16:06 +0000
     2017-12-04 18:16:06.942735 HighlightedSearch[3796:1778484] 匹配结束，结束时间：2017-12-04 10:16:06 +0000，耗时：0.0184
     2017-12-04 18:16:07.305103 HighlightedSearch[3796:1778484] Wan
     2017-12-04 18:16:07.305645 HighlightedSearch[3796:1778484] 开始匹配，开始时间：2017-12-04 10:16:07 +0000
     2017-12-04 18:16:07.326988 HighlightedSearch[3796:1778484] 匹配结束，结束时间：2017-12-04 10:16:07 +0000，耗时：0.0216
     2017-12-04 18:16:07.635750 HighlightedSearch[3796:1778484] Wang
     2017-12-04 18:16:07.636109 HighlightedSearch[3796:1778484] 开始匹配，开始时间：2017-12-04 10:16:07 +0000
     2017-12-04 18:16:07.654624 HighlightedSearch[3796:1778484] 匹配结束，结束时间：2017-12-04 10:16:07 +0000，耗时：0.0185
     */
//    for (WPFPerson *person in self.dataSource) {
    
    /**
     2017-12-04 18:24:40.126644 HighlightedSearch[3807:1780388] W
     2017-12-04 18:24:40.127213 HighlightedSearch[3807:1780388] 开始匹配，开始时间：2017-12-04 10:24:40 +0000
     2017-12-04 18:24:40.137254 HighlightedSearch[3807:1780388] 匹配结束，结束时间：2017-12-04 10:24:40 +0000，耗时：0.0103
     2017-12-04 18:24:40.741455 HighlightedSearch[3807:1780388] Wa
     2017-12-04 18:24:40.741817 HighlightedSearch[3807:1780388] 开始匹配，开始时间：2017-12-04 10:24:40 +0000
     2017-12-04 18:24:40.763300 HighlightedSearch[3807:1780388] 匹配结束，结束时间：2017-12-04 10:24:40 +0000，耗时：0.0215
     2017-12-04 18:24:41.221052 HighlightedSearch[3807:1780388] Wan
     2017-12-04 18:24:41.221399 HighlightedSearch[3807:1780388] 开始匹配，开始时间：2017-12-04 10:24:41 +0000
     2017-12-04 18:24:41.238155 HighlightedSearch[3807:1780388] 匹配结束，结束时间：2017-12-04 10:24:41 +0000，耗时：0.0167
     2017-12-04 18:24:41.706267 HighlightedSearch[3807:1780388] Wang
     2017-12-04 18:24:41.706618 HighlightedSearch[3807:1780388] 开始匹配，开始时间：2017-12-04 10:24:41 +0000
     2017-12-04 18:24:41.729658 HighlightedSearch[3807:1780388] 匹配结束，结束时间：2017-12-04 10:24:41 +0000，耗时：0.0231
     */
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_apply(self.dataSource.count, queue, ^(size_t index) {
    
    /**
     2017-12-04 18:20:01.484445 HighlightedSearch[3803:1779424] W
     2017-12-04 18:20:01.484974 HighlightedSearch[3803:1779424] 开始匹配，开始时间：2017-12-04 10:20:01 +0000
     2017-12-04 18:20:01.498849 HighlightedSearch[3803:1779424] 匹配结束，结束时间：2017-12-04 10:20:01 +0000，耗时：0.0140
     2017-12-04 18:20:01.805866 HighlightedSearch[3803:1779424] Wa
     2017-12-04 18:20:01.806300 HighlightedSearch[3803:1779424] 开始匹配，开始时间：2017-12-04 10:20:01 +0000
     2017-12-04 18:20:01.819802 HighlightedSearch[3803:1779424] 匹配结束，结束时间：2017-12-04 10:20:01 +0000，耗时：0.0135
     2017-12-04 18:20:02.113918 HighlightedSearch[3803:1779424] Wan
     2017-12-04 18:20:02.114341 HighlightedSearch[3803:1779424] 开始匹配，开始时间：2017-12-04 10:20:02 +0000
     2017-12-04 18:20:02.128279 HighlightedSearch[3803:1779424] 匹配结束，结束时间：2017-12-04 10:20:02 +0000，耗时：0.0139
     2017-12-04 18:20:02.313866 HighlightedSearch[3803:1779424] Wang
     2017-12-04 18:20:02.314241 HighlightedSearch[3803:1779424] 开始匹配，开始时间：2017-12-04 10:20:02 +0000
     2017-12-04 18:20:02.329085 HighlightedSearch[3803:1779424] 匹配结束，结束时间：2017-12-04 10:20:02 +0000，耗时：0.0148
     */
    
    [self.dataSource enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    
//        WPFPerson *person = self.dataSource[index];
        WPFPerson *person = (WPFPerson *)obj;
        
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
            [self.searchResultVC.resultDataSource addObject:person];
        }
    }];
//    });
    
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
